package com.platform.system.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 角色实体类
 */
@Data
@Entity
@Table(name = "sys_role")
public class RoleEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "tenant_id")
    private Long tenantId;
    
    @Column(name = "role_code", unique = true)
    private String roleCode;
    
    @Column(name = "role_name")
    private String roleName;
    
    @Column(name = "role_desc")
    private String roleDesc;
    
    private String status;
    
    @Column(name = "sort_order")
    private Integer sortOrder;
    
    @Column(name = "is_system")
    private Integer isSystem;

    @Column(name = "data_scope")
    private String dataScope;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
