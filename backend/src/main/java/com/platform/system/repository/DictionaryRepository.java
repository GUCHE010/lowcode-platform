package com.platform.system.repository;

import com.platform.system.entity.DictionaryEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface DictionaryRepository extends JpaRepository<DictionaryEntity, Long> {
    List<DictionaryEntity> findByTenantIdOrderByDictTypeAscSortOrderAsc(Long tenantId);
    List<DictionaryEntity> findByTenantIdAndDictTypeOrderBySortOrderAsc(Long tenantId, String dictType);
    List<DictionaryEntity> findByTenantIdAndDictTypeAndStatusOrderBySortOrderAsc(Long tenantId, String dictType, String status);
    List<DictionaryEntity> findByTenantIdAndDictionaryTypeIdOrderBySortOrderAsc(Long tenantId, Long dictionaryTypeId);
    List<DictionaryEntity> findByTenantIdAndDictionaryTypeIdAndStatusOrderBySortOrderAsc(Long tenantId, Long dictionaryTypeId, String status);
}