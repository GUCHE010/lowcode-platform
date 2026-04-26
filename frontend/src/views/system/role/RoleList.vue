<template>
  <div class="role-list">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>角色管理</span>
          <el-button type="primary" @click="handleAdd">新增角色</el-button>
        </div>
      </template>

      <el-table :data="tableData" stripe border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="tenantName" label="所属租户" width="180">
          <template #default="{ row }">
            {{ getTenantName(row.tenantId) }}
          </template>
        </el-table-column>
        <el-table-column prop="roleCode" label="角色编码" width="150" />
        <el-table-column prop="roleName" label="角色名称" width="150" />
        <el-table-column prop="dataScope" label="数据权限" width="150">
          <template #default="{ row }">
            {{ getDataScopeName(row.dataScope) }}
          </template>
        </el-table-column>
        <el-table-column prop="sortOrder" label="排序" width="80" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 'active' ? 'success' : 'danger'">
              {{ row.status === 'active' ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="roleDesc" label="备注" />
        <el-table-column label="操作" width="250" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleEdit(row)">编辑</el-button>
            <el-button type="primary" link @click="handleAssignPermission(row)">分配权限</el-button>
            <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        v-model:current-page="pageNum"
        v-model:page-size="pageSize"
        :total="total"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="loadData"
        @current-change="loadData"
        style="margin-top: 20px; justify-content: flex-end"
      />
    </el-card>

    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="500px">
      <el-form :model="formData" :rules="formRules" ref="formRef" label-width="100px">
        <el-form-item label="租户" prop="tenantId">
          <el-select v-model="formData.tenantId" placeholder="请选择租户" style="width: 100%;">
            <el-option v-for="tenant in tenantList" :key="tenant.id" :label="tenant.tenantName" :value="tenant.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="角色编码" prop="roleCode">
          <el-input v-model="formData.roleCode" placeholder="请输入角色编码" />
        </el-form-item>
        <el-form-item label="角色名称" prop="roleName">
          <el-input v-model="formData.roleName" placeholder="请输入角色名称" />
        </el-form-item>
        <el-form-item label="数据权限" prop="dataScope">
          <el-select v-model="formData.dataScope" placeholder="请选择数据权限" style="width: 100%;">
            <el-option label="默认权限" value="DEFAULT" />
            <el-option label="仅本人数据" value="OWN" />
            <el-option label="本部门数据" value="DEPT" />
            <el-option label="本部门及以下" value="DEPT_ALL" />
            <el-option label="全部数据" value="ALL" />
          </el-select>
        </el-form-item>
        <el-form-item label="排序" prop="sortOrder">
          <el-input-number v-model="formData.sortOrder" :min="0" :max="9999" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="formData.status">
            <el-radio value="active">启用</el-radio>
            <el-radio value="inactive">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注" prop="roleDesc">
          <el-input v-model="formData.roleDesc" type="textarea" placeholder="请输入备注" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>

    <el-dialog title="分配权限" v-model="permDialogVisible" width="500px">
      <div class="perm-tip">勾选菜单权限，支持半选状态</div>
      <el-tree
        ref="treeRef"
        :data="menuTree"
        show-checkbox
        node-key="id"
        :props="{ label: 'menuName', children: 'children' }"
        :default-expand-all="true"
      />
      <template #footer>
        <el-button @click="permDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSavePermissions">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getRoleList, createRole, updateRole, deleteRole, assignPermissions, getRoleMenuIds } from '@/api/role'
import { getMenuTree } from '@/api/menu'
import { getTenantList } from '@/api/tenant'

const tableData = ref<any[]>([])
const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)
const tenantList = ref<any[]>([])

const dialogVisible = ref(false)
const dialogTitle = ref('新增角色')
const formRef = ref()
const formData = ref({
  id: null as number | null,
  tenantId: null as number | null,
  roleCode: '',
  roleName: '',
  dataScope: 'DEFAULT',
  sortOrder: 0,
  status: 'active',
  roleDesc: ''
})

const formRules = {
  tenantId: [{ required: true, message: '请选择租户', trigger: 'change' }],
  roleCode: [{ required: true, message: '请输入角色编码', trigger: 'blur' }],
  roleName: [{ required: true, message: '请输入角色名称', trigger: 'blur' }]
}

