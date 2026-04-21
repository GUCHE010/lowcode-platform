#!/bin/bash

# ============================================
# 低代码平台 - 创建后端三层代码脚本
# 功能：创建 Repository、Service、Controller 所有代码
# 使用：在 Git Bash 中执行 ./create-backend-layers.sh
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

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_separator() {
    echo "=========================================="
}

# 项目路径
PROJECT_PATH="/d/GUCHKAIFAPROJECT/DIDAIMAPINTAI/lowcode-platform"
BACKEND_PATH="$PROJECT_PATH/backend"

print_separator
print_info "创建后端三层代码脚本"
print_info "项目路径: $BACKEND_PATH"
print_separator

# 进入后端目录
cd "$BACKEND_PATH" || {
    print_error "后端目录不存在: $BACKEND_PATH"
    exit 1
}

# ============================================
# 三、Repository 层
# ============================================
print_separator
print_info "=== 创建 Repository 层 ==="

# 1. RoleRepository.java
print_info "创建 RoleRepository.java..."
cat > src/main/java/com/platform/system/repository/RoleRepository.java << 'EOF'
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
EOF
print_success "RoleRepository.java 创建成功"

# 2. MenuRepository.java
print_info "创建 MenuRepository.java..."
cat > src/main/java/com/platform/system/repository/MenuRepository.java << 'EOF'
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
EOF
print_success "MenuRepository.java 创建成功"

# 3. UserRoleRepository.java
print_info "创建 UserRoleRepository.java..."
cat > src/main/java/com/platform/system/repository/UserRoleRepository.java << 'EOF'
package com.platform.system.repository;

import com.platform.system.entity.UserRoleEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface UserRoleRepository extends JpaRepository<UserRoleEntity, Long> {
    List<UserRoleEntity> findByUserId(Long userId);
    void deleteByUserId(Long userId);
}
EOF
print_success "UserRoleRepository.java 创建成功"

# 4. RoleMenuRepository.java
print_info "创建 RoleMenuRepository.java..."
cat > src/main/java/com/platform/system/repository/RoleMenuRepository.java << 'EOF'
package com.platform.system.repository;

import com.platform.system.entity.RoleMenuEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface RoleMenuRepository extends JpaRepository<RoleMenuEntity, Long> {
    List<RoleMenuEntity> findByRoleId(Long roleId);
    void deleteByRoleId(Long roleId);
}
EOF
print_success "RoleMenuRepository.java 创建成功"

print_success "✅ Repository 层创建完成（4个文件）"

# ============================================
# 四、Service 层
# ============================================
print_separator
print_info "=== 创建 Service 层 ==="

# 1. RoleService.java
print_info "创建 RoleService.java..."
cat > src/main/java/com/platform/system/service/RoleService.java << 'EOF'
package com.platform.system.service;

import com.platform.system.entity.RoleEntity;
import com.platform.system.entity.RoleMenuEntity;
import com.platform.system.repository.RoleRepository;
import com.platform.system.repository.RoleMenuRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class RoleService {

    @Autowired
    private RoleRepository roleRepository;
    
    @Autowired
    private RoleMenuRepository roleMenuRepository;

    public List<RoleEntity> listByTenant(Long tenantId) {
        return roleRepository.findByTenantId(tenantId);
    }

    @Transactional
    public void create(RoleEntity role) {
        role.setCreatedAt(LocalDateTime.now());
        role.setUpdatedAt(LocalDateTime.now());
        roleRepository.save(role);
    }

    @Transactional
    public void update(RoleEntity role) {
        role.setUpdatedAt(LocalDateTime.now());
        roleRepository.save(role);
    }

    @Transactional
    public void delete(Long id) {
        // 删除角色菜单关联
        roleMenuRepository.deleteByRoleId(id);
        // 删除角色
        roleRepository.deleteById(id);
    }

    public RoleEntity findById(Long id) {
        return roleRepository.findById(id).orElse(null);
    }

    @Transactional
    public void assignPermissions(Long roleId, List<Long> menuIds) {
        // 删除原有权限
        roleMenuRepository.deleteByRoleId(roleId);
        // 添加新权限
        List<RoleMenuEntity> list = menuIds.stream().map(menuId -> {
            RoleMenuEntity rm = new RoleMenuEntity();
            rm.setRoleId(roleId);
            rm.setMenuId(menuId);
            rm.setCreatedAt(LocalDateTime.now());
            return rm;
        }).collect(Collectors.toList());
        roleMenuRepository.saveAll(list);
    }

    public List<Long> getRoleMenuIds(Long roleId) {
        return roleMenuRepository.findByRoleId(roleId).stream()
                .map(RoleMenuEntity::getMenuId)
                .collect(Collectors.toList());
    }
}
EOF
print_success "RoleService.java 创建成功"

