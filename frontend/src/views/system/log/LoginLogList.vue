<template>
  <div class="login-log-list">
    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="用户名">
          <el-input v-model="searchForm.username" placeholder="请输入用户名" clearable />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" clearable>
            <el-option label="成功" value="success" />
            <el-option label="失败" value="fail" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card class="table-card">
      <el-table :data="tableData" stripe border style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="username" label="用户名" width="120" />
        <el-table-column prop="ipAddress" label="IP地址" width="150" />
        <el-table-column prop="loginLocation" label="登录地点" width="150" />
        <el-table-column prop="browser" label="浏览器" width="100" />
        <el-table-column prop="os" label="操作系统" width="100" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 'success' ? 'success' : 'danger'">
              {{ row.status === 'success' ? '成功' : '失败' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="msg" label="消息" width="150" />
        <el-table-column prop="loginTime" label="登录时间" width="180" />
      </el-table>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getLoginLogList } from '@/api/loginLog'

const searchForm = ref({
  username: '',
  status: ''
})

const tableData = ref<any[]>([])

const loadData = async () => {
  try {
    const userInfo = JSON.parse(localStorage.getItem('user') || '{}')
    const tenantId = userInfo.tenantId || 1
    
    const res = await getLoginLogList({ tenantId: tenantId })
    if (res.success) {
      let data = res.data || []
      if (searchForm.value.username) {
        data = data.filter((item: any) => item.username.includes(searchForm.value.username))
      }
      if (searchForm.value.status) {
        data = data.filter((item: any) => item.status === searchForm.value.status)
      }
      tableData.value = data
    } else {
      tableData.value = []
    }
  } catch (error) {
    console.error('加载登录日志失败', error)
    ElMessage.error('加载登录日志失败')
  }
}

const handleSearch = () => {
  loadData()
}

const handleReset = () => {
  searchForm.value = { username: '', status: '' }
  loadData()
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.login-log-list {
  padding: 20px;
}
.search-card {
  margin-bottom: 20px;
}
.search-form {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
}
</style>