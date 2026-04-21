package com.platform.system.controller;

import com.platform.system.entity.LoginLogEntity;
import com.platform.system.service.LoginLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/system/loginLog")
public class LoginLogController {

    @Autowired
    private LoginLogService loginLogService;

    @GetMapping("/list")
    public Map<String, Object> list(@RequestParam Long tenantId) {
        List<LoginLogEntity> logs = loginLogService.getLogsByTenant(tenantId);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", logs);
        return result;
    }

    @GetMapping("/user/{userId}")
    public Map<String, Object> getByUser(@PathVariable Long userId) {
        List<LoginLogEntity> logs = loginLogService.getLogsByUser(userId);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", logs);
        return result;
    }
}