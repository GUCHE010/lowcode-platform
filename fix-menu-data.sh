#!/bin/bash

# ============================================
# 低代码平台 - 修复菜单数据脚本
# 功能：修复后端返回的菜单 path 字段
# 使用：在 Git Bash 中执行 ./fix-menu-data.sh
# ============================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_separator() {
    echo "=========================================="
}

# 项目路径
PROJECT_PATH="/d/GUCHKAIFAPROJECT/DIDAIMAPINTAI/lowcode-platform"
BACKEND_PATH="$PROJECT_PATH/backend"

print_separator
print_info "修复后端菜单数据"
print_separator

cd "$BACKEND_PATH" || {
    echo "后端目录不存在"
    exit 1
}

# ============================================
# 1. 修复 PermissionService.java
# 确保返回的菜单包含正确的 path
# ============================================
print_info "修复 PermissionService.java..."

cat > src/main/java/com/platform/system/service/PermissionService.java << 'EOF'
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
        
        // 只返回菜单类型的（不返回按钮）
        List<MenuEntity> menuMenus = allMenus.stream()
                .filter(m -> "menu".equals(m.getMenuType()))
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
EOF

print_success "PermissionService.java 已修复"

# ============================================
# 2. 更新数据库中的菜单 path 字段
# ============================================
print_info "请执行以下 SQL 更新菜单 path..."

cat << 'SQL_EOF'

============================================
请在 MySQL 中执行以下 SQL：
============================================

USE lowcode_platform;

-- 更新菜单的 path 字段，使其与前端路由匹配
UPDATE sys_menu SET path = '/user' WHERE menu_code = 'system:user' AND menu_type = 'menu';
UPDATE sys_menu SET path = '/role' WHERE menu_code = 'system:role' AND menu_type = 'menu';
UPDATE sys_menu SET path = '/menu' WHERE menu_code = 'system:menu' AND menu_type = 'menu';

-- 查看菜单数据确认
SELECT id, menu_code, menu_name, menu_type, path, component FROM sys_menu WHERE menu_type = 'menu';

============================================
SQL_EOF

print_separator
print_success "✅ 后端代码修复完成！"
print_separator
echo ""
print_info "请执行以下操作："
echo "  1. 在 MySQL 中执行上面的 SQL 语句"
echo "  2. 重启后端: cd $BACKEND_PATH && mvn spring-boot:run"
echo "  3. 重启前端并清除缓存"
echo ""