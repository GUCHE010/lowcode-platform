<template>
  <div class="license-list">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>授权许可管理</span>
          <el-button type="primary" @click="handleInstall">安装License</el-button>
        </div>
      </template>

      <el-descriptions :column="2" border v-if="licenseInfo">
        <el-descriptions-item label="公司名称">{{ licenseInfo.companyName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="公司代码">{{ licenseInfo.companyCode || '-' }}</el-descriptions-item>
        <el-descriptions-item label="License类型">
          <el-tag :type="getLicenseTypeColor(licenseInfo.licenseType)">
            {{ licenseInfo.licenseType || '未设置' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="licenseInfo.status === 'valid' ? 'success' : 'danger'">
            {{ licenseInfo.status === 'valid' ? '有效' : '无效' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="最大租户数">{{ licenseInfo.maxTenants || '-' }}</el-descriptions-item>
        <el-descriptions-item label="每租户最大用户数">{{ licenseInfo.maxUsersPerTenant || '-' }}</el-descriptions-item>
        <el-descriptions-item label="每租户最大应用数">{{ licenseInfo.maxAppsPerTenant || '-' }}</el-descriptions-item>
        <el-descriptions-item label="到期日期">{{ licenseInfo.expireDate || '永久' }}</el-descriptions-item>
        <el-descriptions-item label="授权功能" :span="2">
          <div v-if="licenseInfo.features">
            <el-tag v-for="feature in licenseInfo.features.split(',')" :key="feature" size="small" style="margin-right: 4px;">
              {{ feature }}
            </el-tag>
          </div>
          <span v-else>-</span>
        </el-descriptions-item>
      </el-descriptions>

      <el-empty v-else description="暂未安装License" />
    </el-card>

    <el-card style="margin-top: 20px;">
      <template #header>
        <span>功能开关</span>
      </template>
      <el-table :data="featureList" stripe border>
        <el-table-column prop="feature" label="功能名称" width="200" />
        <el-table-column prop="description" label="说明" />
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.enabled ? 'success' : 'info'">
              {{ row.enabled ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog title="安装License" v-model="dialogVisible" width="500px">
      <el-form :model="formData" ref="formRef" label-width="100px">
        <el-form-item label="License Key" prop="licenseKey">
          <el-input
            v-model="formData.licenseKey"
            type="textarea"
            :rows="6"
            placeholder="请粘贴License Key"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">安装</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getLicenseInfo, installLicense } from '@/api/license'

const licenseInfo = ref<any>(null)
const dialogVisible = ref(false)
const formRef = ref()
const formData = ref({
  licenseKey: ''
})

const featureList = ref([
  { feature: 'source_export', description: '源码导出', enabled: false },
  { feature: 'ai_generate', description: 'AI代码生成', enabled: false },
  { feature: 'workflow', description: '工作流引擎', enabled: false },
  { feature: 'multi_tenant', description: '多租户模式', enabled: false },
  { feature: 'sms_auth', description: '短信认证', enabled: false },
  { feature: 'ldap_auth', description: 'LDAP集成', enabled: false }
])

const getLicenseTypeColor = (type: string) => {
  const colors: Record<string, string> = {
    'TRIAL': 'warning',
    'PROFESSIONAL': 'primary',
    'ENTERPRISE': 'success',
    'OEM': 'info'
  }
  return colors[type] || 'info'
}

const loadLicenseInfo = async () => {
  try {
    const res = await getLicenseInfo()
    if (res.success && res.data) {
      licenseInfo.value = res.data
      updateFeatureList()
    }
  } catch (error) {
    console.error('加载License信息失败', error)
  }
}

const updateFeatureList = () => {
  if (!licenseInfo.value || !licenseInfo.value.features) return
  const features = licenseInfo.value.features.split(',')
  featureList.value = featureList.value.map(item => ({
    ...item,
    enabled: features.includes(item.feature)
  }))
}

const handleInstall = () => {
  formData.value.licenseKey = ''
  dialogVisible.value = true
}

const handleSubmit = async () => {
  if (!formData.value.licenseKey.trim()) {
    ElMessage.error('请输入License Key')
    return
  }
  try {
    const res = await installLicense({ licenseKey: formData.value.licenseKey })
    if (res.success) {
      ElMessage.success('License安装成功')
      dialogVisible.value = false
      loadLicenseInfo()
    } else {
      ElMessage.error(res.message || 'License安装失败')
    }
  } catch (error) {
    ElMessage.error('License安装失败')
  }
}

onMounted(() => {
  loadLicenseInfo()
})
</script>

<style scoped>
.license-list {
  padding: 20px;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
