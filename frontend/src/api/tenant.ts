import request from '@/utils/request'

export const getTenantList = (params?: any) => {
  return request({
    url: '/tenant/list',
    method: 'get',
    params
  })
}

export const getTenantById = (id: number) => {
  return request({
    url: `/tenant/${id}`,
    method: 'get'
  })
}

export const createTenant = (data: any) => {
  return request({
    url: '/tenant',
    method: 'post',
    data
  })
}

export const updateTenant = (data: any) => {
  return request({
    url: '/tenant',
    method: 'put',
    data
  })
}

export const deleteTenant = (id: number) => {
  return request({
    url: `/tenant/${id}`,
    method: 'delete'
  })
}

export const updateTenantStatus = (data: { id: number; status: string }) => {
  return request({
    url: '/tenant/status',
    method: 'put',
    data
  })
}
