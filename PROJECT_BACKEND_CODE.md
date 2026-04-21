

\---



\## 文件2：PROJECT\_BACKEND\_CODE.md



```markdown

\# 后端完整代码



\## 1. Application.java

```java

package com.platform;



import org.springframework.boot.SpringApplication;

import org.springframework.boot.autoconfigure.SpringBootApplication;

import org.springframework.scheduling.annotation.EnableScheduling;



@SpringBootApplication

@EnableScheduling

public class Application {

&#x20;   public static void main(String\[] args) {

&#x20;       SpringApplication.run(Application.class, args);

&#x20;   }

}



2\. TestController.java



package com.platform.api;



import org.springframework.web.bind.annotation.\*;

import java.util.Map;



@RestController

public class TestController {

&#x20;   

&#x20;   @GetMapping("/test")

&#x20;   public Map<String, String> test() {

&#x20;       return Map.of("message", "Hello from backend!");

&#x20;   }

}



3\. AuthController.java



package com.platform.auth;



import com.platform.system.service.UserService;

import com.platform.system.entity.UserEntity;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.web.bind.annotation.\*;

import java.util.HashMap;

import java.util.Map;



@RestController

@RequestMapping("/api/auth")

public class AuthController {

&#x20;   

&#x20;   @Autowired

&#x20;   private UserService userService;

&#x20;   

&#x20;   @Autowired

&#x20;   private JwtUtil jwtUtil;

&#x20;   

&#x20;   @PostMapping("/login")

&#x20;   public Map<String, Object> login(@RequestBody Map<String, String> request) {

&#x20;       Map<String, Object> result = new HashMap<>();

&#x20;       

&#x20;       try {

&#x20;           String tenantCode = request.get("tenantCode");

&#x20;           String username = request.get("username");

&#x20;           String password = request.get("password");

&#x20;           

&#x20;           UserEntity user = userService.login(tenantCode, username, password);

&#x20;           if (user == null) {

&#x20;               result.put("success", false);

&#x20;               result.put("message", "用户名或密码错误");

&#x20;               return result;

&#x20;           }

&#x20;           

&#x20;           String token = jwtUtil.generate(user.getId(), user.getTenantId(), user.getUsername());

&#x20;           

&#x20;           result.put("success", true);

&#x20;           result.put("token", token);

&#x20;           

&#x20;           Map<String, Object> userInfo = new HashMap<>();

&#x20;           userInfo.put("id", user.getId());

&#x20;           userInfo.put("username", user.getUsername());

&#x20;           userInfo.put("realName", user.getRealName());

&#x20;           userInfo.put("email", user.getEmail());

&#x20;           userInfo.put("phone", user.getPhone());

&#x20;           result.put("user", userInfo);

&#x20;           

&#x20;       } catch (Exception e) {

&#x20;           e.printStackTrace();

&#x20;           result.put("success", false);

&#x20;           result.put("message", "服务器错误: " + e.getMessage());

&#x20;       }

&#x20;       

&#x20;       return result;

&#x20;   }

}



4\. JwtUtil.java



**package com.platform.auth;**



**import io.jsonwebtoken.Claims;**

**import io.jsonwebtoken.Jwts;**

**import io.jsonwebtoken.SignatureAlgorithm;**

**import org.springframework.beans.factory.annotation.Value;**

**import org.springframework.stereotype.Component;**

**import java.util.Date;**



**@Component**

**public class JwtUtil {**

&#x20;   

&#x20;   **@Value("${platform.security.jwt-secret}")**

&#x20;   **private String secret;**

&#x20;   

&#x20;   **public String generate(Long userId, Long tenantId, String username) {**

&#x20;       **return Jwts.builder()**

&#x20;           **.setSubject(String.valueOf(userId))**

&#x20;           **.claim("tenantId", tenantId)**

&#x20;           **.claim("username", username)**

&#x20;           **.setIssuedAt(new Date())**

&#x20;           **.setExpiration(new Date(System.currentTimeMillis() + 86400000))**

&#x20;           **.signWith(SignatureAlgorithm.HS256, secret.getBytes())**

&#x20;           **.compact();**

&#x20;   **}**

&#x20;   

&#x20;   **public Claims parse(String token) {**

&#x20;       **return Jwts.parser()**

&#x20;           **.setSigningKey(secret.getBytes())**

&#x20;           **.parseClaimsJws(token)**

&#x20;           **.getBody();**

&#x20;   **}**

**}**



**5. SecurityConfig.java**



**package com.platform.config;**



**import org.springframework.context.annotation.Bean;**

