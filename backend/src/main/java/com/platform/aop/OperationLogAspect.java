package com.platform.aop;

import com.platform.auth.JwtUtil;
import com.platform.system.service.OperationLogService;
import jakarta.servlet.http.HttpServletRequest;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import java.util.Map;

@Aspect
@Component
public class OperationLogAspect {

    private static final Logger logger = LoggerFactory.getLogger(OperationLogAspect.class);

    @Autowired
    private OperationLogService operationLogService;

    @Autowired
    private JwtUtil jwtUtil;

    @Pointcut("execution(* com.platform.system.controller..*.*(..))")
    public void controllerPointcut() {
    }

    @Around("controllerPointcut()")
    public Object around(ProceedingJoinPoint joinPoint) throws Throwable {
        HttpServletRequest request = getRequest();
        if (request == null) {
            return joinPoint.proceed();
        }

        String token = request.getHeader("Authorization");
        Long userId = null;
        String username = null;
        Long tenantId = null;

        if (token != null && !token.isEmpty()) {
                try {
                    var claims = jwtUtil.parse(token.replace("Bearer ", ""));
                    userId = Long.valueOf(claims.get("userId").toString());
                    username = claims.get("username").toString();
                    tenantId = Long.valueOf(claims.get("tenantId").toString());
                } catch (Exception e) {
                    logger.debug("解析Token失败: {}", e.getMessage());
                }
            }

        String className = joinPoint.getTarget().getClass().getSimpleName();
        String methodName = joinPoint.getSignature().getName();
        String url = request.getRequestURI();
        String ipAddress = getClientIp(request);
        String params = getParams(joinPoint);

        String module = className.replace("Controller", "");
        String operation = methodName;

        Object result = null;
        boolean success = true;
        String errorMsg = null;

        try {
            result = joinPoint.proceed();
            return result;
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            if (userId != null && !isIgnoreOperation(methodName)) {
                try {
                    operationLogService.recordOperation(userId, username, tenantId,
                            module, operation, className + "." + methodName,
                            url, params, ipAddress, success, errorMsg);
                } catch (Exception e) {
                    logger.error("记录操作日志失败", e);
                }
            }
        }
    }

    private HttpServletRequest getRequest() {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        return attributes != null ? attributes.getRequest() : null;
    }

    private boolean isIgnoreOperation(String methodName) {
        return methodName.equals("list") || methodName.equals("getById") ||
               methodName.equals("getMenuTree") || methodName.equals("getUserRoleIds") ||
               methodName.equals("getByUser");
    }

    private String getParams(ProceedingJoinPoint joinPoint) {
        Object[] args = joinPoint.getArgs();
        if (args == null || args.length == 0) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < args.length; i++) {
            Object arg = args[i];
            if (arg != null && !(arg instanceof HttpServletRequest)) {
                if (sb.length() > 0) {
                    sb.append(", ");
                }
                String argStr = arg.toString();
                if (argStr.length() > 200) {
                    argStr = argStr.substring(0, 200) + "...";
                }
                sb.append(argStr);
            }
        }
        return sb.toString();
    }

    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip;
    }
}