package com.platform.system.repository;

import com.platform.system.entity.RoleEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface RoleRepository extends JpaRepository<RoleEntity, Long> {
    List<RoleEntity> findByTenantId(Long tenantId);
    Optional<RoleEntity> findByTenantIdAndRoleCode(Long tenantId, String roleCode);
}
