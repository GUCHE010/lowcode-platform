package com.platform.system.service;

import com.platform.system.entity.DictionaryEntity;
import com.platform.system.entity.DictionaryTypeEntity;
import com.platform.system.repository.DictionaryRepository;
import com.platform.system.repository.DictionaryTypeRepository;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class DictionaryCacheService {

    @Autowired
    private DictionaryRepository dictionaryRepository;

    @Autowired
    private DictionaryTypeRepository dictionaryTypeRepository;

    private final Map<Long, List<DictionaryEntity>> cacheByTypeId = new ConcurrentHashMap<>();
    private final Map<String, List<DictionaryEntity>> cacheByDictType = new ConcurrentHashMap<>();
    private final Map<Long, DictionaryTypeEntity> typeCache = new ConcurrentHashMap<>();
    private volatile long lastRefreshTime = 0;

    @PostConstruct
    public void init() {
        refreshCache();
    }

    public void refreshCache() {
        List<DictionaryTypeEntity> types = dictionaryTypeRepository.findAll();
        typeCache.clear();
        for (DictionaryTypeEntity type : types) {
            typeCache.put(type.getId(), type);
            List<DictionaryEntity> dicts = dictionaryRepository.findByTenantIdAndDictionaryTypeIdOrderBySortOrderAsc(
                type.getTenantId(), type.getId());
            cacheByTypeId.put(type.getId(), dicts);
            cacheByDictType.put(type.getTypeCode(), dicts);
        }
        lastRefreshTime = System.currentTimeMillis();
    }

    public List<DictionaryEntity> getByTypeId(Long dictionaryTypeId) {
        return cacheByTypeId.get(dictionaryTypeId);
    }

    public List<DictionaryEntity> getByDictType(String dictType) {
        return cacheByDictType.get(dictType);
    }

    public DictionaryTypeEntity getTypeById(Long id) {
        return typeCache.get(id);
    }

    public Map<Long, DictionaryTypeEntity> getAllTypes() {
        return typeCache;
    }

    public long getLastRefreshTime() {
        return lastRefreshTime;
    }
}
