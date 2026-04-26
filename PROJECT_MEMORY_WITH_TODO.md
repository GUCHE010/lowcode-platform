# AI原生智能体编排平台 - 项目记忆文件

## 项目信息

- **项目名称**：AI原生智能体编排平台
- **项目定位**：自然语言生成完整企业应用的低代码平台
- **项目路径**：`D:\GUCHKAIFAPROJECT\DIDAIMAPINTAI\lowcode-platform`
- **Git Bash路径**：`/d/GUCHKAIFAPROJECT/DIDAIMAPINTAI/lowcode-platform`
- **当前状态**：✅ 后端运行中、✅ 前端运行中、✅ 登录功能正常、✅ 租户管理完成、✅ License授权完成
- **文档更新**：2026-04-26
- **本次更新**：新增租户管理（前后端）、License授权系统（前后端）、FastJSON依赖

---

## 一、技术栈

| 组件 | 技术 | 版本 |
|------|------|------|
| 后端框架 | Spring Boot | 3.2.0 |
| Java | OpenJDK | 21.0.10 |
| 构建工具 | Maven | 3.9.6 |
| 数据库 | MySQL | 8.0 |
| ORM | Spring Data JPA | 内置 |
| 前端框架 | Vue 3 | 3.4.0 |
| 构建工具 | Vite | 5.4.21 |
| UI框架 | Element Plus | 2.4.4 |
| 状态管理 | Pinia | 2.1.7 |
| 路由 | Vue Router | 4.2.5 |
| HTTP客户端 | Axios | 1.6.2 |
| JWT | JJWT | 0.11.5 |
| Excel处理 | EasyExcel + Apache POI | 3.3.2 / 5.2.5 |

---

## 二、数据库配置

```yaml
数据库: MySQL 8.0
地址: localhost:3308
数据库名: lowcode_platform
用户名: root
密码: hhdtest
JPA策略: ddl-auto: update (自动建表)
```

---

## 三、测试账号

| 字段 | 值 |
|------|------|
| 租户(tenantCode) | default |
| 用户名(username) | admin |
| 密码(password) | admin123 |

---

## 四、启动命令

### 启动后端
```bash
cd /d/GUCHKAIFAPROJECT/DIDAIMAPINTAI/lowcode-platform/backend
mvn spring-boot:run
```

### 启动前端（新窗口）
```bash
cd /d/GUCHKAIFAPROJECT/DIDAIMAPINTAI/lowcode-platform/frontend
npm run dev
```

### 访问地址
- 前端：http://localhost:5173
- 后端API：http://localhost:8080

---

## 五、已完成后端文件清单（62个Java文件）

### 启动类
| 文件 | 路径 |
|------|------|
| Application.java | com/platform/ |

### 认证模块 com/platform/auth/
| 文件 | 说明 |
|------|------|
| AuthController.java | 登录认证控制器 |
| JwtUtil.java | JWT工具类 |

### 配置模块 com/platform/config/
| 文件 | 说明 |
|------|------|
| SecurityConfig.java | Spring Security配置 |
| WebConfig.java | CORS跨域配置 |
| MenuInitializer.java | 菜单初始化器 |
| SystemDataInitializer.java | 系统数据初始化 |

### 系统管理模块 com/platform/system/

#### Entity层 (12个)
| 文件 | 说明 |
|------|------|
| UserEntity.java | 用户实体 |
| RoleEntity.java | 角色实体 |
| MenuEntity.java | 菜单实体 |
| DeptEntity.java | 部门实体 |
| PostEntity.java | 岗位实体 |
| LoginLogEntity.java | 登录日志实体 |
| OperationLogEntity.java | 操作日志实体 |
| DictionaryTypeEntity.java | 字典类型实体 |
| DictionaryEntity.java | 字典数据实体 |
| UserRoleEntity.java | 用户角色关联实体 |
| RoleMenuEntity.java | 角色菜单关联实体 |
| LicenseEntity.java | License授权实体 |

