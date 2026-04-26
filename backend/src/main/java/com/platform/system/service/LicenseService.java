package com.platform.system.service;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.platform.system.entity.LicenseEntity;
import com.platform.system.repository.LicenseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.LocalDateTime;
import java.util.Base64;

@Service
public class LicenseService {

    private static final String LICENSE_SECRET = "LowcodePlatform2026SecretKey";

    @Autowired
    private LicenseRepository licenseRepository;

    public LicenseEntity getCurrentLicense() {
        return licenseRepository.findAll().stream().findFirst().orElse(null);
    }

    public boolean isLicenseValid() {
        LicenseEntity license = getCurrentLicense();
        if (license == null) {
            return false;
        }
        if (!"active".equals(license.getStatus())) {
            return false;
        }
        if (license.getExpireDate() != null && license.getExpireDate().isBefore(LocalDateTime.now())) {
            return false;
        }
        return true;
    }

    public String getLicenseType() {
        LicenseEntity license = getCurrentLicense();
        return license != null ? license.getLicenseType() : "NONE";
    }

    public boolean hasFeature(String feature) {
        LicenseEntity license = getCurrentLicense();
        if (license == null || license.getFeatures() == null) {
            return false;
        }
        return license.getFeatures().contains(feature);
    }

    @Transactional
    public LicenseEntity installLicense(String licenseKey) {
        try {
            JSONObject licenseData = decodeAndVerifyLicense(licenseKey);
            if (licenseData == null) {
                return null;
            }

            LicenseEntity license = new LicenseEntity();
            license.setLicenseKey(licenseKey);
            license.setCompanyName(licenseData.getString("companyName"));
            license.setCompanyCode(licenseData.getString("companyCode"));
            license.setLicenseType(licenseData.getString("licenseType"));
            license.setIssueDate(licenseData.getDate("issueDate").toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDateTime());
            license.setExpireDate(licenseData.getDate("expireDate").toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDateTime());
            license.setMaxTenants(licenseData.getInteger("maxTenants"));
            license.setMaxUsersPerTenant(licenseData.getInteger("maxUsersPerTenant"));
            license.setMaxAppsPerTenant(licenseData.getInteger("maxAppsPerTenant"));
            license.setBindServers(licenseData.getString("bindServers"));
            license.setFeatures(licenseData.getString("features"));
            license.setSignature(licenseData.getString("signature"));
            license.setStatus("active");
            license.setCreatedAt(LocalDateTime.now());
            license.setUpdatedAt(LocalDateTime.now());

            licenseRepository.deleteAll();
            return licenseRepository.save(license);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private JSONObject decodeAndVerifyLicense(String licenseKey) {
        try {
            System.out.println("开始解析License: " + licenseKey);
            
            String[] parts = licenseKey.split("\\.");
            System.out.println("License分割后部分数: " + parts.length);
            
            if (parts.length != 2) {
                System.out.println("License格式错误：缺少校验码");
                return null;
            }

            String jsonBase64 = parts[0];
            String providedMd5 = parts[1];
            System.out.println("Base64部分长度: " + jsonBase64.length());
            System.out.println("MD5部分: " + providedMd5);

            String jsonStr = new String(Base64.getDecoder().decode(jsonBase64), StandardCharsets.UTF_8);
            System.out.println("解码后的JSON: " + jsonStr);

            String expectedMd5 = calculateMd5(jsonStr);
            System.out.println("计算的MD5: " + expectedMd5);
            System.out.println("提供的MD5: " + providedMd5);
            
            if (!expectedMd5.equalsIgnoreCase(providedMd5)) {
                System.out.println("License校验失败：MD5不匹配，可能已被篡改");
                return null;
            }

            return JSON.parseObject(jsonStr);
        } catch (Exception e) {
            System.out.println("License解析失败：" + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    private String calculateMd5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] digest = md.digest((input + LICENSE_SECRET).getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            return "";
        }
    }

    public static String generateLicenseKey(JSONObject licenseData) {
        try {
            String jsonStr = JSON.toJSONString(licenseData);
            String jsonBase64 = Base64.getEncoder().encodeToString(jsonStr.getBytes(StandardCharsets.UTF_8));
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] digest = md.digest((jsonStr + LICENSE_SECRET).getBytes(StandardCharsets.UTF_8));
            StringBuilder md5Str = new StringBuilder();
            for (byte b : digest) {
                md5Str.append(String.format("%02x", b));
            }
            return jsonBase64 + "." + md5Str.toString();
        } catch (Exception e) {
            return null;
        }
    }

    public JSONObject getLicenseInfo() {
        LicenseEntity license = getCurrentLicense();
        if (license == null) {
            return null;
        }
        JSONObject info = new JSONObject();
        info.put("companyName", license.getCompanyName());
        info.put("companyCode", license.getCompanyCode());
        info.put("licenseType", license.getLicenseType());
        info.put("issueDate", license.getIssueDate());
        info.put("expireDate", license.getExpireDate());
        info.put("maxTenants", license.getMaxTenants());
        info.put("maxUsersPerTenant", license.getMaxUsersPerTenant());
        info.put("maxAppsPerTenant", license.getMaxAppsPerTenant());
        info.put("features", license.getFeatures());
        info.put("status", isLicenseValid() ? "valid" : "invalid");
        return info;
    }
}