# 2. MenuService.java
print_info "创建 MenuService.java..."
cat > src/main/java/com/platform/system/service/MenuService.java << 'EOF'
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
EOF
print_success "MenuService.java 创建成功"

# 3. PermissionService.java
print_info "创建 PermissionService.java..."
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
        if (roles.stream().anyMatch(r -> "admin".equals(r.getRoleCode()))) {
            // 管理员拥有所有菜单
            return menuRepository.findByStatusOrderBySortOrderAsc("active");
        }
        
        // 获取所有角色的菜单ID
        List<Long> menuIds = roles.stream()
                .flatMap(role -> roleMenuRepository.findByRoleId(role.getId()).stream())
                .map(rm -> rm.getMenuId())
                .distinct()
                .collect(Collectors.toList());
        
        return menuRepository.findAllById(menuIds).stream()
                .filter(m -> "menu".equals(m.getMenuType()))
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
print_success "PermissionService.java 创建成功"

print_success "✅ Service 层创建完成（3个文件）"

# ============================================
# 五、Controller 层
# ============================================
print_separator
print_info "=== 创建 Controller 层 ==="

# 1. RoleController.java
print_info "创建 RoleController.java..."
cat > src/main/java/com/platform/system/controller/RoleController.java << 'EOF'
package com.platform.system.controller;

import com.platform.system.entity.RoleEntity;
import com.platform.system.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/system/role")
public class RoleController {

    @Autowired
    private RoleService roleService;

    @GetMapping("/list")
    public Map<String, Object> list(@RequestParam Long tenantId) {
        List<RoleEntity> roles = roleService.listByTenant(tenantId);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", roles);
        return result;
    }

    @GetMapping("/{id}")
    public Map<String, Object> getById(@PathVariable Long id) {
        RoleEntity role = roleService.findById(id);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", role);
        return result;
    }

    @PostMapping
    public Map<String, Object> create(@RequestBody RoleEntity role) {
        roleService.create(role);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "创建成功");
        return result;
    }

    @PutMapping
    public Map<String, Object> update(@RequestBody RoleEntity role) {
        roleService.update(role);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "更新成功");
        return result;
    }

    @DeleteMapping("/{id}")
    public Map<String, Object> delete(@PathVariable Long id) {
        roleService.delete(id);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }

    @PostMapping("/permission")
    public Map<String, Object> assignPermissions(@RequestBody Map<String, Object> request) {
        Long roleId = Long.valueOf(request.get("roleId").toString());
        @SuppressWarnings("unchecked")
        List<Long> menuIds = (List<Long>) request.get("menuIds");
        roleService.assignPermissions(roleId, menuIds);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "分配成功");
        return result;
    }

    @GetMapping("/menuIds/{roleId}")
    public Map<String, Object> getRoleMenuIds(@PathVariable Long roleId) {
        List<Long> menuIds = roleService.getRoleMenuIds(roleId);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", menuIds);
        return result;
    }
}
EOF
print_success "RoleController.java 创建成功"

# 2. MenuController.java
print_info "创建 MenuController.java..."
cat > src/main/java/com/platform/system/controller/MenuController.java << 'EOF'
package com.platform.system.controller;

import com.platform.system.entity.MenuEntity;
import com.platform.system.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/system/menu")
public class MenuController {

    @Autowired
    private MenuService menuService;

    @GetMapping("/list")
    public Map<String, Object> list() {
        List<MenuEntity> menus = menuService.listAll();
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", menus);
        return result;
    }

