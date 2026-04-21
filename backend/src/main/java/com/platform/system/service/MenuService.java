package com.platform.system.service;

import com.platform.system.entity.MenuEntity;
import com.platform.system.repository.MenuRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class MenuService {

    @Autowired
    private MenuRepository menuRepository;

    public List<MenuEntity> listAll() {
        return menuRepository.findByStatusOrderBySortOrderAsc("active");
    }

    public List<MenuEntity> treeList() {
        List<MenuEntity> all = listAll();
        return buildTree(all, 0L);
    }

    private List<MenuEntity> buildTree(List<MenuEntity> all, Long parentId) {
        return all.stream()
                .filter(menu -> menu.getParentId().equals(parentId))
                .peek(menu -> menu.setChildren(buildTree(all, menu.getId())))
                .collect(Collectors.toList());
    }

    @Transactional
    public void create(MenuEntity menu) {
        menu.setCreatedAt(LocalDateTime.now());
        menu.setUpdatedAt(LocalDateTime.now());
        menuRepository.save(menu);
    }

    @Transactional
    public void update(MenuEntity menu) {
        menu.setUpdatedAt(LocalDateTime.now());
        menuRepository.save(menu);
    }

    @Transactional
    public void delete(Long id) {
        // 删除子菜单
        List<MenuEntity> children = menuRepository.findByParentIdOrderBySortOrderAsc(id);
        children.forEach(child -> delete(child.getId()));
        // 删除自身
        menuRepository.deleteById(id);
    }

    public MenuEntity findById(Long id) {
        return menuRepository.findById(id).orElse(null);
    }
}
