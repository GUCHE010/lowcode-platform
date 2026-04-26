package com.platform.tenant.service;

import com.platform.tenant.entity.TenantEntity;
import com.platform.tenant.repository.TenantRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class TenantService {

    @Autowired
    private TenantRepository tenantRepository;

    public List<TenantEntity> list() {
        return tenantRepository.findAll();
    }

    public TenantEntity findById(Long id) {
        return tenantRepository.findById(id).orElse(null);
    }

    public TenantEntity findByCode(String tenantCode) {
        return tenantRepository.findByTenantCode(tenantCode).orElse(null);
    }

    @Transactional
    public void create(TenantEntity tenant) {
        if (tenant.getStatus() == null) {
            tenant.setStatus("active");
        }
        if (tenant.getMaxUsers() == null) {
            tenant.setMaxUsers(100);
        }
        if (tenant.getMaxApps() == null) {
            tenant.setMaxApps(10);
        }
        if (tenant.getCreatedAt() == null) {
            tenant.setCreatedAt(LocalDateTime.now());
        }
        tenantRepository.save(tenant);
    }

    @Transactional
    public void update(TenantEntity tenant) {
        tenantRepository.save(tenant);
    }

    @Transactional
    public void delete(Long id) {
        tenantRepository.deleteById(id);
    }

    @Transactional
    public void updateStatus(Long id, String status) {
        TenantEntity tenant = tenantRepository.findById(id).orElse(null);
        if (tenant != null) {
            tenant.setStatus(status);
            tenantRepository.save(tenant);
        }
    }
}
