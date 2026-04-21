#!/bin/bash

echo "========================================="
echo "低代码平台 - 完整代码生成器"
echo "========================================="

# 进入项目根目录
cd /d/GUCHKAIFAPROJECT/DIDAIMAPINTAI/lowcode-platform

echo "✓ 开始生成所有Java文件..."

# 创建目录结构
mkdir -p backend/src/main/java/com/platform/auth
mkdir -p backend/src/main/java/com/platform/config
mkdir -p backend/src/main/java/com/platform/tenant/entity
mkdir -p backend/src/main/java/com/platform/system/entity
mkdir -p backend/src/main/java/com/platform/system/controller
mkdir -p backend/src/main/java/com/platform/system/service
mkdir -p backend/src/main/java/com/platform/license
mkdir -p backend/src/main/java/com/platform/ai
mkdir -p backend/src/main/java/com/platform/workflow
mkdir -p backend/src/main/java/com/platform/common

echo "✓ 目录结构创建完成"

# 1. Application.java
cat > backend/src/main/java/com/platform/Application.java << 'EOF'
package com.platform;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
EOF

# 2. TenantEntity.java
cat > backend/src/main/java/com/platform/tenant/entity/TenantEntity.java << 'EOF'
package com.platform.tenant.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "platform_tenant")
public class TenantEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true, nullable = false)
    private String tenantCode;
    
    @Column(nullable = false)
    private String tenantName;
    
    private String licenseKey;
    private String status;
    private LocalDateTime expireDate;
    private Integer maxUsers;
    private Integer maxApps;
    private LocalDateTime createdAt;
}
EOF

# 3. UserEntity.java
cat > backend/src/main/java/com/platform/system/entity/UserEntity.java << 'EOF'
package com.platform.system.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "sys_user")
public class UserEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private Long tenantId;
    private String username;
    private String password;
    private String realName;
    private String email;
    private String phone;
    private Long deptId;
    private Long postId;
    private String status;
    private LocalDateTime lastLoginTime;
    private LocalDateTime createdAt;
}
EOF

# 4. JwtUtil.java
cat > backend/src/main/java/com/platform/auth/JwtUtil.java << 'EOF'
package com.platform.auth;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import java.util.Date;

@Component
public class JwtUtil {
    @Value("${platform.security.jwt-secret}")
    private String secret;
    
    public String generate(Long userId, Long tenantId, String username) {
        return Jwts.builder()
            .setSubject(String.valueOf(userId))
            .claim("tenantId", tenantId)
            .claim("username", username)
            .setIssuedAt(new Date())
            .setExpiration(new Date(System.currentTimeMillis() + 86400000))
            .signWith(SignatureAlgorithm.HS256, secret)
            .compact();
    }
    
    public Claims parse(String token) {
        return Jwts.parser().setSigningKey(secret).parseClaimsJws(token).getBody();
    }
}
EOF

# 5. AuthController.java
cat > backend/src/main/java/com/platform/auth/AuthController.java << 'EOF'
package com.platform.auth;

import com.platform.system.service.UserService;
import com.platform.system.entity.UserEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private JwtUtil jwtUtil;
    
    @PostMapping("/login")
    public Map<String, Object> login(@RequestBody Map<String, String> request) {
        String tenantCode = request.get("tenantCode");
        String username = request.get("username");
        String password = request.get("password");
        
        UserEntity user = userService.login(tenantCode, username, password);
        if (user == null) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "用户名或密码错误");
            return error;
        }
        
        String token = jwtUtil.generate(user.getId(), user.getTenantId(), user.getUsername());
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("token", token);
        result.put("user", Map.of(
            "id", user.getId(),
            "username", user.getUsername(),
            "realName", user.getRealName(),
            "email", user.getEmail(),
            "phone", user.getPhone()
        ));
        return result;
    }
}
EOF

