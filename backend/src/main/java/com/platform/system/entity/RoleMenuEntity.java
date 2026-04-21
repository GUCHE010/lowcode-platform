package com.platform.system.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 角色菜单关联实体类
 */
@Data
@Entity
@Table(name = "sys_role_menu")
public class RoleMenuEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "role_id")
    private Long roleId;
    
    @Column(name = "menu_id")
    private Long menuId;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
}
