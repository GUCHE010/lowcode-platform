<template>
  <div class="dict-type-list">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>字典类型管理</span>
          <el-button type="primary" @click="handleAdd">新增类型</el-button>
        </div>
      </template>

      <el-table :data="tableData" stripe border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="typeCode" label="类型编码" width="150" />
        <el-table-column prop="typeName" label="类型名称" width="150" />
        <el-table-column prop="typeDesc" label="描述" />
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
        <el-form-item label="类型编码" prop="typeCode">
          <el-input v-model="formData.typeCode" placeholder="请输入类型编码" />
        </el-form-item>
        <el-form-item label="类型名称" prop="typeName">
          <el-input v-model="formData.typeName" placeholder="请输入类型名称" />
        </el-form-item>
        <el-form-item label="描述" prop="typeDesc">
          <el-input v-model="formData.typeDesc" type="textarea" placeholder="请输入描述" />
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
import { getDictionaryTypeList, createDictionaryType, updateDictionaryType, deleteDictionaryType } from '@/api/dictionaryType'

const tableData = ref<any[]>([])
const dialogVisible = ref(false)
const dialogTitle = ref('新增类型')
const formRef = ref()
const formData = ref({
  id: null as number | null,
  typeCode: '',
  typeName: '',
  typeDesc: '',
  sortOrder: 0,
  status: 'active'
})

const formRules = {
  typeCode: [{ required: true, message: '请输入类型编码', trigger: 'blur' }],
  typeName: [{ required: true, message: '请输入类型名称', trigger: 'blur' }]
}

const loadData = async () => {
  try {
    const userInfo = JSON.parse(localStorage.getItem('user') || '{}')
    const tenantId = userInfo.tenantId || 1
    const res = await getDictionaryTypeList({ tenantId })
    if (res.success) {
      tableData.value = res.data || []
    } else {
      tableData.value = []
    }
  } catch (error) {
    console.error('加载字典类型列表失败', error)
    ElMessage.error('加载字典类型列表失败')
  }
}

const handleAdd = () => {
  dialogTitle.value = '新增类型'
  formData.value = {
    id: null,
    typeCode: '',
    typeName: '',
    typeDesc: '',
    sortOrder: 0,
    status: 'active'
  }
  dialogVisible.value = true
}

const handleEdit = (row: any) => {
  dialogTitle.value = '编辑类型'
  formData.value = { ...row }
  dialogVisible.value = true
}

const handleDelete = (row: any) => {
  ElMessageBox.confirm(`确定删除字典类型"${row.typeName}"吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await deleteDictionaryType(row.id)
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
    if (dialogTitle.value === '新增类型') {
      const userInfo = JSON.parse(localStorage.getItem('user') || '{}')
      submitData.tenantId = userInfo.tenantId || 1
      await createDictionaryType(submitData)
      ElMessage.success('创建成功')
    } else {
      await updateDictionaryType(submitData)
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
.dict-type-list {
  padding: 20px;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
