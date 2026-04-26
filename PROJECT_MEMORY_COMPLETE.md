# 低代码平台项目完整记忆文件

## 更新时间
**最后更新**：2026-04-26

---

## 一、项目信息

| 项目 | 内容 |
|------|------|
| 项目名称 | AI原生智能体编排平台 |
| 项目定位 | 自然语言生成完整企业应用的低代码平台 |
| 项目路径 | `D:\GUCHKAIFAPROJECT\DIDAIMAPINTAI\lowcode-platform` |
| Git Bash路径 | `/d/GUCHKAIFAPROJECT/DIDAIMAPINTAI/lowcode-platform` |
| 当前状态 | ✅ 前端运行中、❌ 后端待启动 |

---

## 二、技术栈

### 后端技术栈

| 组件 | 技术 | 版本 |
|------|------|------|
| 框架 | Spring Boot | 3.2.0 |
| Java | OpenJDK | 21.0.10 |
| 构建工具 | Maven | 3.9.6 |
| 数据库 | MySQL | 8.0 |
| ORM | Spring Data JPA | 内置 |
| 安全 | Spring Security + JWT | 内置 |
| Excel | EasyExcel | 3.x |

### 前端技术栈

| 组件 | 技术 | 版本 |
|------|------|------|
| 框架 | Vue 3 | 3.4.0 |
| 语言 | TypeScript | 5.3.0 |
| 构建工具 | Vite | 5.4.21 |
| UI框架 | Element Plus | 2.4.4 |
| 状态管理 | Pinia | 2.1.7 |
| 路由 | Vue Router | 4.2.5 |
| HTTP客户端 | Axios | 1.6.2 |

---

## 三、数据库配置

| 配置项 | 值 |
|--------|-----|
| 数据库类型 | MySQL 8.0 |
| 数据库名 | lowcode_platform |
| 用户名 | root |
| 密码 | 123456 |
| 连接URL | jdbc:mysql://localhost:3306/lowcode_platform?useSSL=false&serverTimezone=Asia/Shanghai |

---

## 四、测试账号

| 字段 | 值 |
|------|------|
| 租户(tenantCode) | default |
| 用户名(username) | admin |
| 密码(password) | admin123 |

---

## 五、启动命令

### 启动前端
```bash
cd /d/GUCHKAIFAPINTAI/lowcode-platform/frontend
npm run dev
```

### 启动后端
```bash
cd /d/GUCHKAIFAPINTAI/lowcode-platform/backend
mvn spring-boot:run
```

### 访问地址

| 服务 | 地址 |
|------|------|
| 前端 | http://localhost:5173 |
| 后端API | http://localhost:8080 |

---

## 六、后端文件清单（56个Java文件）

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
| AsyncConfig.java | 异步任务配置 |
| FilterConfig.java | 过滤器配置 |

### 系统管理模块 com/platform/system/

#### Entity层
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
| DictionaryDataEntity.java | 字典数据实体 |
| UserRoleEntity.java | 用户角色关联实体 |
| RoleMenuEntity.java | 角色菜单关联实体 |
| LicenseEntity.java | License授权实体 |

#### Repository层
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
| DictionaryDataRepository.java | 字典数据数据访问 |
| UserRoleRepository.java | 用户角色关联数据访问 |
| RoleMenuRepository.java | 角色菜单关联数据访问 |
| LicenseRepository.java | License数据访问 |

#### Service层
| 文件 | 说明 |
|------|------|
| UserService.java | 用户业务逻辑 |
| RoleService.java | 角色业务逻辑 |
| MenuService.java | 菜单业务逻辑 |
| DeptService.java | 部门业务逻辑 |
| PostService.java | 岗位业务逻辑 |
| LoginLogService.java | 登录日志业务逻辑 |
| OperationLogService.java | 操作日志业务逻辑 |
| DictionaryService.java | 字典业务逻辑 |
| PermissionService.java | 权限业务逻辑 |
| UserRoleService.java | 用户角色业务逻辑 |
| LicenseService.java | License业务逻辑 |
| UserImportExportService.java | 用户导入导出服务 |

