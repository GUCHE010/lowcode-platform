#!/bin/bash

# ============================================
# 低代码平台 - 后端改造脚本
# 功能：将内存存储改为 MySQL 数据库存储
# 使用：在 Git Bash 中执行 ./update-backend.sh
# ============================================

set -e  # 遇到错误立即停止

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 打印分隔线
print_separator() {
    echo "=========================================="
}

# ============================================
# 第一步：配置变量
# ============================================

print_separator
print_info "低代码平台后端改造脚本"
print_info "功能：内存存储 → MySQL 数据库"
print_separator

# 项目路径（可根据实际情况修改）
PROJECT_PATH="/d/GUCHKAIFAPROJECT/DIDAIMAPINTAI/lowcode-platform"
BACKEND_PATH="$PROJECT_PATH/backend"

# MySQL 配置（请根据实际情况修改）
MYSQL_HOST="localhost"
MYSQL_PORT="3308"
MYSQL_DATABASE="lowcode_platform"
MYSQL_USERNAME="root"
MYSQL_PASSWORD="hhdtest"  # ⚠️ 请修改为你的 MySQL 密码

# JWT 配置
JWT_SECRET="mySecretKey123456789012345678901234567890"

print_info "项目路径: $PROJECT_PATH"
print_info "MySQL 数据库: $MYSQL_DATABASE"
print_info "MySQL 用户名: $MYSQL_USERNAME"
print_warning "请确保 MySQL 密码已正确设置（当前脚本中为: $MYSQL_PASSWORD）"
echo ""

# 确认执行
read -p "是否继续执行？(y/n): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "脚本已取消"
    exit 1
fi

# ============================================
# 第二步：进入项目目录
# ============================================

print_separator
print_info "进入项目目录..."
cd "$PROJECT_PATH" || {
    print_error "项目目录不存在: $PROJECT_PATH"
    exit 1
}
print_success "当前目录: $(pwd)"

# ============================================
# 第三步：备份原文件
# ============================================

print_separator
print_info "备份原文件..."

BACKUP_DIR="$BACKEND_PATH/backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# 备份配置文件
cp "$BACKEND_PATH/pom.xml" "$BACKUP_DIR/pom.xml.bak"
cp "$BACKEND_PATH/src/main/resources/application.yml" "$BACKUP_DIR/application.yml.bak"

# 备份 Java 文件
cp "$BACKEND_PATH/src/main/java/com/platform/system/service/UserService.java" "$BACKUP_DIR/UserService.java.bak" 2>/dev/null || true
cp "$BACKEND_PATH/src/main/java/com/platform/system/controller/UserController.java" "$BACKUP_DIR/UserController.java.bak" 2>/dev/null || true

print_success "备份完成，备份目录: $BACKUP_DIR"

# ============================================
# 第四步：创建数据库
# ============================================

print_separator
print_info "创建数据库（如果不存在）..."

# 检查 MySQL 是否可用
if command -v mysql &> /dev/null; then
    mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USERNAME" -p"$MYSQL_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null
    if [ $? -eq 0 ]; then
        print_success "数据库创建成功或已存在: $MYSQL_DATABASE"
    else
        print_warning "无法自动创建数据库，请手动创建"
        echo "执行命令: CREATE DATABASE $MYSQL_DATABASE CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    fi
else
    print_warning "未找到 mysql 命令，请手动创建数据库: $MYSQL_DATABASE"
fi

# ============================================
# 第五步：修改 pom.xml（替换 PostgreSQL 为 MySQL）
# ============================================

print_separator
print_info "修改 pom.xml..."

cd "$BACKEND_PATH"

# 检查是否有 PostgreSQL 依赖，有则替换
if grep -q "postgresql" pom.xml; then
    # 使用 sed 替换（兼容 Git Bash）
    sed -i 's|<dependency>\
    <groupId>org.postgresql</groupId>\
    <artifactId>postgresql</artifactId>\
</dependency>|<dependency>\
    <groupId>com.mysql</groupId>\
    <artifactId>mysql-connector-j</artifactId>\
    <version>8.1.0</version>\
</dependency>|g' pom.xml 2>/dev/null || {
        # 如果 sed 失败，使用更简单的方式
        print_warning "自动替换失败，请手动修改 pom.xml"
        echo "需要将 postgresql 依赖替换为:"
        echo '<dependency>'
        echo '    <groupId>com.mysql</groupId>'
        echo '    <artifactId>mysql-connector-j</artifactId>'
        echo '    <version>8.1.0</version>'
        echo '</dependency>'
    }
    print_success "pom.xml 已修改"