**import org.springframework.context.annotation.Configuration;**

**import org.springframework.security.config.annotation.web.builders.HttpSecurity;**

**import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;**

**import org.springframework.security.config.http.SessionCreationPolicy;**

**import org.springframework.security.web.SecurityFilterChain;**



**@Configuration**

**@EnableWebSecurity**

**public class SecurityConfig {**



&#x20;   **@Bean**

&#x20;   **public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {**

&#x20;       **http**

&#x20;           **.csrf(csrf -> csrf.disable())**

&#x20;           **.authorizeHttpRequests(auth -> auth**

&#x20;               **.requestMatchers("/api/\*\*", "/test").permitAll()**

&#x20;               **.anyRequest().authenticated()**

&#x20;           **)**

&#x20;           **.sessionManagement(session -> session**

&#x20;               **.sessionCreationPolicy(SessionCreationPolicy.STATELESS)**

&#x20;           **);**

&#x20;       

&#x20;       **return http.build();**

&#x20;   **}**

**}**



**6. WebConfig.java**



**package com.platform.config;**



**import org.springframework.context.annotation.Configuration;**

**import org.springframework.web.servlet.config.annotation.CorsRegistry;**

**import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;**



**@Configuration**

**public class WebConfig implements WebMvcConfigurer {**

&#x20;   **@Override**

&#x20;   **public void addCorsMappings(CorsRegistry registry) {**

&#x20;       **registry.addMapping("/api/\*\*")**

&#x20;           **.allowedOrigins("http://localhost:5173", "http://localhost:5174")**

&#x20;           **.allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")**

&#x20;           **.allowedHeaders("\*")**

&#x20;           **.allowCredentials(true);**

&#x20;   **}**

**}**



**7. UserController.java**



**package com.platform.system.controller;**



**import com.platform.system.entity.UserEntity;**

**import com.platform.system.service.UserService;**

**import org.springframework.beans.factory.annotation.Autowired;**

**import org.springframework.web.bind.annotation.\*;**

**import java.util.HashMap;**

**import java.util.List;**

**import java.util.Map;**



**@RestController**

**@RequestMapping("/api/system/user")**

**public class UserController {**

&#x20;   

&#x20;   **@Autowired**

&#x20;   **private UserService userService;**

&#x20;   

&#x20;   **@GetMapping("/list")**

&#x20;   **public Map<String, Object> list(@RequestParam Long tenantId) {**

&#x20;       **List<UserEntity> users = userService.listByTenant(tenantId);**

&#x20;       **Map<String, Object> result = new HashMap<>();**

&#x20;       **result.put("success", true);**

&#x20;       **result.put("data", users);**

&#x20;       **return result;**

&#x20;   **}**

&#x20;   

&#x20;   **@PostMapping**

&#x20;   **public Map<String, Object> create(@RequestBody UserEntity user) {**

&#x20;       **userService.create(user);**

&#x20;       **Map<String, Object> result = new HashMap<>();**

&#x20;       **result.put("success", true);**

&#x20;       **return result;**

&#x20;   **}**

&#x20;   

&#x20;   **@PutMapping**

&#x20;   **public Map<String, Object> update(@RequestBody UserEntity user) {**

&#x20;       **userService.update(user);**

&#x20;       **Map<String, Object> result = new HashMap<>();**

&#x20;       **result.put("success", true);**

&#x20;       **return result;**

&#x20;   **}**

&#x20;   

&#x20;   **@DeleteMapping("/{id}")**

&#x20;   **public Map<String, Object> delete(@PathVariable Long id) {**

&#x20;       **userService.delete(id);**

&#x20;       **Map<String, Object> result = new HashMap<>();**

&#x20;       **result.put("success", true);**

&#x20;       **return result;**

&#x20;   **}**

**}**



**8. UserEntity.java**



**package com.platform.system.entity;**



**import jakarta.persistence.\*;**

**import lombok.Data;**

**import java.time.LocalDateTime;**



**@Data**

**@Entity**

**@Table(name = "sys\_user")**

**public class UserEntity {**

&#x20;   **@Id**

&#x20;   **@GeneratedValue(strategy = GenerationType.IDENTITY)**

&#x20;   **private Long id;**

&#x20;   **private Long tenantId;**

&#x20;   **private String username;**

&#x20;   **private String password;**

&#x20;   **private String realName;**

&#x20;   **private String email;**

&#x20;   **private String phone;**

&#x20;   **private Long deptId;**

&#x20;   **private Long postId;**

&#x20;   **private String status;**

&#x20;   **private LocalDateTime lastLoginTime;**

&#x20;   **private LocalDateTime createdAt;**

**}**



