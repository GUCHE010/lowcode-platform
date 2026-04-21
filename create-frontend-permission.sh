#!/bin/bash

# ============================================
# 低代码平台 - 创建前端权限管理代码脚本
# 功能：创建角色管理、菜单管理、动态菜单、权限指令
# 使用：在 Git Bash 中执行 ./create-frontend-permission.sh
# ============================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_separator() {
    echo "=========================================="
}

# 项目路径
PROJECT_PATH="/d/GUCHKAIFAPROJECT/DIDAIMAPINTAI/lowcode-platform"
FRONTEND_PATH="$PROJECT_PATH/frontend"

print_separator
print_info "创建前端权限管理代码脚本"
print_info "项目路径: $FRONTEND_PATH"
print_separator

# 进入前端目录
cd "$FRONTEND_PATH" || {
    print_error "前端目录不存在: $FRONTEND_PATH"
    exit 1
}

# ============================================
# 一、创建 API 文件
# ============================================
print_separator
print_info "=== 创建 API 文件 ==="

# 1. role.ts
print_info "创建 src/api/role.ts..."
mkdir -p src/api
cat > src/api/role.ts << 'EOF'
import axios from 'axios'

const request = axios.create({
  baseURL: 'http://localhost:8080',
  timeout: 10000
})

request.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

export interface Role {
  id?: number
  tenantId: number
  roleCode: string
  roleName: string
  roleDesc?: string
  status: string
  sortOrder?: number
  isSystem?: number
  createdAt?: string
  updatedAt?: string
}

// 获取角色列表
export const getRoleList = (tenantId: number) => {
  return request.get('/api/system/role/list', { params: { tenantId } })
}

// 获取角色详情
export const getRoleById = (id: number) => {
  return request.get(`/api/system/role/${id}`)
}

// 创建角色
export const createRole = (data: Role) => {
  return request.post('/api/system/role', data)
}

// 更新角色
export const updateRole = (data: Role) => {
  return request.put('/api/system/role', data)
}

// 删除角色
export const deleteRole = (id: number) => {
  return request.delete(`/api/system/role/${id}`)
}

// 分配权限
export const assignPermissions = (roleId: number, menuIds: number[]) => {
  return request.post('/api/system/role/permission', { roleId, menuIds })
}

// 获取角色的菜单ID列表
export const getRoleMenuIds = (roleId: number) => {
  return request.get(`/api/system/role/menuIds/${roleId}`)
}
EOF
print_success "role.ts 创建成功"

# 2. menu.ts
print_info "创建 src/api/menu.ts..."
cat > src/api/menu.ts << 'EOF'
import axios from 'axios'

const request = axios.create({
  baseURL: 'http://localhost:8080',
  timeout: 10000
})

request.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

export interface Menu {
  id?: number
  parentId: number
  menuType: string  // menu, button
  menuCode: string
  menuName: string
  path?: string
  component?: string
  icon?: string
  sortOrder?: number
  status: string
  children?: Menu[]
}

// 获取菜单列表
export const getMenuList = () => {
  return request.get('/api/system/menu/list')
}

// 获取菜单树
export const getMenuTree = () => {
  return request.get('/api/system/menu/tree')
}

// 获取菜单详情
export const getMenuById = (id: number) => {
  return request.get(`/api/system/menu/${id}`)
}

// 创建菜单
export const createMenu = (data: Menu) => {
  return request.post('/api/system/menu', data)
}

// 更新菜单
export const updateMenu = (data: Menu) => {
  return request.put('/api/system/menu', data)
}

// 删除菜单
export const deleteMenu = (id: number) => {
  return request.delete(`/api/system/menu/${id}`)
}
EOF
print_success "menu.ts 创建成功"

print_success "✅ API 文件创建完成（2个文件）"

# ============================================
# 二、创建权限指令
# ============================================
print_separator
print_info "=== 创建权限指令 ==="

print_info "创建 src/directive/permission.ts..."
mkdir -p src/directive
cat > src/directive/permission.ts << 'EOF'
import { Directive } from 'vue'

// 获取用户权限列表
const getPermissions = (): string[] => {
  const userStr = localStorage.getItem('user')
  if (userStr) {
    const user = JSON.parse(userStr)
    return user.permissions || []
  }
  return []
}

