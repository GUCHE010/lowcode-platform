# Checklist - 系统管理模块增强

## P0 核心功能完善

- [x] UserEntity包含deptId、postId、avatar字段
- [x] UserService支持多条件组合查询（用户名、姓名、手机、部门、岗位、状态）
- [x] UserList.vue显示部门、岗位名称列
- [x] UserList.vue支持部门、岗位下拉选择筛选
- [x] UserList.vue支持用户状态快速切换开关
- [x] UserList.vue支持批量选择和批量启用/禁用

- [x] RoleEntity包含dataScope字段
- [x] RoleService定义数据权限范围枚举（DEFAULT, OWN, DEPT, DEPT_ALL, ALL）
- [x] RoleList.vue显示角色状态标签
- [x] 权限树正确显示半选状态（父节点部分子节点选中）

- [x] MenuEntity包含visible、perms、componentName字段
- [x] 存在IconSelector.vue图标选择器组件
- [x] IconSelector.vue支持Element Plus图标搜索
- [x] MenuList.vue集成图标选择器
- [x] MenuList.vue区分展示目录、菜单、按钮类型

- [x] DeptList.vue正确展示树形结构
- [x] DeptList.vue支持新增子部门功能
- [x] DeptList.vue支持部门状态切换

- [x] PostEntity包含deptId、quota字段
- [x] PostList.vue支持岗位编制人数显示和编辑

## P1 数据字典增强

- [x] DictionaryTypeEntity字典类型实体存在且完整
- [x] DictionaryTypeController提供完整CRUD API
- [x] DictionaryEntity关联dictionaryTypeId字段
- [x] DictionaryTypeList.vue类型管理页面存在且功能完整
- [x] DictionaryList.vue支持按字典类型筛选

## P2 高级功能

- [x] pom.xml包含EasyExcel依赖
- [x] 用户导入API支持Excel文件上传和解析
- [x] 用户导出API支持Excel文件生成和下载
- [x] UserList.vue包含导入、导出按钮
- [x] 导入对话框支持Excel文件选择和预览

- [x] DictionaryCacheService使用ConcurrentHashMap缓存字典
- [x] 字典刷新API可清空并重新加载缓存
- [x] DictionaryList.vue包含刷新缓存按钮
