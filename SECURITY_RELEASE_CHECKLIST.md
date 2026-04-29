# SECURITY_RELEASE_CHECKLIST

上线前安全发布检查清单（建议由研发、测试、运维联合签字确认）。

## 1. 配置与环境

- [ ] 预发/生产使用 `preprod` 或 `prod` profile，确认 `platform.security.license-enforce=true`
- [ ] `LICENSE_PUBLIC_KEY` 已通过环境变量注入，未写死在仓库
- [ ] `JWT_SECRET` 已在预发/生产注入且长度满足安全要求（建议 >= 32 字节）
- [ ] `TOKEN_EXPIRE_MS` 已按环境策略配置（默认 24h，可按业务收紧）
- [ ] 数据库账号使用最小权限账号，不使用高权限 root 直连
- [ ] `logging.level.com.platform` 在生产为 `INFO` 或更低

## 2. 认证与鉴权

- [ ] 未登录访问受保护接口返回 `401`
- [ ] 权限不足访问管理接口返回 `403`
- [ ] 登录后 token 含 `userId/tenantId/roleCodes/permissions`
- [ ] token 过期后访问受保护接口被拒绝

## 3. 租户隔离

- [ ] 非管理员用户无法通过篡改 `tenantId` 访问其它租户数据
- [ ] 核心资源（用户、角色、部门、岗位、字典、日志、租户）均做租户归属校验
- [ ] 管理员跨租户访问行为被记录审计日志

## 4. License 校验

- [ ] `license/info` 能准确返回状态：`NOT_INSTALLED/INACTIVE/EXPIRED/VALID`
- [ ] 非法签名 License 无法安装
- [ ] 超配额（租户数/用户数）被拦截并返回明确错误
- [ ] `license-enforce=true` 时，License 无效会阻断业务请求

## 5. 审计与追踪

- [ ] 响应头包含 `X-Trace-Id`
- [ ] 登录日志包含 `traceId`、状态、IP、用户信息
- [ ] 操作日志包含 `traceId`、模块、操作、结果、错误信息
- [ ] 关键动作（租户管理、角色授权、License 安装）可追溯

## 6. 回归与发布闸门

- [ ] 执行 `powershell -ExecutionPolicy Bypass -File .\scripts\smoke-test.ps1` 通过
- [ ] 冒烟覆盖：无 token、权限不足、核心列表接口、License 查询
- [ ] 本次变更有回滚方案（配置回滚 + 服务回滚）
- [ ] 发布窗口内有监控与告警值班安排

## 7. 发布记录

- 发布版本：
- 发布人：
- 审核人：
- 发布时间：
- 回滚负责人：