// 检查是否有权限
export const hasPermission = (permission: string): boolean => {
  const permissions = getPermissions()
  return permissions.includes(permission)
}

// 权限指令 v-permission
export const permissionDirective: Directive = {
  mounted(el: HTMLElement, binding) {
    const { value } = binding
    if (value && !hasPermission(value)) {
      el.parentNode?.removeChild(el)
    }
  }
}
EOF
print_success "permission.ts 创建成功"

# 在 main.ts 中注册权限指令
print_info "在 main.ts 中注册权限指令..."
if grep -q "v-permission" src/main.ts; then
    print_info "权限指令已注册"
else
    # 备份原文件
    cp src/main.ts src/main.ts.bak
    
    # 在 main.ts 中添加权限指令注册
    sed -i 's/import { createApp } from '\''vue'\''/import { createApp } from '\''vue'\''\nimport { permissionDirective } from '\''.\/directive\/permission'\''/' src/main.ts
    sed -i 's/app.mount('\''#app'\'')/app.directive('\''permission'\'', permissionDirective)\napp.mount('\''#app'\'')/' src/main.ts
fi
print_success "权限指令注册完成"

print_success "✅ 权限指令创建完成"

# ============================================
# 三、创建角色管理页面
# ============================================
print_separator
print_info "=== 创建角色管理页面 ==="

