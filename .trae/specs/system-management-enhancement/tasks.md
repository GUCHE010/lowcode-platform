# Tasks - 系统管理模块增强

## 优先级P0 - 核心功能完善

- [ ] Task 1: 完善用户管理功能
  - [ ] 1.1 修改UserEntity添加deptId、postId、avatar字段
  - [ ] 1.2 修改UserService/UserController支持多条件查询
  - [ ] 1.3 更新前端UserList.vue添加部门、岗位选择器
  - [ ] 1.4 添加用户状态快速切换功能
  - [ ] 1.5 添加批量启用/禁用功能

- [ ] Task 2: 完善角色管理功能
  - [ ] 2.1 修改RoleEntity添加dataScope字段（数据权限范围）
  - [ ] 2.2 修改RoleService添加数据权限范围枚举
  - [ ] 2.3 更新前端RoleList.vue添加角色状态显示
  - [ ] 2.4 优化权限树，支持半选状态显示

- [ ] Task 3: 完善菜单管理功能
  - [ ] 3.1 修改MenuEntity添加visible、perms、componentName字段
  - [ ] 3.2 创建图标选择器组件IconSelector.vue
  - [ ] 3.3 更新MenuList.vue添加图标选择器
  - [ ] 3.4 添加菜单类型区分（目录/菜单/按钮）展示

- [ ] Task 4: 完善部门管理功能
  - [ ] 4.1 修改DeptService添加根据ID查询子部门方法
  - [ ] 4.2 更新DeptList.vue完善树形展示和操作
  - [ ] 4.3 添加部门状态切换功能

- [ ] Task 5: 完善岗位管理功能
  - [ ] 5.1 修改PostEntity添加deptId、quota（编制人数）字段
  - [ ] 5.2 更新PostList.vue添加岗位编制管理

## 优先级P1 - 数据字典增强

- [ ] Task 6: 数据字典分类管理
  - [ ] 6.1 创建DictionaryTypeEntity字典类型实体
  - [ ] 6.2 创建DictionaryTypeRepository/Service/Controller
  - [ ] 6.3 修改DictionaryEntity关联字典类型
  - [ ] 6.4 创建前端字典类型管理页面DictionaryTypeList.vue
  - [ ] 6.5 更新DictionaryList.vue支持按类型筛选

## 优先级P2 - 高级功能

- [ ] Task 7: 用户导入导出功能
  - [ ] 7.1 添加EasyExcel依赖到pom.xml
  - [ ] 7.2 创建用户导入导出Service
  - [ ] 7.3 添加后端导入导出API接口
  - [ ] 7.4 前端添加导入导出按钮和对话框

- [ ] Task 8: 字典缓存功能
  - [ ] 8.1 创建字典缓存Service（使用ConcurrentHashMap）
  - [ ] 8.2 添加字典刷新接口
  - [ ] 8.3 前端添加刷新按钮

## Task Dependencies
- Task 6 依赖于 Task 1-5 完成后的基础架构
- Task 7 可独立进行
- Task 8 可独立进行
