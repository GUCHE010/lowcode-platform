-- 创建租户表
CREATE TABLE IF NOT EXISTS platform_tenant (
    id BIGSERIAL PRIMARY KEY,
    tenant_code VARCHAR(64) UNIQUE NOT NULL,
    tenant_name VARCHAR(200) NOT NULL,
    license_key VARCHAR(500),
    status VARCHAR(20) DEFAULT 'active',
    expire_date DATE,
    max_users INT DEFAULT 100,
    max_apps INT DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建部门表
CREATE TABLE IF NOT EXISTS sys_dept (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    parent_id BIGINT DEFAULT 0,
    dept_name VARCHAR(100) NOT NULL,
    dept_code VARCHAR(64),
    sort_order INT DEFAULT 0,
    leader_id BIGINT,
    status VARCHAR(10) DEFAULT 'active'
);

-- 创建岗位表
CREATE TABLE IF NOT EXISTS sys_post (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    post_code VARCHAR(64) NOT NULL,
    post_name VARCHAR(100) NOT NULL,
    post_rank INT,
    status VARCHAR(10) DEFAULT 'active'
);

-- 创建用户表
CREATE TABLE IF NOT EXISTS sys_user (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    username VARCHAR(64) NOT NULL,
    password VARCHAR(200) NOT NULL,
    real_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    dept_id BIGINT,
    post_id BIGINT,
    status VARCHAR(10) DEFAULT 'active',
    last_login_time TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建角色表
CREATE TABLE IF NOT EXISTS sys_role (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    role_code VARCHAR(64) NOT NULL,
    role_name VARCHAR(100) NOT NULL,
    role_type VARCHAR(20),
    data_scope VARCHAR(20) DEFAULT 'dept'
);

-- 创建用户角色关联表
CREATE TABLE IF NOT EXISTS sys_user_role (
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, role_id)
);

-- 创建菜单表
CREATE TABLE IF NOT EXISTS sys_menu (
    id BIGSERIAL PRIMARY KEY,
    parent_id BIGINT DEFAULT 0,
    menu_name VARCHAR(100) NOT NULL,
    menu_type VARCHAR(20),
    permission VARCHAR(200),
    path VARCHAR(200),
    component VARCHAR(200),
    sort_order INT
);

-- 创建角色菜单关联表
CREATE TABLE IF NOT EXISTS sys_role_menu (
    role_id BIGINT NOT NULL,
    menu_id BIGINT NOT NULL
);

-- 创建操作日志表
CREATE TABLE IF NOT EXISTS sys_log (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT,
    user_id BIGINT,
    username VARCHAR(64),
    operation VARCHAR(200),
    method VARCHAR(100),
    params TEXT,
    ip VARCHAR(50),
    duration INT,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 插入默认菜单数据
INSERT INTO sys_menu (parent_id, menu_name, menu_type, permission, path, component, sort_order) VALUES
(0, '系统管理', 'directory', NULL, '/system', NULL, 1),
(1, '用户管理', 'menu', 'system:user:list', 'user', 'system/user/index', 1),
(1, '角色管理', 'menu', 'system:role:list', 'role', 'system/role/index', 2),
(1, '菜单管理', 'menu', 'system:menu:list', 'menu', 'system/menu/index', 3),
(1, '部门管理', 'menu', 'system:dept:list', 'dept', 'system/dept/index', 4),
(0, 'AI生成器', 'directory', NULL, '/ai', NULL, 0),
(6, '自然语言生成', 'menu', 'ai:generate', 'generate', 'ai/generator/index', 1);

-- 插入默认角色
INSERT INTO sys_role (tenant_id, role_code, role_name, role_type, data_scope) VALUES
(0, 'admin', '超级管理员', 'builtin', 'all'),
(0, 'tenant_admin', '租户管理员', 'builtin', 'tenant');

-- 分配菜单权限给admin角色
INSERT INTO sys_role_menu (role_id, menu_id) 
SELECT 1, id FROM sys_menu;
