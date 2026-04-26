package com.platform.tenant.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDate;
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

    @Column(length = 2000)
    private String licenseKey;
    private String status;

    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate expireDate;

    private Integer maxUsers;
    private Integer maxApps;
    private LocalDateTime createdAt;
}
