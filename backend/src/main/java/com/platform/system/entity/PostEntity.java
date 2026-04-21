package com.platform.system.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "sys_post")
public class PostEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "tenant_id")
    private Long tenantId;

    @Column(name = "post_code")
    private String postCode;

    @Column(name = "post_name")
    private String postName;

    @Column(name = "post_rank")
    private String postRank;

    @Column(name = "dept_id")
    private Long deptId;

    @Column(name = "quota")
    private Integer quota;

    @Column(name = "sort_order")
    private Integer sortOrder;

    private String status;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
