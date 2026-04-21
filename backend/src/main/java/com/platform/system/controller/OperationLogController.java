package com.platform.system.controller;

import com.platform.system.entity.OperationLogEntity;
import com.platform.system.service.OperationLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/system/operationLog")
public class OperationLogController {

    @Autowired
    private OperationLogService operationLogService;

    @GetMapping("/list")
    public Map<String, Object> list(@RequestParam Long tenantId) {
        List<OperationLogEntity> logs = operationLogService.getLogsByTenant(tenantId);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", logs);
        return result;
    }

    @GetMapping("/user/{userId}")
    public Map<String, Object> getByUser(@PathVariable Long userId) {
        List<OperationLogEntity> logs = operationLogService.getLogsByUser(userId);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", logs);
        return result;
    }
}