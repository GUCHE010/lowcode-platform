import request from '@/utils/request'

export const getUserList = (params: any) => {
  return request({
    url: '/system/user/list',
    method: 'get',
    params: params
  })
}

export const searchUsers = (params: any) => {
  return request({
    url: '/system/user/search',
    method: 'get',
    params: params
  })
}

export const getUserById = (id: number) => {
  return request({
    url: `/system/user/${id}`,
    method: 'get'
  })
}

export const createUser = (data: any) => {
  return request({
    url: '/system/user',
    method: 'post',
    data
  })
}

export const updateUser = (data: any) => {
  return request({
    url: '/system/user',
    method: 'put',
    data
  })
}

export const deleteUser = (id: number) => {
  return request({
    url: `/system/user/${id}`,
    method: 'delete'
  })
}

export const updateUserStatus = (data: { userId: number; status: string }) => {
  return request({
    url: '/system/user/status',
    method: 'put',
    data
  })
}

export const batchUpdateUserStatus = (data: { userIds: number[]; status: string }) => {
  return request({
    url: '/system/user/batchStatus',
    method: 'put',
    data
  })
}

export const getUserRoleIds = (userId: number) => {
  return request({
    url: `/system/user/roleIds/${userId}`,
    method: 'get'
  })
}

export const assignUserRoles = (data: { userId: number; roleIds: number[] }) => {
  return request({
    url: '/system/user/roles',
    method: 'post',
    data
  })
}

export const importUsers = (file: File, tenantId: number) => {
  const formData = new FormData()
  formData.append('file', file)
  formData.append('tenantId', tenantId.toString())
  return request({
    url: '/system/user/import',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

export const exportUsers = (tenantId: number) => {
  return request({
    url: '/system/user/export',
    method: 'get',
    params: { tenantId },
    responseType: 'blob'
  })
}

export const downloadUserTemplate = () => {
  return request({
    url: '/system/user/template',
    method: 'get',
    responseType: 'blob'
  })
}
