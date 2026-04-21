package com.platform.system.service;

import com.platform.system.entity.DeptEntity;
import com.platform.system.repository.DeptRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class DeptService {

    @Autowired
    private DeptRepository deptRepository;

    public List<DeptEntity> listByTenant(Long tenantId) {
        return deptRepository.findByTenantIdOrderBySortOrder(tenantId);
    }

    public List<DeptEntity> listByParent(Long parentId) {
        return deptRepository.findByParentId(parentId);
    }

    public DeptEntity findById(Long id) {
        return deptRepository.findById(id).orElse(null);
    }

    @Transactional
    public void create(DeptEntity dept) {
        dept.setCreatedAt(LocalDateTime.now());
        dept.setStatus("active");
        if (dept.getSortOrder() == null) {
            dept.setSortOrder(0);
        }
        if (dept.getParentId() == null) {
            dept.setParentId(0L);
        }
        deptRepository.save(dept);
    }

    @Transactional
    public void update(DeptEntity dept) {
        dept.setUpdatedAt(LocalDateTime.now());
        deptRepository.save(dept);
    }

    @Transactional
    public void delete(Long id) {
        deptRepository.deleteById(id);
    }

    public List<DeptEntity> buildTree(Long tenantId) {
        List<DeptEntity> allDepts = listByTenant(tenantId);
        return buildTreeRecursive(allDepts, 0L);
    }

    private List<DeptEntity> buildTreeRecursive(List<DeptEntity> allDepts, Long parentId) {
        List<DeptEntity> tree = new ArrayList<>();
        for (DeptEntity dept : allDepts) {
            if (dept.getParentId().equals(parentId)) {
                List<DeptEntity> children = buildTreeRecursive(allDepts, dept.getId());
                dept.setChildren(children);
                tree.add(dept);
            }
        }
        return tree;
    }

    public boolean hasChildren(Long deptId) {
        return !deptRepository.findByParentId(deptId).isEmpty();
    }
}