#### Repository层 (11个)
| 文件 | 说明 |
|------|------|
| UserRepository.java | 用户数据访问 |
| RoleRepository.java | 角色数据访问 |
| MenuRepository.java | 菜单数据访问 |
| DeptRepository.java | 部门数据访问 |
| PostRepository.java | 岗位数据访问 |
| LoginLogRepository.java | 登录日志数据访问 |
| OperationLogRepository.java | 操作日志数据访问 |
| DictionaryTypeRepository.java | 字典类型数据访问 |
| DictionaryRepository.java | 字典数据访问 |
| UserRoleRepository.java | 用户角色关联数据访问 |
| RoleMenuRepository.java | 角色菜单关联数据访问 |
| LicenseRepository.java | License数据访问 |

#### Service层 (16个)
| 文件 | 说明 |
|------|------|
| UserService.java | 用户业务逻辑 |
| RoleService.java | 角色业务逻辑 |
| MenuService.java | 菜单业务逻辑 |
| DeptService.java | 部门业务逻辑 |
| PostService.java | 岗位业务逻辑 |
| LoginLogService.java | 登录日志业务逻辑 |
| OperationLogService.java | 操作日志业务逻辑 |
| DictionaryTypeService.java | 字典类型业务逻辑 |
| DictionaryService.java | 字典数据业务逻辑 |
| DictionaryCacheService.java | 字典缓存服务 |
| PermissionService.java | 权限业务逻辑 |
| UserRoleService.java | 用户角色业务逻辑 |
| UserImportExportService.java | 用户导入导出服务 |
| LicenseService.java | License验证服务 |

#### Controller层 (12个)
| 文件 | 说明 |
|------|------|
| UserController.java | 用户管理接口 |
| RoleController.java | 角色管理接口 |
| MenuController.java | 菜单管理接口 |
| DeptController.java | 部门管理接口 |
| PostController.java | 岗位管理接口 |
| LoginLogController.java | 登录日志接口 |
| OperationLogController.java | 操作日志接口 |
| DictionaryTypeController.java | 字典类型接口 |
| DictionaryController.java | 字典数据接口 |
| LicenseController.java | License授权接口 |

### AOP模块 com/platform/aop/
| 文件 | 说明 |
|------|------|
| OperationLogAspect.java | 操作日志切面 |

### 租户模块 com/platform/tenant/
| 文件 | 说明 |
|------|------|
| TenantEntity.java | 租户实体 |
| TenantRepository.java | 租户数据访问 |
| TenantService.java | 租户业务逻辑 |
| TenantController.java | 租户管理接口 |

---

## 六、已完前端文件清单

### 核心文件
| 文件 | 路径 | 说明 |
|------|------|------|
| main.ts | src/ | 应用入口 |
| App.vue | src/ | 根组件 |
| vite.config.ts | 根目录 | Vite配置 |

### 页面 views (12个)
| 文件 | 路径 | 说明 |
|------|------|------|
| Login.vue | views/login/ | 登录页面 |
| UserList.vue | views/system/user/ | 用户管理 |
| RoleList.vue | views/system/role/ | 角色管理 |
| MenuList.vue | views/system/menu/ | 菜单管理 |
| DeptList.vue | views/system/dept/ | 部门管理 |
| PostList.vue | views/system/post/ | 岗位管理 |
| LoginLogList.vue | views/system/log/ | 登录日志 |
| OperationLogList.vue | views/system/log/ | 操作日志 |
| DictionaryTypeList.vue | views/system/dicttype/ | 字典类型 |
| DictionaryList.vue | views/system/dict/ | 字典数据 |
| TenantList.vue | views/system/tenant/ | 租户管理 |
| LicenseList.vue | views/system/license/ | 授权许可 |

### API接口 api (11个)
| 文件 | 说明 |
|------|------|
| user.ts | 用户相关API |
| role.ts | 角色相关API |
| menu.ts | 菜单相关API |
| dept.ts | 部门相关API |
| post.ts | 岗位相关API |
| loginLog.ts | 登录日志API |
| operationLog.ts | 操作日志API |
| dictionaryType.ts | 字典类型API |
| dictionary.ts | 字典数据API |
| tenant.ts | 租户管理API |
| license.ts | License授权API |

