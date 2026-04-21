package com.platform.system.repository;

import com.platform.system.entity.RoleMenuEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface RoleMenuRepository extends JpaRepository<RoleMenuEntity, Long> {
    List<RoleMenuEntity> findByRoleId(Long roleId);
    
    @Modifying
    @Query("DELETE FROM RoleMenuEntity rm WHERE rm.roleId = :roleId")
    void deleteByRoleId(Long roleId);
}
