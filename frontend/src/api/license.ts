import request from '@/utils/request'

export const getLicenseInfo = () => {
  return request({
    url: '/license/info',
    method: 'get'
  })
}

export const validateLicense = () => {
  return request({
    url: '/license/validate',
    method: 'post'
  })
}

export const installLicense = (data: { licenseKey: string }) => {
  return request({
    url: '/license/install',
    method: 'post',
    data
  })
}
