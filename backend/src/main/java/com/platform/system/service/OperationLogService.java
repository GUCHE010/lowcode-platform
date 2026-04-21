package com.platform.system.service;

import com.platform.system.entity.OperationLogEntity;
import com.platform.system.repository.OperationLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class OperationLogService {

    @Autowired
    private OperationLogRepository operationLogRepository;

    public void recordOperation(Long userId, String username, Long tenantId, String module,
                               String operation, String method, String url,
                               String params, String ipAddress, boolean success, String errorMsg) {
        OperationLogEntity log = new OperationLogEntity();
        log.setUserId(userId);
        log.setUsername(username);
        log.setTenantId(tenantId);
        log.setModule(module);
        log.setOperation(operation);
        log.setMethod(method);
        log.setUrl(url);
        log.setParams(params);
        log.setIpAddress(ipAddress);
        log.setResult(success ? "success" : "fail");
        log.setErrorMsg(errorMsg);
        log.setOperationTime(LocalDateTime.now());
        operationLogRepository.save(log);
    }

    public List<OperationLogEntity> getLogsByTenant(Long tenantId) {
        return operationLogRepository.findByTenantIdOrderByOperationTimeDesc(tenantId);
    }

    public List<OperationLogEntity> getLogsByUser(Long userId) {
        return operationLogRepository.findByUserIdOrderByOperationTimeDesc(userId);
    }
}