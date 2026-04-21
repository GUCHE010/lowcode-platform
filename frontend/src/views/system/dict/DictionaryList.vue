<template>
  <div class="dictionary-list">
    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="字典类型">
          <el-select v-model="searchForm.dictType" placeholder="请选择字典类型" clearable style="width: 200px;">
            <el-option v-for="type in dictTypeList" :key="type.id" :label="type.typeName" :value="type.typeCode" />
          </el-select>
        </el-form-item>
        <el-form-item label="字典名称">
          <el-input v-model="searchForm.dictName" placeholder="请输入字典名称" clearable />
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
          <span>字典列表</span>
          <div>
            <el-button type="primary" @click="handleAdd">新增字典</el-button>
            <el-button type="info" @click="handleRefreshCache">刷新缓存</el-button>
          </div>
        </div>
      </template>

      <el-table :data="tableData" stripe border style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="dictType" label="字典类型" width="150" />
        <el-table-column prop="dictName" label="字典名称" width="150" />
        <el-table-column prop="dictCode" label="字典编码" width="150" />
        <el-table-column prop="dictValue" label="字典值" width="150" />
        <el-table-column prop="sortOrder" label="排序" width="80" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 'active' ? 'success' : 'danger'">
              {{ row.status === 'active' ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="remark" label="备注" width="200" show-overflow-tooltip />
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
        <el-form-item label="字典类型" prop="dictType">
          <el-select v-model="formData.dictType" placeholder="请选择字典类型" style="width: 100%;">
            <el-option v-for="type in dictTypeList" :key="type.id" :label="type.typeName" :value="type.typeCode" />
          </el-select>
        </el-form-item>
        <el-form-item label="字典名称" prop="dictName">
          <el-input v-model="formData.dictName" placeholder="请输入字典名称" />
        </el-form-item>
        <el-form-item label="字典编码" prop="dictCode">
          <el-input v-model="formData.dictCode" placeholder="请输入字典编码" />
        </el-form-item>
        <el-form-item label="字典值" prop="dictValue">
          <el-input v-model="formData.dictValue" placeholder="请输入字典值" />
        </el-form-item>
        <el-form-item label="排序" prop="sortOrder">
          <el-input-number v-model="formData.sortOrder" :min="0" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="formData.status">
            <el-radio value="active">启用</el-radio>
            <el-radio value="inactive">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="formData.remark" type="textarea" rows="3" placeholder="请输入备注" />
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
import { getDictionaryList, createDictionary, updateDictionary, deleteDictionary, refreshDictionaryCache } from '@/api/dictionary'
import { getDictionaryTypeList } from '@/api/dictionaryType'

const searchForm = ref({
  dictType: '',
  dictName: ''
})

const tableData = ref<any[]>([])
const dictTypeList = ref<any[]>([])

const dialogVisible = ref(false)
const dialogTitle = ref('新增字典')
const formRef = ref()
const formData = ref({
  id: null as number | null,
  dictType: '',
  dictName: '',
  dictCode: '',
  dictValue: '',
  sortOrder: 0,
  status: 'active',
  remark: ''
})

const formRules = {
  dictType: [{ required: true, message: '请选择字典类型', trigger: 'change' }],
  dictName: [{ required: true, message: '请输入字典名称', trigger: 'blur' }],
  dictCode: [{ required: true, message: '请输入字典编码', trigger: 'blur' }],
  dictValue: [{ required: true, message: '请输入字典值', trigger: 'blur' }]
}

const loadDictTypes = async () => {
  try {
    const userInfo = JSON.parse(localStorage.getItem('user') || '{}')
    const tenantId = userInfo.tenantId || 1
    const res = await getDictionaryTypeList({ tenantId })
    if (res.success) {
      dictTypeList.value = res.data || []
    }
  } catch (error) {
    console.error('加载字典类型列表失败', error)
  }
}

const loadData = async () => {
  try {
    const userInfo = JSON.parse(localStorage.getItem('user') || '{}')
    const tenantId = userInfo.tenantId || 1

    const res = await getDictionaryList({ tenantId: tenantId })
    if (res.success) {
      let data = res.data || []
      if (searchForm.value.dictType) {
        data = data.filter((item: any) => item.dictType === searchForm.value.dictType)
      }
      if (searchForm.value.dictName) {
        data = data.filter((item: any) => item.dictName.includes(searchForm.value.dictName))
      }
      tableData.value = data
    } else {
      tableData.value = []
    }
  } catch (error) {
    console.error('加载字典列表失败', error)
    ElMessage.error('加载字典列表失败')
  }
}

const handleSearch = () => {
  loadData()
}

const handleReset = () => {
  searchForm.value = { dictType: '', dictName: '' }
  loadData()
}

const handleAdd = () => {
  dialogTitle.value = '新增字典'
  formData.value = {
    id: null,
    dictType: '',
    dictName: '',
    dictCode: '',
    dictValue: '',
    sortOrder: 0,
    status: 'active',
    remark: ''
  }
  dialogVisible.value = true
}

const handleEdit = (row: any) => {
  dialogTitle.value = '编辑字典'
  formData.value = { ...row }
  dialogVisible.value = true
}

const handleDelete = (row: any) => {
  ElMessageBox.confirm(`确定删除字典"${row.dictName}"吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await deleteDictionary(row.id)
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
    const submitData = {
      id: formData.value.id,
      dictType: String(formData.value.dictType || ''),
      dictName: String(formData.value.dictName || ''),
      dictCode: String(formData.value.dictCode || ''),
      dictValue: String(formData.value.dictValue || ''),
      sortOrder: Number(formData.value.sortOrder || 0),
      status: String(formData.value.status || 'active'),
      remark: String(formData.value.remark || '')
    }
    if (dialogTitle.value === '新增字典') {
      const userInfo = JSON.parse(localStorage.getItem('user') || '{}')
      submitData.tenantId = userInfo.tenantId || 1
      await createDictionary(submitData)
      ElMessage.success('创建成功')
    } else {
      await updateDictionary(submitData)
      ElMessage.success('更新成功')
    }
    dialogVisible.value = false
    loadData()
  } catch (error) {
    console.error('操作失败', error)
    ElMessage.error('操作失败')
  }
}

const handleRefreshCache = async () => {
  try {
    const res = await refreshDictionaryCache()
    if (res.success) {
      ElMessage.success('缓存刷新成功')
    } else {
      ElMessage.error('缓存刷新失败')
    }
  } catch (error) {
    ElMessage.error('缓存刷新失败')
  }
}

onMounted(() => {
  loadDictTypes()
  loadData()
})
</script>

<style scoped>
.dictionary-list {
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
</style>