print_info "创建 src/views/system/role/RoleList.vue..."
mkdir -p src/views/system/role
cat > src/views/system/role/RoleList.vue << 'EOF'
<template>
  <div class="role-list">
    <div class="header">
      <h2>角色管理</h2>
      <el-button type="primary" @click="handleAdd" v-permission="'system:role:add'">
        <el-icon><Plus /></el-icon>
        新增角色
      </el-button>
    </div>

    <!-- 角色表格 -->
    <el-table :data="roleList" border stripe v-loading="loading">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="roleCode" label="角色编码" width="150" />
      <el-table-column prop="roleName" label="角色名称" width="150" />
      <el-table-column prop="roleDesc" label="角色描述" />
      <el-table-column prop="sortOrder" label="排序" width="80" />
      <el-table-column prop="status" label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="row.status === 'active' ? 'success' : 'danger'">
            {{ row.status === 'active' ? '启用' : '禁用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="280" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link @click="handlePermission(row)" v-permission="'system:role:permission'">
            分配权限
          </el-button>
          <el-button type="primary" link @click="handleEdit(row)" v-permission="'system:role:edit'">
            编辑
          </el-button>
          <el-button type="danger" link @click="handleDelete(row)" v-permission="'system:role:delete'">
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 新增/编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="500px">
      <el-form ref="formRef" :model="formData" :rules="formRules" label-width="100px">
        <el-form-item label="角色编码" prop="roleCode">
          <el-input v-model="formData.roleCode" placeholder="请输入角色编码" />
        </el-form-item>
        <el-form-item label="角色名称" prop="roleName">
          <el-input v-model="formData.roleName" placeholder="请输入角色名称" />
        </el-form-item>
        <el-form-item label="角色描述" prop="roleDesc">
          <el-input v-model="formData.roleDesc" type="textarea" placeholder="请输入角色描述" />
        </el-form-item>
        <el-form-item label="排序" prop="sortOrder">
          <el-input-number v-model="formData.sortOrder" :min="0" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="formData.status">
            <el-radio label="active">启用</el-radio>
            <el-radio label="disabled">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitLoading">确定</el-button>
      </template>
    </el-dialog>

    <!-- 分配权限对话框 -->
    <el-dialog v-model="permissionDialogVisible" title="分配权限" width="400px">
      <el-tree
        ref="treeRef"
        :data="menuTree"
        show-checkbox
        node-key="id"
        :props="{ label: 'menuName', children: 'children' }"
      />
      <template #footer>
        <el-button @click="permissionDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmitPermission" :loading="permissionLoading">
          确定
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import type { FormInstance, FormRules } from 'element-plus'
import type { Role } from '@/api/role'
import { getRoleList, createRole, updateRole, deleteRole, assignPermissions, getRoleMenuIds } from '@/api/role'
import { getMenuTree, type Menu } from '@/api/menu'

const loading = ref(false)
const submitLoading = ref(false)
const permissionLoading = ref(false)
const roleList = ref<Role[]>([])
const menuTree = ref<Menu[]>([])

// 对话框相关
const dialogVisible = ref(false)
const dialogTitle = ref('')
const isAdd = ref(true)
const formRef = ref<FormInstance>()

// 权限分配相关
const permissionDialogVisible = ref(false)
const currentRole = ref<Role | null>(null)
const treeRef = ref()

const formData = ref<Role>({
  tenantId: 1,
  roleCode: '',
  roleName: '',
  roleDesc: '',
  status: 'active',
  sortOrder: 0,
  isSystem: 0
})

const formRules: FormRules = {
  roleCode: [{ required: true, message: '请输入角色编码', trigger: 'blur' }],
  roleName: [{ required: true, message: '请输入角色名称', trigger: 'blur' }]
}

// 加载角色列表
const loadRoleList = async () => {
  loading.value = true
  try {
    const res = await getRoleList(1)
    if (res.data.success) {
      roleList.value = res.data.data
    }
  } catch (error) {
    console.error('加载角色列表失败', error)
    ElMessage.error('加载角色列表失败')
  } finally {
    loading.value = false
  }
}

// 加载菜单树
const loadMenuTree = async () => {
  try {
    const res = await getMenuTree()
    if (res.data.success) {
      menuTree.value = res.data.data
    }
  } catch (error) {
    console.error('加载菜单树失败', error)
  }
}

// 新增
const handleAdd = () => {
  isAdd.value = true
  dialogTitle.value = '新增角色'
  formData.value = {
    tenantId: 1,
    roleCode: '',
    roleName: '',
    roleDesc: '',
    status: 'active',
    sortOrder: 0,
    isSystem: 0
  }
  dialogVisible.value = true
}

// 编辑
const handleEdit = (row: Role) => {
  isAdd.value = false
  dialogTitle.value = '编辑角色'
  formData.value = { ...row }
  dialogVisible.value = true
}

// 删除
const handleDelete = (row: Role) => {
  ElMessageBox.confirm(`确定要删除角色 "${row.roleName}" 吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await deleteRole(row.id!)
      ElMessage.success('删除成功')
      loadRoleList()
    } catch (error) {
      console.error('删除失败', error)
      ElMessage.error('删除失败')
    }
  })
}

// 提交表单
const handleSubmit = async () => {
  if (!formRef.value) return
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    submitLoading.value = true
    try {
      if (isAdd.value) {
        await createRole(formData.value)
        ElMessage.success('创建成功')
      } else {
        await updateRole(formData.value)
        ElMessage.success('更新成功')
      }
      dialogVisible.value = false
      loadRoleList()
    } catch (error) {
      console.error('保存失败', error)
      ElMessage.error('保存失败')
    } finally {
      submitLoading.value = false
    }
  })
}

// 分配权限
const handlePermission = async (row: Role) => {
  currentRole.value = row
  permissionDialogVisible.value = true
  
  // 加载角色已有的菜单ID
  try {
    const res = await getRoleMenuIds(row.id!)
    if (res.data.success) {
      await loadMenuTree()
      setTimeout(() => {
        treeRef.value?.setCheckedKeys(res.data.data)
      }, 100)
    }
  } catch (error) {
    console.error('加载角色权限失败', error)
  }
}

// 提交权限分配
const handleSubmitPermission = async () => {
  if (!currentRole.value) return
  permissionLoading.value = true
  try {
    const checkedKeys = treeRef.value?.getCheckedKeys() || []
    const halfCheckedKeys = treeRef.value?.getHalfCheckedKeys() || []
    const menuIds = [...checkedKeys, ...halfCheckedKeys]
    await assignPermissions(currentRole.value.id!, menuIds)
    ElMessage.success('权限分配成功')
    permissionDialogVisible.value = false
  } catch (error) {
    console.error('权限分配失败', error)
    ElMessage.error('权限分配失败')
  } finally {
    permissionLoading.value = false
  }
}

onMounted(() => {
  loadRoleList()
  loadMenuTree()
})
</script>

<style scoped>
.role-list {
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
</style>
EOF
print_success "RoleList.vue 创建成功"

# ============================================
# 四、创建菜单管理页面
# ============================================
print_separator
print_info "=== 创建菜单管理页面 ==="

print_info "创建 src/views/system/menu/MenuList.vue..."
mkdir -p src/views/system/menu
cat > src/views/system/menu/MenuList.vue << 'EOF'
<template>
  <div class="menu-list">
    <div class="header">
      <h2>菜单管理</h2>
      <el-button type="primary" @click="handleAdd" v-permission="'system:menu:add'">
        <el-icon><Plus /></el-icon>
        新增菜单
      </el-button>
    </div>

    <!-- 菜单树形表格 -->
    <el-table :data="menuTree" row-key="id" border stripe v-loading="loading">
      <el-table-column prop="menuName" label="菜单名称" />
      <el-table-column prop="menuCode" label="权限标识" width="200" />
      <el-table-column prop="menuType" label="类型" width="100">
        <template #default="{ row }">
          <el-tag :type="row.menuType === 'menu' ? 'primary' : 'info'">
            {{ row.menuType === 'menu' ? '菜单' : '按钮' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="path" label="路由路径" width="200" />
      <el-table-column prop="component" label="组件路径" width="200" />
      <el-table-column prop="icon" label="图标" width="100" />
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
          <el-button type="primary" link @click="handleEdit(row)" v-permission="'system:menu:edit'">
            编辑
          </el-button>
          <el-button type="danger" link @click="handleDelete(row)" v-permission="'system:menu:delete'">
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 新增/编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="600px">
      <el-form ref="formRef" :model="formData" :rules="formRules" label-width="100px">
        <el-form-item label="父级菜单" prop="parentId">
          <el-tree-select
            v-model="formData.parentId"
            :data="menuTree"
            :props="{ label: 'menuName', value: 'id', children: 'children' }"
            placeholder="请选择父级菜单"
            clearable
            check-strictly
          />
        </el-form-item>
        <el-form-item label="菜单类型" prop="menuType">
          <el-radio-group v-model="formData.menuType">
            <el-radio value="menu">菜单</el-radio>
            <el-radio value="button">按钮</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="菜单名称" prop="menuName">
          <el-input v-model="formData.menuName" placeholder="请输入菜单名称" />
        </el-form-item>
        <el-form-item label="权限标识" prop="menuCode">
          <el-input v-model="formData.menuCode" placeholder="例如: system:user:add" />
        </el-form-item>
        <el-form-item label="路由路径" prop="path" v-if="formData.menuType === 'menu'">
          <el-input v-model="formData.path" placeholder="例如: /system/user" />
        </el-form-item>
        <el-form-item label="组件路径" prop="component" v-if="formData.menuType === 'menu'">
          <el-input v-model="formData.component" placeholder="例如: system/user/UserList" />
        </el-form-item>
        <el-form-item label="图标" prop="icon" v-if="formData.menuType === 'menu'">
          <el-input v-model="formData.icon" placeholder="请输入图标名称" />
        </el-form-item>
        <el-form-item label="排序" prop="sortOrder">
          <el-input-number v-model="formData.sortOrder" :min="0" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="formData.status">
            <el-radio label="active">启用</el-radio>
            <el-radio label="disabled">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitLoading">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import type { FormInstance, FormRules } from 'element-plus'
import type { Menu } from '@/api/menu'
import { getMenuTree, createMenu, updateMenu, deleteMenu } from '@/api/menu'

const loading = ref(false)
const submitLoading = ref(false)
const menuTree = ref<Menu[]>([])
const flatMenus = ref<Menu[]>([])

// 对话框相关
const dialogVisible = ref(false)
const dialogTitle = ref('')
const isAdd = ref(true)
const formRef = ref<FormInstance>()

const formData = ref<Menu>({
  parentId: 0,
  menuType: 'menu',
  menuCode: '',
  menuName: '',
  path: '',
  component: '',
  icon: '',
  sortOrder: 0,
  status: 'active'
})

const formRules: FormRules = {
  menuName: [{ required: true, message: '请输入菜单名称', trigger: 'blur' }],
  menuCode: [{ required: true, message: '请输入权限标识', trigger: 'blur' }]
}

// 加载菜单树
const loadMenuTree = async () => {
  loading.value = true
  try {
    const res = await getMenuTree()
    if (res.data.success) {
      menuTree.value = res.data.data
      flatMenus.value = flattenTree(res.data.data)
    }
  } catch (error) {
    console.error('加载菜单树失败', error)
    ElMessage.error('加载菜单树失败')
  } finally {
    loading.value = false
  }
}

// 展平树结构
const flattenTree = (nodes: Menu[]): Menu[] => {
  let result: Menu[] = []
  nodes.forEach(node => {
    result.push(node)
    if (node.children && node.children.length) {
      result = result.concat(flattenTree(node.children))
    }
  })
  return result
}

// 新增
const handleAdd = () => {
  isAdd.value = true
  dialogTitle.value = '新增菜单'
  formData.value = {
    parentId: 0,
    menuType: 'menu',
    menuCode: '',
    menuName: '',
    path: '',
    component: '',
    icon: '',
    sortOrder: 0,
    status: 'active'
  }
  dialogVisible.value = true
}

// 编辑
const handleEdit = (row: Menu) => {
  isAdd.value = false
  dialogTitle.value = '编辑菜单'
  formData.value = { ...row }
  dialogVisible.value = true
}

// 删除
const handleDelete = (row: Menu) => {
  ElMessageBox.confirm(`确定要删除菜单 "${row.menuName}" 及其子菜单吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await deleteMenu(row.id!)
      ElMessage.success('删除成功')
      loadMenuTree()
    } catch (error) {
      console.error('删除失败', error)
      ElMessage.error('删除失败')
    }
  })
}

