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

    public enum DataScope {
        DEFAULT("默认权限"),
        OWN("仅本人数据"),
        DEPT("本部门数据"),
        DEPT_ALL("本部门及以下数据"),
        ALL("全部数据");

        private final String desc;
        DataScope(String desc) {
            this.desc = desc;
        }
        public String getDesc() {
            return desc;
        }
    }

    @Autowired
    private RoleRepository roleRepository;
    
    @Autowired
    private RoleMenuRepository roleMenuRepository;

    public List<RoleEntity> listByTenant(Long tenantId) {
        return roleRepository.findByTenantId(tenantId);
    }

    @Transactional
    public void create(RoleEntity role) {
        if (role.getDataScope() == null) {
            role.setDataScope(DataScope.DEFAULT.name());
        }
        if (role.getSortOrder() == null) {
            role.setSortOrder(0);
        }
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
    public void assignPermissions(Long roleId, List<?> menuIds) {
        if (menuIds == null || menuIds.isEmpty()) {
            return;
        }
        roleMenuRepository.deleteByRoleId(roleId);
        List<RoleMenuEntity> list = new java.util.ArrayList<>();
        for (Object menuId : menuIds) {
            RoleMenuEntity rm = new RoleMenuEntity();
            rm.setRoleId(roleId);
            if (menuId instanceof Number) {
                rm.setMenuId(((Number) menuId).longValue());
            } else if (menuId instanceof String) {
                rm.setMenuId(Long.parseLong((String) menuId));
            }
            rm.setCreatedAt(LocalDateTime.now());
            list.add(rm);
        }
        roleMenuRepository.saveAll(list);
    }

    public List<Long> getRoleMenuIds(Long roleId) {
        return roleMenuRepository.findByRoleId(roleId).stream()
                .map(RoleMenuEntity::getMenuId)
                .collect(Collectors.toList());
    }
}
