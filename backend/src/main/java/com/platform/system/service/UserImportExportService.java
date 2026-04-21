package com.platform.system.service;

import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.support.ExcelTypeEnum;
import com.platform.system.entity.UserEntity;
import com.platform.system.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class UserImportExportService {

    @Autowired
    private UserRepository userRepository;

    public static class UserExcelData {
        private String username;
        private String realName;
        private String email;
        private String phone;
        private String deptCode;
        private String postCode;
        private String status;

        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }
        public String getRealName() { return realName; }
        public void setRealName(String realName) { this.realName = realName; }
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        public String getPhone() { return phone; }
        public void setPhone(String phone) { this.phone = phone; }
        public String getDeptCode() { return deptCode; }
        public void setDeptCode(String deptCode) { this.deptCode = deptCode; }
        public String getPostCode() { return postCode; }
        public void setPostCode(String postCode) { this.postCode = postCode; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
    }

    public List<UserExcelData> parseExcel(MultipartFile file) throws IOException {
        return EasyExcel.read(file.getInputStream())
                .head(UserExcelData.class)
                .sheet()
                .doReadSync();
    }

    @Transactional
    public int importUsers(List<UserExcelData> dataList, Long tenantId) {
        int count = 0;
        for (UserExcelData data : dataList) {
            if (data.getUsername() == null || data.getUsername().trim().isEmpty()) {
                continue;
            }

            if (userRepository.findByTenantIdAndUsername(tenantId, data.getUsername()).isPresent()) {
                continue;
            }

            UserEntity user = new UserEntity();
            user.setTenantId(tenantId);
            user.setUsername(data.getUsername());
            user.setRealName(data.getRealName() != null ? data.getRealName() : data.getUsername());
            user.setEmail(data.getEmail());
            user.setPhone(data.getPhone());
            user.setStatus(data.getStatus() != null ? data.getStatus() : "active");
            user.setPassword("$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E"); // Default password: 123456
            user.setCreatedAt(LocalDateTime.now());
            userRepository.save(user);
            count++;
        }
        return count;
    }

    public List<UserEntity> getUsersByTenant(Long tenantId) {
        return userRepository.findByTenantId(tenantId);
    }
}
