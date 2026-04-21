<template>
  <div class="menu-list">
    <div class="header">
      <h2>菜单管理</h2>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>
        新增菜单
      </el-button>
    </div>

    <el-table :data="menuTree" row-key="id" border stripe v-loading="loading" :tree-props="{ children: 'children', hasChildren: 'hasChildren' }">
      <el-table-column prop="menuName" label="菜单名称" width="200" />
      <el-table-column prop="menuType" label="类型" width="120">
        <template #default="{ row }">
          <el-tag v-if="row.menuType === 'directory'" type="warning">目录</el-tag>
          <el-tag v-else-if="row.menuType === 'menu'" type="primary">菜单</el-tag>
          <el-tag v-else type="info">按钮</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="icon" label="图标" width="80">
        <template #default="{ row }">
          <el-icon v-if="row.icon" :size="20">
            <component :is="row.icon" />
          </el-icon>
        </template>
      </el-table-column>
      <el-table-column prop="perms" label="权限标识" width="180" />
      <el-table-column prop="path" label="路由路径" width="180" />
      <el-table-column prop="component" label="组件路径" width="200" />
      <el-table-column prop="sortOrder" label="排序" width="80" />
      <el-table-column prop="visible" label="可见" width="80">
        <template #default="{ row }">
          {{ row.visible === '0' ? '显示' : '隐藏' }}
        </template>
      </el-table-column>
      <el-table-column prop="status" label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="row.status === 'active' ? 'success' : 'danger'">
            {{ row.status === 'active' ? '启用' : '禁用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="200" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link @click="handleAddChild(row)">新增</el-button>
          <el-button type="primary" link @click="handleEdit(row)">编辑</el-button>
          <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="600px">
      <el-form ref="formRef" :model="formData" :rules="formRules" label-width="100px">
        <el-form-item label="父级菜单" prop="parentId">
          <el-tree-select
            v-model="formData.parentId"
            :data="menuTreeForSelect"
            :props="{ label: 'menuName', value: 'id', children: 'children' }"
            placeholder="请选择父级菜单"
            clearable
            check-strictly
          />
        </el-form-item>
        <el-form-item label="菜单类型" prop="menuType">
          <el-radio-group v-model="formData.menuType">
            <el-radio value="directory">目录</el-radio>
            <el-radio value="menu">菜单</el-radio>
            <el-radio value="button">按钮</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="菜单名称" prop="menuName">
          <el-input v-model="formData.menuName" placeholder="请输入菜单名称" />
        </el-form-item>
        <el-form-item label="权限标识" prop="perms">
          <el-input v-model="formData.perms" placeholder="例如: system:user:add" />
        </el-form-item>
        <el-form-item label="路由路径" prop="path" v-if="formData.menuType !== 'button'">
          <el-input v-model="formData.path" placeholder="例如: /system/user" />
        </el-form-item>
        <el-form-item label="组件路径" prop="component" v-if="formData.menuType === 'menu'">
          <el-input v-model="formData.component" placeholder="例如: system/user/UserList" />
        </el-form-item>
        <el-form-item label="图标" prop="icon" v-if="formData.menuType !== 'button'">
          <div class="icon-selector">
            <el-input v-model="formData.icon" placeholder="点击选择图标" readonly @click="openIconSelector">
              <template #append>
                <el-icon v-if="formData.icon" :size="16"><component :is="formData.icon" /></el-icon>
              </template>
            </el-input>
          </div>
        </el-form-item>
        <el-form-item label="排序" prop="sortOrder">
          <el-input-number v-model="formData.sortOrder" :min="0" />
        </el-form-item>
        <el-form-item label="可见" prop="visible" v-if="formData.menuType !== 'button'">
          <el-radio-group v-model="formData.visible">
            <el-radio value="0">显示</el-radio>
            <el-radio value="1">隐藏</el-radio>
          </el-radio-group>
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

    <IconSelector ref="iconSelectorRef" @select="handleIconSelect" />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import { getMenuTree, createMenu, updateMenu, deleteMenu } from '@/api/menu'
import IconSelector from '@/components/IconSelector.vue'

interface Menu {
  id?: number
  parentId?: number
  menuType?: string
  menuCode?: string
  menuName?: string
  path?: string
  component?: string
  icon?: string
  sortOrder?: number
  status?: string
  visible?: string
  perms?: string
  children?: Menu[]
}

const loading = ref(false)
const menuTree = ref<Menu[]>([])
const menuTreeForSelect = ref<Menu[]>([])

const dialogVisible = ref(false)
const dialogTitle = ref('')
const isAdd = ref(true)
const formRef = ref()
const iconSelectorRef = ref()

const formData = ref<Menu>({
  parentId: 0,
  menuType: 'menu',
  perms: '',
  menuName: '',
  path: '',
  component: '',
  icon: '',
  sortOrder: 0,
  status: 'active',
  visible: '0'
})

const formRules = {
  menuName: [{ required: true, message: '请输入菜单名称', trigger: 'blur' }],
  menuType: [{ required: true, message: '请选择菜单类型', trigger: 'change' }]
}

const loadMenuTree = async () => {
  loading.value = true
  try {
    const res = await getMenuTree()
    if (res.success) {
      menuTree.value = res.data || []
      menuTreeForSelect.value = [{ id: 0, menuName: '根目录', children: res.data || [] }]
    }
  } catch (error) {
    console.error('加载菜单树失败', error)
    ElMessage.error('加载菜单树失败')
  } finally {
    loading.value = false
  }
}

const openIconSelector = () => {
  iconSelectorRef.value?.open(formData.value.icon)
}

const handleIconSelect = (icon: string) => {
  formData.value.icon = icon
}

const handleAdd = () => {
  isAdd.value = true
  dialogTitle.value = '新增菜单'
  formData.value = {
    parentId: 0,
    menuType: 'menu',
    perms: '',
    menuName: '',
    path: '',
    component: '',
    icon: '',
    sortOrder: 0,
    status: 'active',
    visible: '0'
  }
  dialogVisible.value = true
}

const handleAddChild = (row: Menu) => {
  isAdd.value = true
  dialogTitle.value = '新增子菜单'
  formData.value = {
    parentId: row.id,
    menuType: 'menu',
    perms: '',
    menuName: '',
    path: '',
    component: '',
    icon: '',
    sortOrder: 0,
    status: 'active',
    visible: '0'
  }
  dialogVisible.value = true
}

const handleEdit = (row: Menu) => {
  isAdd.value = false
  dialogTitle.value = '编辑菜单'
  formData.value = { ...row, parentId: row.parentId || 0 }
  dialogVisible.value = true
}

const handleDelete = (row: Menu) => {
  ElMessageBox.confirm(`确定要删除菜单 "${row.menuName}" 吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await deleteMenu(row.id!)
      ElMessage.success('删除成功')
      loadMenuTree()
    } catch (error) {
      ElMessage.error('删除失败')
    }
  })
}

const handleSubmit = async () => {
  if (!formRef.value) return
  try {
    await formRef.value.validate()
    const submitData: any = { ...formData.value }
    if (isAdd.value) {
      await createMenu(submitData)
      ElMessage.success('创建成功')
    } else {
      await updateMenu(submitData)
      ElMessage.success('更新成功')
    }
    dialogVisible.value = false
    loadMenuTree()
  } catch (error) {
    ElMessage.error('保存失败')
  }
}

onMounted(() => {
  loadMenuTree()
})
</script>

<style scoped>
.menu-list {
  padding: 20px;
  background: #fff;
  border-radius: 8px;
}
.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
.header h2 {
  margin: 0;
}
.icon-selector {
  display: flex;
  align-items: center;
}
</style>
