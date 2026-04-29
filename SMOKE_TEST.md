# 平台底座冒烟测试

这个文档提供一个可重复执行的 10 秒级回归脚本，用于快速验证平台底座核心接口是否可用。

## 一键执行

在项目根目录运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\smoke-test.ps1
```

## 默认测试项

- `POST /api/auth/login`
- `GET /api/system/user/list?tenantId=1`
- `GET /api/system/menu/list?tenantId=1`
- `GET /api/system/role/list?tenantId=1`
- `GET /api/system/dictionaryType/list?tenantId=1`
- `GET /api/tenant/list`
- `GET /api/system/loginLog/list?tenantId=1`
- `GET /api/system/operationLog/list?tenantId=1`
- `GET /api/license/info`

## 脚本行为说明

- 若后端 `8080` 未运行，脚本会尝试自动启动后端。
- 若脚本自动启动了后端，测试结束会自动停止该进程。
- 任一检查失败返回退出码 `1`，全部通过返回 `0`，适合接入 CI 或本地 pre-check。

## 自定义参数

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\smoke-test.ps1 `
  -BaseUrl "http://localhost:8080" `
  -TenantCode "default" `
  -Username "admin" `
  -Password "admin123" `
  -TenantId 1 `
  -MavenCmd "C:\Users\gch\apache-maven-3.9.6\bin\mvn.cmd"
```

参数说明：

- `BaseUrl`：后端地址
- `TenantCode`：登录租户编码
- `Username` / `Password`：登录凭证
- `TenantId`：系统接口查询用租户 ID
- `MavenCmd`：本机 Maven 命令路径（后端未启动时需要）

## 建议使用方式

- 每次改动后端鉴权、权限、租户、日志、字典、菜单相关功能后执行一次。
- 提交前执行一次，确保基础能力不回归。
