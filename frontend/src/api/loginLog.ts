import request from '@/utils/request'

export const getLoginLogList = (params: any) => {
  return request({
    url: '/system/loginLog/list',
    method: 'get',
    params: params
  })
}

export const getLoginLogByUser = (userId: number) => {
  return request({
    url: `/system/loginLog/user/${userId}`,
    method: 'get'
  })
}