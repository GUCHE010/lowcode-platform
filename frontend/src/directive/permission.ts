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
