package com.platform.system.service;

import com.platform.system.entity.RoleEntity;
import com.platform.system.entity.UserEntity;
import com.platform.system.repository.RoleRepository;
import com.platform.system.repository.UserRepository;
import com.platform.system.repository.UserRoleRepository;
import com.platform.tenant.entity.TenantEntity;
import com.platform.tenant.repository.TenantRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import jakarta.annotation.PostConstruct;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TenantRepository tenantRepository;
    
    @Autowired
    private UserRoleRepository userRoleRepository;
    
    @Autowired
    private RoleRepository roleRepository;

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

    public List<UserEntity> searchUsers(Long tenantId, String username, String realName,
                                       String phone, Long deptId, Long postId, String status) {
        return userRepository.searchUsers(tenantId, username, realName, phone, deptId, postId, status);
    }

    @Transactional
    public void updateUserStatus(Long userId, String status) {
        UserEntity user = userRepository.findById(userId).orElse(null);
        if (user != null) {
            user.setStatus(status);
            userRepository.save(user);
        }
    }

    @Transactional
    public void batchUpdateStatus(List<Long> userIds, String status) {
        for (Long userId : userIds) {
            UserEntity user = userRepository.findById(userId).orElse(null);
            if (user != null) {
                user.setStatus(status);
                userRepository.save(user);
            }
        }
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
    
    public List<String> getUserRoleNames(Long userId) {
        List<Long> roleIds = userRoleRepository.findByUserId(userId).stream()
                .map(ur -> ur.getRoleId())
                .collect(Collectors.toList());
        
        if (roleIds.isEmpty()) {
            return new ArrayList<>();
        }
        
        return roleRepository.findAllById(roleIds).stream()
                .map(RoleEntity::getRoleName)
                .collect(Collectors.toList());
    }
    
    public String getUserRoleNamesStr(Long userId) {
        List<String> roleNames = getUserRoleNames(userId);
        return String.join(", ", roleNames);
    }
}
