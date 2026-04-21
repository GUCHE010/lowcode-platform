--

## 文件4：PROJECT_CONFIG.md

```markdown
# 配置文件

## 1. application.yml
```yaml
spring:
  autoconfigure:
    exclude:
      - org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration
      - org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration
      - org.springframework.boot.autoconfigure.data.jpa.JpaRepositoriesAutoConfiguration

platform:
  security:
    jwt-secret: mySecretKey123456789012345678901234567890
    token-expire: 86400000

server:
  port: 8080
2. pom.xml
xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.0</version>
    </parent>
    <groupId>com.platform</groupId>
    <artifactId>lowcode-platform</artifactId>
    <version>1.0.0</version>
    <properties>
        <java.version>21</java.version>
        <jjwt.version>0.11.5</jjwt.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-redis</artifactId>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-api</artifactId>
            <version>${jjwt.version}</version>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-impl</artifactId>
            <version>${jjwt.version}</version>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-jackson</artifactId>
            <version>${jjwt.version}</version>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
    </dependencies>
</project>
环境配置汇总
配置项	值
后端端口	8080
前端端口	5173
JWT密钥	mySecretKey123456789012345678901234567890
Token有效期	86400000 ms (24小时)
Java路径	D:\Program Files\Eclipse Adoptium\jdk-21.0.10.7-hotspot
Maven路径	C:\Users\gch\apache-maven-3.9.6
text

---

## 保存方法

在 Git Bash 中分别执行以下命令保存：

```bash
cd /d/GUCHKAIFAPROJECT/DIDAIMAPINTAI/lowcode-platform

# 保存索引文件
cat > PROJECT_SNAPSHOT_INDEX.md << 'EOF'
[粘贴文件1内容]
EOF

# 保存后端代码
cat > PROJECT_BACKEND_CODE.md << 'EOF'
[粘贴文件2内容]
EOF

# 保存前端代码
cat > PROJECT_FRONTEND_CODE.md << 'EOF'
[粘贴文件3内容]
EOF

# 保存配置文件
cat > PROJECT_CONFIG.md << 'EOF'
[粘贴文件4内容]
EOF