### 其他
| 文件 | 路径 | 说明 |
|------|------|------|
| MainLayout.vue | layouts/ | 主布局组件 |
| index.ts | router/ | 路由配置 |
| request.ts | utils/ | Axios封装 |
| permission.ts | directive/ | 权限指令 |
| IconSelector.vue | components/ | 图标选择器 |
| user.ts | store/ | 用户状态管理 |

---

## 七、API接口清单

### 认证模块 /api/auth
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/auth/login | 登录认证 |

### 用户管理 /api/system/user
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/system/user/list | 用户列表 |
| GET | /api/system/user/search | 搜索用户 |
| GET | /api/system/user/{id} | 用户详情 |
| POST | /api/system/user | 创建用户 |
| PUT | /api/system/user | 更新用户 |
| DELETE | /api/system/user/{id} | 删除用户 |
| PUT | /api/system/user/status | 更新状态 |
| PUT | /api/system/user/batchStatus | 批量更新状态 |
| GET | /api/system/user/roleIds/{userId} | 获取用户角色ID列表 |
| POST | /api/system/user/roles | 分配用户角色 |
| POST | /api/system/user/import | 导入用户 |
| GET | /api/system/user/export | 导出用户 |
| GET | /api/system/user/template | 下载导入模板 |

### 角色管理 /api/system/role
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/system/role/list | 角色列表 |
| GET | /api/system/role/{id} | 角色详情 |
| POST | /api/system/role | 创建角色 |
| PUT | /api/system/role | 更新角色 |
| DELETE | /api/system/role/{id} | 删除角色 |
| POST | /api/system/role/permission | 分配角色权限 |
| GET | /api/system/role/menuIds/{roleId} | 获取角色菜单ID |

### 菜单管理 /api/system/menu
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/system/menu/list | 菜单列表 |
| GET | /api/system/menu/tree | 菜单树 |
| GET | /api/system/menu/{id} | 菜单详情 |
| POST | /api/system/menu | 创建菜单 |
| PUT | /api/system/menu | 更新菜单 |
| DELETE | /api/system/menu/{id} | 删除菜单 |

### 部门管理 /api/system/dept
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/system/dept/list | 部门列表 |
| GET | /api/system/dept/tree | 部门树 |
| GET | /api/system/dept/{id} | 部门详情 |
| POST | /api/system/dept | 创建部门 |
| PUT | /api/system/dept | 更新部门 |
| DELETE | /api/system/dept/{id} | 删除部门 |

### 岗位管理 /api/system/post
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/system/post/list | 岗位列表 |
| GET | /api/system/post/{id} | 岗位详情 |
| POST | /api/system/post | 创建岗位 |
| PUT | /api/system/post | 更新岗位 |
| DELETE | /api/system/post/{id} | 删除岗位 |

### 登录日志 /api/system/loginLog
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/system/loginLog/list | 登录日志列表 |

### 操作日志 /api/system/operationLog
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/system/operationLog/list | 操作日志列表 |

### 字典类型 /api/system/dictionaryType
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/system/dictionaryType/list | 字典类型列表 |
| GET | /api/system/dictionaryType/{id} | 字典类型详情 |
| POST | /api/system/dictionaryType | 创建字典类型 |
| PUT | /api/system/dictionaryType | 更新字典类型 |
| DELETE | /api/system/dictionaryType/{id} | 删除字典类型 |

### 字典数据 /api/system/dictionary
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/system/dictionary/list | 字典数据列表 |
| GET | /api/system/dictionary/{id} | 字典数据详情 |
| POST | /api/system/dictionary | 创建字典数据 |
| PUT | /api/system/dictionary | 更新字典数据 |
| DELETE | /api/system/dictionary/{id} | 删除字典数据 |

### 租户管理 /api/tenant
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/tenant/list | 租户列表 |
| GET | /api/tenant/{id} | 租户详情 |
| POST | /api/tenant | 创建租户 |
| PUT | /api/tenant | 更新租户 |
| DELETE | /api/tenant/{id} | 删除租户 |
| PUT | /api/tenant/status | 更新租户状态 |

### License授权 /api/license
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/license/info | 获取License信息 |
| POST | /api/license/validate | 验证License |
| POST | /api/license/install | 安装License |

---

## 八、数据库表结构

