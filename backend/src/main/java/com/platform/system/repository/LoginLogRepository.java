package com.platform.system.repository;

import com.platform.system.entity.LoginLogEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface LoginLogRepository extends JpaRepository<LoginLogEntity, Long> {
    List<LoginLogEntity> findByTenantIdOrderByLoginTimeDesc(Long tenantId);
    List<LoginLogEntity> findByUserIdOrderByLoginTimeDesc(Long userId);
}