import com.alibaba.fastjson2.JSONObject;
import com.platform.system.service.LicenseService;

public class TestLicense {
    public static void main(String[] args) {
        // 构建License数据
        JSONObject licenseData = new JSONObject();
        licenseData.put("companyName", "测试公司");
        licenseData.put("companyCode", "TEST001");
        licenseData.put("licenseType", "ENTERPRISE");
        licenseData.put("issueDate", "2026-04-26");
        licenseData.put("expireDate", "2099-12-31");
        licenseData.put("maxTenants", 9999);
        licenseData.put("maxUsersPerTenant", -1);
        licenseData.put("maxAppsPerTenant", -1);
        licenseData.put("bindServers", "[]");
        licenseData.put("features", "source_export,ai_generate,workflow,multi_tenant");
        licenseData.put("signature", "");
        
        // 生成License Key
        String licenseKey = LicenseService.generateLicenseKey(licenseData);
        
        System.out.println("生成的License Key:");
        System.out.println(licenseKey);
        System.out.println("\n请复制以上内容到系统中安装");
    }
}