// 提交表单
const handleSubmit = async () => {
  if (!formRef.value) return
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    submitLoading.value = true
    try {
      if (isAdd.value) {
        await createMenu(formData.value)
        ElMessage.success('创建成功')
      } else {
        await updateMenu(formData.value)
        ElMessage.success('更新成功')
      }
      dialogVisible.value = false
      loadMenuTree()
    } catch (error) {
      console.error('保存失败', error)
      ElMessage.error('保存失败')
    } finally {
      submitLoading.value = false
    }
  })
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
</style>
EOF
print_success "MenuList.vue 创建成功"

# ============================================
# 五、修改 MainLayout.vue（动态菜单）
# ============================================
print_separator
print_info "=== 修改 MainLayout.vue（动态菜单）==="

# 备份原文件
cp src/layouts/MainLayout.vue src/layouts/MainLayout.vue.bak

cat > src/layouts/MainLayout.vue << 'EOF'
<template>
  <div class="main-layout">
    <div class="sidebar">
      <div class="logo">
        <span>低代码平台</span>
      </div>
      <el-menu
        :default-active="activeMenu"
        class="sidebar-menu"
        background-color="#304156"
        text-color="#bfcbd9"
        active-text-color="#409eff"
        router
        :collapse="isCollapse"
      >
        <template v-for="menu in userMenus" :key="menu.id">
          <!-- 有子菜单 -->
          <el-sub-menu v-if="menu.children && menu.children.length" :index="menu.path">
            <template #title>
              <el-icon v-if="menu.icon"><component :is="getIconComponent(menu.icon)" /></el-icon>
              <span>{{ menu.menuName }}</span>
            </template>
            <el-menu-item
              v-for="child in menu.children"
              :key="child.id"
              :index="child.path"
            >
              <el-icon v-if="child.icon"><component :is="getIconComponent(child.icon)" /></el-icon>
              <span>{{ child.menuName }}</span>
            </el-menu-item>
          </el-sub-menu>
          <!-- 无子菜单 -->
          <el-menu-item v-else :index="menu.path">
            <el-icon v-if="menu.icon"><component :is="getIconComponent(menu.icon)" /></el-icon>
            <span>{{ menu.menuName }}</span>
          </el-menu-item>
        </template>
      </el-menu>
    </div>
    <div class="content">
      <div class="header">
        <div class="header-left">
          <el-icon @click="toggleCollapse" class="collapse-icon">
            <Fold v-if="!isCollapse" />
            <Expand v-else />
          </el-icon>
        </div>
        <div class="header-right">
          <el-dropdown @command="handleCommand">
            <span class="user-info">
              {{ currentUser }}
              <el-icon><ArrowDown /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>
      <div class="page-content">
        <router-view />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { Fold, Expand, ArrowDown } from '@element-plus/icons-vue'
