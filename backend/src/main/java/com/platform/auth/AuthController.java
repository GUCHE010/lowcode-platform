package com.platform.auth;

import com.platform.system.entity.MenuEntity;
import com.platform.system.entity.UserEntity;
import com.platform.system.service.LoginLogService;
import com.platform.system.service.PermissionService;
import com.platform.system.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;
    
    @Autowired
    private PermissionService permissionService;
    
    @Autowired
    private LoginLogService loginLogService;
    
    @Autowired
    private HttpServletRequest httpServletRequest;

    @PostMapping("/login")
    public Map<String, Object> login(@RequestBody Map<String, String> request) {
        Map<String, Object> result = new HashMap<>();
        String ipAddress = getClientIp();
        String userAgent = httpServletRequest.getHeader("User-Agent");
        
        try {
            String tenantCode = request.get("tenantCode");
            String username = request.get("username");
            String password = request.get("password");
            
            UserEntity user = userService.login(tenantCode, username, password);
            if (user == null) {
                loginLogService.recordLoginFail(username, 1L, ipAddress, userAgent, "用户名或密码错误");
                result.put("success", false);
                result.put("message", "用户名或密码错误");
                return result;
            }
            
            String token = jwtUtil.generate(user.getId(), user.getTenantId(), user.getUsername());
            loginLogService.recordLoginSuccess(user.getId(), user.getUsername(), user.getTenantId(), ipAddress, userAgent);
            
            List<MenuEntity> menus = permissionService.getUserMenus(user.getId());
            List<String> permissions = permissionService.getUserPermissions(user.getId());
            
            result.put("success", true);
            result.put("token", token);
            
            Map<String, Object> userInfo = new HashMap<>();
            userInfo.put("id", user.getId());
            userInfo.put("tenantId", user.getTenantId());
            userInfo.put("username", user.getUsername());
            userInfo.put("realName", user.getRealName());
            userInfo.put("email", user.getEmail());
            userInfo.put("phone", user.getPhone());
            userInfo.put("menus", menus);
            userInfo.put("permissions", permissions);
            result.put("user", userInfo);
            
        } catch (Exception e) {
            e.printStackTrace();
            loginLogService.recordLoginFail(request.get("username"), 1L, ipAddress, userAgent, "服务器错误");
            result.put("success", false);
            result.put("message", "服务器错误: " + e.getMessage());
        }
        
        return result;
    }
    
    private String getClientIp() {
        String ip = httpServletRequest.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = httpServletRequest.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = httpServletRequest.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = httpServletRequest.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = httpServletRequest.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = httpServletRequest.getRemoteAddr();
        }
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip;
    }
}
