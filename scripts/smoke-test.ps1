param(
    [string]$BaseUrl = "http://localhost:8080",
    [string]$TenantCode = "default",
    [string]$Username = "admin",
    [string]$Password = "admin123",
    [int]$TenantId = 1,
    [string]$MavenCmd = "C:\Users\gch\apache-maven-3.9.6\bin\mvn.cmd"
)

$ErrorActionPreference = "Stop"

function Test-PortOpen {
    param([int]$Port)
    try {
        $tcp = New-Object Net.Sockets.TcpClient
        $iar = $tcp.BeginConnect("127.0.0.1", $Port, $null, $null)
        $ok = $iar.AsyncWaitHandle.WaitOne(400)
        $tcp.Close()
        return $ok
    } catch {
        return $false
    }
}

function Invoke-ApiJson {
    param(
        [string]$Method,
        [string]$Url,
        [hashtable]$Headers = $null,
        [object]$Body = $null
    )
    if ($null -eq $Body) {
        return Invoke-RestMethod -Method $Method -Uri $Url -Headers $Headers
    }
    $json = $Body | ConvertTo-Json -Depth 8
    return Invoke-RestMethod -Method $Method -Uri $Url -Headers $Headers -ContentType "application/json" -Body $json
}

$backendStartedByScript = $false
$backendProcess = $null
$results = @()

try {
    if (-not (Test-PortOpen -Port 8080)) {
        if (-not (Test-Path -Path $MavenCmd)) {
            throw "Backend is not running and Maven is missing: $MavenCmd"
        }
        Write-Host "Backend is not running, starting now..." -ForegroundColor Yellow
        $backendProcess = Start-Process -FilePath $MavenCmd -ArgumentList "spring-boot:run" -WorkingDirectory (Join-Path $PSScriptRoot "..\backend") -PassThru
        $backendStartedByScript = $true

        $deadline = (Get-Date).AddSeconds(45)
        while ((Get-Date) -lt $deadline) {
            if (Test-PortOpen -Port 8080) { break }
            Start-Sleep -Milliseconds 500
        }
        if (-not (Test-PortOpen -Port 8080)) {
            throw "Backend startup timeout: port 8080 is not ready."
        }
    }

    $loginResp = Invoke-ApiJson -Method "POST" -Url "$BaseUrl/api/auth/login" -Body @{
        tenantCode = $TenantCode
        username   = $Username
        password   = $Password
    }
    $results += [pscustomobject]@{ Name = "auth/login"; Passed = [bool]$loginResp.success; Detail = $loginResp.message }
    if (-not $loginResp.success) {
        throw "Login failed: $($loginResp.message)"
    }

    $token = $loginResp.token
    $headers = @{ Authorization = "Bearer $token" }

    $checks = @(
        @{ Name = "system/user/list"; Url = "$BaseUrl/api/system/user/list?tenantId=$TenantId" },
        @{ Name = "system/menu/list"; Url = "$BaseUrl/api/system/menu/list?tenantId=$TenantId" },
        @{ Name = "system/role/list"; Url = "$BaseUrl/api/system/role/list?tenantId=$TenantId" },
        @{ Name = "system/dictionaryType/list"; Url = "$BaseUrl/api/system/dictionaryType/list?tenantId=$TenantId" },
        @{ Name = "tenant/list"; Url = "$BaseUrl/api/tenant/list" },
        @{ Name = "system/loginLog/list"; Url = "$BaseUrl/api/system/loginLog/list?tenantId=$TenantId" },
        @{ Name = "system/operationLog/list"; Url = "$BaseUrl/api/system/operationLog/list?tenantId=$TenantId" }
    )

    foreach ($c in $checks) {
        try {
            $resp = Invoke-ApiJson -Method "GET" -Url $c.Url -Headers $headers
            $ok = [bool]$resp.success
            $count = if ($null -ne $resp.data -and $resp.data -is [System.Collections.ICollection]) { $resp.data.Count } else { "-" }
            $results += [pscustomobject]@{ Name = $c.Name; Passed = $ok; Detail = "count=$count" }
        } catch {
            $results += [pscustomobject]@{ Name = $c.Name; Passed = $false; Detail = $_.Exception.Message }
        }
    }

    try {
        $license = Invoke-ApiJson -Method "GET" -Url "$BaseUrl/api/license/info" -Headers $headers
        $results += [pscustomobject]@{ Name = "license/info"; Passed = $true; Detail = "success=$($license.success)" }
    } catch {
        $results += [pscustomobject]@{ Name = "license/info"; Passed = $false; Detail = $_.Exception.Message }
    }

    Write-Host ""
    Write-Host "==== Smoke Test Result ====" -ForegroundColor Cyan
    foreach ($r in $results) {
        $flag = if ($r.Passed) { "PASS" } else { "FAIL" }
        $color = if ($r.Passed) { "Green" } else { "Red" }
        Write-Host ("[{0}] {1}  {2}" -f $flag, $r.Name, $r.Detail) -ForegroundColor $color
    }

    $failed = @($results | Where-Object { -not $_.Passed }).Count
    if ($failed -gt 0) {
        Write-Host ""
        Write-Host "Smoke test finished with $failed failure(s)." -ForegroundColor Red
        exit 1
    }

    Write-Host ""
    Write-Host "Smoke test passed." -ForegroundColor Green
    exit 0
}
finally {
    if ($backendStartedByScript -and $null -ne $backendProcess) {
        try {
            if (-not $backendProcess.HasExited) {
                Stop-Process -Id $backendProcess.Id -Force -ErrorAction SilentlyContinue
            }
        } catch {}
    }
}
