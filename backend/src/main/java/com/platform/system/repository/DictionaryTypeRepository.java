package com.platform.system.repository;

import com.platform.system.entity.DictionaryTypeEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface DictionaryTypeRepository extends JpaRepository<DictionaryTypeEntity, Long> {

    List<DictionaryTypeEntity> findByTenantId(Long tenantId);

    List<DictionaryTypeEntity> findByTenantIdOrderBySortOrder(Long tenantId);
}
