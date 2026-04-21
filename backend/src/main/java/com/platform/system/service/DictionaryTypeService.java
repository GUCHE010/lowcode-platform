package com.platform.system.service;

import com.platform.system.entity.DictionaryTypeEntity;
import com.platform.system.repository.DictionaryTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class DictionaryTypeService {

    @Autowired
    private DictionaryTypeRepository dictionaryTypeRepository;

    public List<DictionaryTypeEntity> listByTenant(Long tenantId) {
        return dictionaryTypeRepository.findByTenantIdOrderBySortOrder(tenantId);
    }

    public DictionaryTypeEntity findById(Long id) {
        return dictionaryTypeRepository.findById(id).orElse(null);
    }

    @Transactional
    public void create(DictionaryTypeEntity type) {
        if (type.getSortOrder() == null) {
            type.setSortOrder(0);
        }
        type.setCreatedAt(LocalDateTime.now());
        type.setStatus("active");
        dictionaryTypeRepository.save(type);
    }

    @Transactional
    public void update(DictionaryTypeEntity type) {
        type.setUpdatedAt(LocalDateTime.now());
        dictionaryTypeRepository.save(type);
    }

    @Transactional
    public void delete(Long id) {
        dictionaryTypeRepository.deleteById(id);
    }
}
