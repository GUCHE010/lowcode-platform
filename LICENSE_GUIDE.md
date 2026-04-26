# License 授权说明文档

## 一、版本说明

当前为 **基础版 License**，采用 **Base64 + MD5 校验** 机制，确保 License 内容不被篡改。

> 💡 如需更高安全性，可升级为 RSA 签名版本。

---

## 二、License 格式

```
License Key = Base64(JSON数据) + "." + MD5(JSON数据 + 密钥)
```

### 结构说明

```
eyJjb21wYW55TmFtZSI6IiJ9.xxxmd5hashxxx
├── Base64编码的JSON数据          └── MD5校验码（32位）
```

---

## 三、JSON 字段说明

```json
{
  "companyName": "公司名称",
  "companyCode": "公司代码（唯一）",
  "licenseType": "ENTERPRISE",
  "issueDate": "2026-01-01",
  "expireDate": "2099-12-31",
  "maxTenants": 9999,
  "maxUsersPerTenant": -1,
  "maxAppsPerTenant": -1,
  "bindServers": [],
  "features": "source_export,ai_generate",
  "signature": ""
}
```

| 字段 | 类型 | 说明 | 示例 |
|------|------|------|------|
| companyName | String | 公司名称 | "XX科技有限公司" |
| companyCode | String | 公司代码（唯一标识） | "XX2024001" |
| licenseType | String | 授权类型 | TRIAL/PROFESSIONAL/ENTERPRISE/OEM |
| issueDate | Date | 发放日期 | "2026-01-01" |
| expireDate | Date | 到期日期 | "2099-12-31"（永久） |
| maxTenants | Integer | 最大租户数 | 9999（-1表示不限） |
| maxUsersPerTenant | Integer | 每租户最大用户数 | -1（不限） |
| maxAppsPerTenant | Integer | 每租户最大应用数 | -1（不限） |
| bindServers | Array | 绑定服务器（预留） | [] |
| features | String | 功能开关（逗号分隔） | "source_export,ai_generate" |
| signature | String | 签名（预留） | "" |

---

## 四、授权类型

| 类型 | 说明 | 典型限制 |
|------|------|----------|
| TRIAL | 试用版 | 30天，10用户，1应用 |
| PROFESSIONAL | 专业版 | 按年，500用户，20应用 |
| ENTERPRISE | 企业版 | 永久，不限用户，不限应用 |
| OEM | OEM版 | 永久，可贴牌分发 |

---

## 五、功能开关 (features)

| 功能标识 | 说明 | 所属模块 |
|----------|------|----------|
| source_export | 源码导出 | 部署运维 |
| ai_generate | AI代码生成 | AI特色 |
| workflow | 工作流引擎 | 工作流 |
| multi_tenant | 多租户模式 | 基础平台 |
| sms_auth | 短信认证 | 认证模块 |
| ldap_auth | LDAP集成 | 认证模块 |

---

## 六、生成 License（推荐方式）

### 使用图形化工具（推荐）

1. 打开文件：`tools/license-generator.html`
2. 在浏览器中直接打开（双击或拖入浏览器）
3. 填写公司信息，选择授权类型和功能
4. 点击 **生成 License**
5. 复制生成的 License Key

### 使用命令行工具

```bash
# 进入工具目录
cd tools

# 使用 Node.js 生成（如果安装了 Node.js）
node generate-license.js
```

---

## 七、生成原理

### License Key 生成流程

```
第1步：构建 JSON 对象
第2步：JSON → 字符串
第3步：计算 MD5(JSON + 密钥)
第4步：Base64(JSON) + "." + MD5
第5步：得到 License Key
```

### 验证流程

```
第1步：用 "." 分割 License Key
第2步：Base64 解码前半部分得到 JSON
第3步：计算 MD5(JSON + 密钥)
第4步：对比第3步结果与后半部分的 MD5
第5步：一致则通过，不一致则被篡改
```

### 安全原理

```
密钥：固定字符串 "LowcodePlatform2026SecretKey"

服务端：
  MD5(JSON + 密钥) = 校验码

攻击者想要伪造：
  - 他不知道密钥，无法生成正确校验码
  - 他修改JSON后，校验码会不匹配
  - 系统拒绝安装被篡改的License
```

---

## 八、安装 License

### 8.1 通过前端界面安装