import * as ElementPlusIcons from '@element-plus/icons-vue'
import type { Menu } from '@/api/menu'

const router = useRouter()
const route = useRoute()
const isCollapse = ref(false)
const currentUser = ref('')
const userMenus = ref<Menu[]>([])

// 当前激活的菜单
const activeMenu = computed(() => route.path)

// 获取图标组件
const getIconComponent = (iconName: string) => {
  return (ElementPlusIcons as any)[iconName] || 'Menu'
}

// 切换侧边栏
const toggleCollapse = () => {
  isCollapse.value = !isCollapse.value
}

// 处理下拉菜单命令
const handleCommand = (command: string) => {
  if (command === 'logout') {
    localStorage.removeItem('token')
    localStorage.removeItem('user')
    router.push('/login')
  }
}

// 从登录信息中获取用户菜单
const initUserMenus = () => {
  const userStr = localStorage.getItem('user')
  if (userStr) {
    const user = JSON.parse(userStr)
    currentUser.value = user.realName || user.username
    userMenus.value = user.menus || []
  }
}

onMounted(() => {
  initUserMenus()
})
</script>

<style scoped>
.main-layout {
  display: flex;
  height: 100vh;
}

.sidebar {
  width: 220px;
  background: #304156;
  transition: width 0.3s;
  overflow-y: auto;
}