else
    print_info "pom.xml 中没有 PostgreSQL 依赖，检查是否已有 MySQL 依赖..."
    if ! grep -q "mysql-connector" pom.xml; then
        # 在 dependencies 中添加 MySQL 依赖
        sed -i 's|</dependencies>|    <dependency>\n        <groupId>com.mysql</groupId>\n        <artifactId>mysql-connector-j</artifactId>\n        <version>8.1.0</version>\n    </dependency>\n</dependencies>|g' pom.xml
        print_success "已添加 MySQL 依赖"
    else
        print_info "MySQL 依赖已存在"
    fi
fi

# ============================================
# 第六步：修改 application.yml
# ============================================

print_separator
print_info "修改 application.yml..."

cat > "$BACKEND_PATH/src/main/resources/application.yml" << EOF
spring:
  datasource:
    url: jdbc:mysql://${MYSQL_HOST}:${MYSQL_PORT}/${MYSQL_DATABASE}?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=utf8
    username: ${MYSQL_USERNAME}
    password: ${MYSQL_PASSWORD}
    driver-class-name: com.mysql.cj.jdbc.Driver
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQL8Dialect
        format_sql: true

platform:
  security:
    jwt-secret: ${JWT_SECRET}
    token-expire: 86400000

server:
  port: 8080

logging:
  level:
    com.platform: DEBUG
EOF

print_success "application.yml 已更新"

# ============================================
# 第七步：创建 UserRepository.java
# ============================================

print_separator
print_info "创建 UserRepository.java..."

mkdir -p "$BACKEND_PATH/src/main/java/com/platform/system/repository"

cat > "$BACKEND_PATH/src/main/java/com/platform/system/repository/UserRepository.java" << 'EOF'
package com.platform.system.repository;

import com.platform.system.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Long> {
    List<UserEntity> findByTenantId(Long tenantId);
    Optional<UserEntity> findByUsername(String username);
    Optional<UserEntity> findByTenantIdAndUsername(Long tenantId, String username);
}
EOF

print_success "UserRepository.java 已创建"

# ============================================
# 第八步：创建 TenantRepository.java
# ============================================

print_separator
print_info "创建 TenantRepository.java..."

mkdir -p "$BACKEND_PATH/src/main/java/com/platform/tenant/repository"

cat > "$BACKEND_PATH/src/main/java/com/platform/tenant/repository/TenantRepository.java" << 'EOF'
package com.platform.tenant.repository;

import com.platform.tenant.entity.TenantEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface TenantRepository extends JpaRepository<TenantEntity, Long> {
    Optional<TenantEntity> findByTenantCode(String tenantCode);
}
EOF

print_success "TenantRepository.java 已创建"

# ============================================
# 第九步：修改 UserService.java
# ============================================

print_separator
print_info "修改 UserService.java..."

cat > "$BACKEND_PATH/src/main/java/com/platform/system/service/UserService.java" << 'EOF'
package com.platform.system.service;

