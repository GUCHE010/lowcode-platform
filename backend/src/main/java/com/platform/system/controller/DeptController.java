package com.platform.system.controller;

import com.platform.system.entity.DeptEntity;
import com.platform.system.service.DeptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/system/dept")
public class DeptController {

    @Autowired
    private DeptService deptService;

    @GetMapping("/list")
    public Map<String, Object> list(@RequestParam Long tenantId) {
        List<DeptEntity> depts = deptService.listByTenant(tenantId);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", depts);
        result.put("total", depts.size());
        return result;
    }

    @GetMapping("/tree")
    public Map<String, Object> tree(@RequestParam Long tenantId) {
        List<DeptEntity> tree = deptService.buildTree(tenantId);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", tree);
        return result;
    }

    @GetMapping("/{id}")
    public Map<String, Object> getById(@PathVariable Long id) {
        DeptEntity dept = deptService.findById(id);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", dept);
        return result;
    }

    @PostMapping
    public Map<String, Object> create(@RequestBody DeptEntity dept) {
        deptService.create(dept);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "创建成功");
        return result;
    }

    @PutMapping
    public Map<String, Object> update(@RequestBody DeptEntity dept) {
        deptService.update(dept);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "更新成功");
        return result;
    }

    @DeleteMapping("/{id}")
    public Map<String, Object> delete(@PathVariable Long id) {
        if (deptService.hasChildren(id)) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "该部门存在子部门，无法删除");
            return result;
        }
        deptService.delete(id);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
}
