import request from '@/utils/request'

export const getDictionaryList = (params: any) => {
  return request({
    url: '/system/dictionary/list',
    method: 'get',
    params: params
  })
}

export const getDictionaryByType = (tenantId: number, dictType: string) => {
  return request({
    url: `/system/dictionary/type/${dictType}`,
    method: 'get',
    params: { tenantId: tenantId }
  })
}

export const getDictionaryById = (id: number) => {
  return request({
    url: `/system/dictionary/${id}`,
    method: 'get'
  })
}

export const createDictionary = (data: any) => {
  return request({
    url: '/system/dictionary',
    method: 'post',
    data
  })
}

export const updateDictionary = (data: any) => {
  return request({
    url: '/system/dictionary',
    method: 'put',
    data
  })
}

export const deleteDictionary = (id: number) => {
  return request({
    url: `/system/dictionary/${id}`,
    method: 'delete'
  })
}

export const getDictionaryFromCache = (dictType: string) => {
  return request({
    url: `/system/dictionary/cache/${dictType}`,
    method: 'get'
  })
}

export const getAllDictionaryTypes = () => {
  return request({
    url: '/system/dictionary/types',
    method: 'get'
  })
}

export const refreshDictionaryCache = () => {
  return request({
    url: '/system/dictionary/refreshCache',
    method: 'post'
  })
}