### 已创建的表
| 表名 | 说明 | 状态 |
|------|------|------|
| platform_tenant | 租户表 | ✅ 已创建 |
| sys_user | 用户表 | ✅ 已创建 |
| sys_role | 角色表 | ✅ 已创建 |
| sys_menu | 菜单表 | ✅ 已创建 |
| sys_dept | 部门表 | ✅ 已创建 |
| sys_post | 岗位表 | ✅ 已创建 |
| sys_login_log | 登录日志表 | ✅ 已创建 |
| sys_operation_log | 操作日志表 | ✅ 已创建 |
| sys_dictionary_type | 字典类型表 | ✅ 已创建 |
| sys_dictionary | 字典数据表 | ✅ 已创建 |
| sys_user_role | 用户角色关联表 | ✅ 已创建 |
| sys_role_menu | 角色菜单关联表 | ✅ 已创建 |

### 初始化数据
- 默认租户：default（ID=1）
- 默认用户：admin/admin123、test/test123
- 默认角色：超级管理员(admin)、普通用户(user)
- 默认菜单：系统管理、用户管理、角色管理、菜单管理、部门管理、岗位管理、登录日志、操作日志、数据字典、字典类型

---

## 九、已实现功能清单

### Phase 1 基础平台（已完成约70%）

```
✅ 登录认证
   ├── JWT Token认证
   ├── BCrypt密码加密
   └── 登录日志记录

✅ 用户管理
   ├── 用户CRUD
   ├── 用户搜索（用户名/姓名/手机/部门/岗位/状态）
   ├── 用户分页
   ├── 用户状态启用/禁用
   ├── 批量启用/禁用
   ├── Excel导入（EasyExcel）
   ├── Excel导出
   ├── 下载导入模板
   ├── 分配用户角色
   └── 用户角色名称显示

✅ 角色管理
   ├── 角色CRUD
   ├── 分配角色权限（菜单）
   └── 数据权限范围

✅ 菜单管理
   ├── 菜单CRUD
   ├── 树形结构展示
   ├── 图标选择器
   ├── 菜单类型（目录/菜单/按钮）
   └── 动态菜单加载

✅ 部门管理
   ├── 部门CRUD
   ├── 树形结构
   └── 后端API完整

✅ 岗位管理
   ├── 岗位CRUD
   └── 后端API完整

✅ 日志管理
   ├── 登录日志记录（成功/失败）
   ├── 登录日志展示
   ├── 操作日志AOP记录
   └── 操作日志展示

✅ 数据字典
   ├── 字典类型CRUD
   ├── 字典数据CRUD
   └── 字典缓存服务

✅ 权限体系
   ├── RBAC模型
   ├── 用户-角色-菜单关联
   ├── 按钮级权限指令(v-permission)
   └── 动态菜单加载

✅ 租户管理
   ├── 租户CRUD
   ├── 租户套餐管理（最大用户数/最大应用数）
   └── 租户状态管理

✅ License授权
   ├── License信息展示
   ├── License安装
   ├── License验证
   └── 功能开关展示
```

---

## 十、未建设功能清单（按优先级排序）

### 🔴 P0 - 立即开发（核心功能）

| 序号 | 功能模块 | 功能点 | 状态 |
|------|----------|--------|------|
| ~~1~~ | ~~租户管理前端页面~~ | ~~后端实体已就绪，需Vue页面~~ | ✅ 已完成 |
| ~~2~~ | ~~部门管理前端页面~~ | ~~后端API完整，需Vue页面~~ | ✅ 已完成 |
| ~~3~~ | ~~岗位管理前端页面~~ | ~~后端API完整，需Vue页面~~ | ✅ 已完成 |
| ~~4~~ | ~~License验证系统~~ | ~~完全未实现~~ | ✅ 已完成 |
| 5 | 低代码核心 | 可视化拖拽编辑器 | ⏳ 待开发 |
| 6 | 低代码核心 | 数据模型设计 | ⏳ 待开发 |
| 7 | 低代码核心 | 页面与数据绑定 | ⏳ 待开发 |
| 8 | 低代码核心 | 应用发布（源码导出） | ⏳ 待开发 |
| 9 | 低代码核心 | 代码生成器 | ⏳ 待开发 |
| 10 | AI特色 | 自然语言→应用 | ⏳ 待开发 |
| 11 | AI特色 | 智能体编排 | ⏳ 待开发 |
| 12 | 工作流 | BPMN流程设计器 | ⏳ 待开发 |
| 13 | 工作流 | 审批流（会签/或签/驳回） | ⏳ 待开发 |
| 14 | 部署运维 | 私有云部署 | ⏳ 待开发 |