#### Controller层
| 文件 | 说明 |
|------|------|
| UserController.java | 用户管理接口 |
| RoleController.java | 角色管理接口 |
| MenuController.java | 菜单管理接口 |
| DeptController.java | 部门管理接口 |
| PostController.java | 岗位管理接口 |
| LoginLogController.java | 登录日志接口 |
| OperationLogController.java | 操作日志接口 |
| DictionaryController.java | 字典管理接口 |
| LicenseController.java | License管理接口 |

#### AOP模块
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

### 工具模块 com/platform/common/
| 文件 | 说明 |
|------|------|
| Constants.java | 常量定义 |
| Result.java | 统一响应结果 |

---

## 七、前端文件清单

### 核心文件
| 文件 | 路径 | 说明 |
|------|------|------|
| main.ts | src/ | 应用入口 |
| App.vue | src/ | 根组件 |
| vite.config.ts | 根目录 | Vite配置 |

### 路由 src/router/
| 文件 | 说明 |
|------|------|
| index.ts | 路由配置 |

### 布局 src/layouts/
| 文件 | 说明 |
|------|------|
| MainLayout.vue | 主布局组件 |

### 页面 src/views/

#### 登录模块
| 文件 | 路径 |
|------|------|
| Login.vue | src/views/login/ |

#### 系统管理模块
| 文件 | 路径 | 说明 |
|------|------|------|
| UserList.vue | src/views/system/user/ | 用户管理 |
| RoleList.vue | src/views/system/role/ | 角色管理 |
| MenuList.vue | src/views/system/menu/ | 菜单管理 |
| DeptList.vue | src/views/system/dept/ | 部门管理 |
| PostList.vue | src/views/system/post/ | 岗位管理 |
| LoginLogList.vue | src/views/system/log/ | 登录日志 |
| OperationLogList.vue | src/views/system/log/ | 操作日志 |
| DictionaryList.vue | src/views/system/dict/ | 字典管理 |
| DictionaryTypeList.vue | src/views/system/dicttype/ | 字典类型管理 |
| TenantList.vue | src/views/system/tenant/ | 租户管理 |
| LicenseList.vue | src/views/system/license/ | 授权许可 |

### API src/api/
| 文件 | 说明 |
|------|------|
| user.ts | 用户API |
| role.ts | 角色API |
| menu.ts | 菜单API |
| dept.ts | 部门API |
| post.ts | 岗位API |
| dict.ts | 字典API |
| tenant.ts | 租户API |
| license.ts | License API |

### 工具 src/utils/
| 文件 | 说明 |
|------|------|
| request.ts | Axios请求封装 |

### 指令 src/directive/
| 文件 | 说明 |
|------|------|
| permission.ts | 权限指令 |

---

## 八、API接口清单

### 认证模块 /api/auth
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/auth/login | 登录认证 |

### 用户管理 /api/system/user
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/system/user/list | 用户列表 |
| GET | /api/system/user/search | 用户搜索 |
| GET | /api/system/user/{id} | 用户详情 |
| POST | /api/system/user | 创建用户 |
| PUT | /api/system/user | 更新用户 |
| DELETE | /api/system/user/{id} | 删除用户 |
| GET | /api/system/user/roleIds/{userId} | 获取用户角色ID |
| POST | /api/system/user/roles | 分配用户角色 |
| PUT | /api/system/user/status | 更新用户状态 |
| PUT | /api/system/user/batchStatus | 批量更新状态 |
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
| GET | /api/system/role/menuIds/{roleId} | 获取角色菜单ID |
| POST | /api/system/role/permission | 分配角色权限 |

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

### 日志模块 /api/system/
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/system/loginLog/list | 登录日志列表 |
| GET | /api/system/operationLog/list | 操作日志列表 |

### 字典管理 /api/system/dictionary
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/system/dictionary/list | 字典数据列表 |
| GET | /api/system/dictionaryType/list | 字典类型列表 |

