# 项目现状说明

## 1. 项目定位

本项目是 AI 原生智能体编排低代码平台的基础底座，当前重点在系统管理能力建设。  
现阶段代码已具备企业后台常见基础模块，低代码设计器与 AI 自动生成能力尚在规划推进中。

## 2. 当前实现范围

### 后端模块

- 认证鉴权：JWT 登录认证、Spring Security 权限控制
- 系统管理：用户、角色、菜单、部门、岗位
- 日志能力：登录日志、操作日志
- 配置能力：数据字典、字典类型
- 平台能力：租户管理、License 授权管理
- 辅助能力：AOP 操作日志、Excel 导入导出

### 前端模块

- 登录页与主布局
- 系统管理菜单与各业务页面
- 基于路由与权限指令的菜单访问控制
- API 封装与基础状态管理

## 3. 技术栈

- 后端：Spring Boot 3.2、Java 21、Spring Data JPA、Spring Security、JWT
- 前端：Vue 3、TypeScript、Vite、Element Plus、Pinia、Vue Router
- 数据库：MySQL 8.x
- 构建：Maven + npm

## 4. 关键目录

- `backend/src/main/java/com/platform/`：后端业务代码
- `backend/src/main/resources/application.yml`：后端配置
- `frontend/src/views/system/`：前端系统管理页面
- `frontend/src/router/index.ts`：前端路由

## 5. 当前状态与建议

- 状态：系统管理核心功能可运行，可作为后续低代码能力扩展基础
- 建议：下一阶段优先补齐低代码元数据模型、页面渲染协议、设计器与发布链路

---

最后整理时间：2026-04-28