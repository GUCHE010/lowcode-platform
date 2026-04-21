#!/bin/bash

# ============================================
# 低代码平台 - 修复菜单路由脚本
# 功能：确保角色管理、菜单管理页面可以正常访问
# 使用：在 Git Bash 中执行 ./fix-menus.sh
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

print_separator() {
    echo "=========================================="
}

# 项目路径
PROJECT_PATH="/d/GUCHKAIFAPROJECT/DIDAIMAPINTAI/lowcode-platform"
FRONTEND_PATH="$PROJECT_PATH/frontend"

print_separator
print_info "修复菜单路由脚本"
print_separator

cd "$FRONTEND_PATH" || {
    echo "前端目录不存在"
    exit 1
}

# ============================================
# 1. 检查并修复路由文件
# ============================================
print_info "检查路由配置..."

# 确保路由文件存在
if [ ! -f "src/router/index.ts" ]; then
    print_info "路由文件不存在，正在创建..."
    mkdir -p src/router
fi

# 重新写入正确的路由配置
cat > src/router/index.ts << 'EOF'
import { createRouter, createWebHistory } from 'vue-router'

// 路由守卫：检查登录状态
const checkAuth = () => {
  const token = localStorage.getItem('token')
  return !!token
}

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
    redirect: '/user',
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
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 全局前置守卫
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
print_success "路由配置已修复"

# ============================================
# 2. 检查角色管理页面是否存在
# ============================================
print_info "检查角色管理页面..."

if [ ! -f "src/views/system/role/RoleList.vue" ]; then
    print_info "角色管理页面不存在，正在创建..."
    mkdir -p src/views/system/role
    
    cat > src/views/system/role/RoleList.vue << 'EOF'
<template>
  <div class="role-list">
    <div class="header">
      <h2>角色管理</h2>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>
        新增角色
      </el-button>
    </div>

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
      <el-table-column label="操作" width="280">
        <template #default="{ row }">
          <el-button type="primary" link @click="handlePermission(row)">分配权限</el-button>
          <el-button type="primary" link @click="handleEdit(row)">编辑</el-button>
          <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
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
        <el-button type="primary" @click="handleSubmitPermission" :loading="permissionLoading">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import type { FormInstance, FormRules } from 'element-plus'
import axios from 'axios'

const request = axios.create({
  baseURL: 'http://localhost:8080'
})

request.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

const loading = ref(false)
const submitLoading = ref(false)
const permissionLoading = ref(false)
const roleList = ref([])
const menuTree = ref([])

const dialogVisible = ref(false)
const dialogTitle = ref('')
const isAdd = ref(true)
const formRef = ref<FormInstance>()
const permissionDialogVisible = ref(false)
const currentRole = ref(null)
const treeRef = ref()

const formData = ref({
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

const loadRoleList = async () => {
  loading.value = true
  try {
    const res = await request.get('/api/system/role/list', { params: { tenantId: 1 } })
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

const loadMenuTree = async () => {
  try {
    const res = await request.get('/api/system/menu/tree')
    if (res.data.success) {
      menuTree.value = res.data.data
    }
  } catch (error) {
    console.error('加载菜单树失败', error)
  }
}

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

const handleEdit = (row) => {
  isAdd.value = false
  dialogTitle.value = '编辑角色'
  formData.value = { ...row }
  dialogVisible.value = true
}

const handleDelete = (row) => {
  ElMessageBox.confirm(`确定要删除角色 "${row.roleName}" 吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await request.delete(`/api/system/role/${row.id}`)
      ElMessage.success('删除成功')
      loadRoleList()
    } catch (error) {
      console.error('删除失败', error)
      ElMessage.error('删除失败')
    }
  })
}

const handleSubmit = async () => {
  if (!formRef.value) return
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    submitLoading.value = true
    try {
      if (isAdd.value) {
        await request.post('/api/system/role', formData.value)
        ElMessage.success('创建成功')
      } else {
        await request.put('/api/system/role', formData.value)
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

const handlePermission = async (row) => {
  currentRole.value = row
  permissionDialogVisible.value = true
  await loadMenuTree()
  try {
    const res = await request.get(`/api/system/role/menuIds/${row.id}`)
    if (res.data.success) {
      setTimeout(() => {
        treeRef.value?.setCheckedKeys(res.data.data)
      }, 100)
    }
  } catch (error) {
    console.error('加载角色权限失败', error)
  }
}

const handleSubmitPermission = async () => {
  if (!currentRole.value) return
  permissionLoading.value = true
  try {
    const checkedKeys = treeRef.value?.getCheckedKeys() || []
    const halfCheckedKeys = treeRef.value?.getHalfCheckedKeys() || []
    const menuIds = [...checkedKeys, ...halfCheckedKeys]
    await request.post('/api/system/role/permission', {
      roleId: currentRole.value.id,
      menuIds
    })
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
    print_success "角色管理页面已创建"
else
    print_success "角色管理页面已存在"
fi

# ============================================
# 3. 检查菜单管理页面是否存在
# ============================================
print_info "检查菜单管理页面..."

if [ ! -f "src/views/system/menu/MenuList.vue" ]; then
    print_info "菜单管理页面不存在，正在创建..."
    mkdir -p src/views/system/menu
    
    cat > src/views/system/menu/MenuList.vue << 'EOF'
<template>
  <div class="menu-list">
    <div class="header">
      <h2>菜单管理</h2>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>
        新增菜单
      </el-button>
    </div>

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
      <el-table-column label="操作" width="200">
        <template #default="{ row }">
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
import axios from 'axios'

const request = axios.create({
  baseURL: 'http://localhost:8080'
})

request.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

const loading = ref(false)
const submitLoading = ref(false)
const menuTree = ref([])

const dialogVisible = ref(false)
const dialogTitle = ref('')
const isAdd = ref(true)
const formRef = ref<FormInstance>()

const formData = ref({
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

const loadMenuTree = async () => {
  loading.value = true
  try {
    const res = await request.get('/api/system/menu/tree')
    if (res.data.success) {
      menuTree.value = res.data.data
    }
  } catch (error) {
    console.error('加载菜单树失败', error)
    ElMessage.error('加载菜单树失败')
  } finally {
    loading.value = false
  }
}

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

const handleEdit = (row) => {
  isAdd.value = false
  dialogTitle.value = '编辑菜单'
  formData.value = { ...row }
  dialogVisible.value = true
}

const handleDelete = (row) => {
  ElMessageBox.confirm(`确定要删除菜单 "${row.menuName}" 及其子菜单吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await request.delete(`/api/system/menu/${row.id}`)
      ElMessage.success('删除成功')
      loadMenuTree()
    } catch (error) {
      console.error('删除失败', error)
      ElMessage.error('删除失败')
    }
  })
}

const handleSubmit = async () => {
  if (!formRef.value) return
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    submitLoading.value = true
    try {
      if (isAdd.value) {
        await request.post('/api/system/menu', formData.value)
        ElMessage.success('创建成功')
      } else {
        await request.put('/api/system/menu', formData.value)
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
    print_success "菜单管理页面已创建"
else
    print_success "菜单管理页面已存在"
fi

# ============================================
# 4. 清除浏览器缓存提示
# ============================================
print_separator
print_success "✅ 修复完成！"
print_separator
echo ""
print_info "请执行以下操作："
echo "  1. 重启前端: npm run dev"
echo "  2. 清除浏览器缓存（Ctrl + Shift + R 强制刷新）"
echo "  3. 重新登录"
echo "  4. 点击角色管理、菜单管理测试"
echo ""
print_info "如果还是不行，请按 F12 打开开发者工具，查看 Console 标签页的错误信息"