### 租户管理 /api/tenant
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/tenant/list | 租户列表 |
| GET | /api/tenant/{id} | 租户详情 |
| POST | /api/tenant | 创建租户 |
| PUT | /api/tenant | 更新租户 |
| DELETE | /api/tenant/{id} | 删除租户 |

### License管理 /api/license
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/license/current | 获取当前License |
| POST | /api/license/install | 安装License |
| POST | /api/license/verify | 验证License |

---

## 九、数据库表结构

### 核心表
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
| sys_dictionary_data | 字典数据表 | ✅ 已创建 |
| sys_user_role | 用户角色关联表 | ✅ 已创建 |
| sys_role_menu | 角色菜单关联表 | ✅ 已创建 |
| platform_license | License表 | ✅ 已创建 |

### 初始化数据
- 默认租户：default（ID=1）
- 默认用户：admin/admin123
- 默认角色：超级管理员(admin)、普通用户(user)
- 默认菜单：完整的系统管理菜单
- 默认部门：技术部、产品部、销售部
- 默认岗位：总经理、开发工程师、产品经理

---

## 十、已实现功能清单

### Phase 1 基础平台 ✅
- [x] 登录认证（JWT + BCrypt）
- [x] 用户管理（CRUD + 导入导出 + 角色分配）
- [x] 角色管理（CRUD + 权限分配）
- [x] 菜单管理（树形CRUD + 动态菜单）
- [x] 部门管理（树形CRUD）
- [x] 岗位管理（CRUD）
- [x] 登录日志（记录+展示）
- [x] 操作日志（AOP切面自动记录）
- [x] 数据字典（类型+数据）
- [x] 租户管理（CRUD + 套餐管理）
- [x] License授权系统（Base64 + MD5校验）
- [x] 租户关联（用户/角色/部门/岗位与租户关联）
- [x] RBAC权限模型
- [x] 按钮级权限指令
- [x] 动态菜单加载

### Phase 2 低代码核心 ⏳
- [ ] 可视化拖拽编辑器
- [ ] 数据模型设计
- [ ] 页面与数据绑定
- [ ] 代码生成器
- [ ] 应用发布

### Phase 3 AI特色功能 ⏳
- [ ] 自然语言→应用
- [ ] 智能体编排
- [ ] 跨系统连接器

### Phase 4 工作流引擎 ⏳
- [ ] Flowable集成
- [ ] 流程设计器
- [ ] 审批流

### Phase 5 部署与运维 ⏳
- [ ] Docker部署
- [ ] 信创适配

---

## 十一、未建设功能清单（按优先级）

### 🔴 P0 - 立即开发
| 序号 | 功能 | 所属模块 |
|------|------|----------|
| 1 | 可视化拖拽编辑器 | 低代码核心 |
| 2 | 数据模型设计 | 低代码核心 |
| 3 | 页面与数据绑定 | 低代码核心 |
| 4 | 应用发布（源码导出） | 低代码核心 |
| 5 | 代码生成器 | 低代码核心 |
| 6 | 自然语言→应用 | AI特色 |
| 7 | 智能体编排 | AI特色 |
| 8 | BPMN流程设计器 | 工作流 |
| 9 | 审批流（会签/或签/驳回） | 工作流 |
| 10 | 私有云部署 | 部署运维 |

### 🟠 P1 - 近期开发
| 序号 | 功能 | 所属模块 |
|------|------|----------|
| 11 | 索引管理 | 低代码核心 |
| 12 | 模板市场 | 低代码核心 |
| 13 | AI辅助调试 | AI特色 |
| 14 | 跨系统连接器 | AI特色 |
| 15 | 执行日志监控 | AI特色 |
| 16 | 自动任务 | 工作流 |
| 17 | 流程监控/代办 | 工作流 |
| 18 | Docker容器化 | 部署运维 |
| 19 | 在线预览 | 低代码核心 |

