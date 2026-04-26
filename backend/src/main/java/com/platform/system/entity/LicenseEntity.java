package com.platform.system.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "sys_license")
public class LicenseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String licenseKey;

    private String companyName;
    private String companyCode;
    private String licenseType;
    private LocalDateTime issueDate;
    private LocalDateTime expireDate;
    private Integer maxTenants;
    private Integer maxUsersPerTenant;
    private Integer maxAppsPerTenant;
    private String bindServers;
    private String features;
    private String signature;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
