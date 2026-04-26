package com.platform.system.controller;

import com.alibaba.fastjson2.JSONObject;
import com.platform.system.service.LicenseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/license")
public class LicenseController {

    @Autowired
    private LicenseService licenseService;

    @GetMapping("/info")
    public Map<String, Object> getLicenseInfo() {
        Map<String, Object> result = new HashMap<>();
        JSONObject info = licenseService.getLicenseInfo();
        if (info != null) {
            result.put("success", true);
            result.put("data", info);
        } else {
            result.put("success", false);
            result.put("message", "未安装License");
            result.put("data", JSONObject.parse("{\"status\": \"none\"}"));
        }
        return result;
    }

    @PostMapping("/validate")
    public Map<String, Object> validate() {
        Map<String, Object> result = new HashMap<>();
        boolean valid = licenseService.isLicenseValid();
        result.put("success", valid);
        result.put("valid", valid);
        result.put("licenseType", licenseService.getLicenseType());
        if (!valid) {
            result.put("message", "License无效或已过期");
        }
        return result;
    }

    @PostMapping("/install")
    public Map<String, Object> install(@RequestBody Map<String, String> request) {
        Map<String, Object> result = new HashMap<>();
        String licenseKey = request.get("licenseKey");
        if (licenseKey == null || licenseKey.isEmpty()) {
            result.put("success", false);
            result.put("message", "License Key不能为空");
            return result;
        }
        var license = licenseService.installLicense(licenseKey);
        if (license != null) {
            result.put("success", true);
            result.put("message", "License安装成功");
            result.put("data", licenseService.getLicenseInfo());
        } else {
            result.put("success", false);
            result.put("message", "License安装失败，Key无效");
        }
        return result;
    }
}