### 🟠 P1 - 近期开发（重要功能）

| 序号 | 功能模块 | 功能点 | 说明 |
|------|----------|--------|------|
| 15 | 基础平台 | 登录日志分页 | 当前无分页 |
| 16 | 基础平台 | 操作日志分页+详情 | 当前无分页 |
| 17 | 基础平台 | 系统参数配置 | SystemConfig表未创建 |
| 18 | 基础平台 | 租户套餐管理 | 最大用户/应用数控制 |
| 19 | 基础平台 | 功能开关控制 | 根据License控制 |
| 20 | 低代码核心 | 索引管理 | 数据库索引优化 |
| 21 | 低代码核心 | 模板市场 | 行业模板库 |
| 22 | 低代码核心 | 在线预览 | 所见即所得 |
| 23 | AI特色 | AI辅助调试 | 性能分析/异常诊断 |
| 24 | AI特色 | 跨系统连接器 | 预置50+系统连接 |
| 25 | AI特色 | 执行日志监控 | 智能体执行追踪 |
| 26 | 工作流 | 自动任务 | 定时/API/数据更新 |
| 27 | 工作流 | 流程监控/代办 | 任务列表/流程追踪 |
| 28 | 部署运维 | Docker容器化 | Docker镜像/Compose |

### 🟡 P2 - 中期开发（增强功能）

| 序号 | 功能模块 | 功能点 | 说明 |
|------|----------|--------|------|
| 29 | 基础平台 | License到期提醒 | 过期前通知 |
| 30 | AI特色 | Excel/Word导入转应用 | 文档解析 |
| 31 | AI特色 | 手绘草图转页面 | OCR识别 |
| 32 | AI特色 | 连接器市场 | 分享连接器 |
| 33 | 工作流 | 流程版本管理 | 多版本控制 |
| 34 | 工作流 | 催办功能 | 催促审批 |
| 35 | 工作流 | 超时提醒 | 审批超时通知 |
| 36 | 部署运维 | 公有云SaaS版本 | 多租户SaaS |
| 37 | 部署运维 | 信创数据库适配 | 达梦/金仓 |
| 38 | 部署运维 | K8s编排 | Kubernetes |
| 39 | 部署运维 | 高可用集群 | 负载均衡/故障转移 |

### 🟢 P3 - 远期规划（优化功能）

| 序号 | 功能模块 | 功能点 | 说明 |
|------|----------|--------|------|
| 40 | AI特色 | 语音创建流程 | 语音输入需求 |
| 41 | 部署运维 | 信创芯片适配 | 龙芯/飞腾 |
| 42 | 部署运维 | 信创系统适配 | 麒麟/UOS |
| 43 | 低代码核心 | 多端适配预览 | PC/平板/手机 |

---

## 十一、建设路线图

