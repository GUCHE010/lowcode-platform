package com.platform.system.service;

import com.platform.system.entity.MenuEntity;
import com.platform.system.entity.RoleEntity;
import com.platform.system.entity.UserRoleEntity;
import com.platform.system.repository.MenuRepository;
import com.platform.system.repository.RoleRepository;
import com.platform.system.repository.RoleMenuRepository;
import com.platform.system.repository.UserRoleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class PermissionService {

    @Autowired
    private UserRoleRepository userRoleRepository;
    
    @Autowired
    private RoleRepository roleRepository;
    
    @Autowired
    private RoleMenuRepository roleMenuRepository;
    
    @Autowired
    private MenuRepository menuRepository;

    /**
     * 获取用户的所有角色
     */
    public List<RoleEntity> getUserRoles(Long userId) {
        List<Long> roleIds = userRoleRepository.findByUserId(userId).stream()
                .map(UserRoleEntity::getRoleId)
                .collect(Collectors.toList());
        return roleRepository.findAllById(roleIds);
    }

    /**
     * 获取用户的菜单权限（用于前端动态渲染）
     */
    public List<MenuEntity> getUserMenus(Long userId) {
        List<RoleEntity> roles = getUserRoles(userId);
        List<MenuEntity> allMenus;
        
        if (roles.stream().anyMatch(r -> "admin".equals(r.getRoleCode()))) {
            // 管理员拥有所有菜单（只返回 type=menu 的）
            allMenus = menuRepository.findByStatusOrderBySortOrderAsc("active");
        } else {
            // 获取所有角色的菜单ID
            List<Long> menuIds = roles.stream()
                    .flatMap(role -> roleMenuRepository.findByRoleId(role.getId()).stream())
                    .map(rm -> rm.getMenuId())
                    .distinct()
                    .collect(Collectors.toList());
            
            allMenus = menuRepository.findAllById(menuIds);
        }
        
        // 返回菜单和目录类型（不返回按钮）
        List<MenuEntity> menuMenus = allMenus.stream()
                .filter(m -> "menu".equals(m.getMenuType()) || "directory".equals(m.getMenuType()))
                .collect(Collectors.toList());
        
        // 构建树形结构
        return buildTree(menuMenus, 0L);
    }
    
    /**
     * 构建菜单树
     */
    private List<MenuEntity> buildTree(List<MenuEntity> all, Long parentId) {
        return all.stream()
                .filter(menu -> menu.getParentId().equals(parentId))
                .peek(menu -> {
                    List<MenuEntity> children = buildTree(all, menu.getId());
                    menu.setChildren(children);
                })
                .collect(Collectors.toList());
    }

    /**
     * 获取用户的权限标识（用于按钮级权限）
     */
    public List<String> getUserPermissions(Long userId) {
        List<RoleEntity> roles = getUserRoles(userId);
        if (roles.stream().anyMatch(r -> "admin".equals(r.getRoleCode()))) {
            // 管理员拥有所有权限
            return menuRepository.findAll().stream()
                    .map(MenuEntity::getMenuCode)
                    .collect(Collectors.toList());
        }
        
        List<Long> menuIds = roles.stream()
                .flatMap(role -> roleMenuRepository.findByRoleId(role.getId()).stream())
                .map(rm -> rm.getMenuId())
                .distinct()
                .collect(Collectors.toList());
        
        return menuRepository.findAllById(menuIds).stream()
                .map(MenuEntity::getMenuCode)
                .collect(Collectors.toList());
    }
}
