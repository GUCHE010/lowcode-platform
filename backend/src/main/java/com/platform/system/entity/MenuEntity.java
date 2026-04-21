package com.platform.system.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 菜单实体类
 */
@Data
@Entity
@Table(name = "sys_menu")
public class MenuEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "parent_id")
    private Long parentId;
    
    @Column(name = "menu_type")
    private String menuType;
    
    @Column(name = "menu_code")
    private String menuCode;
    
    @Column(name = "menu_name")
    private String menuName;
    
    private String path;
    private String component;
    private String componentName;
    private String icon;

    @Column(name = "visible")
    private String visible;

    @Column(name = "perms")
    private String perms;

    @Column(name = "sort_order")
    private Integer sortOrder;
    
    private String status;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @Transient
    private List<MenuEntity> children = new ArrayList<>();
}
