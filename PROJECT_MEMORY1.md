\# 低代码平台项目记忆文件



\## 项目信息

\- 项目名称：AI原生智能体编排平台

\- 项目定位：自然语言生成完整企业应用的低代码平台

\- 当前状态：后端代码已生成，准备编译运行



\## 技术栈

\- 后端：Spring Boot 3.x + Java 21

\- 数据库：PostgreSQL + Redis

\- 前端：Vue3 + TypeScript + Element Plus

\- 工作流：Flowable（待集成）

\- AI：DeepSeek API（待集成）

\- 构建工具：Maven



\## 项目路径

\- Windows：`D:\\GUCHKAIFAPROJECT\\DIDAIMAPINTAI\\lowcode-platform`

\- Git Bash：`/d/GUCHKAIFAPROJECT/DIDAIMAPINTAI/lowcode-platform`



\## 已生成的文件（8个Java文件）

✅ backend/src/main/java/com/platform/Application.java

✅ backend/src/main/java/com/platform/auth/AuthController.java

✅ backend/src/main/java/com/platform/auth/JwtUtil.java

✅ backend/src/main/java/com/platform/config/WebConfig.java

✅ backend/src/main/java/com/platform/system/controller/UserController.java

✅ backend/src/main/java/com/platform/system/entity/UserEntity.java

✅ backend/src/main/java/com/platform/system/service/UserService.java

✅ backend/src/main/java/com/platform/tenant/entity/TenantEntity.java



\## 已生成的配置文件

✅ backend/pom.xml

✅ backend/src/main/resources/application.yml

✅ deploy/docker-compose.yml

✅ scripts/init-db.sql

✅ frontend/package.json

✅ frontend/index.html

✅ frontend/src/main.ts

✅ frontend/src/App.vue



\## 当前进度

\- \[x] 项目目录结构创建

\- \[x] Maven配置文件(pom.xml)

\- \[x] Spring Boot配置文件(application.yml)

\- \[x] 实体类(TenantEntity, UserEntity)

\- \[x] Controller层(AuthController, UserController)

\- \[x] Service层(UserService)

\- \[x] 工具类(JwtUtil, WebConfig)

\- \[ ] 检查Maven是否安装

\- \[ ] 编译项目(mvn compile)

\- \[ ] 运行后端(mvn spring-boot:run)

\- \[ ] 前端代码完善

\- \[ ] 数据库启动和初始化



\## 下一步操作（待执行）

1\. 检查Maven是否安装：`mvn --version`

2\. 如果没有Maven，安装或使用mvnw

3\. 编译后端：`cd backend \&\& mvn clean compile`

4\. 运行后端：`mvn spring-boot:run`

5\. 测试登录接口：`curl`命令验证



\## 账号信息（测试用）

\- 用户名：admin

\- 密码：admin123

\- 租户：default



\## 注意事项

\- 当前UserService使用内存存储，重启后数据丢失

\- 后续需要接入PostgreSQL持久化

\- JWT密钥在application.yml中配置

\- 前端尚未启动，需要先安装Node.js依赖



\## 会话历史要点

\- 用户使用Windows 11系统，Git Bash环境

\- 已通过脚本生成所有后端Java文件

\- 编译前需要确认Maven环境

\- 用户要求输出记忆锚点文件，记录当前进度



\## 待解决问题

\- Maven是否已安装？（下一步检查）

\- Java版本是否符合要求（需要17或21）

\- 是否需要安装Docker Desktop启动数据库



