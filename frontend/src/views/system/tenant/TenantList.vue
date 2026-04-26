<template>
  <div class="tenant-list">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>租户管理</span>
          <el-button type="primary" @click="handleAdd">新增租户</el-button>
        </div>
      </template>

      <el-table :data="tableData" stripe border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="tenantCode" label="租户编码" width="150" />
        <el-table-column prop="tenantName" label="租户名称" width="200" />
        <el-table-column prop="maxUsers" label="最大用户数" width="120" />
        <el-table-column prop="maxApps" label="最大应用数" width="120" />
        <el-table-column prop="expireDate" label="到期日期" width="150">
          <template #default="{ row }">
            {{ row.expireDate || '永久' }}
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 'active' ? 'success' : 'danger'">
              {{ row.status === 'active' ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="创建时间" width="180" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="600px">
      <el-form :model="formData" :rules="formRules" ref="formRef" label-width="100px">
        <el-form-item label="租户编码" prop="tenantCode">
          <el-input v-model="formData.tenantCode" placeholder="请输入租户编码" :disabled="dialogTitle === '编辑租户'" />
        </el-form-item>
        <el-form-item label="租户名称" prop="tenantName">
          <el-input v-model="formData.tenantName" placeholder="请输入租户名称" />
        </el-form-item>
        <el-form-item label="License Key" prop="licenseKey">
          <el-input v-model="formData.licenseKey" placeholder="请输入License Key" />
        </el-form-item>
        <el-form-item label="最大用户数" prop="maxUsers">
          <el-input-number v-model="formData.maxUsers" :min="1" :max="99999" />
        </el-form-item>
        <el-form-item label="最大应用数" prop="maxApps">
          <el-input-number v-model="formData.maxApps" :min="1" :max="99999" />
        </el-form-item>
        <el-form-item label="到期日期" prop="expireDate">
          <el-date-picker
            v-model="formData.expireDate"
            type="date"
            placeholder="选择日期（空表示永久）"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            clearable
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="formData.status">
            <el-radio value="active">启用</el-radio>
            <el-radio value="inactive">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getTenantList, createTenant, updateTenant, deleteTenant } from '@/api/tenant'

const tableData = ref<any[]>([])
const dialogVisible = ref(false)
const dialogTitle = ref('新增租户')
const formRef = ref()
const formData = ref({
  id: null as number | null,
  tenantCode: '',
  tenantName: '',
  licenseKey: '',
  maxUsers: 100,
  maxApps: 10,
  expireDate: '',
  status: 'active'
})

const formRules = {
  tenantCode: [{ required: true, message: '请输入租户编码', trigger: 'blur' }],
  tenantName: [{ required: true, message: '请输入租户名称', trigger: 'blur' }]
}

const loadData = async () => {
  try {
    const res = await getTenantList()
    if (res.success) {
      tableData.value = res.data || []
    } else {
      tableData.value = []
    }
  } catch (error) {
    console.error('加载租户列表失败', error)
    ElMessage.error('加载租户列表失败')
  }
}

const handleAdd = () => {
  dialogTitle.value = '新增租户'
  formData.value = {
    id: null,
    tenantCode: '',
    tenantName: '',
    licenseKey: '',
    maxUsers: 100,
    maxApps: 10,
    expireDate: '',
    status: 'active'
  }
  dialogVisible.value = true
}

const handleEdit = (row: any) => {
  dialogTitle.value = '编辑租户'
  formData.value = { ...row, expireDate: row.expireDate || '' }
  dialogVisible.value = true
}

const handleDelete = (row: any) => {
  ElMessageBox.confirm(`确定删除租户"${row.tenantName}"吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await deleteTenant(row.id)
      ElMessage.success('删除成功')
      loadData()
    } catch (error) {
      ElMessage.error('删除失败')
    }
  })
}

const handleSubmit = async () => {
  try {
    await formRef.value?.validate()
    if (dialogTitle.value === '新增租户') {
      await createTenant(formData.value)
      ElMessage.success('创建成功')
    } else {
      await updateTenant(formData.value)
      ElMessage.success('更新成功')
    }
    dialogVisible.value = false
    loadData()
  } catch (error) {
    console.error('操作失败', error)
    ElMessage.error('操作失败')
  }
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.tenant-list {
  padding: 20px;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
