<template>
  <div class="post-list">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>岗位管理</span>
          <el-button type="primary" @click="handleAdd">新增岗位</el-button>
        </div>
      </template>

      <el-table :data="tableData" stripe border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="postCode" label="岗位编码" width="150" />
        <el-table-column prop="postName" label="岗位名称" width="150" />
        <el-table-column prop="postRank" label="职级" width="120">
          <template #default="{ row }">
            {{ getPostRankName(row.postRank) }}
          </template>
        </el-table-column>
        <el-table-column prop="deptName" label="所属部门" width="150">
          <template #default="{ row }">
            {{ getDeptName(row.deptId) }}
          </template>
        </el-table-column>
        <el-table-column prop="quota" label="编制人数" width="100" />
        <el-table-column prop="sortOrder" label="排序" width="80" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 'active' ? 'success' : 'danger'">
              {{ row.status === 'active' ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="500px">
      <el-form :model="formData" :rules="formRules" ref="formRef" label-width="100px">
        <el-form-item label="岗位编码" prop="postCode">
          <el-input v-model="formData.postCode" placeholder="请输入岗位编码" />
        </el-form-item>
        <el-form-item label="岗位名称" prop="postName">
          <el-input v-model="formData.postName" placeholder="请输入岗位名称" />
        </el-form-item>
        <el-form-item label="职级" prop="postRank">
          <el-select v-model="formData.postRank" placeholder="请选择职级" clearable style="width: 100%;">
            <el-option label="高层管理" value="high" />
            <el-option label="中层管理" value="middle" />
            <el-option label="基层管理" value="low" />
            <el-option label="普通员工" value="staff" />
          </el-select>
        </el-form-item>
        <el-form-item label="所属部门" prop="deptId">
          <el-select v-model="formData.deptId" placeholder="请选择部门" clearable style="width: 100%;">
            <el-option v-for="dept in deptList" :key="dept.id" :label="dept.deptName" :value="dept.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="编制人数" prop="quota">
          <el-input-number v-model="formData.quota" :min="0" :max="9999" />
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
import { getPostList, createPost, updatePost, deletePost } from '@/api/post'
import { getDeptList } from '@/api/dept'

const tableData = ref<any[]>([])
const dialogVisible = ref(false)
const dialogTitle = ref('新增岗位')
const formRef = ref()
const deptList = ref<any[]>([])
const formData = ref({
  id: null as number | null,
  postCode: '',
  postName: '',
  postRank: '',
  deptId: null as number | null,
  quota: 0,
  sortOrder: 0,
  status: 'active'
})

const postRankOptions = [
  { value: 'high', label: '高层管理' },
  { value: 'middle', label: '中层管理' },
  { value: 'low', label: '基层管理' },
  { value: 'staff', label: '普通员工' }
]

const formRules = {
  postCode: [{ required: true, message: '请输入岗位编码', trigger: 'blur' }],
  postName: [{ required: true, message: '请输入岗位名称', trigger: 'blur' }]
}

const getPostRankName = (postRank: string) => {
  const option = postRankOptions.find(o => o.value === postRank)
  return option ? option.label : postRank
}

const getDeptName = (deptId: number | null) => {
  if (!deptId) return '-'
  const dept = deptList.value.find(d => d.id === deptId)
  return dept ? dept.deptName : '-'
}

const loadDepts = async () => {
  try {
    const userInfo = JSON.parse(localStorage.getItem('user') || '{}')
    const tenantId = userInfo.tenantId || 1
    const res = await getDeptList({ tenantId })
    if (res.success) {
      deptList.value = res.data || []
    }
  } catch (error) {
    console.error('加载部门列表失败', error)
  }
}

const loadData = async () => {
  try {
    const userInfo = JSON.parse(localStorage.getItem('user') || '{}')
    const tenantId = userInfo.tenantId || 1
    const res = await getPostList({ tenantId })
    if (res.success) {
      tableData.value = res.data || []
    } else {
      tableData.value = []
    }
  } catch (error) {
    console.error('加载岗位列表失败', error)
    ElMessage.error('加载岗位列表失败')
  }
}

const handleAdd = () => {
  dialogTitle.value = '新增岗位'
  formData.value = {
    id: null,
    postCode: '',
    postName: '',
    postRank: '',
    deptId: null,
    quota: 0,
    sortOrder: 0,
    status: 'active'
  }
  dialogVisible.value = true
}

const handleEdit = (row: any) => {
  dialogTitle.value = '编辑岗位'
  formData.value = { ...row, deptId: row.deptId || null }
  dialogVisible.value = true
}

const handleDelete = (row: any) => {
  ElMessageBox.confirm(`确定删除岗位"${row.postName}"吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await deletePost(row.id)
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
    const submitData: any = { ...formData.value }
    if (dialogTitle.value === '新增岗位') {
      const userInfo = JSON.parse(localStorage.getItem('user') || '{}')
      submitData.tenantId = userInfo.tenantId || 1
      await createPost(submitData)
      ElMessage.success('创建成功')
    } else {
      await updatePost(submitData)
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
  loadDepts()
  loadData()
})
</script>

<style scoped>
.post-list {
  padding: 20px;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
