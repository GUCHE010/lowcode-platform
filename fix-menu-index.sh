#!/bin/bash

# ============================================
# 低代码平台 - 修复菜单 index 属性脚本
# 功能：修复 ElMenuItem 缺少 index 属性的错误
# 使用：在 Git Bash 中执行 ./fix-menu-index.sh
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
print_info "修复菜单 index 属性"
print_separator

cd "$FRONTEND_PATH" || {
    echo "前端目录不存在"
    exit 1
}

# 备份原文件
cp src/layouts/MainLayout.vue src/layouts/MainLayout.vue.bak2

# 修复 MainLayout.vue
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
          <el-sub-menu v-if="menu.children && menu.children.length" :index="menu.path || menu.id.toString()">
            <template #title>
              <el-icon v-if="menu.icon"><component :is="getIconComponent(menu.icon)" /></el-icon>
              <span>{{ menu.menuName }}</span>
            </template>
            <el-menu-item
              v-for="child in menu.children"
              :key="child.id"
              :index="child.path || child.id.toString()"
            >
              <el-icon v-if="child.icon"><component :is="getIconComponent(child.icon)" /></el-icon>
              <span>{{ child.menuName }}</span>
            </el-menu-item>
          </el-sub-menu>
          <!-- 无子菜单 -->
          <el-menu-item v-else :index="menu.path || menu.id.toString()">
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

const router = useRouter()
const route = useRoute()
const isCollapse = ref(false)
const currentUser = ref('')
const userMenus = ref<any[]>([])

// 当前激活的菜单
const activeMenu = computed(() => route.path)

// 获取图标组件
const getIconComponent = (iconName: string) => {
  if (!iconName) return 'Menu'
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
    try {
      const user = JSON.parse(userStr)
      currentUser.value = user.realName || user.username
      userMenus.value = user.menus || []
      console.log('菜单数据:', userMenus.value)
    } catch (e) {
      console.error('解析用户数据失败', e)
    }
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

print_success "MainLayout.vue 已修复"

# ============================================
# 完成
# ============================================
print_separator
print_success "✅ 修复完成！"
print_separator
echo ""
print_info "请执行以下操作："
echo "  1. 重启前端: npm run dev"
echo "  2. 清除浏览器缓存（Ctrl + Shift + R 强制刷新）"
echo "  3. 重新登录"
echo "  4. 检查控制台是否还有错误"
echo ""