### 🟡 P2 - 中期开发
| 序号 | 功能 | 所属模块 |
|------|------|----------|
| 20 | 操作日志到期提醒 | 基础平台 |
| 21 | Excel/Word导入转应用 | AI特色 |
| 22 | 手绘草图转页面 | AI特色 |
| 23 | 连接器市场 | AI特色 |
| 24 | 流程版本管理 | 工作流 |
| 25 | 催办功能 | 工作流 |
| 26 | 超时提醒 | 工作流 |
| 27 | 公有云SaaS版本 | 部署运维 |
| 28 | 信创适配（数据库） | 部署运维 |

### 🟢 P3 - 远期规划
| 序号 | 功能 | 所属模块 |
|------|------|----------|
| 29 | 语音创建流程 | AI特色 |
| 30 | 信创适配（芯片/系统） | 部署运维 |
| 31 | 多端适配预览 | 低代码核心 |

---

## 十二、建设路线图

```
当前进度: Phase 1 约90%完成

下一步建议:
┌─────────────────────────────────────────────────────────┐
│ 阶段1-续 (1周)                                          │
│ └── 完善租户关联、测试所有功能                            │
├─────────────────────────────────────────────────────────┤
│ 阶段2 (1-2月)                                           │
│ ├── 可视化拖拽编辑器                                     │
│ ├── 数据模型设计                                         │
│ ├── 页面与数据绑定                                       │
│ └── 代码生成器                                           │
├─────────────────────────────────────────────────────────┤
│ 阶段3 (2-3月)                                           │
│ ├── DeepSeek API集成                                    │
│ ├── 自然语言→应用                                        │
│ ├── 智能体编排                                           │
│ └── 跨系统连接器                                         │
├─────────────────────────────────────────────────────────┤
│ 阶段4 (3-4月)                                            │
│ ├── Flowable工作流集成                                   │
│ ├── 流程设计器                                           │
│ ├── 审批流功能                                           │
│ └── 流程监控                                             │
├─────────────────────────────────────────────────────────┤
│ 阶段5 (4-6月)                                            │
│ ├── 模板市场                                             │
│ ├── 信创适配                                             │
│ └── 容器化部署                                           │
└─────────────────────────────────────────────────────────┘
```

---

## 十三、License系统说明

### License格式
```
Base64(JSON数据).MD5(JSON数据+密钥)
```

### License生成工具
- 位置：`tools/license-generator.html`
- 使用：双击用浏览器打开，填写信息后生成

### License功能
- 公司名称和代码
- 授权类型（ENTERPRISE/PROFESSIONAL/STANDARD）
- 到期日期
- 最大租户数、用户数、应用数
- 功能开关（source_export,ai_generate,workflow等）
- MD5校验防篡改

### 升级方向
1. **基础版**：Base64 + MD5校验（当前实现）
2. **进阶版**：RSA签名
3. **完整版**：RSA签名 + 机器指纹 + 在线验证

---

## 十四、重要提醒

### 环境配置
| 工具 | 版本 | 路径 |
|------|------|------|
| Java | 21.0.10 | D:\Program Files\Eclipse Adoptium\jdk-21.0.10.7-hotspot |
| Maven | 3.9.6 | C:\Users\gch\apache-maven-3.9.6 |
| Node.js | 已安装 | - |

### 启动前检查
1. 检查端口是否被占用（5173、5174、8080）
2. 如有占用，先停止对应进程再启动
3. 使用 `netstat -ano | findstr :端口号` 检查

### 已知问题
1. Maven环境问题导致后端无法启动
2. 用户导出功能需要后端支持

### 备份文件位置
- backend/backup_* 目录

### 数据库密码
- 默认：123456
- 请在 application.yml 中修改

---

## 十五、下一步行动计划

### 立即执行
1. 解决Maven环境问题，启动后端服务
2. 测试租户关联功能
3. 测试用户导入导出功能
4. 测试License授权系统

### 短期计划
1. 完善所有功能的租户关联
2. 添加更多业务模块
3. 开始低代码核心功能开发

---

**文档版本**：1.0
**最后更新**：2026-04-26
**状态**：✅ 前端运行中、❌ 后端待启动