# 6. UserController.java
cat > backend/src/main/java/com/platform/system/controller/UserController.java << 'EOF'
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
    
    @PostMapping
    public Map<String, Object> create(@RequestBody UserEntity user) {
        userService.create(user);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }
    
    @PutMapping
    public Map<String, Object> update(@RequestBody UserEntity user) {
        userService.update(user);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }
    
    @DeleteMapping("/{id}")
    public Map<String, Object> delete(@PathVariable Long id) {
        userService.delete(id);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }
}
EOF

# 7. UserService.java
cat > backend/src/main/java/com/platform/system/service/UserService.java << 'EOF'
package com.platform.system.service;

import com.platform.system.entity.UserEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import jakarta.annotation.PostConstruct;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class UserService {
    private final ConcurrentHashMap<Long, UserEntity> userStore = new ConcurrentHashMap<>();
    private long idCounter = 1;
    private final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    
    @PostConstruct
    public void init() {
        UserEntity admin = new UserEntity();
        admin.setId(idCounter++);
        admin.setTenantId(1L);
        admin.setUsername("admin");
        admin.setPassword(passwordEncoder.encode("admin123"));
        admin.setRealName("管理员");
        admin.setStatus("active");
        admin.setCreatedAt(LocalDateTime.now());
        userStore.put(admin.getId(), admin);
        
        UserEntity testUser = new UserEntity();
        testUser.setId(idCounter++);
        testUser.setTenantId(1L);
        testUser.setUsername("test");
        testUser.setPassword(passwordEncoder.encode("test123"));
        testUser.setRealName("测试用户");
        testUser.setStatus("active");
        testUser.setCreatedAt(LocalDateTime.now());
        userStore.put(testUser.getId(), testUser);
    }
    
    public UserEntity login(String tenantCode, String username, String password) {
        for (UserEntity user : userStore.values()) {
            if (user.getUsername().equals(username) && 
                passwordEncoder.matches(password, user.getPassword())) {
                user.setLastLoginTime(LocalDateTime.now());
                return user;
            }
        }
        return null;
    }
    
    public List<UserEntity> listByTenant(Long tenantId) {
        List<UserEntity> result = new ArrayList<>();
        for (UserEntity user : userStore.values()) {
            if (user.getTenantId().equals(tenantId)) {
                result.add(user);
            }
        }
        return result;
    }
    
    public void create(UserEntity user) {
        user.setId(idCounter++);
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setCreatedAt(LocalDateTime.now());
        userStore.put(user.getId(), user);
    }
    
    public void update(UserEntity user) {
        userStore.put(user.getId(), user);
    }
    
    public void delete(Long id) {
        userStore.remove(id);
    }
}
EOF

# 8. WebConfig.java
cat > backend/src/main/java/com/platform/config/WebConfig.java << 'EOF'
package com.platform.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
            .allowedOrigins("http://localhost:5173", "http://localhost:5174")
            .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
            .allowedHeaders("*")
            .allowCredentials(true);
    }
}
EOF

# 9. pom.xml (如果不存在则创建)
if [ ! -f backend/pom.xml ]; then
cat > backend/pom.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.0</version>
    </parent>
    <groupId>com.platform</groupId>
    <artifactId>lowcode-platform</artifactId>
    <version>1.0.0</version>
    <properties>
        <java.version>21</java.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-redis</artifactId>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt</artifactId>
            <version>0.12.3</version>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
    </dependencies>
</project>
EOF
fi

# 10. application.yml
if [ ! -f backend/src/main/resources/application.yml ]; then
mkdir -p backend/src/main/resources
cat > backend/src/main/resources/application.yml << 'EOF'
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/lowcode
    username: postgres
    password: password
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true

platform:
  security:
    jwt-secret: your-secret-key-123456
    token-expire: 86400000

server:
  port: 8080
EOF
fi

echo ""
echo "========================================="
echo "所有Java文件生成完成！"
echo "========================================="
echo ""
echo "生成的文件列表："
find backend/src/main/java -name "*.java" | sort
echo ""
echo "下一步："
echo "1. cd backend"
echo "2. mvn clean compile"
echo "3. mvn spring-boot:run"
echo "========================================="