```
当前进度: Phase 1 约70%

┌─────────────────────────────────────────────────────────────┐
│ 阶段1-续 (1-2周) - 收尾基础平台                               │
│                                                             │
│ P0:                                                         │
│ ├── [ ] 租户管理前端页面                                      │
│ ├── [ ] 部门管理前端页面                                      │
│ ├── [ ] 岗位管理前端页面                                      │
│ └── [ ] License验证系统                                      │
│                                                             │
│ P1:                                                         │
│ ├── [ ] 登录日志分页                                          │
│ ├── [ ] 操作日志分页+详情                                     │
│ ├── [ ] 系统参数配置                                          │
│ └── [ ] 租户套餐管理                                          │
├─────────────────────────────────────────────────────────────┤
│ 阶段2 (1-2月) - 低代码核心                                    │
│                                                             │
│ P0:                                                         │
│ ├── [ ] 可视化拖拽编辑器                                      │
│ ├── [ ] 数据模型设计                                          │
│ ├── [ ] 页面与数据绑定                                        │
│ ├── [ ] 代码生成器                                            │
│ └── [ ] 应用发布（源码导出）                                   │
│                                                             │
│ P1:                                                         │
│ ├── [ ] 索引管理                                              │
│ ├── [ ] 模板市场                                              │
│ └── [ ] 在线预览                                              │
├─────────────────────────────────────────────────────────────┤
│ 阶段3 (2-3月) - AI特色功能                                    │
│                                                             │
│ P0:                                                         │
│ ├── [ ] DeepSeek API集成                                      │
│ ├── [ ] 自然语言→应用                                         │
│ └── [ ] 智能体编排                                            │
│                                                             │
│ P1:                                                         │
│ ├── [ ] AI辅助调试                                            │
│ ├── [ ] 跨系统连接器                                          │
│ └── [ ] 执行日志监控                                          │
├─────────────────────────────────────────────────────────────┤
│ 阶段4 (3-4月) - 工作流引擎                                    │
│                                                             │
│ P0:                                                         │
│ ├── [ ] Flowable集成                                          │
│ ├── [ ] BPMN流程设计器                                        │
│ └── [ ] 审批流功能                                            │
│                                                             │
│ P1:                                                         │
│ ├── [ ] 自动任务                                              │
│ └── [ ] 流程监控/代办                                          │
├─────────────────────────────────────────────────────────────┤
│ 阶段5 (4-6月) - 生态建设                                      │
│                                                             │
│ P1:                                                         │
│ ├── [ ] Docker容器化                                          │
│ └── [ ] 模板市场                                              │
│                                                             │
│ P2:                                                         │
│ ├── [ ] 信创适配（数据库）                                    │
│ ├── [ ] 公有云SaaS                                            │
│ └── [ ] K8s编排                                              │
│                                                             │
│ P3:                                                         │
│ └── [ ] 完整信创适配                                          │
└─────────────────────────────────────────────────────────────┘
```

---

## 十二、待解决问题

| 问题 | 优先级 | 说明 |
|------|--------|------|
| 前端DeptList.vue页面缺失 | 高 | 后端API完整，需创建Vue页面 |
| 前端PostList.vue页面缺失 | 高 | 后端API完整，需创建Vue页面 |
| 租户管理页面缺失 | 高 | 后端实体存在，需完整页面 |
| UserRoleService.java文件缺失 | 中 | 代码中引用但未找到该文件 |
| 登录日志无分页 | 低 | 需要添加分页功能 |
| 操作日志无分页 | 低 | 需要添加分页功能 |
| 备份文件未清理 | 低 | backend/下存在.bak文件 |

---

## 十三、会话历史要点

- **用户环境**：Windows 11，Git Bash环境
- **项目起点**：从零搭建，已完成基础平台70%功能
- **数据库**：MySQL 8.0 (localhost:3308/lowcode_platform)
- **认证方式**：JWT + BCrypt
- **权限模型**：RBAC + 动态菜单 + 按钮权限
- **特色功能**：Excel导入导出、操作日志AOP、登录日志记录

---

## 十四、重要提醒

1. **备份文件位置**：`backend/backup_*` 目录和 `.bak` 文件需定期清理
2. **数据库密码**：`application.yml` 中配置为 `hhdtest`
3. **JWT密钥**：`application.yml` 中配置，需生产环境更换
4. **JPA策略**：`ddl-auto: update` 会在启动时自动创建/更新表结构
5. **前端页面**：DeptList.vue和PostList.vue已创建但需验证完整性

---

## 十五、下一步行动计划

### 立即执行（本周）

1. **创建/完善部门管理前端页面** (DeptList.vue)
   - 树形表格展示
   - 新增/编辑/删除部门
   - 部门选择器组件

2. **创建/完善岗位管理前端页面** (PostList.vue)
   - 表格展示
   - 新增/编辑/删除岗位

3. **创建租户管理页面** (TenantList.vue)
   - 租户CRUD
   - 租户状态管理

### 短期计划（1-2周）

1. 添加登录日志分页
2. 添加操作日志分页
3. 实现系统参数配置
4. 清理备份文件

---

**文档版本**：v2.0
**最后更新**：2026-04-21
**维护者**：开发团队
