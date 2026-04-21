import request from '@/utils/request'

export const getOperationLogList = (params: any) => {
  return request({
    url: '/system/operationLog/list',
    method: 'get',
    params: params
  })
}

export const getOperationLogByUser = (userId: number) => {
  return request({
    url: `/system/operationLog/user/${userId}`,
    method: 'get'
  })
}