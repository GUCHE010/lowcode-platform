#!/bin/bash

# ============================================
# 低代码平台 - 创建后端实体类脚本
# 功能：创建权限体系的所有实体类
# 使用：在 Git Bash 中执行 ./create-entities.sh
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
print_info "创建后端实体类脚本"
print_info "项目路径: $BACKEND_PATH"
print_separator

# 进入后端目录
cd "$BACKEND_PATH" || {
    print_error "后端目录不存在: $BACKEND_PATH"
    exit 1
}

# ============================================
# 1. RoleEntity.java
# ============================================
print_info "创建 RoleEntity.java..."

cat > src/main/java/com/platform/system/entity/RoleEntity.java << 'EOF'
package com.platform.system.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 角色实体类
 */
@Data
@Entity
@Table(name = "sys_role")
public class RoleEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "tenant_id")
    private Long tenantId;
    
    @Column(name = "role_code", unique = true)
    private String roleCode;
    
    @Column(name = "role_name")
    private String roleName;
    
    @Column(name = "role_desc")
    private String roleDesc;
    
    private String status;
    
    @Column(name = "sort_order")
    private Integer sortOrder;
    
    @Column(name = "is_system")
    private Integer isSystem;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
EOF
print_success "RoleEntity.java 创建成功"

# ============================================
# 2. MenuEntity.java
# ============================================
print_info "创建 MenuEntity.java..."

cat > src/main/java/com/platform/system/entity/MenuEntity.java << 'EOF'
package com.platform.system.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 菜单实体类
 */
@Data
@Entity
@Table(name = "sys_menu")
public class MenuEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "parent_id")
    private Long parentId;
    
    @Column(name = "menu_type")
    private String menuType;
    
    @Column(name = "menu_code")
    private String menuCode;
    
    @Column(name = "menu_name")
    private String menuName;
    
    private String path;
    private String component;
    private String icon;
    
    @Column(name = "sort_order")
    private Integer sortOrder;
    
    private String status;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @Transient
    private List<MenuEntity> children = new ArrayList<>();
}
EOF
print_success "MenuEntity.java 创建成功"

# ============================================
# 3. UserRoleEntity.java
# ============================================
print_info "创建 UserRoleEntity.java..."

cat > src/main/java/com/platform/system/entity/UserRoleEntity.java << 'EOF'
package com.platform.system.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 用户角色关联实体类
 */
@Data
@Entity
@Table(name = "sys_user_role")
public class UserRoleEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "user_id")
    private Long userId;
    
    @Column(name = "role_id")
    private Long roleId;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
}
EOF
print_success "UserRoleEntity.java 创建成功"

# ============================================
# 4. RoleMenuEntity.java
# ============================================
print_info "创建 RoleMenuEntity.java..."

cat > src/main/java/com/platform/system/entity/RoleMenuEntity.java << 'EOF'
package com.platform.system.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 角色菜单关联实体类
 */
@Data
@Entity
@Table(name = "sys_role_menu")
public class RoleMenuEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "role_id")
    private Long roleId;
    
    @Column(name = "menu_id")
    private Long menuId;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
}
EOF
print_success "RoleMenuEntity.java 创建成功"

# ============================================
# 5. 验证创建结果
# ============================================
print_separator
print_info "验证创建结果..."

echo ""
echo "已创建的实体类文件:"
ls -la src/main/java/com/platform/system/entity/*.java 2>/dev/null || print_error "未找到实体类文件"
echo ""

print_separator
print_success "✅ 所有实体类创建完成！"
print_separator
echo ""
print_info "下一步："
echo "  1. 执行数据库建表 SQL（MySQL）"
echo "  2. 创建 Repository 层"
echo "  3. 创建 Service 层"
echo "  4. 创建 Controller 层"
echo ""
print_info "需要继续创建 Repository 层吗？请告诉我。"