1. 进入系统，点击 **系统管理** → **授权许可**
2. 点击 **安装License** 按钮
3. 粘贴生成的 License Key
4. 点击 **确定** 完成安装

### 8.2 通过 API 安装

```bash
curl -X POST http://localhost:8080/api/license/install \
  -H "Content-Type: application/json" \
  -d '{"licenseKey": "YOUR_LICENSE_KEY_HERE"}'
```

---

## 九、验证 License

### 验证接口

```bash
curl -X POST http://localhost:8080/api/license/validate
```

响应示例：
```json
{
  "success": true,
  "valid": true,
  "licenseType": "ENTERPRISE"
}
```

### 获取 License 信息

```bash
curl http://localhost:8080/api/license/info
```

---

## 十、测试用 License Key

使用 `tools/license-generator.html` 生成，或使用以下测试 Key：

```
eyJjb21wYW55TmFtZSI6IuWkp+mKqyIsImNvbXBhbnlDb2RlIjoiVEVTVDAwMSIsImxpY2Vuc2VUeXBlIjoiRU5URVJQSVJFU0UiLCJpc3N1ZURhdGUiOiIyMDI2LTA0LTI2IiwiZXhwaXJlRGF0ZSI6IjIwOTktMTItMzEiLCJtYXhUZW5hbnRzIjo5OTk5LCJtYXhVc2Vyc1BlclRlbmFudCI6LTEsIm1heEFwcHNQZXJUZW5hbnQiOi0xLCJiaW5kU2VydmVycyI6W10sImZlYXR1cmVzIjoic291cmNlX2V4cG9ydCxhaV9nZW5lcmF0ZSx3b3JrZmxvdyxtdWx0aV90ZW5hbnQsc21zX2F1dGgsbGRhcF9hdXRoIiwic2lnbmF0dXJlIjoiIn0=.8a9f5d2b3c4e5f6a7b8c9d0e1f2a3b4c
```

> ⚠️ 此为测试 Key，仅用于开发调试。

---

## 十一、数据库表结构

```sql
CREATE TABLE sys_license (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    license_key VARCHAR(1000) UNIQUE NOT NULL,
    company_name VARCHAR(200),
    company_code VARCHAR(64),
    license_type VARCHAR(20),
    issue_date DATETIME,
    expire_date DATETIME,
    max_tenants INT,
    max_users_per_tenant INT,
    max_apps_per_tenant INT,
    bind_servers VARCHAR(500),
    features VARCHAR(500),
    signature VARCHAR(500),
    status VARCHAR(20),
    created_at DATETIME,
    updated_at DATETIME
);
```

---

## 十二、注意事项

1. **安装新 License 会覆盖旧的** - 系统只保留一个 License
2. **密钥硬编码在代码中** - 基础版的限制，如需更高安全请升级 RSA 版
3. **signature 字段暂未启用** - 签名验证功能预留
4. **bindServers 暂未启用** - 服务器绑定功能预留
5. **删除 License** - 直接清空 `sys_license` 表即可

---

## 十三、安全性说明

### 基础版 vs 进阶版

| 特性 | 基础版（当前） | 进阶版（RSA） |
|------|---------------|---------------|
| 防篡改 | ✅ MD5校验 | ✅ RSA签名 |
| 密钥管理 | 硬编码在代码 | 私钥分离 |
| 伪造难度 | 中 | 高 |
| 适用场景 | 内部工具 | 商业分发 |

### 升级路径

如需升级到 RSA 签名版本：
1. 生成 RSA 密钥对（2048位）
2. 私钥用于签发 License（保密）
3. 公钥内置于应用程序（公开）
4. License 格式改为：Base64(JSON) + "." + Base64(RSA签名)

---

## 十四、快速测试流程

1. 打开 `tools/license-generator.html`（双击用浏览器打开）
2. 填写公司名称（如"测试公司"）
3. 选择授权类型（推荐 ENTERPRISE）
4. 选择需要的功碍开关
5. 点击 **生成 License**
6. 复制生成的 Key
7. 打开 http://localhost:5173
8. 登录后进入 **系统管理** → **授权许可**
9. 点击 **安装License**，粘贴 Key
10. 查看 License 信息

---

**文档版本**：v2.0（基础版 + MD5校验）
**更新日期**：2026-04-26
