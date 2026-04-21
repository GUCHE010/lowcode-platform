package com.platform.system.controller;

import com.platform.system.entity.RoleEntity;
import com.platform.system.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/system/role")
public class RoleController {

    @Autowired
    private RoleService roleService;

    @GetMapping("/list")
    public Map<String, Object> list(@RequestParam Long tenantId) {
        List<RoleEntity> roles = roleService.listByTenant(tenantId);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", roles);
        return result;
    }

    @GetMapping("/{id}")
    public Map<String, Object> getById(@PathVariable Long id) {
        RoleEntity role = roleService.findById(id);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", role);
        return result;
    }

    @PostMapping
    public Map<String, Object> create(@RequestBody RoleEntity role) {
        roleService.create(role);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "创建成功");
        return result;
    }

    @PutMapping
    public Map<String, Object> update(@RequestBody RoleEntity role) {
        roleService.update(role);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "更新成功");
        return result;
    }

    @DeleteMapping("/{id}")
    public Map<String, Object> delete(@PathVariable Long id) {
        roleService.delete(id);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }

    @PostMapping("/permission")
    public Map<String, Object> assignPermissions(@RequestBody Map<String, Object> request) {
        Long roleId = Long.valueOf(request.get("roleId").toString());
        @SuppressWarnings("unchecked")
        List<Long> menuIds = (List<Long>) request.get("menuIds");
        roleService.assignPermissions(roleId, menuIds);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "分配成功");
        return result;
    }

    @GetMapping("/menuIds/{roleId}")
    public Map<String, Object> getRoleMenuIds(@PathVariable Long roleId) {
        List<Long> menuIds = roleService.getRoleMenuIds(roleId);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", menuIds);
        return result;
    }
}
