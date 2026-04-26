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
      },
      {
        path: 'dept',
        name: 'DeptList',
        component: () => import('@/views/system/dept/DeptList.vue'),
        meta: { title: '部门管理', permission: 'system:dept' }
      },
      {
        path: 'post',
        name: 'PostList',
        component: () => import('@/views/system/post/PostList.vue'),
        meta: { title: '岗位管理', permission: 'system:post' }
      },
      {
        path: 'loginLog',
        name: 'LoginLogList',
        component: () => import('@/views/system/log/LoginLogList.vue'),
        meta: { title: '登录日志', permission: 'system:loginLog' }
      },
      {
        path: 'operationLog',
        name: 'OperationLogList',
        component: () => import('@/views/system/log/OperationLogList.vue'),
        meta: { title: '操作日志', permission: 'system:operationLog' }
      },
      {
        path: 'dictionary',
        name: 'DictionaryList',
        component: () => import('@/views/system/dict/DictionaryList.vue'),
        meta: { title: '数据字典', permission: 'system:dictionary' }
      },
      {
        path: 'dictionaryType',
        name: 'DictionaryTypeList',
        component: () => import('@/views/system/dicttype/DictionaryTypeList.vue'),
        meta: { title: '字典类型', permission: 'system:dictionaryType' }
      },
      {
        path: 'tenant',
        name: 'TenantList',
        component: () => import('@/views/system/tenant/TenantList.vue'),
        meta: { title: '租户管理', permission: 'system:tenant' }
      },
      {
        path: 'license',
        name: 'LicenseList',
        component: () => import('@/views/system/license/LicenseList.vue'),
        meta: { title: '授权许可', permission: 'system:license' }
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
