package com.platform.system.controller;

import com.alibaba.excel.EasyExcel;
import com.platform.system.entity.UserEntity;
import com.platform.system.service.UserService;
import com.platform.system.service.UserRoleService;
import com.platform.system.service.UserImportExportService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/system/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private UserRoleService userRoleService;

    @Autowired
    private UserImportExportService userImportExportService;

    @GetMapping("/list")
    public Map<String, Object> list(@RequestParam Long tenantId) {
        List<UserEntity> users = userService.listByTenant(tenantId);
        List<Map<String, Object>> userList = users.stream().map(user -> {
            Map<String, Object> userMap = new HashMap<>();
            userMap.put("id", user.getId());
            userMap.put("tenantId", user.getTenantId());
            userMap.put("username", user.getUsername());
            userMap.put("realName", user.getRealName());
            userMap.put("email", user.getEmail());
            userMap.put("phone", user.getPhone());
            userMap.put("deptId", user.getDeptId());
            userMap.put("postId", user.getPostId());
            userMap.put("avatar", user.getAvatar());
            userMap.put("status", user.getStatus());
            userMap.put("lastLoginTime", user.getLastLoginTime());
            userMap.put("createdAt", user.getCreatedAt());
            userMap.put("roleNames", userService.getUserRoleNames(user.getId()));
            return userMap;
        }).collect(java.util.stream.Collectors.toList());
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", userList);
        result.put("total", userList.size());
        return result;
    }

    @GetMapping("/search")
    public Map<String, Object> search(@RequestParam Long tenantId,
                                      @RequestParam(required = false) String username,
                                      @RequestParam(required = false) String realName,
                                      @RequestParam(required = false) String phone,
                                      @RequestParam(required = false) Long deptId,
                                      @RequestParam(required = false) Long postId,
                                      @RequestParam(required = false) String status) {
        List<UserEntity> users = userService.searchUsers(tenantId, username, realName, phone, deptId, postId, status);
        List<Map<String, Object>> userList = users.stream().map(user -> {
            Map<String, Object> userMap = new HashMap<>();
            userMap.put("id", user.getId());
            userMap.put("tenantId", user.getTenantId());
            userMap.put("username", user.getUsername());
            userMap.put("realName", user.getRealName());
            userMap.put("email", user.getEmail());
            userMap.put("phone", user.getPhone());
            userMap.put("deptId", user.getDeptId());
            userMap.put("postId", user.getPostId());
            userMap.put("avatar", user.getAvatar());
            userMap.put("status", user.getStatus());
            userMap.put("lastLoginTime", user.getLastLoginTime());
            userMap.put("createdAt", user.getCreatedAt());
            userMap.put("roleNames", userService.getUserRoleNames(user.getId()));
            return userMap;
        }).collect(java.util.stream.Collectors.toList());
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", userList);
        result.put("total", userList.size());
        return result;
    }

    @PutMapping("/status")
    public Map<String, Object> updateStatus(@RequestBody Map<String, Object> request) {
        Long userId = Long.valueOf(request.get("userId").toString());
        String status = request.get("status").toString();
        userService.updateUserStatus(userId, status);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "状态更新成功");
        return result;
    }

    @PutMapping("/batchStatus")
    public Map<String, Object> batchUpdateStatus(@RequestBody Map<String, Object> request) {
        @SuppressWarnings("unchecked")
        List<Long> userIds = (List<Long>) request.get("userIds");
        String status = request.get("status").toString();
        userService.batchUpdateStatus(userIds, status);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "批量状态更新成功");
        return result;
    }

    @GetMapping("/{id}")
    public Map<String, Object> getById(@PathVariable Long id) {
        UserEntity user = userService.findById(id);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", user);
        return result;
    }

    @PostMapping
    public Map<String, Object> create(@RequestBody UserEntity user) {
        userService.create(user);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "创建成功");
        return result;
    }

    @PutMapping
    public Map<String, Object> update(@RequestBody UserEntity user) {
        userService.update(user);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "更新成功");
        return result;
    }

    @DeleteMapping("/{id}")
    public Map<String, Object> delete(@PathVariable Long id) {
        userService.delete(id);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }

    @GetMapping("/roleIds/{userId}")
    public Map<String, Object> getUserRoleIds(@PathVariable Long userId) {
        List<Long> roleIds = userRoleService.getUserRoleIds(userId);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", roleIds);
        return result;
    }

    @PostMapping("/roles")
    public Map<String, Object> assignUserRoles(@RequestBody Map<String, Object> request) {
        Long userId = Long.valueOf(request.get("userId").toString());
        @SuppressWarnings("unchecked")
        List<?> roleIdsRaw = (List<?>) request.get("roleIds");
        userRoleService.assignUserRoles(userId, roleIdsRaw);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "分配成功");
        return result;
    }

    @PostMapping("/import")
    public Map<String, Object> importUsers(@RequestParam("file") MultipartFile file,
                                            @RequestParam Long tenantId) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<UserImportExportService.UserExcelData> dataList = userImportExportService.parseExcel(file);
            int count = userImportExportService.importUsers(dataList, tenantId);
            result.put("success", true);
            result.put("message", "成功导入 " + count + " 条用户数据");
        } catch (IOException e) {
            result.put("success", false);
            result.put("message", "导入失败: " + e.getMessage());
        }
        return result;
    }

    @GetMapping("/export")
    public void exportUsers(@RequestParam Long tenantId, HttpServletResponse response) {
        try {
            List<UserEntity> users = userImportExportService.getUsersByTenant(tenantId);
            List<UserImportExportService.UserExcelData> exportData = new ArrayList<>();
            for (UserEntity user : users) {
                UserImportExportService.UserExcelData data = new UserImportExportService.UserExcelData();
                data.setUsername(user.getUsername());
                data.setRealName(user.getRealName());
                data.setEmail(user.getEmail());
                data.setPhone(user.getPhone());
                data.setStatus(user.getStatus());
                exportData.add(data);
            }

            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setCharacterEncoding("utf-8");
            String fileName = URLEncoder.encode("用户数据_" + System.currentTimeMillis(), StandardCharsets.UTF_8).replaceAll("\\+", "%20");
            response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");

            EasyExcel.write(response.getOutputStream())
                    .head(UserImportExportService.UserExcelData.class)
                    .sheet("用户列表")
                    .doWrite(exportData);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @GetMapping("/template")
    public void downloadTemplate(HttpServletResponse response) {
        try {
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setCharacterEncoding("utf-8");
            String fileName = URLEncoder.encode("用户导入模板", StandardCharsets.UTF_8).replaceAll("\\+", "%20");
            response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");

            List<UserImportExportService.UserExcelData> templateData = new ArrayList<>();
            UserImportExportService.UserExcelData example = new UserImportExportService.UserExcelData();
            example.setUsername("zhangsan");
            example.setRealName("张三");
            example.setEmail("zhangsan@company.com");
            example.setPhone("13800138000");
            example.setStatus("active");
            templateData.add(example);

            EasyExcel.write(response.getOutputStream())
                    .head(UserImportExportService.UserExcelData.class)
                    .sheet("用户导入模板")
                    .doWrite(templateData);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}