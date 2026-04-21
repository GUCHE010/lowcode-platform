package com.platform.system.repository;

import com.platform.system.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Long> {
    List<UserEntity> findByTenantId(Long tenantId);
    Optional<UserEntity> findByUsername(String username);
    Optional<UserEntity> findByTenantIdAndUsername(Long tenantId, String username);

    @Query("SELECT u FROM UserEntity u WHERE u.tenantId = :tenantId " +
           "AND (:username IS NULL OR :username = '' OR u.username LIKE %:username%) " +
           "AND (:realName IS NULL OR :realName = '' OR u.realName LIKE %:realName%) " +
           "AND (:phone IS NULL OR :phone = '' OR u.phone LIKE %:phone%) " +
           "AND (:deptId IS NULL OR u.deptId = :deptId) " +
           "AND (:postId IS NULL OR u.postId = :postId) " +
           "AND (:status IS NULL OR :status = '' OR u.status = :status) " +
           "ORDER BY u.id")
    List<UserEntity> searchUsers(@Param("tenantId") Long tenantId,
                                @Param("username") String username,
                                @Param("realName") String realName,
                                @Param("phone") String phone,
                                @Param("deptId") Long deptId,
                                @Param("postId") Long postId,
                                @Param("status") String status);
}
