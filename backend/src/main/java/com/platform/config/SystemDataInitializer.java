package com.platform.config;

import com.platform.system.entity.*;
import com.platform.system.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;

@Component
public class SystemDataInitializer implements CommandLineRunner {

    @Autowired
    private MenuRepository menuRepository;

    @Autowired
    private DeptRepository deptRepository;

    @Autowired
    private PostRepository postRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Override
    @Transactional
    public void run(String... args) {
        initializeMenus();
        initializeDepts();
        initializePosts();
    }

    private void initializeMenus() {
        if (menuRepository.count() > 0) {
            return;
        }

        Long tenantId = 1L;

        MenuEntity systemMenu = new MenuEntity();
        systemMenu.setParentId(0L);
        systemMenu.setMenuType("directory");
        systemMenu.setMenuCode("system");
        systemMenu.setMenuName("系统管理");
        systemMenu.setPath("/system");
        systemMenu.setIcon("Setting");
        systemMenu.setSortOrder(100);
        systemMenu.setStatus("active");
        systemMenu.setCreatedAt(LocalDateTime.now());
        systemMenu = menuRepository.save(systemMenu);

        MenuEntity userMenu = new MenuEntity();
        userMenu.setParentId(systemMenu.getId());
        userMenu.setMenuType("menu");
        userMenu.setMenuCode("system:user");
        userMenu.setMenuName("用户管理");
        userMenu.setPath("/user");
        userMenu.setComponent("system/user/UserList");
        userMenu.setSortOrder(1);
        userMenu.setStatus("active");
        userMenu.setCreatedAt(LocalDateTime.now());
        menuRepository.save(userMenu);

        MenuEntity roleMenu = new MenuEntity();
        roleMenu.setParentId(systemMenu.getId());
        roleMenu.setMenuType("menu");
        roleMenu.setMenuCode("system:role");
        roleMenu.setMenuName("角色管理");
        roleMenu.setPath("/role");
        roleMenu.setComponent("system/role/RoleList");
        roleMenu.setSortOrder(2);
        roleMenu.setStatus("active");
        roleMenu.setCreatedAt(LocalDateTime.now());
        menuRepository.save(roleMenu);

        MenuEntity menuMenu = new MenuEntity();
        menuMenu.setParentId(systemMenu.getId());
        menuMenu.setMenuType("menu");
        menuMenu.setMenuCode("system:menu");
        menuMenu.setMenuName("菜单管理");
        menuMenu.setPath("/menu");
        menuMenu.setComponent("system/menu/MenuList");
        menuMenu.setSortOrder(3);
        menuMenu.setStatus("active");
        menuMenu.setCreatedAt(LocalDateTime.now());
        menuRepository.save(menuMenu);

        MenuEntity deptMenu = new MenuEntity();
        deptMenu.setParentId(systemMenu.getId());
        deptMenu.setMenuType("menu");
        deptMenu.setMenuCode("system:dept");
        deptMenu.setMenuName("部门管理");
        deptMenu.setPath("/dept");
        deptMenu.setComponent("system/dept/DeptList");
        deptMenu.setSortOrder(4);
        deptMenu.setStatus("active");
        deptMenu.setCreatedAt(LocalDateTime.now());
        menuRepository.save(deptMenu);

        MenuEntity postMenu = new MenuEntity();
        postMenu.setParentId(systemMenu.getId());
        postMenu.setMenuType("menu");
        postMenu.setMenuCode("system:post");
        postMenu.setMenuName("岗位管理");
        postMenu.setPath("/post");
        postMenu.setComponent("system/post/PostList");
        postMenu.setSortOrder(5);
        postMenu.setStatus("active");
        postMenu.setCreatedAt(LocalDateTime.now());
        menuRepository.save(postMenu);

        MenuEntity logMenu = new MenuEntity();
        logMenu.setParentId(systemMenu.getId());
        logMenu.setMenuType("directory");
        logMenu.setMenuCode("system:log");
        logMenu.setMenuName("日志管理");
        logMenu.setPath("/log");
        logMenu.setIcon("Document");
        logMenu.setSortOrder(6);
        logMenu.setStatus("active");
        logMenu.setCreatedAt(LocalDateTime.now());
        logMenu = menuRepository.save(logMenu);

        MenuEntity loginLogMenu = new MenuEntity();
        loginLogMenu.setParentId(logMenu.getId());
        loginLogMenu.setMenuType("menu");
        loginLogMenu.setMenuCode("system:loginLog");
        loginLogMenu.setMenuName("登录日志");
        loginLogMenu.setPath("/loginLog");
        loginLogMenu.setComponent("system/log/LoginLogList");
        loginLogMenu.setSortOrder(1);
        loginLogMenu.setStatus("active");
        loginLogMenu.setCreatedAt(LocalDateTime.now());
        menuRepository.save(loginLogMenu);

        MenuEntity operationLogMenu = new MenuEntity();
        operationLogMenu.setParentId(logMenu.getId());
        operationLogMenu.setMenuType("menu");
        operationLogMenu.setMenuCode("system:operationLog");
        operationLogMenu.setMenuName("操作日志");
        operationLogMenu.setPath("/operationLog");
        operationLogMenu.setComponent("system/log/OperationLogList");
        operationLogMenu.setSortOrder(2);
        operationLogMenu.setStatus("active");
        operationLogMenu.setCreatedAt(LocalDateTime.now());
        menuRepository.save(operationLogMenu);

        MenuEntity dictMenu = new MenuEntity();
        dictMenu.setParentId(systemMenu.getId());
        dictMenu.setMenuType("menu");
        dictMenu.setMenuCode("system:dictionary");
        dictMenu.setMenuName("数据字典");
        dictMenu.setPath("/dictionary");
        dictMenu.setComponent("system/dict/DictionaryList");
        dictMenu.setSortOrder(7);
        dictMenu.setStatus("active");
        dictMenu.setCreatedAt(LocalDateTime.now());
        menuRepository.save(dictMenu);

        System.out.println("✅ 初始化菜单数据完成");
    }

