<template>
  <div class="dept-list">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>部门管理</span>
          <el-button type="primary" @click="handleAdd">新增部门</el-button>
        </div>
      </template>

      <el-table :data="tableData" stripe border row-key="id" :tree-props="{ children: 'children', hasChildren: 'hasChildren' }">
        <el-table-column prop="deptName" label="部门名称" width="200" />
        <el-table-column prop="deptCode" label="部门编码" width="150" />
        <el-table-column prop="deptLeader" label="负责人" width="120" />
        <el-table-column prop="deptPhone" label="联系电话" width="150" />
        <el-table-column prop="deptEmail" label="邮箱" width="180" />
        <el-table-column prop="sortOrder" label="排序" width="80" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-switch
              v-model="row.status"
              active-value="active"
              inactive-value="inactive"
              @change="handleStatusChange(row)"
            />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="250" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleAddChild(row)">新增</el-button>
            <el-button type="primary" link @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="500px">
      <el-form :model="formData" :rules="formRules" ref="formRef" label-width="100px">
        <el-form-item label="上级部门" v-if="formData.parentId !== 0">
          <el-input v-model="parentDeptName" disabled />
        </el-form-item>
        <el-form-item label="部门名称" prop="deptName">
          <el-input v-model="formData.deptName" placeholder="请输入部门名称" />
        </el-form-item>
        <el-form-item label="部门编码" prop="deptCode">
          <el-input v-model="formData.deptCode" placeholder="请输入部门编码" />
        </el-form-item>
        <el-form-item label="负责人" prop="deptLeader">
          <el-input v-model="formData.deptLeader" placeholder="请输入负责人" />
        </el-form-item>
        <el-form-item label="联系电话" prop="deptPhone">
          <el-input v-model="formData.deptPhone" placeholder="请输入联系电话" />
        </el-form-item>
        <el-form-item label="邮箱" prop="deptEmail">
          <el-input v-model="formData.deptEmail" placeholder="请输入邮箱" />
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
import { getDeptList, createDept, updateDept, deleteDept } from '@/api/dept'

const tableData = ref<any[]>([])
const dialogVisible = ref(false)
const dialogTitle = ref('新增部门')
const formRef = ref()
const formData = ref({
  id: null as number | null,
  parentId: 0,
  deptName: '',
  deptCode: '',
  deptLeader: '',
  deptPhone: '',
  deptEmail: '',
  sortOrder: 0,
  status: 'active'
})

const parentDeptName = ref('')

const formRules = {
  deptName: [{ required: true, message: '请输入部门名称', trigger: 'blur' }],
  deptCode: [{ required: true, message: '请输入部门编码', trigger: 'blur' }]
}

const loadData = async () => {
  try {
    const userInfo = JSON.parse(localStorage.getItem('user') || '{}')
    const tenantId = userInfo.tenantId || 1
    const res = await getDeptList({ tenantId })
    if (res.success) {
      tableData.value = res.data || []
    } else {
      tableData.value = []
    }
  } catch (error) {
    console.error('加载部门列表失败', error)
    ElMessage.error('加载部门列表失败')
  }
}

const handleStatusChange = async (row: any) => {
  try {
    await updateDept({ id: row.id, status: row.status })
    ElMessage.success('状态更新成功')
  } catch (error) {
    ElMessage.error('状态更新失败')
    loadData()
  }
}

const handleAdd = () => {
  dialogTitle.value = '新增部门'
  formData.value = {
    id: null,
    parentId: 0,
    deptName: '',
    deptCode: '',
    deptLeader: '',
    deptPhone: '',
    deptEmail: '',
    sortOrder: 0,
    status: 'active'
  }
  parentDeptName.value = ''
  dialogVisible.value = true
}

const handleAddChild = (row: any) => {
  dialogTitle.value = '新增子部门'
  formData.value = {
    id: null,
    parentId: row.id,
    deptName: '',
    deptCode: '',
    deptLeader: '',
    deptPhone: '',
    deptEmail: '',
    sortOrder: 0,
    status: 'active'
  }
  parentDeptName.value = row.deptName
  dialogVisible.value = true
}

const handleEdit = (row: any) => {
  dialogTitle.value = '编辑部门'
  formData.value = { ...row, parentId: row.parentId || 0 }
  parentDeptName.value = ''
  dialogVisible.value = true
}

const handleDelete = (row: any) => {
  ElMessageBox.confirm(`确定删除部门"${row.deptName}"吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const res = await deleteDept(row.id)
      if (res.success) {
        ElMessage.success('删除成功')
        loadData()
      } else {
        ElMessage.error(res.message || '删除失败')
      }
    } catch (error) {
      ElMessage.error('删除失败')
    }
  })
}

const handleSubmit = async () => {
  try {
    await formRef.value?.validate()
    const submitData: any = { ...formData.value }
    if (dialogTitle.value === '新增部门' || dialogTitle.value === '新增子部门') {
      const userInfo = JSON.parse(localStorage.getItem('user') || '{}')
      submitData.tenantId = userInfo.tenantId || 1
      await createDept(submitData)
      ElMessage.success('创建成功')
    } else {
      await updateDept(submitData)
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
.dept-list {
  padding: 20px;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
