package com.platform.system.repository;

import com.platform.system.entity.DeptEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface DeptRepository extends JpaRepository<DeptEntity, Long> {

    List<DeptEntity> findByTenantId(Long tenantId);

    List<DeptEntity> findByParentId(Long parentId);

    List<DeptEntity> findByTenantIdAndParentId(Long tenantId, Long parentId);

    @Query("SELECT d FROM DeptEntity d WHERE d.tenantId = :tenantId ORDER BY d.sortOrder, d.id")
    List<DeptEntity> findByTenantIdOrderBySortOrder(Long tenantId);
}
