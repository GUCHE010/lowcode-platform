package com.platform.config;

import com.platform.system.entity.MenuEntity;
import com.platform.system.repository.MenuRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import java.time.LocalDateTime;

@Component
public class MenuInitializer implements CommandLineRunner {
    
    private static final Logger logger = LoggerFactory.getLogger(MenuInitializer.class);

    @Autowired
    private MenuRepository menuRepository;

    @Override
    public void run(String... args) {
        if (menuRepository.count() > 0) {
            logger.info("菜单已存在，跳过初始化");
            return;
        }

        logger.info("开始初始化默认菜单...");
        
        MenuEntity systemMenu = createMenu(0L, "系统管理", "system", "system", "Setting", 1, "active");
        MenuEntity userMenu = createMenu(systemMenu.getId(), "用户管理", "/user", "system:user", "User", 1, "active");
        MenuEntity roleMenu = createMenu(systemMenu.getId(), "角色管理", "/role", "system:role", "Key", 2, "active");
        MenuEntity menuMenu = createMenu(systemMenu.getId(), "菜单管理", "/menu", "system:menu", "Menu", 3, "active");
        MenuEntity deptMenu = createMenu(systemMenu.getId(), "部门管理", "/dept", "system:dept", "OfficeBuilding", 4, "active");
        MenuEntity postMenu = createMenu(systemMenu.getId(), "岗位管理", "/post", "system:post", "Briefcase", 5, "active");
        
        createMenu(systemMenu.getId(), "登录日志", "/loginLog", "system:loginLog", "View", 6, "active");
        createMenu(systemMenu.getId(), "操作日志", "/operationLog", "system:operationLog", "Operation", 7, "active");
        
        createMenu(systemMenu.getId(), "数据字典", "/dictionary", "system:dictionary", "Collection", 8, "active");
        createMenu(systemMenu.getId(), "字典类型", "/dictionaryType", "system:dictionaryType", "Notebook", 9, "active");

        logger.info("默认菜单初始化完成");
    }

    private MenuEntity createMenu(Long parentId, String menuName, String path, String permission, String icon, Integer sortOrder, String status) {
        MenuEntity menu = new MenuEntity();
        menu.setParentId(parentId);
        menu.setMenuName(menuName);
        menu.setMenuCode(permission);
        // 如果path为空，则作为目录类型
        menu.setMenuType(parentId == 0L || path == null || path.isEmpty() ? "directory" : "menu");
        menu.setPath(path);
        menu.setIcon(icon);
        menu.setSortOrder(sortOrder);
        menu.setStatus(status);
        menu.setCreatedAt(LocalDateTime.now());
        menu.setUpdatedAt(LocalDateTime.now());
        return menuRepository.save(menu);
    }
}