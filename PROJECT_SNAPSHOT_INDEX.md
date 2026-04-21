# 低代码平台项目完整快照 - 索引

## 项目信息
- 项目名称：AI原生智能体编排平台
- 项目路径：`D:\GUCHKAIFAPROJECT\DIDAIMAPINTAI\lowcode-platform`
- Git Bash路径：`/d/GUCHKAIFAPROJECT/DIDAIMAPINTAI/lowcode-platform`
- 当前状态：✅ 登录功能完整可用

## 技术栈
| 组件 | 技术 | 版本 |
|------|------|------|
| 后端框架 | Spring Boot | 3.2.0 |
| Java | OpenJDK | 21.0.10 |
| 构建工具 | Maven | 3.9.6 |
| 前端框架 | Vue 3 | 3.4.0 |
| 构建工具 | Vite | 5.4.21 |
| UI框架 | Element Plus | 2.4.4 |
| 状态管理 | Pinia | 2.1.7 |
| 路由 | Vue Router | 4.2.5 |
| JWT | JJWT | 0.11.5 |

## 文件清单

### 后端文件（9个）
backend/src/main/java/com/platform/
├── Application.java
├── api/
│ └── TestController.java
├── auth/
│ ├── AuthController.java
│ └── JwtUtil.java
├── config/
│ ├── SecurityConfig.java
│ └── WebConfig.java
├── system/
│ ├── controller/
│ │ └── UserController.java
│ ├── entity/
│ │ └── UserEntity.java
│ └── service/
│ └── UserService.java
└── tenant/
└── entity/
└── TenantEntity.java

### 前端文件（8个）
frontend/
├── index.html
├── vite.config.ts
├── package.json
└── src/
├── main.ts
├── App.vue
├── router/
│ └── index.ts
├── layouts/
│ └── MainLayout.vue
└── views/
├── login/
│ └── Login.vue
└── system/
└── user/
└── UserList.vue


### 配置文件（2个）
backend/src/main/resources/application.yml
backend/pom.xml


## 测试账号
| 字段 | 值 |
|------|------|
| 租户(tenantCode) | default |
| 用户名(username) | admin |
| 密码(password) | admin123 |

## API接口
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/auth/login | 登录认证 |
| GET | /api/system/user/list | 用户列表 |
| POST | /api/system/user | 创建用户 |
| PUT | /api/system/user | 更新用户 |
| DELETE | /api/system/user/{id} | 删除用户 |
| GET | /test | 测试接口 |

## 启动命令

### 启动后端
```bash
cd /d/GUCHKAIFAPROJECT/DIDAIMAPINTAI/lowcode-platform/backend
mvn spring-boot:run



## 测试账号
| 字段 | 值 |
|------|------|
| 租户(tenantCode) | default |
| 用户名(username) | admin |
| 密码(password) | admin123 |

## API接口
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/auth/login | 登录认证 |
| GET | /api/system/user/list | 用户列表 |
| POST | /api/system/user | 创建用户 |
| PUT | /api/system/user | 更新用户 |
| DELETE | /api/system/user/{id} | 删除用户 |
| GET | /test | 测试接口 |

## 启动命令

### 启动后端
```bash
cd /d/GUCHKAIFAPROJECT/DIDAIMAPINTAI/lowcode-platform/backend
mvn spring-boot:run

启动前端（新窗口）

cd /d/GUCHKAIFAPROJECT/DIDAIMAPINTAI/lowcode-platform/frontend
npm run dev

访问地址
前端：http://localhost:5173

后端：http://localhost:8080

已知限制
用户数据存储在内存（ConcurrentHashMap），重启后丢失

未连接真实数据库

用户管理前端只有框架，未实现完整CRUD

下一步开发建议
连接 PostgreSQL 实现数据持久化

完善用户管理的前后端CRUD

开发角色管理功能

开发AI代码生成器

相关快照文件
PROJECT_BACKEND_CODE.md - 所有后端代码

PROJECT_FRONTEND_CODE.md - 所有前端代码

PROJECT_CONFIG.md - 配置文件内容