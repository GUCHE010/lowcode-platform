<template>
  <div class="user-list">
    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="用户名">
          <el-input v-model="searchForm.username" placeholder="请输入用户名" clearable />
        </el-form-item>
        <el-form-item label="姓名">
          <el-input v-model="searchForm.realName" placeholder="请输入姓名" clearable />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="searchForm.phone" placeholder="请输入手机号" clearable />
        </el-form-item>
        <el-form-item label="部门">
          <el-select v-model="searchForm.deptId" placeholder="请选择部门" clearable>
            <el-option v-for="dept in deptList" :key="dept.id" :label="dept.deptName" :value="dept.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="岗位">
          <el-select v-model="searchForm.postId" placeholder="请选择岗位" clearable>
            <el-option v-for="post in postList" :key="post.id" :label="post.postName" :value="post.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" clearable>
            <el-option label="启用" value="active" />
            <el-option label="禁用" value="inactive" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card class="table-card">
      <template #header>
        <div class="card-header">
          <span>用户列表</span>
          <div>
            <el-button type="primary" @click="handleAdd">新增用户</el-button>
            <el-button type="success" @click="handleBatchEnable" :disabled="selectedUsers.length === 0">批量启用</el-button>
            <el-button type="warning" @click="handleBatchDisable" :disabled="selectedUsers.length === 0">批量禁用</el-button>
            <el-button type="info" @click="handleImport">导入</el-button>
            <el-button type="info" @click="handleExport">导出</el-button>
          </div>
        </div>
      </template>

      <el-table :data="tableData" stripe border style="width: 100%" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" />
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="username" label="用户名" width="120" />
        <el-table-column prop="realName" label="姓名" width="100" />
        <el-table-column prop="deptName" label="部门" width="120">
          <template #default="{ row }">
            {{ getDeptName(row.deptId) }}
          </template>
        </el-table-column>
        <el-table-column prop="postName" label="岗位" width="120">
          <template #default="{ row }">
            {{ getPostName(row.postId) }}
          </template>
        </el-table-column>
        <el-table-column prop="email" label="邮箱" width="180" />
        <el-table-column prop="phone" label="手机号" width="130" />
        <el-table-column prop="status" label="状态" width="90">
          <template #default="{ row }">
            <el-switch
              v-model="row.status"
              active-value="active"
              inactive-value="inactive"
              @change="handleStatusChange(row)"
            />
          </template>
        </el-table-column>
        <el-table-column prop="lastLoginTime" label="最后登录" width="160" />
        <el-table-column label="角色" width="150">
          <template #default="{ row }">
            <el-tag v-for="roleName in row.roleNames" :key="roleName" type="info" size="small" style="margin-right: 4px;">
              {{ roleName }}
            </el-tag>
            <span v-if="!row.roleNames || row.roleNames.length === 0" class="text-gray">未分配</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="250" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleEdit(row)">编辑</el-button>
            <el-button type="primary" link @click="handleAssignRole(row)">分配角色</el-button>
            <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        v-model:current-page="pageNum"
        v-model:page-size="pageSize"
        :page-sizes="[10, 20, 50, 100]"
        :total="total"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="loadData"
        @current-change="loadData"
        style="margin-top: 20px; justify-content: flex-end"
      />
    </el-card>

    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="600px">
      <el-form :model="formData" :rules="formRules" ref="formRef" label-width="80px">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="formData.username" placeholder="请输入用户名" :disabled="dialogTitle === '编辑用户'" />
        </el-form-item>
        <el-form-item label="姓名" prop="realName">
          <el-input v-model="formData.realName" placeholder="请输入姓名" />
        </el-form-item>
        <el-form-item label="部门" prop="deptId">
          <el-select v-model="formData.deptId" placeholder="请选择部门" clearable style="width: 100%;">
            <el-option v-for="dept in deptList" :key="dept.id" :label="dept.deptName" :value="dept.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="岗位" prop="postId">
          <el-select v-model="formData.postId" placeholder="请选择岗位" clearable style="width: 100%;">
            <el-option v-for="post in postList" :key="post.id" :label="post.postName" :value="post.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="formData.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="formData.phone" placeholder="请输入手机号" />
        </el-form-item>
        <el-form-item label="密码" prop="password" v-if="dialogTitle === '新增用户'">
          <el-input v-model="formData.password" type="password" placeholder="请输入密码" show-password />
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

    <el-dialog title="分配角色" v-model="roleDialogVisible" width="400px">
      <el-checkbox-group v-model="selectedRoleIds">
        <el-checkbox v-for="role in allRoles" :key="role.id" :label="role.id">
          {{ role.roleName }}
        </el-checkbox>
      </el-checkbox-group>
      <template #footer>
        <el-button @click="roleDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSaveRoles">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog title="导入用户" v-model="importDialogVisible" width="500px">
      <div class="import-content">
        <el-button type="primary" link @click="handleDownloadTemplate">下载导入模板</el-button>
        <el-upload
          ref="uploadRef"
          :auto-upload="false"
          :limit="1"
          accept=".xlsx,.xls"
          :on-change="handleFileChange"
        >
          <template #trigger>
            <el-button>选择Excel文件</el-button>
          </template>
        </el-upload>
      </div>
      <template #footer>
        <el-button @click="importDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleConfirmImport">确定导入</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getUserList, searchUsers, createUser, updateUser, deleteUser, getUserRoleIds, assignUserRoles, updateUserStatus, batchUpdateUserStatus, importUsers, exportUsers, downloadUserTemplate } from '@/api/user'
