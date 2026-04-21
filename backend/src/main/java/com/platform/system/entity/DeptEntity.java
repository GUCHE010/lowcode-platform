package com.platform.system.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
@Entity
@Table(name = "sys_dept")
public class DeptEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "parent_id")
    private Long parentId;

    @Column(name = "tenant_id")
    private Long tenantId;

    @Column(name = "dept_code")
    private String deptCode;

    @Column(name = "dept_name")
    private String deptName;

    @Column(name = "dept_leader")
    private String deptLeader;

    @Column(name = "dept_phone")
    private String deptPhone;

    @Column(name = "dept_email")
    private String deptEmail;

    @Column(name = "sort_order")
    private Integer sortOrder;

    private String status;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Transient
    private List<DeptEntity> children = new ArrayList<>();
}
