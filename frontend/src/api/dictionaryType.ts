import request from '@/utils/request'

export const getDictionaryTypeList = (params: any) => {
  return request({
    url: '/system/dictionaryType/list',
    method: 'get',
    params: params
  })
}

export const getDictionaryTypeById = (id: number) => {
  return request({
    url: `/system/dictionaryType/${id}`,
    method: 'get'
  })
}

export const createDictionaryType = (data: any) => {
  return request({
    url: '/system/dictionaryType',
    method: 'post',
    data
  })
}

export const updateDictionaryType = (data: any) => {
  return request({
    url: '/system/dictionaryType',
    method: 'put',
    data
  })
}

export const deleteDictionaryType = (id: number) => {
  return request({
    url: `/system/dictionaryType/${id}`,
    method: 'delete'
  })
}