    @GetMapping("/tree")
    public Map<String, Object> tree() {
        List<MenuEntity> tree = menuService.treeList();
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", tree);
        return result;
    }

    @GetMapping("/{id}")
    public Map<String, Object> getById(@PathVariable Long id) {
        MenuEntity menu = menuService.findById(id);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", menu);
        return result;
    }

    @PostMapping
    public Map<String, Object> create(@RequestBody MenuEntity menu) {
        menuService.create(menu);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "创建成功");
        return result;
    }

    @PutMapping
    public Map<String, Object> update(@RequestBody MenuEntity menu) {
        menuService.update(menu);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "更新成功");
        return result;
    }

    @DeleteMapping("/{id}")
    public Map<String, Object> delete(@PathVariable Long id) {
        menuService.delete(id);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
}
EOF
print_success "MenuController.java 创建成功"

# 3. 修改 AuthController.java（添加权限返回）
print_info "修改 AuthController.java（添加菜单和权限返回）..."

# 备份原文件
cp src/main/java/com/platform/auth/AuthController.java src/main/java/com/platform/auth/AuthController.java.bak 2>/dev/null || true

cat > src/main/java/com/platform/auth/AuthController.java << 'EOF'
package com.platform.auth;

import com.platform.system.entity.MenuEntity;
import com.platform.system.entity.UserEntity;
import com.platform.system.service.PermissionService;
import com.platform.system.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;
    
    @Autowired
    private PermissionService permissionService;

    @PostMapping("/login")
    public Map<String, Object> login(@RequestBody Map<String, String> request) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            String tenantCode = request.get("tenantCode");
            String username = request.get("username");
            String password = request.get("password");
            
            UserEntity user = userService.login(tenantCode, username, password);
            if (user == null) {
                result.put("success", false);
                result.put("message", "用户名或密码错误");
                return result;
            }
            
            String token = jwtUtil.generate(user.getId(), user.getTenantId(), user.getUsername());
            
            // 获取用户菜单
            List<MenuEntity> menus = permissionService.getUserMenus(user.getId());
            // 获取用户权限标识
            List<String> permissions = permissionService.getUserPermissions(user.getId());
            
            result.put("success", true);
            result.put("token", token);
            
            Map<String, Object> userInfo = new HashMap<>();
            userInfo.put("id", user.getId());
            userInfo.put("username", user.getUsername());
            userInfo.put("realName", user.getRealName());
            userInfo.put("email", user.getEmail());
            userInfo.put("phone", user.getPhone());
            userInfo.put("menus", menus);
            userInfo.put("permissions", permissions);
            result.put("user", userInfo);
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "服务器错误: " + e.getMessage());
        }
        
        return result;
    }
}
EOF
print_success "AuthController.java 修改成功"

print_success "✅ Controller 层创建完成（3个文件）"

# ============================================
# 六、编译验证
# ============================================
print_separator
print_info "编译验证..."

if mvn clean compile; then
    print_success "✅ 编译成功！"
else
    print_error "编译失败，请检查错误信息"
    exit 1
fi

# ============================================
# 七、完成
# ============================================
print_separator
print_success "✅ 所有代码创建完成！"
print_separator
echo ""
print_info "创建的文件清单："
echo ""
echo "【Repository 层】4个文件"
echo "  - RoleRepository.java"
echo "  - MenuRepository.java"
echo "  - UserRoleRepository.java"
echo "  - RoleMenuRepository.java"
echo ""
echo "【Service 层】3个文件"
echo "  - RoleService.java"
echo "  - MenuService.java"
echo "  - PermissionService.java"
echo ""
echo "【Controller 层】3个文件"
echo "  - RoleController.java"
echo "  - MenuController.java"
echo "  - AuthController.java（已修改）"
echo ""
print_separator
print_info "下一步操作："
echo "  1. 重启后端: cd $BACKEND_PATH && mvn spring-boot:run"
echo "  2. 执行数据库建表 SQL（MySQL）"
echo "  3. 测试角色管理 API"
echo "  4. 测试菜单管理 API"
echo "  5. 测试登录返回菜单和权限"
echo ""
print_separator