import com.platform.system.entity.UserEntity;
import com.platform.system.repository.UserRepository;
import com.platform.tenant.entity.TenantEntity;
import com.platform.tenant.repository.TenantRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import jakarta.annotation.PostConstruct;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TenantRepository tenantRepository;

    private final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @PostConstruct
    @Transactional
    public void init() {
        Optional<TenantEntity> existingTenant = tenantRepository.findByTenantCode("default");
        TenantEntity tenant;
        
        if (existingTenant.isEmpty()) {
            tenant = new TenantEntity();
            tenant.setTenantCode("default");
            tenant.setTenantName("默认租户");
            tenant.setStatus("active");
            tenant.setMaxUsers(100);
            tenant.setMaxApps(50);
            tenant.setCreatedAt(LocalDateTime.now());
            tenant = tenantRepository.save(tenant);
            System.out.println("✅ 创建默认租户: ID=" + tenant.getId());
        } else {
            tenant = existingTenant.get();
            System.out.println("✅ 已存在默认租户: ID=" + tenant.getId());
        }

        Optional<UserEntity> existingAdmin = userRepository.findByUsername("admin");
        
        if (existingAdmin.isEmpty()) {
            UserEntity admin = new UserEntity();
            admin.setTenantId(tenant.getId());
            admin.setUsername("admin");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setRealName("管理员");
            admin.setEmail("admin@lowcode.com");
            admin.setPhone("13800000000");
            admin.setStatus("active");
            admin.setCreatedAt(LocalDateTime.now());
            userRepository.save(admin);
            System.out.println("✅ 创建管理员用户: admin/admin123");
        } else {
            System.out.println("✅ 已存在管理员用户");
        }

        Optional<UserEntity> existingTest = userRepository.findByUsername("test");
        
        if (existingTest.isEmpty()) {
            UserEntity testUser = new UserEntity();
            testUser.setTenantId(tenant.getId());
            testUser.setUsername("test");
            testUser.setPassword(passwordEncoder.encode("test123"));
            testUser.setRealName("测试用户");
            testUser.setEmail("test@lowcode.com");
            testUser.setPhone("13900000000");
            testUser.setStatus("active");
            testUser.setCreatedAt(LocalDateTime.now());
            userRepository.save(testUser);
            System.out.println("✅ 创建测试用户: test/test123");
        }
    }

    public UserEntity login(String tenantCode, String username, String password) {
        Optional<TenantEntity> tenantOpt = tenantRepository.findByTenantCode(tenantCode);
        if (tenantOpt.isEmpty()) {
            System.out.println("❌ 登录失败: 租户不存在 - " + tenantCode);
            return null;
        }
        
        Long tenantId = tenantOpt.get().getId();
        Optional<UserEntity> userOpt = userRepository.findByTenantIdAndUsername(tenantId, username);
        if (userOpt.isEmpty()) {
            System.out.println("❌ 登录失败: 用户不存在 - " + username);
            return null;
        }
        
        UserEntity user = userOpt.get();
        if (!passwordEncoder.matches(password, user.getPassword())) {
            System.out.println("❌ 登录失败: 密码错误 - " + username);
            return null;
        }
        
        user.setLastLoginTime(LocalDateTime.now());
        userRepository.save(user);
        System.out.println("✅ 登录成功: " + username);
        return user;
    }

    public List<UserEntity> listByTenant(Long tenantId) {
        return userRepository.findByTenantId(tenantId);
    }

    @Transactional
    public void create(UserEntity user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setCreatedAt(LocalDateTime.now());
        user.setStatus("active");
        userRepository.save(user);
    }

    @Transactional
    public void update(UserEntity user) {
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            user.setPassword(passwordEncoder.encode(user.getPassword()));
        } else {
            UserEntity existing = userRepository.findById(user.getId()).orElse(null);
            if (existing != null) {
                user.setPassword(existing.getPassword());
            }
        }
        userRepository.save(user);
    }

    @Transactional
    public void delete(Long id) {
        userRepository.deleteById(id);
    }

    public UserEntity findById(Long id) {
        return userRepository.findById(id).orElse(null);
    }
}
EOF

print_success "UserService.java 已更新"

# ============================================
# 第十步：修改 UserController.java
# ============================================

print_separator
print_info "修改 UserController.java..."

cat > "$BACKEND_PATH/src/main/java/com/platform/system/controller/UserController.java" << 'EOF'
package com.platform.system.controller;

import com.platform.system.entity.UserEntity;
import com.platform.system.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/system/user")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/list")
    public Map<String, Object> list(@RequestParam Long tenantId) {
        List<UserEntity> users = userService.listByTenant(tenantId);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", users);
        return result;
    }

    @GetMapping("/{id}")
    public Map<String, Object> getById(@PathVariable Long id) {
        UserEntity user = userService.findById(id);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", user);
        return result;
    }

    @PostMapping
    public Map<String, Object> create(@RequestBody UserEntity user) {
        userService.create(user);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "创建成功");
        return result;
    }

    @PutMapping
    public Map<String, Object> update(@RequestBody UserEntity user) {
        userService.update(user);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "更新成功");
        return result;
    }

    @DeleteMapping("/{id}")
    public Map<String, Object> delete(@PathVariable Long id) {
        userService.delete(id);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
}
EOF

print_success "UserController.java 已更新"

# ============================================
# 第十一步：清理并编译
# ============================================

print_separator
print_info "清理并编译项目..."

cd "$BACKEND_PATH"

# 执行 Maven 清理和编译
print_info "执行 mvn clean compile..."
if mvn clean compile; then
    print_success "编译成功！"
else
    print_error "编译失败，请检查错误信息"
    print_info "常见问题："
    echo "  1. MySQL 驱动下载失败 - 检查网络连接"
    echo "  2. 数据库连接失败 - 确认 MySQL 已启动"
    echo "  3. 密码错误 - 修改脚本中的 MYSQL_PASSWORD"
    exit 1
fi

# ============================================
# 第十二步：完成
# ============================================

print_separator
print_success "✅ 后端改造完成！"
print_separator
echo ""
print_info "下一步操作："
echo "  1. 启动后端: cd $BACKEND_PATH && mvn spring-boot:run"
echo "  2. 测试登录: 前端访问 http://localhost:5173"
echo "  3. 测试账号: default / admin / admin123"
echo ""
print_info "备份文件位置: $BACKUP_DIR"
print_separator