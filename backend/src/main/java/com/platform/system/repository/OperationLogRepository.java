package com.platform.system.repository;

import com.platform.system.entity.OperationLogEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface OperationLogRepository extends JpaRepository<OperationLogEntity, Long> {
    List<OperationLogEntity> findByTenantIdOrderByOperationTimeDesc(Long tenantId);
    List<OperationLogEntity> findByUserIdOrderByOperationTimeDesc(Long userId);
}