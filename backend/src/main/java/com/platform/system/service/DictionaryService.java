package com.platform.system.service;

import com.platform.system.entity.DictionaryEntity;
import com.platform.system.repository.DictionaryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class DictionaryService {

    @Autowired
    private DictionaryRepository dictionaryRepository;

    public List<DictionaryEntity> listByTenant(Long tenantId) {
        return dictionaryRepository.findByTenantIdOrderByDictTypeAscSortOrderAsc(tenantId);
    }

    public List<DictionaryEntity> listByType(Long tenantId, String dictType) {
        return dictionaryRepository.findByTenantIdAndDictTypeOrderBySortOrderAsc(tenantId, dictType);
    }

    public List<DictionaryEntity> listByTypeId(Long tenantId, Long dictionaryTypeId) {
        return dictionaryRepository.findByTenantIdAndDictionaryTypeIdOrderBySortOrderAsc(tenantId, dictionaryTypeId);
    }

    public DictionaryEntity findById(Long id) {
        return dictionaryRepository.findById(id).orElse(null);
    }

    @Transactional
    public void create(DictionaryEntity dictionary) {
        dictionary.setCreatedAt(LocalDateTime.now());
        dictionary.setUpdatedAt(LocalDateTime.now());
        dictionaryRepository.save(dictionary);
    }

    @Transactional
    public void update(DictionaryEntity dictionary) {
        dictionary.setUpdatedAt(LocalDateTime.now());
        dictionaryRepository.save(dictionary);
    }

    @Transactional
    public void delete(Long id) {
        dictionaryRepository.deleteById(id);
    }
}