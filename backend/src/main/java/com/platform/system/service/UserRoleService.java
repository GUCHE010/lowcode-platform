package com.platform.system.service;

import com.platform.system.entity.UserRoleEntity;
import com.platform.system.repository.UserRoleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class UserRoleService {

    @Autowired
    private UserRoleRepository userRoleRepository;

    public List<Long> getUserRoleIds(Long userId) {
        return userRoleRepository.findByUserId(userId).stream()
                .map(UserRoleEntity::getRoleId)
                .collect(java.util.stream.Collectors.toList());
    }

    @Transactional
    public void assignUserRoles(Long userId, List<?> roleIds) {
        if (roleIds == null || roleIds.isEmpty()) {
            return;
        }
        userRoleRepository.deleteByUserId(userId);
        List<UserRoleEntity> list = new ArrayList<>();
        for (Object roleId : roleIds) {
            UserRoleEntity ur = new UserRoleEntity();
            ur.setUserId(userId);
            if (roleId instanceof Number) {
                ur.setRoleId(((Number) roleId).longValue());
            } else if (roleId instanceof String) {
                ur.setRoleId(Long.parseLong((String) roleId));
            }
            ur.setCreatedAt(LocalDateTime.now());
            list.add(ur);
        }
        userRoleRepository.saveAll(list);
    }
}
