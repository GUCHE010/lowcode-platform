package com.platform.system.repository;

import com.platform.system.entity.MenuEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface MenuRepository extends JpaRepository<MenuEntity, Long> {
    List<MenuEntity> findByStatusOrderBySortOrderAsc(String status);
    List<MenuEntity> findByParentIdOrderBySortOrderAsc(Long parentId);
}
