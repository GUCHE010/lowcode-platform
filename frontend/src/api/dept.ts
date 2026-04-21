import request from '@/utils/request'

export const getDeptList = (params: any) => {
  return request({
    url: '/system/dept/list',
    method: 'get',
    params: params
  })
}

export const getDeptTree = (params: any) => {
  return request({
    url: '/system/dept/tree',
    method: 'get',
    params: params
  })
}

export const getDeptById = (id: number) => {
  return request({
    url: `/system/dept/${id}`,
    method: 'get'
  })
}

export const createDept = (data: any) => {
  return request({
    url: '/system/dept',
    method: 'post',
    data
  })
}

export const updateDept = (data: any) => {
  return request({
    url: '/system/dept',
    method: 'put',
    data
  })
}

export const deleteDept = (id: number) => {
  return request({
    url: `/system/dept/${id}`,
    method: 'delete'
  })
}
