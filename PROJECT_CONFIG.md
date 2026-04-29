# 项目配置说明（当前有效）

本文件用于说明当前仓库的关键配置入口。  
具体值请以源码中的配置文件为准，不在文档中记录敏感信息明文。

## 1. 后端配置

- 主配置：`backend/src/main/resources/application.yml`
- 关键项：
  - `spring.datasource.*`：数据库连接
  - `spring.jpa.*`：JPA 行为
  - `platform.security.*`：JWT 相关配置
  - `server.port`：后端端口

建议将数据库密码、JWT 密钥等敏感配置迁移为环境变量或外部配置文件。

## 2. 后端依赖

- 文件：`backend/pom.xml`
- 关键依赖：
  - `spring-boot-starter-web`
  - `spring-boot-starter-security`
  - `spring-boot-starter-data-jpa`
  - `mysql-connector-j`
  - `jjwt-*`
  - `easyexcel`
  - `poi-ooxml`

## 3. 前端配置

- 文件：`frontend/package.json`
- 常用脚本：
  - `npm run dev`：本地开发
  - `npm run build`：构建产物
  - `npm run preview`：预览构建结果

## 4. 默认端口

- 前端：`5173`
- 后端：`8080`

## 5. 开发环境建议

- JDK：21
- Maven：3.9+
- Node.js：18+
- MySQL：8.x

---

最后整理时间：2026-04-28