**9. UserService.java**



**package com.platform.system.service;**



**import com.platform.system.entity.UserEntity;**

**import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;**

**import org.springframework.security.crypto.password.PasswordEncoder;**

**import org.springframework.stereotype.Service;**

**import jakarta.annotation.PostConstruct;**

**import java.time.LocalDateTime;**

**import java.util.ArrayList;**

**import java.util.List;**

**import java.util.concurrent.ConcurrentHashMap;**



**@Service**

**public class UserService {**

&#x20;   **private final ConcurrentHashMap<Long, UserEntity> userStore = new ConcurrentHashMap<>();**

&#x20;   **private long idCounter = 1;**

&#x20;   **private final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();**

&#x20;   

&#x20;   **@PostConstruct**

&#x20;   **public void init() {**

&#x20;       **UserEntity admin = new UserEntity();**

&#x20;       **admin.setId(idCounter++);**

&#x20;       **admin.setTenantId(1L);**

&#x20;       **admin.setUsername("admin");**

&#x20;       **admin.setPassword(passwordEncoder.encode("admin123"));**

&#x20;       **admin.setRealName("管理员");**

&#x20;       **admin.setStatus("active");**

&#x20;       **admin.setCreatedAt(LocalDateTime.now());**

&#x20;       **userStore.put(admin.getId(), admin);**

&#x20;       

&#x20;       **UserEntity testUser = new UserEntity();**

&#x20;       **testUser.setId(idCounter++);**

&#x20;       **testUser.setTenantId(1L);**

&#x20;       **testUser.setUsername("test");**

&#x20;       **testUser.setPassword(passwordEncoder.encode("test123"));**

&#x20;       **testUser.setRealName("测试用户");**

&#x20;       **testUser.setStatus("active");**

&#x20;       **testUser.setCreatedAt(LocalDateTime.now());**

&#x20;       **userStore.put(testUser.getId(), testUser);**

&#x20;   **}**

&#x20;   

&#x20;   **public UserEntity login(String tenantCode, String username, String password) {**

&#x20;       **for (UserEntity user : userStore.values()) {**

&#x20;           **if (user.getUsername().equals(username) \&\&** 

&#x20;               **passwordEncoder.matches(password, user.getPassword())) {**

&#x20;               **user.setLastLoginTime(LocalDateTime.now());**

&#x20;               **return user;**

&#x20;           **}**

&#x20;       **}**

&#x20;       **return null;**

&#x20;   **}**

&#x20;   

&#x20;   **public List<UserEntity> listByTenant(Long tenantId) {**

&#x20;       **List<UserEntity> result = new ArrayList<>();**

&#x20;       **for (UserEntity user : userStore.values()) {**

&#x20;           **if (user.getTenantId().equals(tenantId)) {**

&#x20;               **result.add(user);**

&#x20;           **}**

&#x20;       **}**

&#x20;       **return result;**

&#x20;   **}**

&#x20;   

&#x20;   **public void create(UserEntity user) {**

&#x20;       **user.setId(idCounter++);**

&#x20;       **user.setPassword(passwordEncoder.encode(user.getPassword()));**

&#x20;       **user.setCreatedAt(LocalDateTime.now());**

&#x20;       **userStore.put(user.getId(), user);**

&#x20;   **}**

&#x20;   

&#x20;   **public void update(UserEntity user) {**

&#x20;       **userStore.put(user.getId(), user);**

&#x20;   **}**

&#x20;   

&#x20;   **public void delete(Long id) {**

&#x20;       **userStore.remove(id);**

&#x20;   **}**

**}**



**10. TenantEntity.java**



**package com.platform.tenant.entity;**



**import jakarta.persistence.\*;**

**import lombok.Data;**

**import java.time.LocalDateTime;**



**@Data**

**@Entity**

**@Table(name = "platform\_tenant")**

**public class TenantEntity {**

&#x20;   **@Id**

&#x20;   **@GeneratedValue(strategy = GenerationType.IDENTITY)**

&#x20;   **private Long id;**

&#x20;   

&#x20;   **@Column(unique = true, nullable = false)**

&#x20;   **private String tenantCode;**

&#x20;   

&#x20;   **@Column(nullable = false)**

&#x20;   **private String tenantName;**

&#x20;   

&#x20;   **private String licenseKey;**

&#x20;   **private String status;**

&#x20;   **private LocalDateTime expireDate;**

&#x20;   **private Integer maxUsers;**

&#x20;   **private Integer maxApps;**

&#x20;   **private LocalDateTime createdAt;**

**}**





