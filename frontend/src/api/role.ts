import request from '@/utils/request'

// 获取角色列表
export const getRoleList = (params?: any) => {
  return request({
    url: '/system/role/list',
    method: 'get',
    params: params || {}
  })
}

// 获取角色详情
export const getRoleById = (id: number) => {
  return request({
    url: `/system/role/${id}`,
    method: 'get'
  })
}

// 创建角色
export const createRole = (data: any) => {
  return request({
    url: '/system/role',
    method: 'post',
    data
  })
}

// 更新角色
export const updateRole = (data: any) => {
  return request({
    url: '/system/role',
    method: 'put',
    data
  })
}

// 删除角色
export const deleteRole = (id: number) => {
  return request({
    url: `/system/role/${id}`,
    method: 'delete'
  })
}

// 分配角色权限（菜单）
export const assignPermissions = (data: { roleId: number; menuIds: number[] }) => {
  return request({
    url: '/system/role/permission',
    method: 'post',
    data
  })
}

// 获取角色的菜单ID列表
export const getRoleMenuIds = (roleId: number) => {
  return request({
    url: `/system/role/menuIds/${roleId}`,
    method: 'get'
  })
}
