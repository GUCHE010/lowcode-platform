#!/bin/bash

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_separator() { echo "=========================================="; }

PROJECT_PATH="/d/GUCHKAIFAPROJECT/DIDAIMAPINTAI/lowcode-platform"
BACKEND_PATH="$PROJECT_PATH/backend"

print_separator
print_info "添加用户角色后端 API"
print_separator

cd "$BACKEND_PATH" || { print_error "后端目录不存在"; exit 1; }

print_info "创建 UserRoleService.java..."

cat > src/main/java/com/platform/system/service/UserRoleService.java << 'JAVA_EOF'
package com.platform.system.service;

import com.platform.system.entity.UserRoleEntity;
import com.platform.system.repository.UserRoleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class UserRoleService {

    @Autowired
    private UserRoleRepository userRoleRepository;

    public List<Long> getUserRoleIds(Long userId) {
        return userRoleRepository.findByUserId(userId).stream()
                .map(UserRoleEntity::getRoleId)
                .collect(Collectors.toList());
    }

    @Transactional
    public void assignUserRoles(Long userId, List<Long> roleIds) {
        userRoleRepository.deleteByUserId(userId);
        List<UserRoleEntity> list = roleIds.stream().map(roleId -> {
            UserRoleEntity ur = new UserRoleEntity();
            ur.setUserId(userId);
            ur.setRoleId(roleId);
            ur.setCreatedAt(LocalDateTime.now());
            return ur;
        }).collect(Collectors.toList());
        userRoleRepository.saveAll(list);
    }
}
JAVA_EOF

print_success "UserRoleService.java 创建成功"

print_info "修改 UserController.java..."

# 检查是否已经存在
if grep -q "UserRoleService" src/main/java/com/platform/system/controller/UserController.java; then
    print_info "用户角色接口已存在"
else
    # 找到文件中的最后一个 } 之前插入代码
    sed -i '/private UserService userService;/a\
\
    @Autowired\
    private UserRoleService userRoleService;' src/main/java/com/platform/system/controller/UserController.java

    # 在最后一个方法后面添加新方法
    sed -i '/@DeleteMapping.*$/,/}/{
        /}/ a\
\
    @GetMapping("/roleIds/{userId}")\
    public Map<String, Object> getUserRoleIds(@PathVariable Long userId) {\
        List<Long> roleIds = userRoleService.getUserRoleIds(userId);\
        Map<String, Object> result = new HashMap<>();\
        result.put("success", true);\
        result.put("data", roleIds);\
        return result;\
    }\
\
    @PostMapping("/roles")\
    public Map<String, Object> assignUserRoles(@RequestBody Map<String, Object> request) {\
        Long userId = Long.valueOf(request.get("userId").toString());\
        @SuppressWarnings("unchecked")\
        List<Long> roleIds = (List<Long>) request.get("roleIds");\
        userRoleService.assignUserRoles(userId, roleIds);\
        Map<String, Object> result = new HashMap<>();\
        result.put("success", true);\
        result.put("message", "分配成功");\
        return result;\
    }
    }' src/main/java/com/platform/system/controller/UserController.java
fi

print_success "UserController.java 已修改"

print_separator
print_info "编译验证..."

cd "$BACKEND_PATH"
if mvn clean compile; then
    print_success "编译成功！"
else
    print_error "编译失败"
    exit 1
fi

print_separator
print_success "后端 API 添加完成！"
print_info "请重启后端: mvn spring-boot:run"
