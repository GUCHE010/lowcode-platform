package com.platform.system.repository;

import com.platform.system.entity.PostEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface PostRepository extends JpaRepository<PostEntity, Long> {

    List<PostEntity> findByTenantId(Long tenantId);

    List<PostEntity> findByTenantIdOrderBySortOrder(Long tenantId);
}
