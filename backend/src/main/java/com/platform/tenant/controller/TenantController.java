package com.platform.tenant.controller;

import com.platform.tenant.entity.TenantEntity;
import com.platform.tenant.service.TenantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/tenant")
public class TenantController {

    @Autowired
    private TenantService tenantService;

    @GetMapping("/list")
    public Map<String, Object> list() {
        List<TenantEntity> tenants = tenantService.list();
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", tenants);
        result.put("total", tenants.size());
        return result;
    }

    @GetMapping("/{id}")
    public Map<String, Object> getById(@PathVariable Long id) {
        TenantEntity tenant = tenantService.findById(id);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", tenant);
        return result;
    }

    @PostMapping
    public Map<String, Object> create(@RequestBody TenantEntity tenant) {
        try {
            tenantService.create(tenant);
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "创建成功");
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "创建失败: " + e.getMessage());
            return result;
        }
    }

    @PutMapping
    public Map<String, Object> update(@RequestBody TenantEntity tenant) {
        tenantService.update(tenant);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "更新成功");
        return result;
    }

    @DeleteMapping("/{id}")
    public Map<String, Object> delete(@PathVariable Long id) {
        tenantService.delete(id);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }

    @PutMapping("/status")
    public Map<String, Object> updateStatus(@RequestBody Map<String, Object> request) {
        Long id = Long.valueOf(request.get("id").toString());
        String status = request.get("status").toString();
        tenantService.updateStatus(id, status);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "状态更新成功");
        return result;
    }
}
