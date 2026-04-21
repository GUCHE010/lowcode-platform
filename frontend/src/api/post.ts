import request from '@/utils/request'

export const getPostList = (params: any) => {
  return request({
    url: '/system/post/list',
    method: 'get',
    params: params
  })
}

export const getPostById = (id: number) => {
  return request({
    url: `/system/post/${id}`,
    method: 'get'
  })
}

export const createPost = (data: any) => {
  return request({
    url: '/system/post',
    method: 'post',
    data
  })
}

export const updatePost = (data: any) => {
  return request({
    url: '/system/post',
    method: 'put',
    data
  })
}

export const deletePost = (id: number) => {
  return request({
    url: `/system/post/${id}`,
    method: 'delete'
  })
}
