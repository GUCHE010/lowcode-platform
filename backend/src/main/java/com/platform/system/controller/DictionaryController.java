package com.platform.system.controller;

import com.platform.system.entity.DictionaryEntity;
import com.platform.system.entity.DictionaryTypeEntity;
import com.platform.system.service.DictionaryService;
import com.platform.system.service.DictionaryCacheService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/system/dictionary")
public class DictionaryController {

    @Autowired
    private DictionaryService dictionaryService;

    @Autowired
    private DictionaryCacheService dictionaryCacheService;

    @GetMapping("/list")
    public Map<String, Object> list(@RequestParam Long tenantId) {
        List<DictionaryEntity> list = dictionaryService.listByTenant(tenantId);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", list);
        return result;
    }

    @GetMapping("/type/{dictType}")
    public Map<String, Object> listByType(@RequestParam Long tenantId, @PathVariable String dictType) {
        List<DictionaryEntity> list = dictionaryService.listByType(tenantId, dictType);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", list);
        return result;
    }

    @GetMapping("/cache/{dictType}")
    public Map<String, Object> getFromCache(@PathVariable String dictType) {
        List<DictionaryEntity> list = dictionaryCacheService.getByDictType(dictType);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", list);
        result.put("lastRefreshTime", dictionaryCacheService.getLastRefreshTime());
        return result;
    }

    @GetMapping("/types")
    public Map<String, Object> getAllTypes() {
        Map<Long, DictionaryTypeEntity> types = dictionaryCacheService.getAllTypes();
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", types.values());
        return result;
    }

    @PostMapping("/refreshCache")
    public Map<String, Object> refreshCache() {
        dictionaryCacheService.refreshCache();
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "缓存刷新成功");
        result.put("lastRefreshTime", dictionaryCacheService.getLastRefreshTime());
        return result;
    }

    @GetMapping("/{id}")
    public Map<String, Object> getById(@PathVariable Long id) {
        DictionaryEntity dictionary = dictionaryService.findById(id);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", dictionary);
        return result;
    }

    @PostMapping
    public Map<String, Object> create(@RequestBody DictionaryEntity dictionary) {
        dictionaryService.create(dictionary);
        dictionaryCacheService.refreshCache();
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "创建成功");
        return result;
    }

    @PutMapping
    public Map<String, Object> update(@RequestBody DictionaryEntity dictionary) {
        dictionaryService.update(dictionary);
        dictionaryCacheService.refreshCache();
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "更新成功");
        return result;
    }

    @DeleteMapping("/{id}")
    public Map<String, Object> delete(@PathVariable Long id) {
        dictionaryService.delete(id);
        dictionaryCacheService.refreshCache();
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
}