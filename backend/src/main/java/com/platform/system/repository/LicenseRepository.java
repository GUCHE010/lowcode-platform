package com.platform.system.repository;

import com.platform.system.entity.LicenseEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface LicenseRepository extends JpaRepository<LicenseEntity, Long> {
    LicenseEntity findByLicenseKey(String licenseKey);
}