import { getRoleList } from '@/api/role'
import { getDeptList } from '@/api/dept'
import { getPostList } from '@/api/post'

const searchForm = ref({
  username: '',
  realName: '',
  phone: '',
  deptId: null as number | null,
  postId: null as number | null,
  status: ''
})

const tableData = ref<any[]>([])
const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)
const selectedUsers = ref<any[]>([])
const deptList = ref<any[]>([])
const postList = ref<any[]>([])

const dialogVisible = ref(false)
const dialogTitle = ref('新增用户')
const formRef = ref()
const formData = ref({
  id: null as number | null,
  username: '',
  realName: '',
  email: '',
  phone: '',
  deptId: null as number | null,
  postId: null as number | null,
  password: '',
  status: 'active'
})

const roleDialogVisible = ref(false)
const currentUserId = ref<number | null>(null)
const allRoles = ref<any[]>([])
const selectedRoleIds = ref<number[]>([])

const importDialogVisible = ref(false)
const uploadRef = ref()
const importFile = ref<File | null>(null)

const formRules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  realName: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  email: [{ required: true, message: '请输入邮箱', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}

const getDeptName = (deptId: number | null) => {
  if (!deptId) return '-'
  const dept = deptList.value.find(d => d.id === deptId)
  return dept ? dept.deptName : '-'
}

const getPostName = (postId: number | null) => {
  if (!postId) return '-'
  const post = postList.value.find(p => p.id === postId)
  return post ? post.postName : '-'
}

const loadDeptsAndPosts = async () => {
  try {
    const userInfo = JSON.parse(localStorage.getItem('user') || '{}')
    const tenantId = userInfo.tenantId || 1

    const deptRes = await getDeptList({ tenantId })
    if (deptRes.success) {
      deptList.value = deptRes.data || []
    }

    const postRes = await getPostList({ tenantId })
    if (postRes.success) {
      postList.value = postRes.data || []
    }
  } catch (error) {
    console.error('加载部门岗位列表失败', error)
  }
}

const loadData = async () => {
  try {
    const userInfo = JSON.parse(localStorage.getItem('user') || '{}')
    const tenantId = userInfo.tenantId || 1

    const hasSearch = searchForm.value.username || searchForm.value.realName ||
                      searchForm.value.phone || searchForm.value.deptId ||
                      searchForm.value.postId || searchForm.value.status

    let res
    if (hasSearch) {
      res = await searchUsers({
        tenantId,
        pageNum: pageNum.value,
        pageSize: pageSize.value,
        username: searchForm.value.username || null,
        realName: searchForm.value.realName || null,
        phone: searchForm.value.phone || null,
        deptId: searchForm.value.deptId || null,
        postId: searchForm.value.postId || null,
        status: searchForm.value.status || null
      })
    } else {
      res = await getUserList({ tenantId, pageNum: pageNum.value, pageSize: pageSize.value })
    }

    if (res.success) {
      tableData.value = res.data || []
    } else if (Array.isArray(res)) {
      tableData.value = res
    } else if (res.data && Array.isArray(res.data)) {
      tableData.value = res.data
    } else {
      tableData.value = []
    }

    total.value = tableData.value.length
  } catch (error) {
    console.error('加载用户列表失败', error)
    ElMessage.error('加载用户列表失败')
  }
}

const handleSearch = () => {
  pageNum.value = 1
  loadData()
}

const handleReset = () => {
  searchForm.value = {
    username: '',
    realName: '',
    phone: '',
    deptId: null,
    postId: null,
    status: ''
  }
  handleSearch()
}

const handleSelectionChange = (selection: any[]) => {
  selectedUsers.value = selection
}

const handleStatusChange = async (row: any) => {
  try {
    await updateUserStatus({ userId: row.id, status: row.status })
    ElMessage.success('状态更新成功')
  } catch (error) {
    ElMessage.error('状态更新失败')
    loadData()
  }
}

const handleBatchEnable = async () => {
  ElMessageBox.confirm(`确定启用选中的 ${selectedUsers.value.length} 个用户吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const userIds = selectedUsers.value.map(u => u.id)
      await batchUpdateUserStatus({ userIds, status: 'active' })
      ElMessage.success('批量启用成功')
      loadData()
    } catch (error) {
      ElMessage.error('批量启用失败')
    }
  })
}

const handleBatchDisable = async () => {
  ElMessageBox.confirm(`确定禁用选中的 ${selectedUsers.value.length} 个用户吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const userIds = selectedUsers.value.map(u => u.id)
      await batchUpdateUserStatus({ userIds, status: 'inactive' })
      ElMessage.success('批量禁用成功')
      loadData()
    } catch (error) {
      ElMessage.error('批量禁用失败')
    }
  })
}

