import request from '@/utils/request'

// 获取菜单列表
export const getMenuList = () => {
  return request({
    url: '/system/menu/list',
    method: 'get'
  })
}

// 获取菜单树
export const getMenuTree = () => {
  return request({
    url: '/system/menu/tree',
    method: 'get'
  })
}

// 获取菜单详情
export const getMenuById = (id: number) => {
  return request({
    url: `/system/menu/${id}`,
    method: 'get'
  })
}

// 创建菜单
export const createMenu = (data: any) => {
  return request({
    url: '/system/menu',
    method: 'post',
    data
  })
}

// 更新菜单
export const updateMenu = (data: any) => {
  return request({
    url: '/system/menu',
    method: 'put',
    data
  })
}

// 删除菜单
export const deleteMenu = (id: number) => {
  return request({
    url: `/system/menu/${id}`,
    method: 'delete'
  })
}
