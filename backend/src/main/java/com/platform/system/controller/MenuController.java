package com.platform.system.controller;

import com.platform.system.entity.MenuEntity;
import com.platform.system.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/system/menu")
public class MenuController {

    @Autowired
    private MenuService menuService;

    @GetMapping("/list")
    public Map<String, Object> list() {
        List<MenuEntity> menus = menuService.listAll();
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", menus);
        return result;
    }

    @GetMapping("/tree")
    public Map<String, Object> tree() {
        List<MenuEntity> tree = menuService.treeList();
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", tree);
        return result;
    }

    @GetMapping("/{id}")
    public Map<String, Object> getById(@PathVariable Long id) {
        MenuEntity menu = menuService.findById(id);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", menu);
        return result;
    }

    @PostMapping
    public Map<String, Object> create(@RequestBody MenuEntity menu) {
        menuService.create(menu);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "创建成功");
        return result;
    }

    @PutMapping
    public Map<String, Object> update(@RequestBody MenuEntity menu) {
        menuService.update(menu);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "更新成功");
        return result;
    }

    @DeleteMapping("/{id}")
    public Map<String, Object> delete(@PathVariable Long id) {
        menuService.delete(id);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
}