const handleAdd = () => {
  dialogTitle.value = '新增用户'
  formData.value = {
    id: null,
    username: '',
    realName: '',
    email: '',
    phone: '',
    deptId: null,
    postId: null,
    password: '',
    status: 'active'
  }
  dialogVisible.value = true
}

const handleEdit = (row: any) => {
  dialogTitle.value = '编辑用户'
  formData.value = { ...row, password: '', deptId: row.deptId || null, postId: row.postId || null }
  dialogVisible.value = true
}

const handleDelete = (row: any) => {
  ElMessageBox.confirm(`确定删除用户"${row.username}"吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await deleteUser(row.id)
      ElMessage.success('删除成功')
      loadData()
    } catch (error) {
      ElMessage.error('删除失败')
    }
  })
}

const handleSubmit = async () => {
  try {
    if (dialogTitle.value === '新增用户' && !formData.value.password) {
      ElMessage.error('请输入密码')
      return
    }

    await formRef.value?.validate()

    const submitData = { ...formData.value }
    if (dialogTitle.value === '新增用户') {
      const userInfo = JSON.parse(localStorage.getItem('user') || '{}')
      submitData.tenantId = userInfo.tenantId || 1
      await createUser(submitData)
      ElMessage.success('创建成功')
    } else {
      await updateUser(submitData)
      ElMessage.success('更新成功')
    }
    dialogVisible.value = false
    loadData()
  } catch (error) {
    console.error('操作失败', error)
    ElMessage.error('操作失败')
  }
}

const handleAssignRole = async (row: any) => {
  currentUserId.value = row.id
  try {
    const roleRes = await getRoleList({ tenantId: 1 })
    if (roleRes.success) {
      allRoles.value = roleRes.data || []
    } else if (Array.isArray(roleRes)) {
      allRoles.value = roleRes
    } else {
      allRoles.value = []
    }

    const roleIdRes = await getUserRoleIds(row.id)
    if (roleIdRes.success) {
      selectedRoleIds.value = roleIdRes.data || []
    } else if (Array.isArray(roleIdRes)) {
      selectedRoleIds.value = roleIdRes
    } else {
      selectedRoleIds.value = []
    }

    roleDialogVisible.value = true
  } catch (error) {
    console.error('加载角色失败', error)
    ElMessage.error('加载角色失败')
  }
}

const handleSaveRoles = async () => {
  if (!currentUserId.value) return
  try {
    await assignUserRoles({
      userId: currentUserId.value,
      roleIds: selectedRoleIds.value
    })
    ElMessage.success('分配角色成功')
    roleDialogVisible.value = false
    loadData()
  } catch (error) {
    console.error('分配角色失败', error)
    ElMessage.error('分配角色失败')
  }
}

const handleImport = () => {
  importFile.value = null
  importDialogVisible.value = true
}

const handleFileChange = (file: any) => {
  importFile.value = file.raw
}

const handleConfirmImport = async () => {
  if (!importFile.value) {
    ElMessage.error('请选择要导入的Excel文件')
    return
  }
  try {
    const userInfo = JSON.parse(localStorage.getItem('user') || '{}')
    const tenantId = userInfo.tenantId || 1
    const res = await importUsers(importFile.value, tenantId)
    if (res.success) {
      ElMessage.success(res.message || '导入成功')
      importDialogVisible.value = false
      loadData()
    } else {
      ElMessage.error(res.message || '导入失败')
    }
  } catch (error) {
    ElMessage.error('导入失败')
  }
}

const handleExport = async () => {
  try {
    const userInfo = JSON.parse(localStorage.getItem('user') || '{}')
    const tenantId = userInfo.tenantId || 1
    const res = await exportUsers(tenantId)
    const blob = new Blob([res], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' })
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `用户数据_${Date.now()}.xlsx`
    link.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success('导出成功')
  } catch (error) {
    ElMessage.error('导出失败')
  }
}

const handleDownloadTemplate = async () => {
  try {
    const res = await downloadUserTemplate()
    const blob = new Blob([res], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' })
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = '用户导入模板.xlsx'
    link.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success('模板下载成功')
  } catch (error) {
    ElMessage.error('模板下载失败')
  }
}

onMounted(() => {
  loadDeptsAndPosts()
  loadData()
})
</script>

<style scoped>
.user-list {
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
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.text-gray {
  color: #999;
}
.search-form :deep(.el-form-item:nth-child(4) .el-select .el-select__wrapper),
.search-form :deep(.el-form-item:nth-child(5) .el-select .el-select__wrapper),
.search-form :deep(.el-form-item:nth-child(6) .el-select .el-select__wrapper) {
  width: 180px;
}
.table-card :deep(.card-header > div > button:nth-child(1)) {
  background-color: #619cf8;
}
.table-card :deep(.card-header > div > button:nth-child(2)) {
  background-color: #739bf2;
}
.table-card :deep(.card-header > div > button:nth-child(3)) {
  background-color: #739bf2;
}
.table-card :deep(.card-header > div > button:nth-child(4)) {
  background-color: #7f9aec;
}
.table-card :deep(.card-header > div > button:nth-child(5)) {
  background-color: #7f9aec;
}
</style>
