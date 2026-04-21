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