.sidebar .logo {
  height: 60px;
  line-height: 60px;
  text-align: center;
  color: white;
  font-size: 18px;
  font-weight: bold;
  border-bottom: 1px solid #4a5a6a;
}

.sidebar-menu {
  border-right: none;
  height: calc(100vh - 60px);
}

.content {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.header {
  height: 60px;
  background: white;
  border-bottom: 1px solid #e0e0e0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
}

.header-left {
  display: flex;
  align-items: center;
}

.collapse-icon {
  font-size: 20px;
  cursor: pointer;
  color: #666;
}

.collapse-icon:hover {
  color: #409eff;
}

.header-right {
  display: flex;
  align-items: center;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 5px;
  cursor: pointer;
  color: #333;
}

.page-content {
  flex: 1;
  padding: 20px;
  background: #f5f5f5;
  overflow-y: auto;
}
</style>
EOF
print_success "MainLayout.vue 修改成功"

# ============================================
# 六、添加路由配置
# ============================================
print_separator
print_info "=== 更新路由配置 ==="

# 备份原文件
cp src/router/index.ts src/router/index.ts.bak

cat > src/router/index.ts << 'EOF'
import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/login/Login.vue'),
    meta: { requiresAuth: false }
  },
  {
    path: '/',
    component: () => import('@/layouts/MainLayout.vue'),
    meta: { requiresAuth: true },
    children: [
      {
        path: 'user',
        name: 'UserList',
        component: () => import('@/views/system/user/UserList.vue'),
        meta: { title: '用户管理', permission: 'system:user' }
      },
      {
        path: 'role',
        name: 'RoleList',
        component: () => import('@/views/system/role/RoleList.vue'),
        meta: { title: '角色管理', permission: 'system:role' }
      },
      {
        path: 'menu',
        name: 'MenuList',
        component: () => import('@/views/system/menu/MenuList.vue'),
        meta: { title: '菜单管理', permission: 'system:menu' }
      },
      {
        path: '',
        redirect: '/user'
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')
  const requiresAuth = to.meta.requiresAuth !== false
  
  if (requiresAuth && !token) {
    next('/login')
  } else if (to.path === '/login' && token) {
    next('/')
  } else {
    next()
  }
})

export default router
EOF
print_success "路由配置更新成功"

# ============================================
# 七、完成
# ============================================
print_separator
print_success "✅ 前端权限管理代码创建完成！"
print_separator
echo ""
print_info "创建的文件清单："
echo ""
echo "【API 文件】2个"
echo "  - src/api/role.ts"
echo "  - src/api/menu.ts"
echo ""
echo "【指令文件】1个"
echo "  - src/directive/permission.ts"
echo ""
echo "【页面文件】2个"
echo "  - src/views/system/role/RoleList.vue"
echo "  - src/views/system/menu/MenuList.vue"
echo ""
echo "【修改的文件】2个"
echo "  - src/layouts/MainLayout.vue（动态菜单）"
echo "  - src/router/index.ts（添加路由）"
echo "  - src/main.ts（注册权限指令）"
echo ""
print_separator
print_info "下一步操作："
echo "  1. 确保后端已启动"
echo "  2. 执行数据库建表 SQL（sys_role, sys_menu, sys_user_role, sys_role_menu）"
echo "  3. 重启前端: npm run dev"
echo "  4. 登录后查看动态菜单"
echo "  5. 测试角色管理和菜单管理功能"
echo ""
print_separator