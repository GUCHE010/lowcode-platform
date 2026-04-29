# AI原生智能体编排低代码平台

本仓库当前实现的是低代码平台的系统管理内核，包含认证鉴权、租户、授权许可和后台管理能力。  
低代码设计器、AI 应用生成、工作流引擎等能力处于规划或待完善阶段。

## 当前技术栈

- 后端：Spring Boot 3.2、Java 21、Spring Security、JPA、MySQL
- 前端：Vue 3、TypeScript、Vite、Element Plus、Pinia

## 当前已实现模块

- 登录认证（JWT）
- 租户管理
- 用户、角色、菜单、部门、岗位管理
- 数据字典、字典类型
- 登录日志、操作日志
- License 授权管理

## 文档导航

- `PROJECT_SUMMARY.md`：项目现状与模块说明（推荐先看）
- `PROJECT_CONFIG.md`：开发配置说明（脱敏版）
- `AI原生智能体编排低代码平台开发文档.txt`：产品规划与路线图
- `PROJECT_MEMORY*.md`、`PROJECT_SNAPSHOT_INDEX.md`、`PROJECT_BACKEND_CODE.md`、`PROJECT_FRONTEND_CODE.md`：历史过程文档（归档参考，不作为当前实现依据）

## 快速启动

后端：

```bash
cd backend
mvn spring-boot:run
```

前端：

```bash
cd frontend
npm install
npm run dev
```

默认访问：

- 前端：`http://localhost:5173`
- 后端：`http://localhost:8080`

## 说明

请以源码与本 README、`PROJECT_SUMMARY.md` 为准。  
历史快照文档可能存在与当前代码不一致的内容。