    private void initializeDepts() {
        if (deptRepository.count() > 0) {
            return;
        }

        Long tenantId = 1L;

        DeptEntity rootDept = new DeptEntity();
        rootDept.setParentId(0L);
        rootDept.setTenantId(tenantId);
        rootDept.setDeptCode("ROOT");
        rootDept.setDeptName("总公司");
        rootDept.setDeptLeader("管理员");
        rootDept.setDeptPhone("13800000000");
        rootDept.setDeptEmail("admin@company.com");
        rootDept.setSortOrder(0);
        rootDept.setStatus("active");
        rootDept.setCreatedAt(LocalDateTime.now());
        rootDept = deptRepository.save(rootDept);

        DeptEntity techDept = new DeptEntity();
        techDept.setParentId(rootDept.getId());
        techDept.setTenantId(tenantId);
        techDept.setDeptCode("TECH");
        techDept.setDeptName("技术部");
        techDept.setDeptLeader("技术总监");
        techDept.setDeptPhone("13800000001");
        techDept.setDeptEmail("tech@company.com");
        techDept.setSortOrder(1);
        techDept.setStatus("active");
        techDept.setCreatedAt(LocalDateTime.now());
        deptRepository.save(techDept);

        DeptEntity hrDept = new DeptEntity();
        hrDept.setParentId(rootDept.getId());
        hrDept.setTenantId(tenantId);
        hrDept.setDeptCode("HR");
        hrDept.setDeptName("人力资源部");
        hrDept.setDeptLeader("人事经理");
        hrDept.setDeptPhone("13800000002");
        hrDept.setDeptEmail("hr@company.com");
        hrDept.setSortOrder(2);
        hrDept.setStatus("active");
        hrDept.setCreatedAt(LocalDateTime.now());
        deptRepository.save(hrDept);

        DeptEntity financeDept = new DeptEntity();
        financeDept.setParentId(rootDept.getId());
        financeDept.setTenantId(tenantId);
        financeDept.setDeptCode("FIN");
        financeDept.setDeptName("财务部");
        financeDept.setDeptLeader("财务总监");
        financeDept.setDeptPhone("13800000003");
        financeDept.setDeptEmail("finance@company.com");
        financeDept.setSortOrder(3);
        financeDept.setStatus("active");
        financeDept.setCreatedAt(LocalDateTime.now());
        deptRepository.save(financeDept);

        System.out.println("✅ 初始化部门数据完成");
    }

    private void initializePosts() {
        if (postRepository.count() > 0) {
            return;
        }

        Long tenantId = 1L;

        PostEntity ceo = new PostEntity();
        ceo.setTenantId(tenantId);
        ceo.setPostCode("CEO");
        ceo.setPostName("首席执行官");
        ceo.setPostRank("high");
        ceo.setSortOrder(1);
        ceo.setStatus("active");
        ceo.setCreatedAt(LocalDateTime.now());
        postRepository.save(ceo);

        PostEntity cto = new PostEntity();
        cto.setTenantId(tenantId);
        cto.setPostCode("CTO");
        cto.setPostName("技术总监");
        cto.setPostRank("high");
        cto.setSortOrder(2);
        cto.setStatus("active");
        cto.setCreatedAt(LocalDateTime.now());
        postRepository.save(cto);

        PostEntity hrManager = new PostEntity();
        hrManager.setTenantId(tenantId);
        hrManager.setPostCode("HR_MGR");
        hrManager.setPostName("人事经理");
        hrManager.setPostRank("middle");
        hrManager.setSortOrder(3);
        hrManager.setStatus("active");
        hrManager.setCreatedAt(LocalDateTime.now());
        postRepository.save(hrManager);

        PostEntity developer = new PostEntity();
        developer.setTenantId(tenantId);
        developer.setPostCode("DEV");
        developer.setPostName("开发工程师");
        developer.setPostRank("staff");
        developer.setSortOrder(10);
        developer.setStatus("active");
        developer.setCreatedAt(LocalDateTime.now());
        postRepository.save(developer);

        PostEntity tester = new PostEntity();
        tester.setTenantId(tenantId);
        tester.setPostCode("QA");
        tester.setPostName("测试工程师");
        tester.setPostRank("staff");
        tester.setSortOrder(11);
        tester.setStatus("active");
        tester.setCreatedAt(LocalDateTime.now());
        postRepository.save(tester);

        System.out.println("✅ 初始化岗位数据完成");
    }
}