const permDialogVisible = ref(false)
const currentRoleId = ref<number | null>(null)
const menuTree = ref<any[]>([])
const treeRef = ref()

const dataScopeOptions = [
  { value: 'DEFAULT', label: '默认权限' },
  { value: 'OWN', label: '仅本人数据' },
  { value: 'DEPT', label: '本部门数据' },
  { value: 'DEPT_ALL', label: '本部门及以下' },
  { value: 'ALL', label: '全部数据' }
]

const getDataScopeName = (dataScope: string) => {
  const option = dataScopeOptions.find(o => o.value === dataScope)
  return option ? option.label : dataScope
}

const getTenantName = (tenantId: number | null) => {
  if (!tenantId) return '-'
  const tenant = tenantList.value.find(t => t.id === tenantId)
  return tenant ? tenant.tenantName : '-'
}

const loadData = async () => {
  try {
    // 先加载租户列表
    const tenantRes = await getTenantList()
    if (tenantRes.success) {
      tenantList.value = tenantRes.data || []
    }

    const userInfo = JSON.parse(localStorage.getItem('user') || '{}')
    const tenantId = userInfo.tenantId || 1
    const res = await getRoleList({ tenantId })
    if (res.success) {
      tableData.value = res.data || []
      total.value = tableData.value.length
    } else if (Array.isArray(res)) {
      tableData.value = res
      total.value = res.length
    } else {
      tableData.value = []
      total.value = 0
    }
  } catch (error) {
    console.error('加载角色列表失败', error)
    ElMessage.error('加载角色列表失败')
  }
}

const handleAdd = () => {
  dialogTitle.value = '新增角色'
  const userInfo = JSON.parse(localStorage.getItem('user') || '{}')
  formData.value = {
    id: null,
    tenantId: userInfo.tenantId || 1,
    roleCode: '',
    roleName: '',
    dataScope: 'DEFAULT',
    sortOrder: 0,
    status: 'active',
    roleDesc: ''
  }
  dialogVisible.value = true
}

const handleEdit = (row: any) => {
  dialogTitle.value = '编辑角色'
  formData.value = { ...row, dataScope: row.dataScope || 'DEFAULT', tenantId: row.tenantId || null }
  dialogVisible.value = true
}

const handleDelete = (row: any) => {
  ElMessageBox.confirm(`确定删除角色"${row.roleName}"吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await deleteRole(row.id)
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

    const submitData = { ...formData.value }
    if (dialogTitle.value === '新增角色') {
      const userInfo = JSON.parse(localStorage.getItem('user') || '{}')
      submitData.tenantId = userInfo.tenantId || 1
      await createRole(submitData)
      ElMessage.success('创建成功')
    } else {
      await updateRole(submitData)
      ElMessage.success('更新成功')
    }
    dialogVisible.value = false
    loadData()
  } catch (error) {
    console.error('操作失败', error)
    ElMessage.error('操作失败')
  }
}

const handleAssignPermission = async (row: any) => {
  currentRoleId.value = row.id
  try {
    const menuRes = await getMenuTree()
    if (menuRes.success) {
      menuTree.value = menuRes.data || []
    } else {
      menuTree.value = []
    }

    const permRes = await getRoleMenuIds(row.id)
    if (permRes.success && permRes.data) {
      setTimeout(() => {
        if (treeRef.value) {
          treeRef.value.setCheckedKeys(permRes.data || [])
        }
      }, 100)
    }

    permDialogVisible.value = true
  } catch (error) {
    console.error('加载权限失败', error)
    ElMessage.error('加载权限失败')
  }
}

const handleSavePermissions = async () => {
  if (!currentRoleId.value) return
  try {
    const checkedKeys = treeRef.value?.getCheckedKeys() || []
    const halfCheckedKeys = treeRef.value?.getHalfCheckedKeys() || []
    const menuIds = [...checkedKeys, ...halfCheckedKeys]

    await assignPermissions({
      roleId: currentRoleId.value,
      menuIds: menuIds
    })
    ElMessage.success('分配权限成功')
    permDialogVisible.value = false
  } catch (error) {
    console.error('分配权限失败', error)
    ElMessage.error('分配权限失败')
  }
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.role-list {
  padding: 20px;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.perm-tip {
  color: #909399;
  font-size: 12px;
  margin-bottom: 10px;
}
</style>
