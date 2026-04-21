package com.platform.system.service;

import com.platform.system.entity.LoginLogEntity;
import com.platform.system.repository.LoginLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class LoginLogService {

    @Autowired
    private LoginLogRepository loginLogRepository;

    public void recordLoginSuccess(Long userId, String username, Long tenantId, String ipAddress, String userAgent) {
        LoginLogEntity log = new LoginLogEntity();
        log.setUserId(userId);
        log.setUsername(username);
        log.setTenantId(tenantId);
        log.setIpAddress(ipAddress);
        log.setStatus("success");
        log.setMsg("登录成功");
        log.setLoginTime(LocalDateTime.now());
        parseUserAgent(log, userAgent);
        loginLogRepository.save(log);
    }

    public void recordLoginFail(String username, Long tenantId, String ipAddress, String userAgent, String msg) {
        LoginLogEntity log = new LoginLogEntity();
        log.setUsername(username);
        log.setTenantId(tenantId);
        log.setIpAddress(ipAddress);
        log.setStatus("fail");
        log.setMsg(msg);
        log.setLoginTime(LocalDateTime.now());
        parseUserAgent(log, userAgent);
        loginLogRepository.save(log);
    }

    private void parseUserAgent(LoginLogEntity log, String userAgent) {
        if (userAgent == null || userAgent.isEmpty()) {
            log.setBrowser("未知");
            log.setOs("未知");
            return;
        }
        if (userAgent.contains("MSIE") || userAgent.contains("Trident")) {
            log.setBrowser("IE");
        } else if (userAgent.contains("Edge")) {
            log.setBrowser("Edge");
        } else if (userAgent.contains("Chrome")) {
            log.setBrowser("Chrome");
        } else if (userAgent.contains("Firefox")) {
            log.setBrowser("Firefox");
        } else if (userAgent.contains("Safari")) {
            log.setBrowser("Safari");
        } else {
            log.setBrowser("其他");
        }
        if (userAgent.contains("Windows")) {
            log.setOs("Windows");
        } else if (userAgent.contains("Mac")) {
            log.setOs("Mac");
        } else if (userAgent.contains("Linux")) {
            log.setOs("Linux");
        } else if (userAgent.contains("Android")) {
            log.setOs("Android");
        } else if (userAgent.contains("iPhone") || userAgent.contains("iPad")) {
            log.setOs("iOS");
        } else {
            log.setOs("其他");
        }
    }

    public List<LoginLogEntity> getLogsByTenant(Long tenantId) {
        return loginLogRepository.findByTenantIdOrderByLoginTimeDesc(tenantId);
    }

    public List<LoginLogEntity> getLogsByUser(Long userId) {
        return loginLogRepository.findByUserIdOrderByLoginTimeDesc(userId);
    }
}