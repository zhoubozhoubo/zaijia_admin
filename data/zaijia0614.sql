/*
 Navicat MySQL Data Transfer

 Source Server         : localhost
 Source Server Type    : MariaDB
 Source Server Version : 100140
 Source Host           : localhost:3306
 Source Schema         : zaijia

 Target Server Type    : MariaDB
 Target Server Version : 100140
 File Encoding         : 65001

 Date: 14/06/2019 22:57:06
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin_app
-- ----------------------------
DROP TABLE IF EXISTS `admin_app`;
CREATE TABLE `admin_app`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `app_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '应用id',
  `app_secret` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '应用密码',
  `app_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '应用名称',
  `app_status` tinyint(2) NOT NULL DEFAULT 1 COMMENT '应用状态：0表示禁用，1表示启用',
  `app_info` tinytext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '应用说明',
  `app_api` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '当前应用允许请求的全部API接口',
  `app_group` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'default' COMMENT '当前应用所属的应用组唯一标识',
  `app_addTime` int(11) NOT NULL DEFAULT 0 COMMENT '应用创建时间',
  `app_api_show` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '前台样式显示所需数据格式',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `app_id`(`app_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'appId和appSecret表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for admin_app_group
-- ----------------------------
DROP TABLE IF EXISTS `admin_app_group`;
CREATE TABLE `admin_app_group`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '组名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '组说明',
  `status` tinyint(2) NOT NULL DEFAULT 1 COMMENT '组状态',
  `hash` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '组标识',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '应用组，目前只做管理使用，没有实际权限控制' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for admin_auth_group
-- ----------------------------
DROP TABLE IF EXISTS `admin_auth_group`;
CREATE TABLE `admin_auth_group`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '组名称',
  `description` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '组描述',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '组状态：为1正常，为0禁用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '权限组' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for admin_auth_group_access
-- ----------------------------
DROP TABLE IF EXISTS `admin_auth_group_access`;
CREATE TABLE `admin_auth_group_access`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` mediumint(8) UNSIGNED NOT NULL,
  `groupId` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  INDEX `groupId`(`groupId`(191)) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户和组的对应关系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for admin_auth_rule
-- ----------------------------
DROP TABLE IF EXISTS `admin_auth_rule`;
CREATE TABLE `admin_auth_rule`  (
  `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT,
  `url` char(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '规则唯一标识',
  `groupId` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '权限所属组的ID',
  `auth` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '权限数值',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态：为1正常，为0禁用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '权限细节' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for admin_fields
-- ----------------------------
DROP TABLE IF EXISTS `admin_fields`;
CREATE TABLE `admin_fields`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `fieldName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字段名称',
  `hash` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '对应接口的唯一标识',
  `dataType` tinyint(2) NOT NULL DEFAULT 0 COMMENT '数据类型，来源于DataType类库',
  `default` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '默认值',
  `isMust` tinyint(2) NOT NULL DEFAULT 0 COMMENT '是否必须 0为不必须，1为必须',
  `range` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '范围，Json字符串，根据数据类型有不一样的含义',
  `info` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字段说明',
  `type` tinyint(2) NOT NULL DEFAULT 0 COMMENT '字段用处：0为request，1为response',
  `showName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'wiki显示用字段',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `hash`(`hash`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用于保存各个API的字段规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for admin_group
-- ----------------------------
DROP TABLE IF EXISTS `admin_group`;
CREATE TABLE `admin_group`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '组名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '组说明',
  `status` tinyint(2) NOT NULL DEFAULT 1 COMMENT '组状态',
  `hash` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '组唯一标识',
  `addTime` int(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  `updateTime` int(11) NOT NULL DEFAULT 0 COMMENT '修改时间',
  `image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分组封面图',
  `hot` int(11) NOT NULL DEFAULT 0 COMMENT '分组热度',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '接口组管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin_group
-- ----------------------------
INSERT INTO `admin_group` VALUES (1, '默认分组', '默认分组', 1, 'default', 0, 0, '', 0);

-- ----------------------------
-- Table structure for admin_list
-- ----------------------------
DROP TABLE IF EXISTS `admin_list`;
CREATE TABLE `admin_list`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `apiClass` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'api索引，保存了类和方法',
  `hash` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'api唯一标识',
  `accessToken` tinyint(2) NOT NULL DEFAULT 1 COMMENT '是否需要认证AccessToken 1：需要，0：不需要',
  `needLogin` tinyint(2) NOT NULL DEFAULT 1 COMMENT '是否需要认证用户token  1：需要 0：不需要',
  `status` tinyint(2) NOT NULL DEFAULT 1 COMMENT 'API状态：0表示禁用，1表示启用',
  `method` tinyint(2) NOT NULL DEFAULT 2 COMMENT '请求方式0：不限1：Post，2：Get',
  `info` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'api中文说明',
  `isTest` tinyint(2) NOT NULL DEFAULT 0 COMMENT '是否是测试模式：0:生产模式，1：测试模式',
  `returnStr` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '返回数据示例',
  `groupHash` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'default' COMMENT '当前接口所属的接口分组',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `hash`(`hash`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用于维护接口信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin_list
-- ----------------------------
INSERT INTO `admin_list` VALUES (1, 'Index/areaList', '5d0253080db26', 0, 0, 1, 0, '地区列表', 1, NULL, 'default');
INSERT INTO `admin_list` VALUES (2, 'Index/bannerList', '5d0286898878a', 0, 0, 1, 0, '轮播图列表', 1, NULL, 'default');
INSERT INTO `admin_list` VALUES (3, 'Index/linkList', '5d0286b4ea311', 0, 0, 1, 0, '链接列表', 1, NULL, 'default');
INSERT INTO `admin_list` VALUES (4, 'Task/taskList', '5d0286cb35cb3', 0, 0, 1, 0, '任务列表', 1, NULL, 'default');
INSERT INTO `admin_list` VALUES (5, 'Task/taskDetails', '5d0286f251c4d', 0, 0, 1, 0, '任务详情', 1, NULL, 'default');
INSERT INTO `admin_list` VALUES (6, 'User/sendCode', '5d02871310048', 0, 0, 1, 0, '发送验证码', 1, NULL, 'default');
INSERT INTO `admin_list` VALUES (7, 'User/register', '5d02872f6e368', 0, 0, 1, 0, '用户注册', 1, NULL, 'default');
INSERT INTO `admin_list` VALUES (8, 'User/login', '5d0287415a574', 0, 0, 1, 0, '用户登录', 1, NULL, 'default');
INSERT INTO `admin_list` VALUES (9, 'User/info', '5d028757a9784', 0, 0, 1, 0, '用户个人信息', 1, NULL, 'default');
INSERT INTO `admin_list` VALUES (10, 'UserIncome/myIncomeList', '5d02876d5d982', 0, 0, 1, 0, '用户收入列表', 1, NULL, 'default');
INSERT INTO `admin_list` VALUES (11, 'User/myTeamList', '5d02879991352', 0, 0, 1, 0, '用户团队列表', 1, NULL, 'default');
INSERT INTO `admin_list` VALUES (12, 'UserIncome/teamIncomeList', '5d0287d22f573', 0, 0, 1, 0, '用户团队收入列表', 1, NULL, 'default');
INSERT INTO `admin_list` VALUES (13, 'WithDraw/withdrawList', '5d0287e451a4c', 0, 0, 1, 0, '用户提现列表', 1, NULL, 'default');
INSERT INTO `admin_list` VALUES (14, 'UserTask/taskList', '5d0287facb879', 0, 0, 1, 0, '用户任务列表', 1, NULL, 'default');
INSERT INTO `admin_list` VALUES (15, 'UserTask/addTask', '5d0288178f14a', 0, 0, 1, 0, '用户添加任务', 1, NULL, 'default');
INSERT INTO `admin_list` VALUES (16, 'UserTask/submitTask', '5d02882d0a05a', 0, 0, 1, 0, '用户提交任务', 1, NULL, 'default');
INSERT INTO `admin_list` VALUES (17, 'UserTask/delTask', '5d0288414ff33', 0, 0, 1, 0, '用户放弃任务', 1, NULL, 'default');
INSERT INTO `admin_list` VALUES (18, 'UserNotice/noticeList', '5d02b2c1a7b23', 0, 0, 1, 0, '用户消息列表', 1, NULL, 'default');
INSERT INTO `admin_list` VALUES (19, 'UserTask/taskDetails', '5d0379759b283', 0, 0, 1, 0, '用户任务详情', 1, NULL, 'default');

-- ----------------------------
-- Table structure for admin_menu
-- ----------------------------
DROP TABLE IF EXISTS `admin_menu`;
CREATE TABLE `admin_menu`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '菜单名',
  `fid` int(11) NOT NULL COMMENT '父级菜单ID',
  `url` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '链接',
  `auth` tinyint(2) NOT NULL DEFAULT 0 COMMENT '访客权限',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `hide` tinyint(2) NOT NULL DEFAULT 0 COMMENT '是否显示',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '菜单图标',
  `level` tinyint(2) NOT NULL DEFAULT 0 COMMENT '菜单认证等级',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '目录信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin_menu
-- ----------------------------
INSERT INTO `admin_menu` VALUES (1, '用户登录', 0, 'admin/Login/index', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (2, '用户登出', 0, 'admin/Login/logout', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (3, '系统管理', 0, '', 0, 1, 0, '', 0);
INSERT INTO `admin_menu` VALUES (4, '菜单维护', 3, '', 0, 1, 0, '', 0);
INSERT INTO `admin_menu` VALUES (5, '菜单状态修改', 4, 'admin/Menu/changeStatus', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (6, '新增菜单', 4, 'admin/Menu/add', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (7, '编辑菜单', 4, 'admin/Menu/edit', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (8, '菜单删除', 4, 'admin/Menu/del', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (9, '用户管理', 3, '', 0, 2, 0, '', 0);
INSERT INTO `admin_menu` VALUES (10, '获取当前组的全部用户', 9, 'admin/User/getUsers', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (11, '用户状态修改', 9, 'admin/User/changeStatus', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (12, '新增用户', 9, 'admin/User/add', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (13, '用户编辑', 9, 'admin/User/edit', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (14, '用户删除', 9, 'admin/User/del', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (15, '权限管理', 3, '', 0, 3, 0, '', 0);
INSERT INTO `admin_menu` VALUES (16, '权限组状态编辑', 15, 'admin/Auth/changeStatus', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (17, '从指定组中删除指定用户', 15, 'admin/Auth/delMember', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (18, '新增权限组', 15, 'admin/Auth/add', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (19, '权限组编辑', 15, 'admin/Auth/edit', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (20, '删除权限组', 15, 'admin/Auth/del', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (21, '获取全部已开放的可选组', 15, 'admin/Auth/getGroups', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (22, '获取组所有的权限列表', 15, 'admin/Auth/getRuleList', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (23, '应用接入', 0, '', 0, 2, 0, '', 0);
INSERT INTO `admin_menu` VALUES (24, '应用管理', 23, '', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (25, '应用状态编辑', 24, 'admin/App/changeStatus', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (26, '获取AppId,AppSecret,接口列表,应用接口权限细节', 24, 'admin/App/getAppInfo', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (27, '新增应用', 24, 'admin/App/add', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (28, '编辑应用', 24, 'admin/App/edit', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (29, '删除应用', 24, 'admin/App/del', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (30, '接口管理', 0, '', 0, 3, 0, '', 0);
INSERT INTO `admin_menu` VALUES (31, '接口维护', 30, '', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (32, '接口状态编辑', 31, 'admin/InterfaceList/changeStatus', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (33, '获取接口唯一标识', 31, 'admin/InterfaceList/getHash', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (34, '添加接口', 31, 'admin/InterfaceList/add', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (35, '编辑接口', 31, 'admin/InterfaceList/edit', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (36, '删除接口', 31, 'admin/InterfaceList/del', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (37, '获取接口请求字段', 31, 'admin/Fields/request', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (38, '获取接口返回字段', 31, 'admin/Fields/response', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (39, '添加接口字段', 31, 'admin/Fields/add', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (40, '上传接口返回字段', 31, 'admin/Fields/upload', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (41, '编辑接口字段', 31, 'admin/Fields/edit', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (42, '删除接口字段', 31, 'admin/Fields/del', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (43, '接口分组', 30, '', 0, 1, 0, '', 0);
INSERT INTO `admin_menu` VALUES (44, '添加接口组', 43, 'admin/InterfaceGroup/add', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (45, '编辑接口组', 43, 'admin/InterfaceGroup/edit', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (46, '删除接口组', 43, 'admin/InterfaceGroup/del', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (47, '获取全部有效的接口组', 43, 'admin/InterfaceGroup/getAll', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (48, '接口组状态维护', 43, 'admin/InterfaceGroup/changeStatus', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (49, '应用分组', 23, '', 0, 1, 0, '', 0);
INSERT INTO `admin_menu` VALUES (50, '添加应用组', 49, 'admin/AppGroup/add', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (51, '编辑应用组', 49, 'admin/AppGroup/edit', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (52, '删除应用组', 49, 'admin/AppGroup/del', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (53, '获取全部可用应用组', 49, 'admin/AppGroup/getAll', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (54, '应用组状态编辑', 49, 'admin/AppGroup/changeStatus', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (55, '菜单列表', 4, 'admin/Menu/index', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (56, '用户列表', 9, 'admin/User/index', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (57, '权限列表', 15, 'admin/Auth/index', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (58, '应用列表', 24, 'admin/App/index', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (59, '应用分组列表', 49, 'admin/AppGroup/index', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (60, '接口列表', 31, 'admin/InterfaceList/index', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (61, '接口分组列表', 43, 'admin/InterfaceGroup/index', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (62, '日志管理', 3, '', 0, 4, 0, '', 0);
INSERT INTO `admin_menu` VALUES (63, '获取操作日志列表', 62, 'admin/Log/index', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (64, '删除单条日志记录', 62, 'admin/Log/del', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (65, '刷新路由', 31, 'admin/InterfaceList/refresh', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (67, '文件上传', 0, 'admin/Index/upload', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (68, '更新个人信息', 9, 'admin/User/own', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (69, '刷新AppSecret', 24, 'admin/App/refreshAppSecret', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (70, '首页管理', 0, '', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (71, '轮播图列表', 70, 'admin/Banner/getList', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (72, '添加/编辑轮播图', 71, 'admin/Banner/save', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (73, '改变轮播图状态', 71, 'admin/Banner/change', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (74, '链接列表', 70, 'admin/Link/getList', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (75, '添加/编辑链接', 74, 'admin/Link/save', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (76, '改变链接状态', 74, 'admin/Link/change', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (77, '用户管理', 0, '', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (78, '用户列表', 77, 'admin/UserCon/getList', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (79, '用户收入列表', 77, 'admin/UserIncome/getList', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (80, '用户消息列表', 77, 'admin/UserNotice/getList', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (81, '添加/编辑用户消息列表', 80, 'admin/UserNotice/save', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (82, '用户任务列表', 77, 'admin/UserTask/getList', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (83, '提现管理', 0, '', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (84, '提现列表', 83, 'admin/Withdraw/getList', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (85, '提现方式列表', 83, 'admin/WithdrawWay/getList', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (86, '添加/编辑提现方式', 85, 'admin/WithdrawWay/save', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (87, '改变提现状态', 85, 'admin/WithdrawWay/change', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (88, '佣金管理', 0, '', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (89, '佣金列表', 88, 'admin/Commission/getList', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (90, '佣金配置', 88, 'admin/CommissionConf/getList', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (91, '添加/编辑佣金配置', 90, 'admin/CommissionConf/save', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (92, '任务管理', 0, '', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (93, '任务列表', 92, 'admin/Task/getList', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (94, '添加/编辑任务', 93, 'admin/Task/save', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (95, '改变任务状态', 93, 'admin/Task/change', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (96, '删除任务', 93, 'admin/Task/delete', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (97, '任务类型列表', 92, 'admin/TaskType/getList', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (98, '添加/编辑任务类型', 97, 'admin/TaskType/save', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (99, '改变任务类型状态', 97, 'admin/TaskType/change', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (100, '删除任务类型', 97, 'admin/TaskType/delete', 0, 0, 0, '', 0);
INSERT INTO `admin_menu` VALUES (101, '地区列表', 0, 'admin/AreaCon/getList', 0, 0, 0, '', 0);

-- ----------------------------
-- Table structure for admin_user
-- ----------------------------
DROP TABLE IF EXISTS `admin_user`;
CREATE TABLE `admin_user`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户名',
  `nickname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户昵称',
  `password` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户密码',
  `regTime` int(10) NOT NULL DEFAULT 0 COMMENT '注册时间',
  `regIp` bigint(11) NOT NULL COMMENT '注册IP',
  `updateTime` int(10) NOT NULL DEFAULT 0 COMMENT '更新时间',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '账号状态 0封号 1正常',
  `openId` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '三方登录唯一ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `regTime`(`regTime`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员认证信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin_user
-- ----------------------------
INSERT INTO `admin_user` VALUES (1, 'root', 'root', '912601e4ad1b308c9ae41877cf6ca754', 1519453594, 3663623043, 1524152828, 1, NULL);

-- ----------------------------
-- Table structure for admin_user_action
-- ----------------------------
DROP TABLE IF EXISTS `admin_user_action`;
CREATE TABLE `admin_user_action`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `actionName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '行为名称',
  `uid` int(11) NOT NULL DEFAULT 0 COMMENT '操作用户ID',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户昵称',
  `addTime` int(11) NOT NULL DEFAULT 0 COMMENT '操作时间',
  `data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '用户提交的数据',
  `url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作URL',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 323 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户操作日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin_user_action
-- ----------------------------
INSERT INTO `admin_user_action` VALUES (1, '获取操作日志列表', 1, 'root', 1559924636, '{\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\"}', 'admin/Log/index');
INSERT INTO `admin_user_action` VALUES (2, '权限列表', 1, 'root', 1559924645, '{\"page\":\"1\",\"size\":\"10\",\"keywords\":\"\",\"status\":\"\"}', 'admin/Auth/index');
INSERT INTO `admin_user_action` VALUES (3, '接口分组列表', 1, 'root', 1559924650, '{\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceGroup/index');
INSERT INTO `admin_user_action` VALUES (4, '获取操作日志列表', 1, 'root', 1559924654, '{\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\"}', 'admin/Log/index');
INSERT INTO `admin_user_action` VALUES (5, '权限列表', 1, 'root', 1559924655, '{\"page\":\"1\",\"size\":\"10\",\"keywords\":\"\",\"status\":\"\"}', 'admin/Auth/index');
INSERT INTO `admin_user_action` VALUES (6, '接口列表', 1, 'root', 1559924658, '{\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (7, '菜单列表', 1, 'root', 1560430866, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (8, '新增菜单', 1, 'root', 1560431007, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u9996\\u9875\\u7ba1\\u7406\",\"fid\":0,\"url\":\"\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (9, '菜单列表', 1, 'root', 1560431007, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (10, '新增菜单', 1, 'root', 1560431047, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u8f6e\\u64ad\\u56fe\\u5217\\u8868\",\"fid\":70,\"url\":\"Banner\\/getList\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (11, '菜单列表', 1, 'root', 1560431048, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (12, '新增菜单', 1, 'root', 1560431073, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u6dfb\\u52a0\\/\\u7f16\\u8f91\\u8f6e\\u64ad\\u56fe\",\"fid\":71,\"url\":\"Banner\\/save\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (13, '菜单列表', 1, 'root', 1560431074, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (14, '新增菜单', 1, 'root', 1560431092, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u6539\\u53d8\\u8f6e\\u64ad\\u56fe\\u72b6\\u6001\",\"fid\":71,\"url\":\"Banner\\/change\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (15, '菜单列表', 1, 'root', 1560431092, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (16, '新增菜单', 1, 'root', 1560431120, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u94fe\\u63a5\\u5217\\u8868\",\"fid\":70,\"url\":\"Link\\/getList\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (17, '菜单列表', 1, 'root', 1560431120, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (18, '新增菜单', 1, 'root', 1560431146, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u6dfb\\u52a0\\/\\u7f16\\u8f91\\u94fe\\u63a5\",\"fid\":74,\"url\":\"Link\\/getList\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (19, '菜单列表', 1, 'root', 1560431146, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (20, '新增菜单', 1, 'root', 1560431164, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u6539\\u53d8\\u94fe\\u63a5\\u72b6\\u6001\",\"fid\":74,\"url\":\"Link\\/change\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (21, '菜单列表', 1, 'root', 1560431164, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (22, '新增菜单', 1, 'root', 1560431188, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u7528\\u6237\\u7ba1\\u7406\",\"fid\":0,\"url\":\"\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (23, '菜单列表', 1, 'root', 1560431188, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (24, '新增菜单', 1, 'root', 1560431238, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u7528\\u6237\\u5217\\u8868\",\"fid\":77,\"url\":\"UserCon\\/getList\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (25, '菜单列表', 1, 'root', 1560431238, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (26, '新增菜单', 1, 'root', 1560431278, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u7528\\u6237\\u6536\\u5165\\u5217\\u8868\",\"fid\":77,\"url\":\"UserIncome\\/getList\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (27, '菜单列表', 1, 'root', 1560431278, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (28, '新增菜单', 1, 'root', 1560431306, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u7528\\u6237\\u6d88\\u606f\\u5217\\u8868\",\"fid\":77,\"url\":\"UserNotice\\/getList\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (29, '菜单列表', 1, 'root', 1560431307, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (30, '新增菜单', 1, 'root', 1560431336, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u6dfb\\u52a0\\/\\u7f16\\u8f91\\u7528\\u6237\\u6d88\\u606f\\u5217\\u8868\",\"fid\":80,\"url\":\"UserNotice\\/save\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (31, '菜单列表', 1, 'root', 1560431336, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (32, '新增菜单', 1, 'root', 1560431355, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u7528\\u6237\\u4efb\\u52a1\\u5217\\u8868\",\"fid\":77,\"url\":\"UserTask\\/getList\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (33, '菜单列表', 1, 'root', 1560431355, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (34, '新增菜单', 1, 'root', 1560431376, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u63d0\\u73b0\\u7ba1\\u7406\",\"fid\":0,\"url\":\"\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (35, '菜单列表', 1, 'root', 1560431376, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (36, '新增菜单', 1, 'root', 1560431392, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u63d0\\u73b0\\u5217\\u8868\",\"fid\":83,\"url\":\"Withdraw\\/getList\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (37, '菜单列表', 1, 'root', 1560431392, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (38, '新增菜单', 1, 'root', 1560431429, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u63d0\\u73b0\\u65b9\\u5f0f\\u5217\\u8868\",\"fid\":83,\"url\":\"WithdrawWay\\/getList\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (39, '菜单列表', 1, 'root', 1560431429, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (40, '新增菜单', 1, 'root', 1560431450, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u6dfb\\u52a0\\/\\u7f16\\u8f91\\u63d0\\u73b0\\u65b9\\u5f0f\",\"fid\":85,\"url\":\"WithdrawWay\\/save\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (41, '菜单列表', 1, 'root', 1560431450, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (42, '新增菜单', 1, 'root', 1560431469, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u6539\\u53d8\\u63d0\\u73b0\\u72b6\\u6001\",\"fid\":85,\"url\":\"WithdrawWay\\/change\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (43, '菜单列表', 1, 'root', 1560431470, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (44, '新增菜单', 1, 'root', 1560431502, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u4f63\\u91d1\\u7ba1\\u7406\",\"fid\":0,\"url\":\"\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (45, '菜单列表', 1, 'root', 1560431502, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (46, '新增菜单', 1, 'root', 1560431526, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u4f63\\u91d1\\u5217\\u8868\",\"fid\":88,\"url\":\"Commission\\/getList\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (47, '菜单列表', 1, 'root', 1560431527, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (48, '新增菜单', 1, 'root', 1560431544, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u4f63\\u91d1\\u914d\\u7f6e\",\"fid\":0,\"url\":\"CommissionConf\\/getList\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (49, '菜单列表', 1, 'root', 1560431544, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (50, '编辑菜单', 1, 'root', 1560431557, '{\"\\/admin\\/Menu\\/edit\":\"\",\"name\":\"\\u4f63\\u91d1\\u914d\\u7f6e\",\"fid\":88,\"url\":\"CommissionConf\\/getList\",\"sort\":0,\"id\":90}', 'admin/Menu/edit');
INSERT INTO `admin_user_action` VALUES (51, '菜单列表', 1, 'root', 1560431558, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (52, '新增菜单', 1, 'root', 1560431581, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u6dfb\\u52a0\\/\\u7f16\\u8f91\\u4f63\\u91d1\\u914d\\u7f6e\",\"fid\":90,\"url\":\"CommissionConf\\/save\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (53, '菜单列表', 1, 'root', 1560431581, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (54, '新增菜单', 1, 'root', 1560431615, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u4efb\\u52a1\\u7ba1\\u7406\",\"fid\":0,\"url\":\"\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (55, '菜单列表', 1, 'root', 1560431615, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (56, '新增菜单', 1, 'root', 1560431633, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u4efb\\u52a1\\u5217\\u8868\",\"fid\":92,\"url\":\"Task\\/getList\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (57, '菜单列表', 1, 'root', 1560431634, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (58, '新增菜单', 1, 'root', 1560431663, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u6dfb\\u52a0\\/\\u7f16\\u8f91\\u4efb\\u52a1\",\"fid\":93,\"url\":\"Task\\/save\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (59, '菜单列表', 1, 'root', 1560431664, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (60, '新增菜单', 1, 'root', 1560431678, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u6539\\u53d8\\u4efb\\u52a1\\u72b6\\u6001\",\"fid\":93,\"url\":\"Task\\/change\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (61, '菜单列表', 1, 'root', 1560431678, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (62, '新增菜单', 1, 'root', 1560431688, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u5220\\u9664\\u4efb\\u52a1\",\"fid\":93,\"url\":\"Task\\/delete\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (63, '菜单列表', 1, 'root', 1560431688, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (64, '新增菜单', 1, 'root', 1560431706, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u4efb\\u52a1\\u7c7b\\u578b\\u5217\\u8868\",\"fid\":92,\"url\":\"TaskType\\/getList\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (65, '菜单列表', 1, 'root', 1560431706, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (66, '新增菜单', 1, 'root', 1560431732, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u6dfb\\u52a0\\/\\u7f16\\u8f91\\u4efb\\u52a1\\u7c7b\\u578b\",\"fid\":97,\"url\":\"TaskType\\/save\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (67, '菜单列表', 1, 'root', 1560431732, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (68, '新增菜单', 1, 'root', 1560431754, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u6539\\u53d8\\u4efb\\u52a1\\u7c7b\\u578b\\u72b6\\u6001\",\"fid\":97,\"url\":\"TaskType\\/change\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (69, '菜单列表', 1, 'root', 1560431754, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (70, '新增菜单', 1, 'root', 1560431776, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u5220\\u9664\\u4efb\\u52a1\\u7c7b\\u578b\",\"fid\":97,\"url\":\"TaskType\\/delete\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (71, '菜单列表', 1, 'root', 1560431776, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (72, '菜单列表', 1, 'root', 1560431824, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (73, '用户登出', 1, 'root', 1560431826, '{\"\\/admin\\/Login\\/logout\":\"\"}', 'admin/Login/logout');
INSERT INTO `admin_user_action` VALUES (74, '轮播图列表', 1, 'root', 1560431836, '{\"\\/admin\\/Banner\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"status\\\":\\\"\\\"}\"}', 'admin/Banner/getList');
INSERT INTO `admin_user_action` VALUES (75, '链接列表', 1, 'root', 1560431839, '{\"\\/admin\\/Link\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"status\\\":\\\"\\\"}\"}', 'admin/Link/getList');
INSERT INTO `admin_user_action` VALUES (76, '用户列表', 1, 'root', 1560431842, '{\"\\/admin\\/UserCon\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"nickname\\\":\\\"\\\",\\\"phone\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\",\\\"user_id\\\":\\\"\\\",\\\"level\\\":\\\"\\\"}\"}', 'admin/UserCon/getList');
INSERT INTO `admin_user_action` VALUES (77, '用户收入列表', 1, 'root', 1560431844, '{\"\\/admin\\/UserIncome\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"nickname\\\":\\\"\\\",\\\"title\\\":\\\"\\\"}\"}', 'admin/UserIncome/getList');
INSERT INTO `admin_user_action` VALUES (78, '用户消息列表', 1, 'root', 1560431845, '{\"\\/admin\\/UserNotice\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"nickaname\\\":\\\"\\\",\\\"title\\\":\\\"\\\",\\\"content\\\":\\\"\\\",\\\"is_read\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\"}\"}', 'admin/UserNotice/getList');
INSERT INTO `admin_user_action` VALUES (79, '用户任务列表', 1, 'root', 1560431847, '{\"\\/admin\\/UserTask\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"nickname\\\":\\\"\\\",\\\"title\\\":\\\"\\\",\\\"submit_time\\\":\\\"\\\",\\\"check_time\\\":\\\"\\\",\\\"status\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\"}\"}', 'admin/UserTask/getList');
INSERT INTO `admin_user_action` VALUES (80, '提现列表', 1, 'root', 1560431850, '{\"\\/admin\\/Withdraw\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"nickname\\\":\\\"\\\",\\\"withdraw_way_id\\\":\\\"\\\",\\\"account\\\":\\\"\\\",\\\"status\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\"}\"}', 'admin/Withdraw/getList');
INSERT INTO `admin_user_action` VALUES (81, '提现方式列表', 1, 'root', 1560431852, '{\"\\/admin\\/WithdrawWay\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\"}', 'admin/WithdrawWay/getList');
INSERT INTO `admin_user_action` VALUES (82, '佣金列表', 1, 'root', 1560431855, '{\"\\/admin\\/Commission\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"type\\\":\\\"\\\",\\\"nickname\\\":\\\"\\\",\\\"from_user_nickname\\\":\\\"\\\",\\\"title\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\"}\"}', 'admin/Commission/getList');
INSERT INTO `admin_user_action` VALUES (83, '佣金配置', 1, 'root', 1560431856, '{\"\\/admin\\/CommissionConf\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\"}', 'admin/CommissionConf/getList');
INSERT INTO `admin_user_action` VALUES (84, '菜单列表', 1, 'root', 1560431902, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (85, '菜单列表', 1, 'root', 1560431933, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (86, '菜单列表', 1, 'root', 1560431954, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (87, '佣金配置', 1, 'root', 1560431959, '{\"\\/admin\\/CommissionConf\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\"}', 'admin/CommissionConf/getList');
INSERT INTO `admin_user_action` VALUES (88, '接口分组列表', 1, 'root', 1560432221, '{\"\\/admin\\/InterfaceGroup\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceGroup/index');
INSERT INTO `admin_user_action` VALUES (89, '接口列表', 1, 'root', 1560432226, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (90, '任务列表', 1, 'root', 1560432697, '{\"\\/admin\\/Task\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"task_type_id\\\":\\\"\\\",\\\"title\\\":\\\"\\\",\\\"is_repeat\\\":\\\"\\\",\\\"area\\\":[],\\\"device\\\":\\\"\\\",\\\"submit_way\\\":\\\"\\\",\\\"status\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\"}\"}', 'admin/Task/getList');
INSERT INTO `admin_user_action` VALUES (91, '任务类型列表', 1, 'root', 1560432697, '{\"\\/admin\\/TaskType\\/getList\":\"\"}', 'admin/TaskType/getList');
INSERT INTO `admin_user_action` VALUES (92, '任务列表', 1, 'root', 1560432733, '{\"\\/admin\\/Task\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"task_type_id\\\":\\\"\\\",\\\"title\\\":\\\"\\\",\\\"is_repeat\\\":\\\"\\\",\\\"area\\\":[],\\\"device\\\":\\\"\\\",\\\"submit_way\\\":\\\"\\\",\\\"status\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\"}\"}', 'admin/Task/getList');
INSERT INTO `admin_user_action` VALUES (93, '任务类型列表', 1, 'root', 1560432733, '{\"\\/admin\\/TaskType\\/getList\":\"\"}', 'admin/TaskType/getList');
INSERT INTO `admin_user_action` VALUES (94, '菜单列表', 1, 'root', 1560432987, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (95, '新增菜单', 1, 'root', 1560433009, '{\"\\/admin\\/Menu\\/add\":\"\",\"name\":\"\\u5730\\u533a\\u5217\\u8868\",\"fid\":0,\"url\":\"AreaCon\\/getList\",\"sort\":0,\"id\":0}', 'admin/Menu/add');
INSERT INTO `admin_user_action` VALUES (96, '菜单列表', 1, 'root', 1560433009, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (97, '任务列表', 1, 'root', 1560433012, '{\"\\/admin\\/Task\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"task_type_id\\\":\\\"\\\",\\\"title\\\":\\\"\\\",\\\"is_repeat\\\":\\\"\\\",\\\"area\\\":[],\\\"device\\\":\\\"\\\",\\\"submit_way\\\":\\\"\\\",\\\"status\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\"}\"}', 'admin/Task/getList');
INSERT INTO `admin_user_action` VALUES (98, '地区列表', 1, 'root', 1560433012, '{\"\\/admin\\/AreaCon\\/getList\":\"\"}', 'admin/AreaCon/getList');
INSERT INTO `admin_user_action` VALUES (99, '任务类型列表', 1, 'root', 1560433012, '{\"\\/admin\\/TaskType\\/getList\":\"\"}', 'admin/TaskType/getList');
INSERT INTO `admin_user_action` VALUES (100, '任务类型列表', 1, 'root', 1560433171, '{\"\\/admin\\/TaskType\\/getList\":\"\"}', 'admin/TaskType/getList');
INSERT INTO `admin_user_action` VALUES (101, '任务列表', 1, 'root', 1560433171, '{\"\\/admin\\/Task\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"task_type_id\\\":\\\"\\\",\\\"title\\\":\\\"\\\",\\\"is_repeat\\\":\\\"\\\",\\\"area\\\":[],\\\"device\\\":\\\"\\\",\\\"submit_way\\\":\\\"\\\",\\\"status\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\"}\"}', 'admin/Task/getList');
INSERT INTO `admin_user_action` VALUES (102, '地区列表', 1, 'root', 1560433171, '{\"\\/admin\\/AreaCon\\/getList\":\"\"}', 'admin/AreaCon/getList');
INSERT INTO `admin_user_action` VALUES (103, '任务类型列表', 1, 'root', 1560433191, '{\"\\/admin\\/TaskType\\/getList\":\"\"}', 'admin/TaskType/getList');
INSERT INTO `admin_user_action` VALUES (104, '任务列表', 1, 'root', 1560433191, '{\"\\/admin\\/Task\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"task_type_id\\\":\\\"\\\",\\\"title\\\":\\\"\\\",\\\"is_repeat\\\":\\\"\\\",\\\"area\\\":[],\\\"device\\\":\\\"\\\",\\\"submit_way\\\":\\\"\\\",\\\"status\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\"}\"}', 'admin/Task/getList');
INSERT INTO `admin_user_action` VALUES (105, '地区列表', 1, 'root', 1560433191, '{\"\\/admin\\/AreaCon\\/getList\":\"\"}', 'admin/AreaCon/getList');
INSERT INTO `admin_user_action` VALUES (106, '任务类型列表', 1, 'root', 1560433193, '{\"\\/admin\\/TaskType\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"name\\\":\\\"\\\",\\\"status\\\":\\\"\\\"}\"}', 'admin/TaskType/getList');
INSERT INTO `admin_user_action` VALUES (107, '接口列表', 1, 'root', 1560433328, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (108, '获取接口唯一标识', 1, 'root', 1560433330, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (109, '获取全部有效的接口组', 1, 'root', 1560433330, '{\"\\/admin\\/InterfaceGroup\\/getAll\":\"\"}', 'admin/InterfaceGroup/getAll');
INSERT INTO `admin_user_action` VALUES (110, '获取接口唯一标识', 1, 'root', 1560433383, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (111, '接口分组列表', 1, 'root', 1560433384, '{\"\\/admin\\/InterfaceGroup\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceGroup/index');
INSERT INTO `admin_user_action` VALUES (112, '获取接口唯一标识', 1, 'root', 1560433385, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (113, '接口列表', 1, 'root', 1560433414, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (114, '获取接口唯一标识', 1, 'root', 1560433416, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (115, '获取全部有效的接口组', 1, 'root', 1560433416, '{\"\\/admin\\/InterfaceGroup\\/getAll\":\"\"}', 'admin/InterfaceGroup/getAll');
INSERT INTO `admin_user_action` VALUES (116, '添加接口', 1, 'root', 1560433445, '{\"\\/admin\\/InterfaceList\\/add\":\"\",\"apiClass\":\"User\\/register\",\"info\":\"\\u7528\\u6237\\u6ce8\\u518c\",\"groupHash\":\"default\",\"method\":1,\"hash\":\"5d0253080db26\",\"accessToken\":1,\"isTest\":1,\"needLogin\":0,\"id\":0}', 'admin/InterfaceList/add');
INSERT INTO `admin_user_action` VALUES (117, '接口列表', 1, 'root', 1560433445, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (118, '刷新路由', 1, 'root', 1560433451, '{\"\\/admin\\/InterfaceList\\/refresh\":\"\"}', 'admin/InterfaceList/refresh');
INSERT INTO `admin_user_action` VALUES (119, '编辑接口', 1, 'root', 1560435238, '{\"\\/admin\\/InterfaceList\\/edit\":\"\",\"apiClass\":\"User\\/register\",\"info\":\"\\u7528\\u6237\\u6ce8\\u518c\",\"groupHash\":\"default\",\"method\":2,\"hash\":\"5d0253080db26\",\"accessToken\":1,\"isTest\":1,\"needLogin\":0,\"id\":1}', 'admin/InterfaceList/edit');
INSERT INTO `admin_user_action` VALUES (120, '接口列表', 1, 'root', 1560435238, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (121, '刷新路由', 1, 'root', 1560435242, '{\"\\/admin\\/InterfaceList\\/refresh\":\"\"}', 'admin/InterfaceList/refresh');
INSERT INTO `admin_user_action` VALUES (122, '编辑接口', 1, 'root', 1560435378, '{\"\\/admin\\/InterfaceList\\/edit\":\"\",\"apiClass\":\"api\\/User\\/register\",\"info\":\"\\u7528\\u6237\\u6ce8\\u518c\",\"groupHash\":\"default\",\"method\":2,\"hash\":\"5d0253080db26\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":1}', 'admin/InterfaceList/edit');
INSERT INTO `admin_user_action` VALUES (123, '接口列表', 1, 'root', 1560435378, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (124, '刷新路由', 1, 'root', 1560435380, '{\"\\/admin\\/InterfaceList\\/refresh\":\"\"}', 'admin/InterfaceList/refresh');
INSERT INTO `admin_user_action` VALUES (125, '接口列表', 1, 'root', 1560439102, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (126, '获取全部有效的接口组', 1, 'root', 1560439341, '{\"\\/admin\\/InterfaceGroup\\/getAll\":\"\"}', 'admin/InterfaceGroup/getAll');
INSERT INTO `admin_user_action` VALUES (127, '编辑接口', 1, 'root', 1560440637, '{\"\\/admin\\/InterfaceList\\/edit\":\"\",\"apiClass\":\"api\\/User\\/register\",\"info\":\"\\u7528\\u6237\\u6ce8\\u518c\",\"groupHash\":\"default\",\"method\":1,\"hash\":\"5d0253080db26\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":1}', 'admin/InterfaceList/edit');
INSERT INTO `admin_user_action` VALUES (128, '接口列表', 1, 'root', 1560440637, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (129, '刷新路由', 1, 'root', 1560440640, '{\"\\/admin\\/InterfaceList\\/refresh\":\"\"}', 'admin/InterfaceList/refresh');
INSERT INTO `admin_user_action` VALUES (130, '编辑接口', 1, 'root', 1560442718, '{\"\\/admin\\/InterfaceList\\/edit\":\"\",\"apiClass\":\"api\\/User\\/register\",\"info\":\"\\u7528\\u6237\\u6ce8\\u518c\",\"groupHash\":\"default\",\"method\":2,\"hash\":\"5d0253080db26\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":1}', 'admin/InterfaceList/edit');
INSERT INTO `admin_user_action` VALUES (131, '接口列表', 1, 'root', 1560442719, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (132, '刷新路由', 1, 'root', 1560442722, '{\"\\/admin\\/InterfaceList\\/refresh\":\"\"}', 'admin/InterfaceList/refresh');
INSERT INTO `admin_user_action` VALUES (133, '编辑接口', 1, 'root', 1560443600, '{\"\\/admin\\/InterfaceList\\/edit\":\"\",\"apiClass\":\"api\\/User\\/register\",\"info\":\"\\u7528\\u6237\\u6ce8\\u518c\",\"groupHash\":\"default\",\"method\":1,\"hash\":\"5d0253080db26\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":1}', 'admin/InterfaceList/edit');
INSERT INTO `admin_user_action` VALUES (134, '接口列表', 1, 'root', 1560443601, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (135, '刷新路由', 1, 'root', 1560443602, '{\"\\/admin\\/InterfaceList\\/refresh\":\"\"}', 'admin/InterfaceList/refresh');
INSERT INTO `admin_user_action` VALUES (136, '刷新路由', 1, 'root', 1560444708, '{\"\\/admin\\/InterfaceList\\/refresh\":\"\"}', 'admin/InterfaceList/refresh');
INSERT INTO `admin_user_action` VALUES (137, '编辑接口', 1, 'root', 1560444722, '{\"\\/admin\\/InterfaceList\\/edit\":\"\",\"apiClass\":\"api\\/User\\/register\",\"info\":\"\\u7528\\u6237\\u6ce8\\u518c\",\"groupHash\":\"default\",\"method\":2,\"hash\":\"5d0253080db26\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":1}', 'admin/InterfaceList/edit');
INSERT INTO `admin_user_action` VALUES (138, '接口列表', 1, 'root', 1560444722, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (139, '接口列表', 1, 'root', 1560444726, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (140, '获取全部有效的接口组', 1, 'root', 1560444754, '{\"\\/admin\\/InterfaceGroup\\/getAll\":\"\"}', 'admin/InterfaceGroup/getAll');
INSERT INTO `admin_user_action` VALUES (141, '编辑接口', 1, 'root', 1560444757, '{\"\\/admin\\/InterfaceList\\/edit\":\"\",\"apiClass\":\"api\\/User\\/register\",\"info\":\"\\u7528\\u6237\\u6ce8\\u518c\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d0253080db26\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":1}', 'admin/InterfaceList/edit');
INSERT INTO `admin_user_action` VALUES (142, '接口列表', 1, 'root', 1560444757, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (143, '接口列表', 1, 'root', 1560444759, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (144, '获取全部有效的接口组', 1, 'root', 1560444795, '{\"\\/admin\\/InterfaceGroup\\/getAll\":\"\"}', 'admin/InterfaceGroup/getAll');
INSERT INTO `admin_user_action` VALUES (145, '编辑接口', 1, 'root', 1560444817, '{\"\\/admin\\/InterfaceList\\/edit\":\"\",\"apiClass\":\"User\\/register\",\"info\":\"\\u7528\\u6237\\u6ce8\\u518c\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d0253080db26\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":1}', 'admin/InterfaceList/edit');
INSERT INTO `admin_user_action` VALUES (146, '接口列表', 1, 'root', 1560444817, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (147, '刷新路由', 1, 'root', 1560444820, '{\"\\/admin\\/InterfaceList\\/refresh\":\"\"}', 'admin/InterfaceList/refresh');
INSERT INTO `admin_user_action` VALUES (148, '编辑接口', 1, 'root', 1560444874, '{\"\\/admin\\/InterfaceList\\/edit\":\"\",\"apiClass\":\"User\\/register\",\"info\":\"\\u7528\\u6237\\u6ce8\\u518c\",\"groupHash\":\"default\",\"method\":1,\"hash\":\"5d0253080db26\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":1}', 'admin/InterfaceList/edit');
INSERT INTO `admin_user_action` VALUES (149, '接口列表', 1, 'root', 1560444874, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (150, '刷新路由', 1, 'root', 1560444877, '{\"\\/admin\\/InterfaceList\\/refresh\":\"\"}', 'admin/InterfaceList/refresh');
INSERT INTO `admin_user_action` VALUES (151, '编辑接口', 1, 'root', 1560444914, '{\"\\/admin\\/InterfaceList\\/edit\":\"\",\"apiClass\":\"User\\/register\",\"info\":\"\\u7528\\u6237\\u6ce8\\u518c\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d0253080db26\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":1}', 'admin/InterfaceList/edit');
INSERT INTO `admin_user_action` VALUES (152, '接口列表', 1, 'root', 1560444914, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (153, '刷新路由', 1, 'root', 1560444917, '{\"\\/admin\\/InterfaceList\\/refresh\":\"\"}', 'admin/InterfaceList/refresh');
INSERT INTO `admin_user_action` VALUES (154, '编辑接口', 1, 'root', 1560444957, '{\"\\/admin\\/InterfaceList\\/edit\":\"\",\"apiClass\":\"User\\/register\",\"info\":\"\\u7528\\u6237\\u6ce8\\u518c\",\"groupHash\":\"default\",\"method\":1,\"hash\":\"5d0253080db26\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":1}', 'admin/InterfaceList/edit');
INSERT INTO `admin_user_action` VALUES (155, '接口列表', 1, 'root', 1560444957, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (156, '刷新路由', 1, 'root', 1560444960, '{\"\\/admin\\/InterfaceList\\/refresh\":\"\"}', 'admin/InterfaceList/refresh');
INSERT INTO `admin_user_action` VALUES (157, '编辑接口', 1, 'root', 1560444984, '{\"\\/admin\\/InterfaceList\\/edit\":\"\",\"apiClass\":\"User\\/register\",\"info\":\"\\u7528\\u6237\\u6ce8\\u518c\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d0253080db26\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":1}', 'admin/InterfaceList/edit');
INSERT INTO `admin_user_action` VALUES (158, '接口列表', 1, 'root', 1560444984, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (159, '刷新路由', 1, 'root', 1560444988, '{\"\\/admin\\/InterfaceList\\/refresh\":\"\"}', 'admin/InterfaceList/refresh');
INSERT INTO `admin_user_action` VALUES (160, '编辑接口', 1, 'root', 1560445539, '{\"\\/admin\\/InterfaceList\\/edit\":\"\",\"apiClass\":\"Index\\/areaList\",\"info\":\"\\u57ce\\u5e02\\u5217\\u8868\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d0253080db26\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":1}', 'admin/InterfaceList/edit');
INSERT INTO `admin_user_action` VALUES (161, '接口列表', 1, 'root', 1560445539, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (162, '编辑接口', 1, 'root', 1560445569, '{\"\\/admin\\/InterfaceList\\/edit\":\"\",\"apiClass\":\"User\\/register\",\"info\":\"\\u7528\\u6237\\u6ce8\\u518c\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d0253080db26\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":1}', 'admin/InterfaceList/edit');
INSERT INTO `admin_user_action` VALUES (163, '接口列表', 1, 'root', 1560445569, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (164, '刷新路由', 1, 'root', 1560445571, '{\"\\/admin\\/InterfaceList\\/refresh\":\"\"}', 'admin/InterfaceList/refresh');
INSERT INTO `admin_user_action` VALUES (165, '编辑接口', 1, 'root', 1560445595, '{\"\\/admin\\/InterfaceList\\/edit\":\"\",\"apiClass\":\"User\\/register\",\"info\":\"\\u7528\\u6237\\u6ce8\\u518c\",\"groupHash\":\"default\",\"method\":1,\"hash\":\"5d0253080db26\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":1}', 'admin/InterfaceList/edit');
INSERT INTO `admin_user_action` VALUES (166, '接口列表', 1, 'root', 1560445595, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (167, '刷新路由', 1, 'root', 1560445597, '{\"\\/admin\\/InterfaceList\\/refresh\":\"\"}', 'admin/InterfaceList/refresh');
INSERT INTO `admin_user_action` VALUES (168, '编辑接口', 1, 'root', 1560445665, '{\"\\/admin\\/InterfaceList\\/edit\":\"\",\"apiClass\":\"User\\/register\",\"info\":\"\\u7528\\u6237\\u6ce8\\u518c\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d0253080db26\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":1}', 'admin/InterfaceList/edit');
INSERT INTO `admin_user_action` VALUES (169, '接口列表', 1, 'root', 1560445666, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (170, '刷新路由', 1, 'root', 1560445668, '{\"\\/admin\\/InterfaceList\\/refresh\":\"\"}', 'admin/InterfaceList/refresh');
INSERT INTO `admin_user_action` VALUES (171, '接口列表', 1, 'root', 1560446586, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (172, '获取全部有效的接口组', 1, 'root', 1560446588, '{\"\\/admin\\/InterfaceGroup\\/getAll\":\"\"}', 'admin/InterfaceGroup/getAll');
INSERT INTO `admin_user_action` VALUES (173, '编辑接口', 1, 'root', 1560446600, '{\"\\/admin\\/InterfaceList\\/edit\":\"\",\"apiClass\":\"Index\\/areaList\",\"info\":\"\\u5730\\u533a\\u5217\\u8868\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d0253080db26\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":1}', 'admin/InterfaceList/edit');
INSERT INTO `admin_user_action` VALUES (174, '接口列表', 1, 'root', 1560446600, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (175, '获取接口唯一标识', 1, 'root', 1560446601, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (176, '添加接口', 1, 'root', 1560446643, '{\"\\/admin\\/InterfaceList\\/add\":\"\",\"apiClass\":\"Index\\/bannerList\",\"info\":\"\\u8f6e\\u64ad\\u56fe\\u5217\\u8868\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d0286898878a\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":0}', 'admin/InterfaceList/add');
INSERT INTO `admin_user_action` VALUES (177, '接口列表', 1, 'root', 1560446643, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (178, '获取接口唯一标识', 1, 'root', 1560446644, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (179, '添加接口', 1, 'root', 1560446665, '{\"\\/admin\\/InterfaceList\\/add\":\"\",\"apiClass\":\"Index\\/linkList\",\"info\":\"\\u94fe\\u63a5\\u5217\\u8868\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d0286b4ea311\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":0}', 'admin/InterfaceList/add');
INSERT INTO `admin_user_action` VALUES (180, '接口列表', 1, 'root', 1560446665, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (181, '获取接口唯一标识', 1, 'root', 1560446667, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (182, '添加接口', 1, 'root', 1560446703, '{\"\\/admin\\/InterfaceList\\/add\":\"\",\"apiClass\":\"Task\\/taskList\",\"info\":\"\\u4efb\\u52a1\\u5217\\u8868\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d0286cb35cb3\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":0}', 'admin/InterfaceList/add');
INSERT INTO `admin_user_action` VALUES (183, '接口列表', 1, 'root', 1560446703, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (184, '获取接口唯一标识', 1, 'root', 1560446706, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (185, '添加接口', 1, 'root', 1560446722, '{\"\\/admin\\/InterfaceList\\/add\":\"\",\"apiClass\":\"Task\\/taskDetails\",\"info\":\"\\u4efb\\u52a1\\u8be6\\u60c5\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d0286f251c4d\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":0}', 'admin/InterfaceList/add');
INSERT INTO `admin_user_action` VALUES (186, '接口列表', 1, 'root', 1560446723, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (187, '获取接口唯一标识', 1, 'root', 1560446739, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (188, '添加接口', 1, 'root', 1560446759, '{\"\\/admin\\/InterfaceList\\/add\":\"\",\"apiClass\":\"User\\/sendCode\",\"info\":\"\\u53d1\\u9001\\u9a8c\\u8bc1\\u7801\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d02871310048\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":0}', 'admin/InterfaceList/add');
INSERT INTO `admin_user_action` VALUES (189, '接口列表', 1, 'root', 1560446759, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (190, '获取接口唯一标识', 1, 'root', 1560446767, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (191, '添加接口', 1, 'root', 1560446781, '{\"\\/admin\\/InterfaceList\\/add\":\"\",\"apiClass\":\"User\\/register\",\"info\":\"\\u7528\\u6237\\u6ce8\\u518c\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d02872f6e368\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":0}', 'admin/InterfaceList/add');
INSERT INTO `admin_user_action` VALUES (192, '接口列表', 1, 'root', 1560446781, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (193, '获取接口唯一标识', 1, 'root', 1560446785, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (194, '添加接口', 1, 'root', 1560446803, '{\"\\/admin\\/InterfaceList\\/add\":\"\",\"apiClass\":\"User\\/login\",\"info\":\"\\u7528\\u6237\\u767b\\u5f55\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d0287415a574\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":0}', 'admin/InterfaceList/add');
INSERT INTO `admin_user_action` VALUES (195, '接口列表', 1, 'root', 1560446803, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (196, '获取接口唯一标识', 1, 'root', 1560446807, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (197, '添加接口', 1, 'root', 1560446822, '{\"\\/admin\\/InterfaceList\\/add\":\"\",\"apiClass\":\"User\\/info\",\"info\":\"\\u7528\\u6237\\u4e2a\\u4eba\\u4fe1\\u606f\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d028757a9784\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":0}', 'admin/InterfaceList/add');
INSERT INTO `admin_user_action` VALUES (198, '接口列表', 1, 'root', 1560446822, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (199, '获取接口唯一标识', 1, 'root', 1560446829, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (200, '添加接口', 1, 'root', 1560446867, '{\"\\/admin\\/InterfaceList\\/add\":\"\",\"apiClass\":\"UserIncome\\/myIncomeList\",\"info\":\"\\u7528\\u6237\\u6536\\u5165\\u5217\\u8868\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d02876d5d982\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":0}', 'admin/InterfaceList/add');
INSERT INTO `admin_user_action` VALUES (201, '接口列表', 1, 'root', 1560446867, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (202, '获取接口唯一标识', 1, 'root', 1560446873, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (203, '添加接口', 1, 'root', 1560446892, '{\"\\/admin\\/InterfaceList\\/add\":\"\",\"apiClass\":\"UserIncome\\/teamIncomeList\",\"info\":\"\\u7528\\u6237\\u56e2\\u961f\\u5217\\u8868\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d02879991352\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":0}', 'admin/InterfaceList/add');
INSERT INTO `admin_user_action` VALUES (204, '接口列表', 1, 'root', 1560446892, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (205, '获取接口唯一标识', 1, 'root', 1560446893, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (206, '编辑接口', 1, 'root', 1560446925, '{\"\\/admin\\/InterfaceList\\/edit\":\"\",\"apiClass\":\"User\\/myTeamList\",\"info\":\"\\u7528\\u6237\\u56e2\\u961f\\u5217\\u8868\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d02879991352\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":11}', 'admin/InterfaceList/edit');
INSERT INTO `admin_user_action` VALUES (207, '接口列表', 1, 'root', 1560446925, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (208, '获取接口唯一标识', 1, 'root', 1560446930, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (209, '添加接口', 1, 'root', 1560446944, '{\"\\/admin\\/InterfaceList\\/add\":\"\",\"apiClass\":\"UserIncome\\/teamIncomeList\",\"info\":\"\\u7528\\u6237\\u56e2\\u961f\\u6536\\u5165\\u5217\\u8868\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d0287d22f573\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":0}', 'admin/InterfaceList/add');
INSERT INTO `admin_user_action` VALUES (210, '接口列表', 1, 'root', 1560446944, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (211, '获取接口唯一标识', 1, 'root', 1560446948, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (212, '添加接口', 1, 'root', 1560446966, '{\"\\/admin\\/InterfaceList\\/add\":\"\",\"apiClass\":\"UserWithDraw\\/withdrawList\",\"info\":\"\\u7528\\u6237\\u63d0\\u73b0\\u5217\\u8868\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d0287e451a4c\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":0}', 'admin/InterfaceList/add');
INSERT INTO `admin_user_action` VALUES (213, '接口列表', 1, 'root', 1560446966, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (214, '获取接口唯一标识', 1, 'root', 1560446970, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (215, '添加接口', 1, 'root', 1560446989, '{\"\\/admin\\/InterfaceList\\/add\":\"\",\"apiClass\":\"UserTask\\/taskList\",\"info\":\"\\u7528\\u6237\\u4efb\\u52a1\\u5217\\u8868\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d0287facb879\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":0}', 'admin/InterfaceList/add');
INSERT INTO `admin_user_action` VALUES (216, '接口列表', 1, 'root', 1560446989, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (217, '获取接口唯一标识', 1, 'root', 1560446999, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (218, '添加接口', 1, 'root', 1560447013, '{\"\\/admin\\/InterfaceList\\/add\":\"\",\"apiClass\":\"UserTask\\/addTask\",\"info\":\"\\u7528\\u6237\\u6dfb\\u52a0\\u4efb\\u52a1\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d0288178f14a\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":0}', 'admin/InterfaceList/add');
INSERT INTO `admin_user_action` VALUES (219, '接口列表', 1, 'root', 1560447013, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (220, '获取接口唯一标识', 1, 'root', 1560447021, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (221, '添加接口', 1, 'root', 1560447033, '{\"\\/admin\\/InterfaceList\\/add\":\"\",\"apiClass\":\"UserTask\\/submitTask\",\"info\":\"\\u7528\\u6237\\u63d0\\u4ea4\\u4efb\\u52a1\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d02882d0a05a\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":0}', 'admin/InterfaceList/add');
INSERT INTO `admin_user_action` VALUES (222, '接口列表', 1, 'root', 1560447034, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (223, '获取接口唯一标识', 1, 'root', 1560447041, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (224, '添加接口', 1, 'root', 1560447052, '{\"\\/admin\\/InterfaceList\\/add\":\"\",\"apiClass\":\"UserTask\\/delTask\",\"info\":\"\\u7528\\u6237\\u653e\\u5f03\\u4efb\\u52a1\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d0288414ff33\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":0}', 'admin/InterfaceList/add');
INSERT INTO `admin_user_action` VALUES (225, '接口列表', 1, 'root', 1560447053, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (226, '刷新路由', 1, 'root', 1560447056, '{\"\\/admin\\/InterfaceList\\/refresh\":\"\"}', 'admin/InterfaceList/refresh');
INSERT INTO `admin_user_action` VALUES (227, '接口列表', 1, 'root', 1560447098, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"2\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (228, '轮播图列表', 1, 'root', 1560447511, '{\"\\/admin\\/Banner\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"status\\\":\\\"\\\"}\"}', 'admin/Banner/getList');
INSERT INTO `admin_user_action` VALUES (229, '文件上传', 1, 'root', 1560447517, '{\"\\/admin\\/Index\\/upload\":\"\"}', 'admin/Index/upload');
INSERT INTO `admin_user_action` VALUES (230, '添加/编辑轮播图', 1, 'root', 1560447524, '{\"\\/admin\\/Banner\\/save\":\"\",\"id\":0,\"name\":\"1\",\"img\":\"http:\\/\\/127.0.0.1:8001\\/upload\\/20190614\\/4dbfabce14347111d9055c81b1293da3.png\",\"url\":\"\",\"sort\":\"\"}', 'admin/Banner/save');
INSERT INTO `admin_user_action` VALUES (231, '轮播图列表', 1, 'root', 1560447524, '{\"\\/admin\\/Banner\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"status\\\":\\\"\\\"}\"}', 'admin/Banner/getList');
INSERT INTO `admin_user_action` VALUES (232, '文件上传', 1, 'root', 1560447531, '{\"\\/admin\\/Index\\/upload\":\"\"}', 'admin/Index/upload');
INSERT INTO `admin_user_action` VALUES (233, '添加/编辑轮播图', 1, 'root', 1560447531, '{\"\\/admin\\/Banner\\/save\":\"\",\"id\":0,\"name\":\"2\",\"img\":\"http:\\/\\/127.0.0.1:8001\\/upload\\/20190614\\/38823471cea55aad277f4c70f2745304.png\",\"url\":\"\",\"sort\":\"\"}', 'admin/Banner/save');
INSERT INTO `admin_user_action` VALUES (234, '轮播图列表', 1, 'root', 1560447532, '{\"\\/admin\\/Banner\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"status\\\":\\\"\\\"}\"}', 'admin/Banner/getList');
INSERT INTO `admin_user_action` VALUES (235, '文件上传', 1, 'root', 1560447536, '{\"\\/admin\\/Index\\/upload\":\"\"}', 'admin/Index/upload');
INSERT INTO `admin_user_action` VALUES (236, '添加/编辑轮播图', 1, 'root', 1560447538, '{\"\\/admin\\/Banner\\/save\":\"\",\"id\":0,\"name\":\"3\",\"img\":\"http:\\/\\/127.0.0.1:8001\\/upload\\/20190614\\/1eecadd4d8870492b12dfaecd18458f7.png\",\"url\":\"\",\"sort\":\"\"}', 'admin/Banner/save');
INSERT INTO `admin_user_action` VALUES (237, '轮播图列表', 1, 'root', 1560447538, '{\"\\/admin\\/Banner\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"status\\\":\\\"\\\"}\"}', 'admin/Banner/getList');
INSERT INTO `admin_user_action` VALUES (238, '文件上传', 1, 'root', 1560447542, '{\"\\/admin\\/Index\\/upload\":\"\"}', 'admin/Index/upload');
INSERT INTO `admin_user_action` VALUES (239, '添加/编辑轮播图', 1, 'root', 1560447544, '{\"\\/admin\\/Banner\\/save\":\"\",\"id\":0,\"name\":\"4\",\"img\":\"http:\\/\\/127.0.0.1:8001\\/upload\\/20190614\\/38e372e4e9e1e8f81c29ea6e2a4b45a9.png\",\"url\":\"\",\"sort\":\"\"}', 'admin/Banner/save');
INSERT INTO `admin_user_action` VALUES (240, '轮播图列表', 1, 'root', 1560447544, '{\"\\/admin\\/Banner\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"status\\\":\\\"\\\"}\"}', 'admin/Banner/getList');
INSERT INTO `admin_user_action` VALUES (241, '链接列表', 1, 'root', 1560447546, '{\"\\/admin\\/Link\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"status\\\":\\\"\\\"}\"}', 'admin/Link/getList');
INSERT INTO `admin_user_action` VALUES (242, '文件上传', 1, 'root', 1560447550, '{\"\\/admin\\/Index\\/upload\":\"\"}', 'admin/Index/upload');
INSERT INTO `admin_user_action` VALUES (243, '菜单列表', 1, 'root', 1560447570, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (244, '编辑菜单', 1, 'root', 1560447590, '{\"\\/admin\\/Menu\\/edit\":\"\",\"name\":\"\\u6dfb\\u52a0\\/\\u7f16\\u8f91\\u94fe\\u63a5\",\"fid\":74,\"url\":\"Link\\/save\",\"sort\":0,\"id\":75}', 'admin/Menu/edit');
INSERT INTO `admin_user_action` VALUES (245, '菜单列表', 1, 'root', 1560447591, '{\"\\/admin\\/Menu\\/index\":\"\"}', 'admin/Menu/index');
INSERT INTO `admin_user_action` VALUES (246, '链接列表', 1, 'root', 1560447594, '{\"\\/admin\\/Link\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"status\\\":\\\"\\\"}\"}', 'admin/Link/getList');
INSERT INTO `admin_user_action` VALUES (247, '文件上传', 1, 'root', 1560447599, '{\"\\/admin\\/Index\\/upload\":\"\"}', 'admin/Index/upload');
INSERT INTO `admin_user_action` VALUES (248, '添加/编辑链接', 1, 'root', 1560447602, '{\"\\/admin\\/Link\\/save\":\"\",\"id\":0,\"name\":\"1\",\"img\":\"http:\\/\\/127.0.0.1:8001\\/upload\\/20190614\\/f44f0c9df54d5b29332f6853f2808cbb.png\",\"url\":\"www.baidu.com\",\"sort\":\"\"}', 'admin/Link/save');
INSERT INTO `admin_user_action` VALUES (249, '链接列表', 1, 'root', 1560447602, '{\"\\/admin\\/Link\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"status\\\":\\\"\\\"}\"}', 'admin/Link/getList');
INSERT INTO `admin_user_action` VALUES (250, '文件上传', 1, 'root', 1560447605, '{\"\\/admin\\/Index\\/upload\":\"\"}', 'admin/Index/upload');
INSERT INTO `admin_user_action` VALUES (251, '添加/编辑链接', 1, 'root', 1560447607, '{\"\\/admin\\/Link\\/save\":\"\",\"id\":0,\"name\":\"2\",\"img\":\"http:\\/\\/127.0.0.1:8001\\/upload\\/20190614\\/02631b977ee8d63a51e54978e900ae29.png\",\"url\":\"www.baidu.com\",\"sort\":\"\"}', 'admin/Link/save');
INSERT INTO `admin_user_action` VALUES (252, '链接列表', 1, 'root', 1560447607, '{\"\\/admin\\/Link\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"status\\\":\\\"\\\"}\"}', 'admin/Link/getList');
INSERT INTO `admin_user_action` VALUES (253, '文件上传', 1, 'root', 1560447611, '{\"\\/admin\\/Index\\/upload\":\"\"}', 'admin/Index/upload');
INSERT INTO `admin_user_action` VALUES (254, '添加/编辑链接', 1, 'root', 1560447612, '{\"\\/admin\\/Link\\/save\":\"\",\"id\":0,\"name\":\"3\",\"img\":\"http:\\/\\/127.0.0.1:8001\\/upload\\/20190614\\/02d2cc0211de69ca2e05556254609952.png\",\"url\":\"www.baidu.com\",\"sort\":\"\"}', 'admin/Link/save');
INSERT INTO `admin_user_action` VALUES (255, '链接列表', 1, 'root', 1560447613, '{\"\\/admin\\/Link\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"status\\\":\\\"\\\"}\"}', 'admin/Link/getList');
INSERT INTO `admin_user_action` VALUES (256, '文件上传', 1, 'root', 1560447618, '{\"\\/admin\\/Index\\/upload\":\"\"}', 'admin/Index/upload');
INSERT INTO `admin_user_action` VALUES (257, '添加/编辑链接', 1, 'root', 1560447618, '{\"\\/admin\\/Link\\/save\":\"\",\"id\":0,\"name\":\"4\",\"img\":\"http:\\/\\/127.0.0.1:8001\\/upload\\/20190614\\/78ef72a72755e0d5591e5f39d2af7c72.png\",\"url\":\"www.baidu.com\",\"sort\":\"\"}', 'admin/Link/save');
INSERT INTO `admin_user_action` VALUES (258, '链接列表', 1, 'root', 1560447619, '{\"\\/admin\\/Link\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"status\\\":\\\"\\\"}\"}', 'admin/Link/getList');
INSERT INTO `admin_user_action` VALUES (259, '任务类型列表', 1, 'root', 1560447634, '{\"\\/admin\\/TaskType\\/getList\":\"\"}', 'admin/TaskType/getList');
INSERT INTO `admin_user_action` VALUES (260, '任务列表', 1, 'root', 1560447634, '{\"\\/admin\\/Task\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"task_type_id\\\":\\\"\\\",\\\"title\\\":\\\"\\\",\\\"is_repeat\\\":\\\"\\\",\\\"area\\\":[],\\\"device\\\":\\\"\\\",\\\"submit_way\\\":\\\"\\\",\\\"status\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\"}\"}', 'admin/Task/getList');
INSERT INTO `admin_user_action` VALUES (261, '地区列表', 1, 'root', 1560447634, '{\"\\/admin\\/AreaCon\\/getList\":\"\"}', 'admin/AreaCon/getList');
INSERT INTO `admin_user_action` VALUES (262, '任务类型列表', 1, 'root', 1560447635, '{\"\\/admin\\/TaskType\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"name\\\":\\\"\\\",\\\"status\\\":\\\"\\\"}\"}', 'admin/TaskType/getList');
INSERT INTO `admin_user_action` VALUES (263, '文件上传', 1, 'root', 1560447647, '{\"\\/admin\\/Index\\/upload\":\"\"}', 'admin/Index/upload');
INSERT INTO `admin_user_action` VALUES (264, '添加/编辑任务类型', 1, 'root', 1560447652, '{\"\\/admin\\/TaskType\\/save\":\"\",\"id\":0,\"name\":\"\\u6e38\\u620f\",\"img\":\"http:\\/\\/127.0.0.1:8001\\/upload\\/20190614\\/93775dab78f8b737a9f11690d90e71df.png\",\"comment\":\"\",\"sort\":\"\"}', 'admin/TaskType/save');
INSERT INTO `admin_user_action` VALUES (265, '任务类型列表', 1, 'root', 1560447652, '{\"\\/admin\\/TaskType\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"name\\\":\\\"\\\",\\\"status\\\":\\\"\\\"}\"}', 'admin/TaskType/getList');
INSERT INTO `admin_user_action` VALUES (266, '文件上传', 1, 'root', 1560447658, '{\"\\/admin\\/Index\\/upload\":\"\"}', 'admin/Index/upload');
INSERT INTO `admin_user_action` VALUES (267, '添加/编辑任务类型', 1, 'root', 1560447659, '{\"\\/admin\\/TaskType\\/save\":\"\",\"id\":0,\"name\":\"\\u8d2d\\u7269\",\"img\":\"http:\\/\\/127.0.0.1:8001\\/upload\\/20190614\\/14b206df4643b99b3888d43ea8cd2ad4.png\",\"comment\":\"\",\"sort\":\"\"}', 'admin/TaskType/save');
INSERT INTO `admin_user_action` VALUES (268, '任务类型列表', 1, 'root', 1560447659, '{\"\\/admin\\/TaskType\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"name\\\":\\\"\\\",\\\"status\\\":\\\"\\\"}\"}', 'admin/TaskType/getList');
INSERT INTO `admin_user_action` VALUES (269, '任务列表', 1, 'root', 1560447661, '{\"\\/admin\\/Task\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"task_type_id\\\":\\\"\\\",\\\"title\\\":\\\"\\\",\\\"is_repeat\\\":\\\"\\\",\\\"area\\\":[],\\\"device\\\":\\\"\\\",\\\"submit_way\\\":\\\"\\\",\\\"status\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\"}\"}', 'admin/Task/getList');
INSERT INTO `admin_user_action` VALUES (270, '任务类型列表', 1, 'root', 1560447661, '{\"\\/admin\\/TaskType\\/getList\":\"\"}', 'admin/TaskType/getList');
INSERT INTO `admin_user_action` VALUES (271, '地区列表', 1, 'root', 1560447661, '{\"\\/admin\\/AreaCon\\/getList\":\"\"}', 'admin/AreaCon/getList');
INSERT INTO `admin_user_action` VALUES (272, '文件上传', 1, 'root', 1560447770, '{\"\\/admin\\/Index\\/upload\":\"\"}', 'admin/Index/upload');
INSERT INTO `admin_user_action` VALUES (273, '文件上传', 1, 'root', 1560447773, '{\"\\/admin\\/Index\\/upload\":\"\"}', 'admin/Index/upload');
INSERT INTO `admin_user_action` VALUES (274, '文件上传', 1, 'root', 1560447838, '{\"\\/admin\\/Index\\/upload\":\"\"}', 'admin/Index/upload');
INSERT INTO `admin_user_action` VALUES (275, '添加/编辑任务', 1, 'root', 1560447852, '{\"\\/admin\\/Task\\/save\":\"\",\"task_id\":0,\"task_type_id\":1,\"title\":\"\\u738b\\u8005\",\"money\":\"9900\",\"number\":\"10\",\"end_date\":\"2019-06-19T16:00:00.000Z\",\"check_duration\":\"24\",\"finish_duration\":\"2\",\"is_repeat\":\"0\",\"area\":[\"110000\",\"110100\"],\"step\":[\"\\uff08\\u8bc4\\u8bed\\u8bf7\\u52a0\\u5fae\\u4fe1\\u53f7377047364\\uff0c\\u5907\\u6ce8\\uff1a\\u767e\\u5ea6\\u53e3\\u7891+\\u4f60\\u7684\\u624b\\u673a\\u54c1\\u724c\\uff0c\\u5ba2\\u670d\\u901a\\u8fc7\\u4f60\\u7684\\u597d\\u53cb\\u9a8c\\u8bc1\\u53d1\\u8bc4\\u8bed\\u7ed9\\u4f60\\uff09\",\"\\u4e00\\u5b9a\\u8981\\u52a0\\u5ba2\\u670d\\u7b49\\u5ba2\\u670d\\u7ed9\\u4f60\\u8bc4\\u8bed\\u5728\\u505a\\u4efb\\u52a1\\uff0c\\u4e0d\\u662f\\u5ba2\\u670d\\u7ed9\\u7684\\u8bc4\\u8bed\\u4e0d\\u5408\\u683c\",\"\\uff08\\u590d\\u5236\\u6ce8\\u610f\\u4e8b\\u9879\\u4e2d\\u7684\\u94fe\\u63a5\\u5230\\u6d4f\\u89c8\\u5668\\u8fdb\\u5165\\uff0c\\u70b9\\u51fb\\u767b\\u9646\\u8d26\\u53f7\\uff0c\\u7ed9\\u4e94\\u661f\\u597d\\u8bc4+\\u8bc4\\u8bed+\\u4e0a\\u4f20\\u56fe\\u7247\\u5373\\u53ef\",\"\\uff08\\u9700\\u8981\\u6709\\u767e\\u5ea6\\u8d26\\u53f7\\uff0c\\u5982\\u5df2\\u6709\\u8d26\\u53f7\\uff0c\\u76f4\\u63a5\\u767b\\u5f55\\u8bc4\\u4ef7\\uff0c\\u5982\\u679c\\u6ca1\\u6709\\u81ea\\u884c\\u6ce8\\u518c\\u4e00\\u4e2a\\u53f7\",\"\\u4e00\\u4eba\\u53ea\\u80fd\\u8bc4\\u8bba\\u4e00\\u6b21\\uff0c\\u8bbe\\u7f6e\\u4e0d\\u9650\\u6b21\\u6570\\u662f\\u56e0\\u4e3a\\u6015\\u6709\\u7684\\u8d85\\u65f6\\u6ca1\\u529e\\u6cd5\\u63d0\\u4ea4\"],\"link\":\"www.baidu.com\",\"show_img\":[\"http:\\/\\/127.0.0.1:8001\\/upload\\/20190614\\/4c292520ae632633af81f9403a6e8576.png\",\"http:\\/\\/127.0.0.1:8001\\/upload\\/20190614\\/48603eff30e52d9ac393854553703710.png\"],\"take_care\":\"1\\uff0c\\u4e00\\u4e2a\\u624b\\u673a\\u53ea\\u80fd\\u6ce8\\u518c\\u4e00\\u6b21\\uff0c\\u6ce8\\u518c\\u8fc7\\u7684\\u7528\\u6237\\u4e0d\\u80fd\\u518d\\u6ce8\\u518c\\uff0c\\u65b0\\u7528\\u6237\\u6536\\u5230\\u501f\\u6761\\u989d\\u5ea6\\u901a\\u8fc7\\u901a\\u77e5\\u548c\\u6210\\u529f\\u501f\\u6b3e\\u7684\\u7528\\u6237\\u624d\\u6709\\u5956\\u52b1\\u30022\\uff0c\\u53ef\\u4ee5\\u968f\\u610f\\u501f\\u4e00\\u7b14\\u6b3e\\uff0c\\u51e0\\u5929\\u540e\\u8fd8\\u6b3e\\uff0c\\u5229\\u606f\\u6309\\u65e5\\u8ba1\\u7b97\\uff0c\\u7ea2\\u5305\\u53ef\\u4ee5\\u62b5\\u6263\\u5229\\u606f\\u3002\",\"device\":\"1\",\"submit_way\":\"1\",\"submit_notice\":\"1\\uff0c\\u5fc5\\u987b\\u626b\\u56fe\\u4e2d\\u4e8c\\u7ef4\\u7801\\u30022\\uff0c\\u6210\\u529f\\u4e4b\\u540e\\u5fc5\\u987b\\u6709\\u5f53\\u5929\\u8d60\\u9001\\u7684\\u5361\\u5238\",\"submit_img\":[]}', 'admin/Task/save');
INSERT INTO `admin_user_action` VALUES (276, '添加/编辑任务', 1, 'root', 1560448055, '{\"\\/admin\\/Task\\/save\":\"\",\"task_id\":0,\"task_type_id\":1,\"title\":\"\\u3010\\u767e\\u5ea6\\u53e3\\u7891\\u3011\\u597d\\u8bc4\\u5373\\u53ef\\u4e0d\\u4e0b\\u8f7d\",\"money\":\"100\",\"number\":\"10\",\"end_date\":\"2019-06-29T16:00:00.000Z\",\"check_duration\":\"72\",\"finish_duration\":\"2\",\"is_repeat\":\"1\",\"area\":[\"110000\",\"110100\"],\"step\":[\"\\uff08\\u8bc4\\u8bed\\u8bf7\\u52a0\\u5fae\\u4fe1\\u53f7377047364\\uff0c\\u5907\\u6ce8\\uff1a\\u767e\\u5ea6\\u53e3\\u7891+\\u4f60\\u7684\\u624b\\u673a\\u54c1\\u724c\\uff0c\\u5ba2\\u670d\\u901a\\u8fc7\\u4f60\\u7684\\u597d\\u53cb\\u9a8c\\u8bc1\\u53d1\\u8bc4\\u8bed\\u7ed9\\u4f60\\uff09\",\"\\u4e00\\u5b9a\\u8981\\u52a0\\u5ba2\\u670d\\u7b49\\u5ba2\\u670d\\u7ed9\\u4f60\\u8bc4\\u8bed\\u5728\\u505a\\u4efb\\u52a1\\uff0c\\u4e0d\\u662f\\u5ba2\\u670d\\u7ed9\\u7684\\u8bc4\\u8bed\\u4e0d\\u5408\\u683c\",\"\\uff08\\u590d\\u5236\\u6ce8\\u610f\\u4e8b\\u9879\\u4e2d\\u7684\\u94fe\\u63a5\\u5230\\u6d4f\\u89c8\\u5668\\u8fdb\\u5165\\uff0c\\u70b9\\u51fb\\u767b\\u9646\\u8d26\\u53f7\\uff0c\\u7ed9\\u4e94\\u661f\\u597d\\u8bc4+\\u8bc4\\u8bed+\\u4e0a\\u4f20\\u56fe\\u7247\\u5373\\u53ef\",\"\\uff08\\u9700\\u8981\\u6709\\u767e\\u5ea6\\u8d26\\u53f7\\uff0c\\u5982\\u5df2\\u6709\\u8d26\\u53f7\\uff0c\\u76f4\\u63a5\\u767b\\u5f55\\u8bc4\\u4ef7\\uff0c\\u5982\\u679c\\u6ca1\\u6709\\u81ea\\u884c\\u6ce8\\u518c\\u4e00\\u4e2a\\u53f7\",\"\\u4e00\\u4eba\\u53ea\\u80fd\\u8bc4\\u8bba\\u4e00\\u6b21\\uff0c\\u8bbe\\u7f6e\\u4e0d\\u9650\\u6b21\\u6570\\u662f\\u56e0\\u4e3a\\u6015\\u6709\\u7684\\u8d85\\u65f6\\u6ca1\\u529e\\u6cd5\\u63d0\\u4ea4\"],\"link\":\"www.baidu.com\",\"show_img\":[\"http:\\/\\/127.0.0.1:8001\\/upload\\/20190614\\/4c292520ae632633af81f9403a6e8576.png\",\"http:\\/\\/127.0.0.1:8001\\/upload\\/20190614\\/48603eff30e52d9ac393854553703710.png\"],\"take_care\":\"1\\uff0c\\u4e00\\u4e2a\\u624b\\u673a\\u53ea\\u80fd\\u6ce8\\u518c\\u4e00\\u6b21\\uff0c\\u6ce8\\u518c\\u8fc7\\u7684\\u7528\\u6237\\u4e0d\\u80fd\\u518d\\u6ce8\\u518c\\uff0c\\u65b0\\u7528\\u6237\\u6536\\u5230\\u501f\\u6761\\u989d\\u5ea6\\u901a\\u8fc7\\u901a\\u77e5\\u548c\\u6210\\u529f\\u501f\\u6b3e\\u7684\\u7528\\u6237\\u624d\\u6709\\u5956\\u52b1\\u30022\\uff0c\\u53ef\\u4ee5\\u968f\\u610f\\u501f\\u4e00\\u7b14\\u6b3e\\uff0c\\u51e0\\u5929\\u540e\\u8fd8\\u6b3e\\uff0c\\u5229\\u606f\\u6309\\u65e5\\u8ba1\\u7b97\\uff0c\\u7ea2\\u5305\\u53ef\\u4ee5\\u62b5\\u6263\\u5229\\u606f\\u3002\",\"device\":\"1\",\"submit_way\":\"1\",\"submit_notice\":\"1\\uff0c\\u5fc5\\u987b\\u626b\\u56fe\\u4e2d\\u4e8c\\u7ef4\\u7801\\u30022\\uff0c\\u6210\\u529f\\u4e4b\\u540e\\u5fc5\\u987b\\u6709\\u5f53\\u5929\\u8d60\\u9001\\u7684\\u5361\\u5238\",\"submit_img\":[]}', 'admin/Task/save');
INSERT INTO `admin_user_action` VALUES (277, '添加/编辑任务', 1, 'root', 1560448197, '{\"\\/admin\\/Task\\/save\":\"\",\"task_id\":0,\"task_type_id\":1,\"title\":\"\\u3010\\u767e\\u5ea6\\u53e3\\u7891\\u3011\\u597d\\u8bc4\\u5373\\u53ef\\u4e0d\\u4e0b\\u8f7d\",\"money\":\"100\",\"number\":\"10\",\"end_date\":\"2019-06-29T16:00:00.000Z\",\"check_duration\":\"72\",\"finish_duration\":\"2\",\"is_repeat\":\"1\",\"area\":[\"110000\",\"110100\"],\"step\":[\"\\uff08\\u8bc4\\u8bed\\u8bf7\\u52a0\\u5fae\\u4fe1\\u53f7377047364\\uff0c\\u5907\\u6ce8\\uff1a\\u767e\\u5ea6\\u53e3\\u7891+\\u4f60\\u7684\\u624b\\u673a\\u54c1\\u724c\\uff0c\\u5ba2\\u670d\\u901a\\u8fc7\\u4f60\\u7684\\u597d\\u53cb\\u9a8c\\u8bc1\\u53d1\\u8bc4\\u8bed\\u7ed9\\u4f60\\uff09\",\"\\u4e00\\u5b9a\\u8981\\u52a0\\u5ba2\\u670d\\u7b49\\u5ba2\\u670d\\u7ed9\\u4f60\\u8bc4\\u8bed\\u5728\\u505a\\u4efb\\u52a1\\uff0c\\u4e0d\\u662f\\u5ba2\\u670d\\u7ed9\\u7684\\u8bc4\\u8bed\\u4e0d\\u5408\\u683c\",\"\\uff08\\u590d\\u5236\\u6ce8\\u610f\\u4e8b\\u9879\\u4e2d\\u7684\\u94fe\\u63a5\\u5230\\u6d4f\\u89c8\\u5668\\u8fdb\\u5165\\uff0c\\u70b9\\u51fb\\u767b\\u9646\\u8d26\\u53f7\\uff0c\\u7ed9\\u4e94\\u661f\\u597d\\u8bc4+\\u8bc4\\u8bed+\\u4e0a\\u4f20\\u56fe\\u7247\\u5373\\u53ef\",\"\\uff08\\u9700\\u8981\\u6709\\u767e\\u5ea6\\u8d26\\u53f7\\uff0c\\u5982\\u5df2\\u6709\\u8d26\\u53f7\\uff0c\\u76f4\\u63a5\\u767b\\u5f55\\u8bc4\\u4ef7\\uff0c\\u5982\\u679c\\u6ca1\\u6709\\u81ea\\u884c\\u6ce8\\u518c\\u4e00\\u4e2a\\u53f7\",\"\\u4e00\\u4eba\\u53ea\\u80fd\\u8bc4\\u8bba\\u4e00\\u6b21\\uff0c\\u8bbe\\u7f6e\\u4e0d\\u9650\\u6b21\\u6570\\u662f\\u56e0\\u4e3a\\u6015\\u6709\\u7684\\u8d85\\u65f6\\u6ca1\\u529e\\u6cd5\\u63d0\\u4ea4\"],\"link\":\"www.baidu.com\",\"show_img\":[\"http:\\/\\/127.0.0.1:8001\\/upload\\/20190614\\/4c292520ae632633af81f9403a6e8576.png\",\"http:\\/\\/127.0.0.1:8001\\/upload\\/20190614\\/48603eff30e52d9ac393854553703710.png\"],\"take_care\":\"1\\u3001\\u4e00\\u4e2a\\u624b\\u673a\\u53ea\\u80fd\\u6ce8\\u518c\\u4e00\\u6b21\\uff0c\\u6ce8\\u518c\\u8fc7\\u7684\\u7528\\u6237\\u4e0d\\u80fd\\u518d\\u6ce8\\u518c\\uff0c\\u65b0\\u7528\\u6237\\u6536\\u5230\\u501f\\u6761\\u989d\\u5ea6\\u901a\\u8fc7\\u901a\\u77e5\\u548c\\u6210\\u529f\\u501f\\u6b3e\\u7684\\u7528\\u6237\\u624d\\u6709\\u5956\\u52b1\\uff1b\\n2\\u3001\\u53ef\\u4ee5\\u968f\\u610f\\u501f\\u4e00\\u7b14\\u6b3e\\uff0c\\u51e0\\u5929\\u540e\\u8fd8\\u6b3e\\uff0c\\u5229\\u606f\\u6309\\u65e5\\u8ba1\\u7b97\\uff0c\\u7ea2\\u5305\\u53ef\\u4ee5\\u62b5\\u6263\\u5229\\u606f\\uff1b\",\"device\":\"1\",\"submit_way\":\"1\",\"submit_notice\":\"1\\u3001\\u5fc5\\u987b\\u626b\\u56fe\\u4e2d\\u4e8c\\u7ef4\\u7801\\uff1b\\n2\\u3001\\u6210\\u529f\\u4e4b\\u540e\\u5fc5\\u987b\\u6709\\u5f53\\u5929\\u8d60\\u9001\\u7684\\u5361\\u5238\\uff1b\",\"submit_img\":[]}', 'admin/Task/save');
INSERT INTO `admin_user_action` VALUES (278, '添加/编辑任务', 1, 'root', 1560448285, '{\"\\/admin\\/Task\\/save\":\"\",\"task_id\":0,\"task_type_id\":1,\"title\":\"\\u3010\\u767e\\u5ea6\\u53e3\\u7891\\u3011\\u597d\\u8bc4\\u5373\\u53ef\\u4e0d\\u4e0b\\u8f7d\",\"money\":\"100\",\"number\":\"10\",\"end_date\":\"2019-06-29T16:00:00.000Z\",\"check_duration\":\"72\",\"finish_duration\":\"2\",\"is_repeat\":\"1\",\"area\":[\"110000\",\"110100\"],\"step\":[\"\\uff08\\u8bc4\\u8bed\\u8bf7\\u52a0\\u5fae\\u4fe1\\u53f7377047364\\uff0c\\u5907\\u6ce8\\uff1a\\u767e\\u5ea6\\u53e3\\u7891+\\u4f60\\u7684\\u624b\\u673a\\u54c1\\u724c\\uff0c\\u5ba2\\u670d\\u901a\\u8fc7\\u4f60\\u7684\\u597d\\u53cb\\u9a8c\\u8bc1\\u53d1\\u8bc4\\u8bed\\u7ed9\\u4f60\\uff09\",\"\\u4e00\\u5b9a\\u8981\\u52a0\\u5ba2\\u670d\\u7b49\\u5ba2\\u670d\\u7ed9\\u4f60\\u8bc4\\u8bed\\u5728\\u505a\\u4efb\\u52a1\\uff0c\\u4e0d\\u662f\\u5ba2\\u670d\\u7ed9\\u7684\\u8bc4\\u8bed\\u4e0d\\u5408\\u683c\",\"\\uff08\\u590d\\u5236\\u6ce8\\u610f\\u4e8b\\u9879\\u4e2d\\u7684\\u94fe\\u63a5\\u5230\\u6d4f\\u89c8\\u5668\\u8fdb\\u5165\\uff0c\\u70b9\\u51fb\\u767b\\u9646\\u8d26\\u53f7\\uff0c\\u7ed9\\u4e94\\u661f\\u597d\\u8bc4+\\u8bc4\\u8bed+\\u4e0a\\u4f20\\u56fe\\u7247\\u5373\\u53ef\",\"\\uff08\\u9700\\u8981\\u6709\\u767e\\u5ea6\\u8d26\\u53f7\\uff0c\\u5982\\u5df2\\u6709\\u8d26\\u53f7\\uff0c\\u76f4\\u63a5\\u767b\\u5f55\\u8bc4\\u4ef7\\uff0c\\u5982\\u679c\\u6ca1\\u6709\\u81ea\\u884c\\u6ce8\\u518c\\u4e00\\u4e2a\\u53f7\",\"\\u4e00\\u4eba\\u53ea\\u80fd\\u8bc4\\u8bba\\u4e00\\u6b21\\uff0c\\u8bbe\\u7f6e\\u4e0d\\u9650\\u6b21\\u6570\\u662f\\u56e0\\u4e3a\\u6015\\u6709\\u7684\\u8d85\\u65f6\\u6ca1\\u529e\\u6cd5\\u63d0\\u4ea4\"],\"link\":\"www.baidu.com\",\"show_img\":[\"http:\\/\\/127.0.0.1:8001\\/upload\\/20190614\\/4c292520ae632633af81f9403a6e8576.png\",\"http:\\/\\/127.0.0.1:8001\\/upload\\/20190614\\/48603eff30e52d9ac393854553703710.png\"],\"take_care\":\"1\\u3001\\u4e00\\u4e2a\\u624b\\u673a\\u53ea\\u80fd\\u6ce8\\u518c\\u4e00\\u6b21\\uff0c\\u6ce8\\u518c\\u8fc7\\u7684\\u7528\\u6237\\u4e0d\\u80fd\\u518d\\u6ce8\\u518c\\uff0c\\u65b0\\u7528\\u6237\\u6536\\u5230\\u501f\\u6761\\u989d\\u5ea6\\u901a\\u8fc7\\u901a\\u77e5\\u548c\\u6210\\u529f\\u501f\\u6b3e\\u7684\\u7528\\u6237\\u624d\\u6709\\u5956\\u52b1\\uff1b\\n2\\u3001\\u53ef\\u4ee5\\u968f\\u610f\\u501f\\u4e00\\u7b14\\u6b3e\\uff0c\\u51e0\\u5929\\u540e\\u8fd8\\u6b3e\\uff0c\\u5229\\u606f\\u6309\\u65e5\\u8ba1\\u7b97\\uff0c\\u7ea2\\u5305\\u53ef\\u4ee5\\u62b5\\u6263\\u5229\\u606f\\uff1b\",\"device\":\"1\",\"submit_way\":\"1\",\"submit_notice\":\"1\\u3001\\u5fc5\\u987b\\u626b\\u56fe\\u4e2d\\u4e8c\\u7ef4\\u7801\\uff1b\\n2\\u3001\\u6210\\u529f\\u4e4b\\u540e\\u5fc5\\u987b\\u6709\\u5f53\\u5929\\u8d60\\u9001\\u7684\\u5361\\u5238\\uff1b\",\"submit_img\":[]}', 'admin/Task/save');
INSERT INTO `admin_user_action` VALUES (279, '任务列表', 1, 'root', 1560448286, '{\"\\/admin\\/Task\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"task_type_id\\\":\\\"\\\",\\\"title\\\":\\\"\\\",\\\"is_repeat\\\":\\\"\\\",\\\"area\\\":[],\\\"device\\\":\\\"\\\",\\\"submit_way\\\":\\\"\\\",\\\"status\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\"}\"}', 'admin/Task/getList');
INSERT INTO `admin_user_action` VALUES (280, '任务列表', 1, 'root', 1560448330, '{\"\\/admin\\/Task\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"task_type_id\\\":\\\"\\\",\\\"title\\\":\\\"\\\",\\\"is_repeat\\\":\\\"\\\",\\\"area\\\":[],\\\"device\\\":\\\"\\\",\\\"submit_way\\\":\\\"\\\",\\\"status\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\"}\"}', 'admin/Task/getList');
INSERT INTO `admin_user_action` VALUES (281, '任务类型列表', 1, 'root', 1560448331, '{\"\\/admin\\/TaskType\\/getList\":\"\"}', 'admin/TaskType/getList');
INSERT INTO `admin_user_action` VALUES (282, '地区列表', 1, 'root', 1560448331, '{\"\\/admin\\/AreaCon\\/getList\":\"\"}', 'admin/AreaCon/getList');
INSERT INTO `admin_user_action` VALUES (283, '任务列表', 1, 'root', 1560448414, '{\"\\/admin\\/Task\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"task_type_id\\\":\\\"\\\",\\\"title\\\":\\\"\\\",\\\"is_repeat\\\":\\\"\\\",\\\"area\\\":[],\\\"device\\\":\\\"\\\",\\\"submit_way\\\":\\\"\\\",\\\"status\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\"}\"}', 'admin/Task/getList');
INSERT INTO `admin_user_action` VALUES (284, '任务类型列表', 1, 'root', 1560448414, '{\"\\/admin\\/TaskType\\/getList\":\"\"}', 'admin/TaskType/getList');
INSERT INTO `admin_user_action` VALUES (285, '地区列表', 1, 'root', 1560448414, '{\"\\/admin\\/AreaCon\\/getList\":\"\"}', 'admin/AreaCon/getList');
INSERT INTO `admin_user_action` VALUES (286, '接口列表', 1, 'root', 1560457919, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (287, '获取全部有效的接口组', 1, 'root', 1560457921, '{\"\\/admin\\/InterfaceGroup\\/getAll\":\"\"}', 'admin/InterfaceGroup/getAll');
INSERT INTO `admin_user_action` VALUES (288, '获取接口唯一标识', 1, 'root', 1560457921, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (289, '添加接口', 1, 'root', 1560457949, '{\"\\/admin\\/InterfaceList\\/add\":\"\",\"apiClass\":\"UserNotice\\/noticeList\",\"info\":\"\\u7528\\u6237\\u6d88\\u606f\\u5217\\u8868\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d02b2c1a7b23\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":0}', 'admin/InterfaceList/add');
INSERT INTO `admin_user_action` VALUES (290, '接口列表', 1, 'root', 1560457949, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (291, '刷新路由', 1, 'root', 1560457951, '{\"\\/admin\\/InterfaceList\\/refresh\":\"\"}', 'admin/InterfaceList/refresh');
INSERT INTO `admin_user_action` VALUES (292, '用户列表', 1, 'root', 1560458088, '{\"\\/admin\\/UserCon\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"nickname\\\":\\\"\\\",\\\"phone\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\",\\\"user_id\\\":\\\"\\\",\\\"level\\\":\\\"\\\"}\"}', 'admin/UserCon/getList');
INSERT INTO `admin_user_action` VALUES (293, '添加/编辑用户消息列表', 1, 'root', 1560458094, '{\"\\/admin\\/UserNotice\\/save\":\"\",\"user_id\":\"03\",\"title\":\"12\",\"content\":\"123123123\"}', 'admin/UserNotice/save');
INSERT INTO `admin_user_action` VALUES (294, '用户列表', 1, 'root', 1560458094, '{\"\\/admin\\/UserCon\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"nickname\\\":\\\"\\\",\\\"phone\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\",\\\"user_id\\\":\\\"\\\",\\\"level\\\":\\\"\\\"}\"}', 'admin/UserCon/getList');
INSERT INTO `admin_user_action` VALUES (295, '提现列表', 1, 'root', 1560458301, '{\"\\/admin\\/Withdraw\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"nickname\\\":\\\"\\\",\\\"withdraw_way_id\\\":\\\"\\\",\\\"account\\\":\\\"\\\",\\\"status\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\"}\"}', 'admin/Withdraw/getList');
INSERT INTO `admin_user_action` VALUES (296, '接口列表', 1, 'root', 1560458684, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (297, '获取全部有效的接口组', 1, 'root', 1560458690, '{\"\\/admin\\/InterfaceGroup\\/getAll\":\"\"}', 'admin/InterfaceGroup/getAll');
INSERT INTO `admin_user_action` VALUES (298, '编辑接口', 1, 'root', 1560458698, '{\"\\/admin\\/InterfaceList\\/edit\":\"\",\"apiClass\":\"WithDraw\\/withdrawList\",\"info\":\"\\u7528\\u6237\\u63d0\\u73b0\\u5217\\u8868\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d0287e451a4c\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":13}', 'admin/InterfaceList/edit');
INSERT INTO `admin_user_action` VALUES (299, '接口列表', 1, 'root', 1560458698, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (300, '接口列表', 1, 'root', 1560458701, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (301, '刷新路由', 1, 'root', 1560458703, '{\"\\/admin\\/InterfaceList\\/refresh\":\"\"}', 'admin/InterfaceList/refresh');
INSERT INTO `admin_user_action` VALUES (302, '用户任务列表', 1, 'root', 1560483139, '{\"\\/admin\\/UserTask\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"nickname\\\":\\\"\\\",\\\"title\\\":\\\"\\\",\\\"submit_time\\\":\\\"\\\",\\\"check_time\\\":\\\"\\\",\\\"status\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\"}\"}', 'admin/UserTask/getList');
INSERT INTO `admin_user_action` VALUES (303, '任务列表', 1, 'root', 1560483157, '{\"\\/admin\\/Task\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"task_type_id\\\":\\\"\\\",\\\"title\\\":\\\"\\\",\\\"is_repeat\\\":\\\"\\\",\\\"area\\\":[],\\\"device\\\":\\\"\\\",\\\"submit_way\\\":\\\"\\\",\\\"status\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\"}\"}', 'admin/Task/getList');
INSERT INTO `admin_user_action` VALUES (304, '地区列表', 1, 'root', 1560483158, '{\"\\/admin\\/AreaCon\\/getList\":\"\"}', 'admin/AreaCon/getList');
INSERT INTO `admin_user_action` VALUES (305, '任务类型列表', 1, 'root', 1560483158, '{\"\\/admin\\/TaskType\\/getList\":\"\"}', 'admin/TaskType/getList');
INSERT INTO `admin_user_action` VALUES (306, '接口列表', 1, 'root', 1560508783, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (307, '获取接口唯一标识', 1, 'root', 1560508789, '{\"\\/admin\\/InterfaceList\\/getHash\":\"\"}', 'admin/InterfaceList/getHash');
INSERT INTO `admin_user_action` VALUES (308, '获取全部有效的接口组', 1, 'root', 1560508789, '{\"\\/admin\\/InterfaceGroup\\/getAll\":\"\"}', 'admin/InterfaceGroup/getAll');
INSERT INTO `admin_user_action` VALUES (309, '添加接口', 1, 'root', 1560508810, '{\"\\/admin\\/InterfaceList\\/add\":\"\",\"apiClass\":\"UserTask\\/taskDetails\",\"info\":\"\\u7528\\u6237\\u4efb\\u52a1\\u8be6\\u60c5\",\"groupHash\":\"default\",\"method\":0,\"hash\":\"5d0379759b283\",\"accessToken\":0,\"isTest\":1,\"needLogin\":0,\"id\":0}', 'admin/InterfaceList/add');
INSERT INTO `admin_user_action` VALUES (310, '接口列表', 1, 'root', 1560508810, '{\"\\/admin\\/InterfaceList\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceList/index');
INSERT INTO `admin_user_action` VALUES (311, '刷新路由', 1, 'root', 1560508813, '{\"\\/admin\\/InterfaceList\\/refresh\":\"\"}', 'admin/InterfaceList/refresh');
INSERT INTO `admin_user_action` VALUES (312, '接口分组列表', 1, 'root', 1560512388, '{\"\\/admin\\/InterfaceGroup\\/index\":\"\",\"page\":\"1\",\"size\":\"10\",\"type\":\"\",\"keywords\":\"\",\"status\":\"\"}', 'admin/InterfaceGroup/index');
INSERT INTO `admin_user_action` VALUES (313, '地区列表', 1, 'root', 1560512391, '{\"\\/admin\\/AreaCon\\/getList\":\"\"}', 'admin/AreaCon/getList');
INSERT INTO `admin_user_action` VALUES (314, '任务类型列表', 1, 'root', 1560512391, '{\"\\/admin\\/TaskType\\/getList\":\"\"}', 'admin/TaskType/getList');
INSERT INTO `admin_user_action` VALUES (315, '任务列表', 1, 'root', 1560512391, '{\"\\/admin\\/Task\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"task_type_id\\\":\\\"\\\",\\\"title\\\":\\\"\\\",\\\"is_repeat\\\":\\\"\\\",\\\"area\\\":[],\\\"device\\\":\\\"\\\",\\\"submit_way\\\":\\\"\\\",\\\"status\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\"}\"}', 'admin/Task/getList');
INSERT INTO `admin_user_action` VALUES (316, '用户任务列表', 1, 'root', 1560512395, '{\"\\/admin\\/UserTask\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"task_id\\\":2,\\\"status\\\":1}\"}', 'admin/UserTask/getList');
INSERT INTO `admin_user_action` VALUES (317, '用户任务列表', 1, 'root', 1560512401, '{\"\\/admin\\/UserTask\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"task_id\\\":2,\\\"status\\\":2}\"}', 'admin/UserTask/getList');
INSERT INTO `admin_user_action` VALUES (318, '用户任务列表', 1, 'root', 1560512403, '{\"\\/admin\\/UserTask\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"task_id\\\":2,\\\"status\\\":3}\"}', 'admin/UserTask/getList');
INSERT INTO `admin_user_action` VALUES (319, '任务列表', 1, 'root', 1560512409, '{\"\\/admin\\/Task\\/getList\":\"\",\"page\":\"2\",\"size\":\"10\",\"searchConf\":\"{\\\"task_type_id\\\":\\\"\\\",\\\"title\\\":\\\"\\\",\\\"is_repeat\\\":\\\"\\\",\\\"area\\\":[],\\\"device\\\":\\\"\\\",\\\"submit_way\\\":\\\"\\\",\\\"status\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\"}\"}', 'admin/Task/getList');
INSERT INTO `admin_user_action` VALUES (320, '任务列表', 1, 'root', 1560512412, '{\"\\/admin\\/Task\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"task_type_id\\\":\\\"\\\",\\\"title\\\":\\\"\\\",\\\"is_repeat\\\":\\\"\\\",\\\"area\\\":[],\\\"device\\\":\\\"\\\",\\\"submit_way\\\":\\\"\\\",\\\"status\\\":\\\"\\\",\\\"gmt_create\\\":\\\"\\\"}\"}', 'admin/Task/getList');
INSERT INTO `admin_user_action` VALUES (321, '用户任务列表', 1, 'root', 1560512453, '{\"\\/admin\\/UserTask\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"task_id\\\":2,\\\"status\\\":1}\"}', 'admin/UserTask/getList');
INSERT INTO `admin_user_action` VALUES (322, '任务类型列表', 1, 'root', 1560512463, '{\"\\/admin\\/TaskType\\/getList\":\"\",\"page\":\"1\",\"size\":\"10\",\"searchConf\":\"{\\\"name\\\":\\\"\\\",\\\"status\\\":\\\"\\\"}\"}', 'admin/TaskType/getList');

-- ----------------------------
-- Table structure for admin_user_data
-- ----------------------------
DROP TABLE IF EXISTS `admin_user_data`;
CREATE TABLE `admin_user_data`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `loginTimes` int(11) NOT NULL DEFAULT 0 COMMENT '账号登录次数',
  `lastLoginIp` bigint(11) NOT NULL DEFAULT 0 COMMENT '最后登录IP',
  `lastLoginTime` int(11) NOT NULL DEFAULT 0 COMMENT '最后登录时间',
  `uid` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户ID',
  `headImg` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '用户头像',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin_user_data
-- ----------------------------
INSERT INTO `admin_user_data` VALUES (1, 7, 2130706433, 1560508777, '1', '');

-- ----------------------------
-- Table structure for area
-- ----------------------------
DROP TABLE IF EXISTS `area`;
CREATE TABLE `area`  (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '地区Id',
  `code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '地区编码',
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '地区名',
  `level` tinyint(4) NULL DEFAULT -1 COMMENT '地区级别（1:省份province,2:市city,3:区县district）',
  `pid` int(20) NULL DEFAULT -1 COMMENT '地区父节点',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `areaCode`(`code`) USING BTREE,
  INDEX `parentId`(`pid`) USING BTREE,
  INDEX `level`(`level`) USING BTREE,
  INDEX `areaName`(`name`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 3260 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '地区码表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of area
-- ----------------------------
INSERT INTO `area` VALUES (1, '110000', '北京市', 1, -1);
INSERT INTO `area` VALUES (2, '110100', '北京城区', 2, 1);
INSERT INTO `area` VALUES (3, '110101', '东城区', 3, 2);
INSERT INTO `area` VALUES (4, '110102', '西城区', 3, 2);
INSERT INTO `area` VALUES (5, '110105', '朝阳区', 3, 2);
INSERT INTO `area` VALUES (6, '110106', '丰台区', 3, 2);
INSERT INTO `area` VALUES (7, '110107', '石景山区', 3, 2);
INSERT INTO `area` VALUES (8, '110108', '海淀区', 3, 2);
INSERT INTO `area` VALUES (9, '110109', '门头沟区', 3, 2);
INSERT INTO `area` VALUES (10, '110111', '房山区', 3, 2);
INSERT INTO `area` VALUES (11, '110112', '通州区', 3, 2);
INSERT INTO `area` VALUES (12, '110113', '顺义区', 3, 2);
INSERT INTO `area` VALUES (13, '110114', '昌平区', 3, 2);
INSERT INTO `area` VALUES (14, '110115', '大兴区', 3, 2);
INSERT INTO `area` VALUES (15, '110116', '怀柔区', 3, 2);
INSERT INTO `area` VALUES (16, '110117', '平谷区', 3, 2);
INSERT INTO `area` VALUES (17, '110118', '密云区', 3, 2);
INSERT INTO `area` VALUES (18, '110119', '延庆区', 3, 2);
INSERT INTO `area` VALUES (19, '120000', '天津市', 1, -1);
INSERT INTO `area` VALUES (20, '120100', '天津城区', 2, 19);
INSERT INTO `area` VALUES (21, '120101', '和平区', 3, 20);
INSERT INTO `area` VALUES (22, '120102', '河东区', 3, 20);
INSERT INTO `area` VALUES (23, '120103', '河西区', 3, 20);
INSERT INTO `area` VALUES (24, '120104', '南开区', 3, 20);
INSERT INTO `area` VALUES (25, '120105', '河北区', 3, 20);
INSERT INTO `area` VALUES (26, '120106', '红桥区', 3, 20);
INSERT INTO `area` VALUES (27, '120110', '东丽区', 3, 20);
INSERT INTO `area` VALUES (28, '120111', '西青区', 3, 20);
INSERT INTO `area` VALUES (29, '120112', '津南区', 3, 20);
INSERT INTO `area` VALUES (30, '120113', '北辰区', 3, 20);
INSERT INTO `area` VALUES (31, '120114', '武清区', 3, 20);
INSERT INTO `area` VALUES (32, '120115', '宝坻区', 3, 20);
INSERT INTO `area` VALUES (33, '120116', '滨海新区', 3, 20);
INSERT INTO `area` VALUES (34, '120117', '宁河区', 3, 20);
INSERT INTO `area` VALUES (35, '120118', '静海区', 3, 20);
INSERT INTO `area` VALUES (36, '120119', '蓟州区', 3, 20);
INSERT INTO `area` VALUES (37, '130000', '河北省', 1, -1);
INSERT INTO `area` VALUES (38, '130100', '石家庄市', 2, 37);
INSERT INTO `area` VALUES (39, '130102', '长安区', 3, 38);
INSERT INTO `area` VALUES (40, '130104', '桥西区', 3, 38);
INSERT INTO `area` VALUES (41, '130105', '新华区', 3, 38);
INSERT INTO `area` VALUES (42, '130107', '井陉矿区', 3, 38);
INSERT INTO `area` VALUES (43, '130108', '裕华区', 3, 38);
INSERT INTO `area` VALUES (44, '130109', '藁城区', 3, 38);
INSERT INTO `area` VALUES (45, '130110', '鹿泉区', 3, 38);
INSERT INTO `area` VALUES (46, '130111', '栾城区', 3, 38);
INSERT INTO `area` VALUES (47, '130121', '井陉县', 3, 38);
INSERT INTO `area` VALUES (48, '130123', '正定县', 3, 38);
INSERT INTO `area` VALUES (49, '130125', '行唐县', 3, 38);
INSERT INTO `area` VALUES (50, '130126', '灵寿县', 3, 38);
INSERT INTO `area` VALUES (51, '130127', '高邑县', 3, 38);
INSERT INTO `area` VALUES (52, '130128', '深泽县', 3, 38);
INSERT INTO `area` VALUES (53, '130129', '赞皇县', 3, 38);
INSERT INTO `area` VALUES (54, '130130', '无极县', 3, 38);
INSERT INTO `area` VALUES (55, '130131', '平山县', 3, 38);
INSERT INTO `area` VALUES (56, '130132', '元氏县', 3, 38);
INSERT INTO `area` VALUES (57, '130133', '赵县', 3, 38);
INSERT INTO `area` VALUES (58, '130181', '辛集市', 3, 38);
INSERT INTO `area` VALUES (59, '130183', '晋州市', 3, 38);
INSERT INTO `area` VALUES (60, '130184', '新乐市', 3, 38);
INSERT INTO `area` VALUES (61, '130200', '唐山市', 2, 37);
INSERT INTO `area` VALUES (62, '130202', '路南区', 3, 61);
INSERT INTO `area` VALUES (63, '130203', '路北区', 3, 61);
INSERT INTO `area` VALUES (64, '130204', '古冶区', 3, 61);
INSERT INTO `area` VALUES (65, '130205', '开平区', 3, 61);
INSERT INTO `area` VALUES (66, '130207', '丰南区', 3, 61);
INSERT INTO `area` VALUES (67, '130208', '丰润区', 3, 61);
INSERT INTO `area` VALUES (68, '130209', '曹妃甸区', 3, 61);
INSERT INTO `area` VALUES (69, '130223', '滦县', 3, 61);
INSERT INTO `area` VALUES (70, '130224', '滦南县', 3, 61);
INSERT INTO `area` VALUES (71, '130225', '乐亭县', 3, 61);
INSERT INTO `area` VALUES (72, '130227', '迁西县', 3, 61);
INSERT INTO `area` VALUES (73, '130229', '玉田县', 3, 61);
INSERT INTO `area` VALUES (74, '130281', '遵化市', 3, 61);
INSERT INTO `area` VALUES (75, '130283', '迁安市', 3, 61);
INSERT INTO `area` VALUES (76, '130300', '秦皇岛市', 2, 37);
INSERT INTO `area` VALUES (77, '130302', '海港区', 3, 76);
INSERT INTO `area` VALUES (78, '130303', '山海关区', 3, 76);
INSERT INTO `area` VALUES (79, '130304', '北戴河区', 3, 76);
INSERT INTO `area` VALUES (80, '130306', '抚宁区', 3, 76);
INSERT INTO `area` VALUES (81, '130321', '青龙满族自治县', 3, 76);
INSERT INTO `area` VALUES (82, '130322', '昌黎县', 3, 76);
INSERT INTO `area` VALUES (83, '130324', '卢龙县', 3, 76);
INSERT INTO `area` VALUES (84, '130400', '邯郸市', 2, 37);
INSERT INTO `area` VALUES (85, '130402', '邯山区', 3, 84);
INSERT INTO `area` VALUES (86, '130403', '丛台区', 3, 84);
INSERT INTO `area` VALUES (87, '130404', '复兴区', 3, 84);
INSERT INTO `area` VALUES (88, '130406', '峰峰矿区', 3, 84);
INSERT INTO `area` VALUES (89, '130423', '临漳县', 3, 84);
INSERT INTO `area` VALUES (90, '130424', '成安县', 3, 84);
INSERT INTO `area` VALUES (91, '130425', '大名县', 3, 84);
INSERT INTO `area` VALUES (92, '130426', '涉县', 3, 84);
INSERT INTO `area` VALUES (93, '130427', '磁县', 3, 84);
INSERT INTO `area` VALUES (94, '130407', '肥乡区', 3, 84);
INSERT INTO `area` VALUES (95, '130408', '永年区', 3, 84);
INSERT INTO `area` VALUES (96, '130430', '邱县', 3, 84);
INSERT INTO `area` VALUES (97, '130431', '鸡泽县', 3, 84);
INSERT INTO `area` VALUES (98, '130432', '广平县', 3, 84);
INSERT INTO `area` VALUES (99, '130433', '馆陶县', 3, 84);
INSERT INTO `area` VALUES (100, '130434', '魏县', 3, 84);
INSERT INTO `area` VALUES (101, '130435', '曲周县', 3, 84);
INSERT INTO `area` VALUES (102, '130481', '武安市', 3, 84);
INSERT INTO `area` VALUES (103, '130500', '邢台市', 2, 37);
INSERT INTO `area` VALUES (104, '130502', '桥东区', 3, 103);
INSERT INTO `area` VALUES (105, '130503', '桥西区', 3, 103);
INSERT INTO `area` VALUES (106, '130521', '邢台县', 3, 103);
INSERT INTO `area` VALUES (107, '130522', '临城县', 3, 103);
INSERT INTO `area` VALUES (108, '130523', '内丘县', 3, 103);
INSERT INTO `area` VALUES (109, '130524', '柏乡县', 3, 103);
INSERT INTO `area` VALUES (110, '130525', '隆尧县', 3, 103);
INSERT INTO `area` VALUES (111, '130526', '任县', 3, 103);
INSERT INTO `area` VALUES (112, '130527', '南和县', 3, 103);
INSERT INTO `area` VALUES (113, '130528', '宁晋县', 3, 103);
INSERT INTO `area` VALUES (114, '130529', '巨鹿县', 3, 103);
INSERT INTO `area` VALUES (115, '130530', '新河县', 3, 103);
INSERT INTO `area` VALUES (116, '130531', '广宗县', 3, 103);
INSERT INTO `area` VALUES (117, '130532', '平乡县', 3, 103);
INSERT INTO `area` VALUES (118, '130533', '威县', 3, 103);
INSERT INTO `area` VALUES (119, '130534', '清河县', 3, 103);
INSERT INTO `area` VALUES (120, '130535', '临西县', 3, 103);
INSERT INTO `area` VALUES (121, '130581', '南宫市', 3, 103);
INSERT INTO `area` VALUES (122, '130582', '沙河市', 3, 103);
INSERT INTO `area` VALUES (123, '130600', '保定市', 2, 37);
INSERT INTO `area` VALUES (124, '130602', '竞秀区', 3, 123);
INSERT INTO `area` VALUES (125, '130606', '莲池区', 3, 123);
INSERT INTO `area` VALUES (126, '130607', '满城区', 3, 123);
INSERT INTO `area` VALUES (127, '130608', '清苑区', 3, 123);
INSERT INTO `area` VALUES (128, '130609', '徐水区', 3, 123);
INSERT INTO `area` VALUES (129, '130623', '涞水县', 3, 123);
INSERT INTO `area` VALUES (130, '130624', '阜平县', 3, 123);
INSERT INTO `area` VALUES (131, '130626', '定兴县', 3, 123);
INSERT INTO `area` VALUES (132, '130627', '唐县', 3, 123);
INSERT INTO `area` VALUES (133, '130628', '高阳县', 3, 123);
INSERT INTO `area` VALUES (134, '130629', '容城县', 3, 123);
INSERT INTO `area` VALUES (135, '130630', '涞源县', 3, 123);
INSERT INTO `area` VALUES (136, '130631', '望都县', 3, 123);
INSERT INTO `area` VALUES (137, '130632', '安新县', 3, 123);
INSERT INTO `area` VALUES (138, '130633', '易县', 3, 123);
INSERT INTO `area` VALUES (139, '130634', '曲阳县', 3, 123);
INSERT INTO `area` VALUES (140, '130635', '蠡县', 3, 123);
INSERT INTO `area` VALUES (141, '130636', '顺平县', 3, 123);
INSERT INTO `area` VALUES (142, '130637', '博野县', 3, 123);
INSERT INTO `area` VALUES (143, '130638', '雄县', 3, 123);
INSERT INTO `area` VALUES (144, '130681', '涿州市', 3, 123);
INSERT INTO `area` VALUES (145, '130682', '定州市', 3, 123);
INSERT INTO `area` VALUES (146, '130683', '安国市', 3, 123);
INSERT INTO `area` VALUES (147, '130684', '高碑店市', 3, 123);
INSERT INTO `area` VALUES (148, '130700', '张家口市', 2, 37);
INSERT INTO `area` VALUES (149, '130702', '桥东区', 3, 148);
INSERT INTO `area` VALUES (150, '130703', '桥西区', 3, 148);
INSERT INTO `area` VALUES (151, '130705', '宣化区', 3, 148);
INSERT INTO `area` VALUES (152, '130706', '下花园区', 3, 148);
INSERT INTO `area` VALUES (153, '130708', '万全区', 3, 148);
INSERT INTO `area` VALUES (154, '130709', '崇礼区', 3, 148);
INSERT INTO `area` VALUES (155, '130722', '张北县', 3, 148);
INSERT INTO `area` VALUES (156, '130723', '康保县', 3, 148);
INSERT INTO `area` VALUES (157, '130724', '沽源县', 3, 148);
INSERT INTO `area` VALUES (158, '130725', '尚义县', 3, 148);
INSERT INTO `area` VALUES (159, '130726', '蔚县', 3, 148);
INSERT INTO `area` VALUES (160, '130727', '阳原县', 3, 148);
INSERT INTO `area` VALUES (161, '130728', '怀安县', 3, 148);
INSERT INTO `area` VALUES (162, '130730', '怀来县', 3, 148);
INSERT INTO `area` VALUES (163, '130731', '涿鹿县', 3, 148);
INSERT INTO `area` VALUES (164, '130732', '赤城县', 3, 148);
INSERT INTO `area` VALUES (165, '130800', '承德市', 2, 37);
INSERT INTO `area` VALUES (166, '130802', '双桥区', 3, 165);
INSERT INTO `area` VALUES (167, '130803', '双滦区', 3, 165);
INSERT INTO `area` VALUES (168, '130804', '鹰手营子矿区', 3, 165);
INSERT INTO `area` VALUES (169, '130821', '承德县', 3, 165);
INSERT INTO `area` VALUES (170, '130822', '兴隆县', 3, 165);
INSERT INTO `area` VALUES (171, '130881', '平泉市', 3, 165);
INSERT INTO `area` VALUES (172, '130824', '滦平县', 3, 165);
INSERT INTO `area` VALUES (173, '130825', '隆化县', 3, 165);
INSERT INTO `area` VALUES (174, '130826', '丰宁满族自治县', 3, 165);
INSERT INTO `area` VALUES (175, '130827', '宽城满族自治县', 3, 165);
INSERT INTO `area` VALUES (176, '130828', '围场满族蒙古族自治县', 3, 165);
INSERT INTO `area` VALUES (177, '130900', '沧州市', 2, 37);
INSERT INTO `area` VALUES (178, '130902', '新华区', 3, 177);
INSERT INTO `area` VALUES (179, '130903', '运河区', 3, 177);
INSERT INTO `area` VALUES (180, '130921', '沧县', 3, 177);
INSERT INTO `area` VALUES (181, '130922', '青县', 3, 177);
INSERT INTO `area` VALUES (182, '130923', '东光县', 3, 177);
INSERT INTO `area` VALUES (183, '130924', '海兴县', 3, 177);
INSERT INTO `area` VALUES (184, '130925', '盐山县', 3, 177);
INSERT INTO `area` VALUES (185, '130926', '肃宁县', 3, 177);
INSERT INTO `area` VALUES (186, '130927', '南皮县', 3, 177);
INSERT INTO `area` VALUES (187, '130928', '吴桥县', 3, 177);
INSERT INTO `area` VALUES (188, '130929', '献县', 3, 177);
INSERT INTO `area` VALUES (189, '130930', '孟村回族自治县', 3, 177);
INSERT INTO `area` VALUES (190, '130981', '泊头市', 3, 177);
INSERT INTO `area` VALUES (191, '130982', '任丘市', 3, 177);
INSERT INTO `area` VALUES (192, '130983', '黄骅市', 3, 177);
INSERT INTO `area` VALUES (193, '130984', '河间市', 3, 177);
INSERT INTO `area` VALUES (194, '131000', '廊坊市', 2, 37);
INSERT INTO `area` VALUES (195, '131002', '安次区', 3, 194);
INSERT INTO `area` VALUES (196, '131003', '广阳区', 3, 194);
INSERT INTO `area` VALUES (197, '131022', '固安县', 3, 194);
INSERT INTO `area` VALUES (198, '131023', '永清县', 3, 194);
INSERT INTO `area` VALUES (199, '131024', '香河县', 3, 194);
INSERT INTO `area` VALUES (200, '131025', '大城县', 3, 194);
INSERT INTO `area` VALUES (201, '131026', '文安县', 3, 194);
INSERT INTO `area` VALUES (202, '131028', '大厂回族自治县', 3, 194);
INSERT INTO `area` VALUES (203, '131081', '霸州市', 3, 194);
INSERT INTO `area` VALUES (204, '131082', '三河市', 3, 194);
INSERT INTO `area` VALUES (205, '131100', '衡水市', 2, 37);
INSERT INTO `area` VALUES (206, '131102', '桃城区', 3, 205);
INSERT INTO `area` VALUES (207, '131103', '冀州区', 3, 205);
INSERT INTO `area` VALUES (208, '131121', '枣强县', 3, 205);
INSERT INTO `area` VALUES (209, '131122', '武邑县', 3, 205);
INSERT INTO `area` VALUES (210, '131123', '武强县', 3, 205);
INSERT INTO `area` VALUES (211, '131124', '饶阳县', 3, 205);
INSERT INTO `area` VALUES (212, '131125', '安平县', 3, 205);
INSERT INTO `area` VALUES (213, '131126', '故城县', 3, 205);
INSERT INTO `area` VALUES (214, '131127', '景县', 3, 205);
INSERT INTO `area` VALUES (215, '131128', '阜城县', 3, 205);
INSERT INTO `area` VALUES (216, '131182', '深州市', 3, 205);
INSERT INTO `area` VALUES (217, '140000', '山西省', 1, -1);
INSERT INTO `area` VALUES (218, '140100', '太原市', 2, 217);
INSERT INTO `area` VALUES (219, '140105', '小店区', 3, 218);
INSERT INTO `area` VALUES (220, '140106', '迎泽区', 3, 218);
INSERT INTO `area` VALUES (221, '140107', '杏花岭区', 3, 218);
INSERT INTO `area` VALUES (222, '140108', '尖草坪区', 3, 218);
INSERT INTO `area` VALUES (223, '140109', '万柏林区', 3, 218);
INSERT INTO `area` VALUES (224, '140110', '晋源区', 3, 218);
INSERT INTO `area` VALUES (225, '140121', '清徐县', 3, 218);
INSERT INTO `area` VALUES (226, '140122', '阳曲县', 3, 218);
INSERT INTO `area` VALUES (227, '140123', '娄烦县', 3, 218);
INSERT INTO `area` VALUES (228, '140181', '古交市', 3, 218);
INSERT INTO `area` VALUES (229, '140200', '大同市', 2, 217);
INSERT INTO `area` VALUES (230, '140202', '城区', 3, 229);
INSERT INTO `area` VALUES (231, '140203', '矿区', 3, 229);
INSERT INTO `area` VALUES (232, '140211', '南郊区', 3, 229);
INSERT INTO `area` VALUES (233, '140212', '新荣区', 3, 229);
INSERT INTO `area` VALUES (234, '140221', '阳高县', 3, 229);
INSERT INTO `area` VALUES (235, '140222', '天镇县', 3, 229);
INSERT INTO `area` VALUES (236, '140223', '广灵县', 3, 229);
INSERT INTO `area` VALUES (237, '140224', '灵丘县', 3, 229);
INSERT INTO `area` VALUES (238, '140225', '浑源县', 3, 229);
INSERT INTO `area` VALUES (239, '140226', '左云县', 3, 229);
INSERT INTO `area` VALUES (240, '140227', '大同县', 3, 229);
INSERT INTO `area` VALUES (241, '140300', '阳泉市', 2, 217);
INSERT INTO `area` VALUES (242, '140302', '城区', 3, 241);
INSERT INTO `area` VALUES (243, '140303', '矿区', 3, 241);
INSERT INTO `area` VALUES (244, '140311', '郊区', 3, 241);
INSERT INTO `area` VALUES (245, '140321', '平定县', 3, 241);
INSERT INTO `area` VALUES (246, '140322', '盂县', 3, 241);
INSERT INTO `area` VALUES (247, '140400', '长治市', 2, 217);
INSERT INTO `area` VALUES (248, '140402', '城区', 3, 247);
INSERT INTO `area` VALUES (249, '140411', '郊区', 3, 247);
INSERT INTO `area` VALUES (250, '140421', '长治县', 3, 247);
INSERT INTO `area` VALUES (251, '140423', '襄垣县', 3, 247);
INSERT INTO `area` VALUES (252, '140424', '屯留县', 3, 247);
INSERT INTO `area` VALUES (253, '140425', '平顺县', 3, 247);
INSERT INTO `area` VALUES (254, '140426', '黎城县', 3, 247);
INSERT INTO `area` VALUES (255, '140427', '壶关县', 3, 247);
INSERT INTO `area` VALUES (256, '140428', '长子县', 3, 247);
INSERT INTO `area` VALUES (257, '140429', '武乡县', 3, 247);
INSERT INTO `area` VALUES (258, '140430', '沁县', 3, 247);
INSERT INTO `area` VALUES (259, '140431', '沁源县', 3, 247);
INSERT INTO `area` VALUES (260, '140481', '潞城市', 3, 247);
INSERT INTO `area` VALUES (261, '140500', '晋城市', 2, 217);
INSERT INTO `area` VALUES (262, '140502', '城区', 3, 261);
INSERT INTO `area` VALUES (263, '140521', '沁水县', 3, 261);
INSERT INTO `area` VALUES (264, '140522', '阳城县', 3, 261);
INSERT INTO `area` VALUES (265, '140524', '陵川县', 3, 261);
INSERT INTO `area` VALUES (266, '140525', '泽州县', 3, 261);
INSERT INTO `area` VALUES (267, '140581', '高平市', 3, 261);
INSERT INTO `area` VALUES (268, '140600', '朔州市', 2, 217);
INSERT INTO `area` VALUES (269, '140602', '朔城区', 3, 268);
INSERT INTO `area` VALUES (270, '140603', '平鲁区', 3, 268);
INSERT INTO `area` VALUES (271, '140621', '山阴县', 3, 268);
INSERT INTO `area` VALUES (272, '140622', '应县', 3, 268);
INSERT INTO `area` VALUES (273, '140623', '右玉县', 3, 268);
INSERT INTO `area` VALUES (274, '140624', '怀仁县', 3, 268);
INSERT INTO `area` VALUES (275, '140700', '晋中市', 2, 217);
INSERT INTO `area` VALUES (276, '140702', '榆次区', 3, 275);
INSERT INTO `area` VALUES (277, '140721', '榆社县', 3, 275);
INSERT INTO `area` VALUES (278, '140722', '左权县', 3, 275);
INSERT INTO `area` VALUES (279, '140723', '和顺县', 3, 275);
INSERT INTO `area` VALUES (280, '140724', '昔阳县', 3, 275);
INSERT INTO `area` VALUES (281, '140725', '寿阳县', 3, 275);
INSERT INTO `area` VALUES (282, '140726', '太谷县', 3, 275);
INSERT INTO `area` VALUES (283, '140727', '祁县', 3, 275);
INSERT INTO `area` VALUES (284, '140728', '平遥县', 3, 275);
INSERT INTO `area` VALUES (285, '140729', '灵石县', 3, 275);
INSERT INTO `area` VALUES (286, '140781', '介休市', 3, 275);
INSERT INTO `area` VALUES (287, '140800', '运城市', 2, 217);
INSERT INTO `area` VALUES (288, '140802', '盐湖区', 3, 287);
INSERT INTO `area` VALUES (289, '140821', '临猗县', 3, 287);
INSERT INTO `area` VALUES (290, '140822', '万荣县', 3, 287);
INSERT INTO `area` VALUES (291, '140823', '闻喜县', 3, 287);
INSERT INTO `area` VALUES (292, '140824', '稷山县', 3, 287);
INSERT INTO `area` VALUES (293, '140825', '新绛县', 3, 287);
INSERT INTO `area` VALUES (294, '140826', '绛县', 3, 287);
INSERT INTO `area` VALUES (295, '140827', '垣曲县', 3, 287);
INSERT INTO `area` VALUES (296, '140828', '夏县', 3, 287);
INSERT INTO `area` VALUES (297, '140829', '平陆县', 3, 287);
INSERT INTO `area` VALUES (298, '140830', '芮城县', 3, 287);
INSERT INTO `area` VALUES (299, '140881', '永济市', 3, 287);
INSERT INTO `area` VALUES (300, '140882', '河津市', 3, 287);
INSERT INTO `area` VALUES (301, '140900', '忻州市', 2, 217);
INSERT INTO `area` VALUES (302, '140902', '忻府区', 3, 301);
INSERT INTO `area` VALUES (303, '140921', '定襄县', 3, 301);
INSERT INTO `area` VALUES (304, '140922', '五台县', 3, 301);
INSERT INTO `area` VALUES (305, '140923', '代县', 3, 301);
INSERT INTO `area` VALUES (306, '140924', '繁峙县', 3, 301);
INSERT INTO `area` VALUES (307, '140925', '宁武县', 3, 301);
INSERT INTO `area` VALUES (308, '140926', '静乐县', 3, 301);
INSERT INTO `area` VALUES (309, '140927', '神池县', 3, 301);
INSERT INTO `area` VALUES (310, '140928', '五寨县', 3, 301);
INSERT INTO `area` VALUES (311, '140929', '岢岚县', 3, 301);
INSERT INTO `area` VALUES (312, '140930', '河曲县', 3, 301);
INSERT INTO `area` VALUES (313, '140931', '保德县', 3, 301);
INSERT INTO `area` VALUES (314, '140932', '偏关县', 3, 301);
INSERT INTO `area` VALUES (315, '140981', '原平市', 3, 301);
INSERT INTO `area` VALUES (316, '141000', '临汾市', 2, 217);
INSERT INTO `area` VALUES (317, '141002', '尧都区', 3, 316);
INSERT INTO `area` VALUES (318, '141021', '曲沃县', 3, 316);
INSERT INTO `area` VALUES (319, '141022', '翼城县', 3, 316);
INSERT INTO `area` VALUES (320, '141023', '襄汾县', 3, 316);
INSERT INTO `area` VALUES (321, '141024', '洪洞县', 3, 316);
INSERT INTO `area` VALUES (322, '141025', '古县', 3, 316);
INSERT INTO `area` VALUES (323, '141026', '安泽县', 3, 316);
INSERT INTO `area` VALUES (324, '141027', '浮山县', 3, 316);
INSERT INTO `area` VALUES (325, '141028', '吉县', 3, 316);
INSERT INTO `area` VALUES (326, '141029', '乡宁县', 3, 316);
INSERT INTO `area` VALUES (327, '141030', '大宁县', 3, 316);
INSERT INTO `area` VALUES (328, '141031', '隰县', 3, 316);
INSERT INTO `area` VALUES (329, '141032', '永和县', 3, 316);
INSERT INTO `area` VALUES (330, '141033', '蒲县', 3, 316);
INSERT INTO `area` VALUES (331, '141034', '汾西县', 3, 316);
INSERT INTO `area` VALUES (332, '141081', '侯马市', 3, 316);
INSERT INTO `area` VALUES (333, '141082', '霍州市', 3, 316);
INSERT INTO `area` VALUES (334, '141100', '吕梁市', 2, 217);
INSERT INTO `area` VALUES (335, '141102', '离石区', 3, 334);
INSERT INTO `area` VALUES (336, '141121', '文水县', 3, 334);
INSERT INTO `area` VALUES (337, '141122', '交城县', 3, 334);
INSERT INTO `area` VALUES (338, '141123', '兴县', 3, 334);
INSERT INTO `area` VALUES (339, '141124', '临县', 3, 334);
INSERT INTO `area` VALUES (340, '141125', '柳林县', 3, 334);
INSERT INTO `area` VALUES (341, '141126', '石楼县', 3, 334);
INSERT INTO `area` VALUES (342, '141127', '岚县', 3, 334);
INSERT INTO `area` VALUES (343, '141128', '方山县', 3, 334);
INSERT INTO `area` VALUES (344, '141129', '中阳县', 3, 334);
INSERT INTO `area` VALUES (345, '141130', '交口县', 3, 334);
INSERT INTO `area` VALUES (346, '141181', '孝义市', 3, 334);
INSERT INTO `area` VALUES (347, '141182', '汾阳市', 3, 334);
INSERT INTO `area` VALUES (348, '150000', '内蒙古自治区', 1, -1);
INSERT INTO `area` VALUES (349, '150100', '呼和浩特市', 2, 348);
INSERT INTO `area` VALUES (350, '150102', '新城区', 3, 349);
INSERT INTO `area` VALUES (351, '150103', '回民区', 3, 349);
INSERT INTO `area` VALUES (352, '150104', '玉泉区', 3, 349);
INSERT INTO `area` VALUES (353, '150105', '赛罕区', 3, 349);
INSERT INTO `area` VALUES (354, '150121', '土默特左旗', 3, 349);
INSERT INTO `area` VALUES (355, '150122', '托克托县', 3, 349);
INSERT INTO `area` VALUES (356, '150123', '和林格尔县', 3, 349);
INSERT INTO `area` VALUES (357, '150124', '清水河县', 3, 349);
INSERT INTO `area` VALUES (358, '150125', '武川县', 3, 349);
INSERT INTO `area` VALUES (359, '150200', '包头市', 2, 348);
INSERT INTO `area` VALUES (360, '150202', '东河区', 3, 359);
INSERT INTO `area` VALUES (361, '150203', '昆都仑区', 3, 359);
INSERT INTO `area` VALUES (362, '150204', '青山区', 3, 359);
INSERT INTO `area` VALUES (363, '150205', '石拐区', 3, 359);
INSERT INTO `area` VALUES (364, '150206', '白云鄂博矿区', 3, 359);
INSERT INTO `area` VALUES (365, '150207', '九原区', 3, 359);
INSERT INTO `area` VALUES (366, '150221', '土默特右旗', 3, 359);
INSERT INTO `area` VALUES (367, '150222', '固阳县', 3, 359);
INSERT INTO `area` VALUES (368, '150223', '达尔罕茂明安联合旗', 3, 359);
INSERT INTO `area` VALUES (369, '150300', '乌海市', 2, 348);
INSERT INTO `area` VALUES (370, '150302', '海勃湾区', 3, 369);
INSERT INTO `area` VALUES (371, '150303', '海南区', 3, 369);
INSERT INTO `area` VALUES (372, '150304', '乌达区', 3, 369);
INSERT INTO `area` VALUES (373, '150400', '赤峰市', 2, 348);
INSERT INTO `area` VALUES (374, '150402', '红山区', 3, 373);
INSERT INTO `area` VALUES (375, '150403', '元宝山区', 3, 373);
INSERT INTO `area` VALUES (376, '150404', '松山区', 3, 373);
INSERT INTO `area` VALUES (377, '150421', '阿鲁科尔沁旗', 3, 373);
INSERT INTO `area` VALUES (378, '150422', '巴林左旗', 3, 373);
INSERT INTO `area` VALUES (379, '150423', '巴林右旗', 3, 373);
INSERT INTO `area` VALUES (380, '150424', '林西县', 3, 373);
INSERT INTO `area` VALUES (381, '150425', '克什克腾旗', 3, 373);
INSERT INTO `area` VALUES (382, '150426', '翁牛特旗', 3, 373);
INSERT INTO `area` VALUES (383, '150428', '喀喇沁旗', 3, 373);
INSERT INTO `area` VALUES (384, '150429', '宁城县', 3, 373);
INSERT INTO `area` VALUES (385, '150430', '敖汉旗', 3, 373);
INSERT INTO `area` VALUES (386, '150500', '通辽市', 2, 348);
INSERT INTO `area` VALUES (387, '150502', '科尔沁区', 3, 386);
INSERT INTO `area` VALUES (388, '150521', '科尔沁左翼中旗', 3, 386);
INSERT INTO `area` VALUES (389, '150522', '科尔沁左翼后旗', 3, 386);
INSERT INTO `area` VALUES (390, '150523', '开鲁县', 3, 386);
INSERT INTO `area` VALUES (391, '150524', '库伦旗', 3, 386);
INSERT INTO `area` VALUES (392, '150525', '奈曼旗', 3, 386);
INSERT INTO `area` VALUES (393, '150526', '扎鲁特旗', 3, 386);
INSERT INTO `area` VALUES (394, '150581', '霍林郭勒市', 3, 386);
INSERT INTO `area` VALUES (395, '150600', '鄂尔多斯市', 2, 348);
INSERT INTO `area` VALUES (396, '150602', '东胜区', 3, 395);
INSERT INTO `area` VALUES (397, '150603', '康巴什区', 3, 395);
INSERT INTO `area` VALUES (398, '150621', '达拉特旗', 3, 395);
INSERT INTO `area` VALUES (399, '150622', '准格尔旗', 3, 395);
INSERT INTO `area` VALUES (400, '150623', '鄂托克前旗', 3, 395);
INSERT INTO `area` VALUES (401, '150624', '鄂托克旗', 3, 395);
INSERT INTO `area` VALUES (402, '150625', '杭锦旗', 3, 395);
INSERT INTO `area` VALUES (403, '150626', '乌审旗', 3, 395);
INSERT INTO `area` VALUES (404, '150627', '伊金霍洛旗', 3, 395);
INSERT INTO `area` VALUES (405, '150700', '呼伦贝尔市', 2, 348);
INSERT INTO `area` VALUES (406, '150702', '海拉尔区', 3, 405);
INSERT INTO `area` VALUES (407, '150703', '扎赉诺尔区', 3, 405);
INSERT INTO `area` VALUES (408, '150721', '阿荣旗', 3, 405);
INSERT INTO `area` VALUES (409, '150722', '莫力达瓦达斡尔族自治旗', 3, 405);
INSERT INTO `area` VALUES (410, '150723', '鄂伦春自治旗', 3, 405);
INSERT INTO `area` VALUES (411, '150724', '鄂温克族自治旗', 3, 405);
INSERT INTO `area` VALUES (412, '150725', '陈巴尔虎旗', 3, 405);
INSERT INTO `area` VALUES (413, '150726', '新巴尔虎左旗', 3, 405);
INSERT INTO `area` VALUES (414, '150727', '新巴尔虎右旗', 3, 405);
INSERT INTO `area` VALUES (415, '150781', '满洲里市', 3, 405);
INSERT INTO `area` VALUES (416, '150782', '牙克石市', 3, 405);
INSERT INTO `area` VALUES (417, '150783', '扎兰屯市', 3, 405);
INSERT INTO `area` VALUES (418, '150784', '额尔古纳市', 3, 405);
INSERT INTO `area` VALUES (419, '150785', '根河市', 3, 405);
INSERT INTO `area` VALUES (420, '150800', '巴彦淖尔市', 2, 348);
INSERT INTO `area` VALUES (421, '150802', '临河区', 3, 420);
INSERT INTO `area` VALUES (422, '150821', '五原县', 3, 420);
INSERT INTO `area` VALUES (423, '150822', '磴口县', 3, 420);
INSERT INTO `area` VALUES (424, '150823', '乌拉特前旗', 3, 420);
INSERT INTO `area` VALUES (425, '150824', '乌拉特中旗', 3, 420);
INSERT INTO `area` VALUES (426, '150825', '乌拉特后旗', 3, 420);
INSERT INTO `area` VALUES (427, '150826', '杭锦后旗', 3, 420);
INSERT INTO `area` VALUES (428, '150900', '乌兰察布市', 2, 348);
INSERT INTO `area` VALUES (429, '150902', '集宁区', 3, 428);
INSERT INTO `area` VALUES (430, '150921', '卓资县', 3, 428);
INSERT INTO `area` VALUES (431, '150922', '化德县', 3, 428);
INSERT INTO `area` VALUES (432, '150923', '商都县', 3, 428);
INSERT INTO `area` VALUES (433, '150924', '兴和县', 3, 428);
INSERT INTO `area` VALUES (434, '150925', '凉城县', 3, 428);
INSERT INTO `area` VALUES (435, '150926', '察哈尔右翼前旗', 3, 428);
INSERT INTO `area` VALUES (436, '150927', '察哈尔右翼中旗', 3, 428);
INSERT INTO `area` VALUES (437, '150928', '察哈尔右翼后旗', 3, 428);
INSERT INTO `area` VALUES (438, '150929', '四子王旗', 3, 428);
INSERT INTO `area` VALUES (439, '150981', '丰镇市', 3, 428);
INSERT INTO `area` VALUES (440, '152200', '兴安盟', 2, 348);
INSERT INTO `area` VALUES (441, '152201', '乌兰浩特市', 3, 440);
INSERT INTO `area` VALUES (442, '152202', '阿尔山市', 3, 440);
INSERT INTO `area` VALUES (443, '152221', '科尔沁右翼前旗', 3, 440);
INSERT INTO `area` VALUES (444, '152222', '科尔沁右翼中旗', 3, 440);
INSERT INTO `area` VALUES (445, '152223', '扎赉特旗', 3, 440);
INSERT INTO `area` VALUES (446, '152224', '突泉县', 3, 440);
INSERT INTO `area` VALUES (447, '152500', '锡林郭勒盟', 2, 348);
INSERT INTO `area` VALUES (448, '152501', '二连浩特市', 3, 447);
INSERT INTO `area` VALUES (449, '152502', '锡林浩特市', 3, 447);
INSERT INTO `area` VALUES (450, '152522', '阿巴嘎旗', 3, 447);
INSERT INTO `area` VALUES (451, '152523', '苏尼特左旗', 3, 447);
INSERT INTO `area` VALUES (452, '152524', '苏尼特右旗', 3, 447);
INSERT INTO `area` VALUES (453, '152525', '东乌珠穆沁旗', 3, 447);
INSERT INTO `area` VALUES (454, '152526', '西乌珠穆沁旗', 3, 447);
INSERT INTO `area` VALUES (455, '152527', '太仆寺旗', 3, 447);
INSERT INTO `area` VALUES (456, '152528', '镶黄旗', 3, 447);
INSERT INTO `area` VALUES (457, '152529', '正镶白旗', 3, 447);
INSERT INTO `area` VALUES (458, '152530', '正蓝旗', 3, 447);
INSERT INTO `area` VALUES (459, '152531', '多伦县', 3, 447);
INSERT INTO `area` VALUES (460, '152900', '阿拉善盟', 2, 348);
INSERT INTO `area` VALUES (461, '152921', '阿拉善左旗', 3, 460);
INSERT INTO `area` VALUES (462, '152922', '阿拉善右旗', 3, 460);
INSERT INTO `area` VALUES (463, '152923', '额济纳旗', 3, 460);
INSERT INTO `area` VALUES (464, '210000', '辽宁省', 1, -1);
INSERT INTO `area` VALUES (465, '210100', '沈阳市', 2, 464);
INSERT INTO `area` VALUES (466, '210102', '和平区', 3, 465);
INSERT INTO `area` VALUES (467, '210103', '沈河区', 3, 465);
INSERT INTO `area` VALUES (468, '210104', '大东区', 3, 465);
INSERT INTO `area` VALUES (469, '210105', '皇姑区', 3, 465);
INSERT INTO `area` VALUES (470, '210106', '铁西区', 3, 465);
INSERT INTO `area` VALUES (471, '210111', '苏家屯区', 3, 465);
INSERT INTO `area` VALUES (472, '210112', '浑南区', 3, 465);
INSERT INTO `area` VALUES (473, '210113', '沈北新区', 3, 465);
INSERT INTO `area` VALUES (474, '210114', '于洪区', 3, 465);
INSERT INTO `area` VALUES (475, '210115', '辽中区', 3, 465);
INSERT INTO `area` VALUES (476, '210123', '康平县', 3, 465);
INSERT INTO `area` VALUES (477, '210124', '法库县', 3, 465);
INSERT INTO `area` VALUES (478, '210181', '新民市', 3, 465);
INSERT INTO `area` VALUES (479, '210200', '大连市', 2, 464);
INSERT INTO `area` VALUES (480, '210202', '中山区', 3, 479);
INSERT INTO `area` VALUES (481, '210203', '西岗区', 3, 479);
INSERT INTO `area` VALUES (482, '210204', '沙河口区', 3, 479);
INSERT INTO `area` VALUES (483, '210211', '甘井子区', 3, 479);
INSERT INTO `area` VALUES (484, '210212', '旅顺口区', 3, 479);
INSERT INTO `area` VALUES (485, '210213', '金州区', 3, 479);
INSERT INTO `area` VALUES (486, '210214', '普兰店区', 3, 479);
INSERT INTO `area` VALUES (487, '210224', '长海县', 3, 479);
INSERT INTO `area` VALUES (488, '210281', '瓦房店市', 3, 479);
INSERT INTO `area` VALUES (489, '210283', '庄河市', 3, 479);
INSERT INTO `area` VALUES (490, '210300', '鞍山市', 2, 464);
INSERT INTO `area` VALUES (491, '210302', '铁东区', 3, 490);
INSERT INTO `area` VALUES (492, '210303', '铁西区', 3, 490);
INSERT INTO `area` VALUES (493, '210304', '立山区', 3, 490);
INSERT INTO `area` VALUES (494, '210311', '千山区', 3, 490);
INSERT INTO `area` VALUES (495, '210321', '台安县', 3, 490);
INSERT INTO `area` VALUES (496, '210323', '岫岩满族自治县', 3, 490);
INSERT INTO `area` VALUES (497, '210381', '海城市', 3, 490);
INSERT INTO `area` VALUES (498, '210400', '抚顺市', 2, 464);
INSERT INTO `area` VALUES (499, '210402', '新抚区', 3, 498);
INSERT INTO `area` VALUES (500, '210403', '东洲区', 3, 498);
INSERT INTO `area` VALUES (501, '210404', '望花区', 3, 498);
INSERT INTO `area` VALUES (502, '210411', '顺城区', 3, 498);
INSERT INTO `area` VALUES (503, '210421', '抚顺县', 3, 498);
INSERT INTO `area` VALUES (504, '210422', '新宾满族自治县', 3, 498);
INSERT INTO `area` VALUES (505, '210423', '清原满族自治县', 3, 498);
INSERT INTO `area` VALUES (506, '210500', '本溪市', 2, 464);
INSERT INTO `area` VALUES (507, '210502', '平山区', 3, 506);
INSERT INTO `area` VALUES (508, '210503', '溪湖区', 3, 506);
INSERT INTO `area` VALUES (509, '210504', '明山区', 3, 506);
INSERT INTO `area` VALUES (510, '210505', '南芬区', 3, 506);
INSERT INTO `area` VALUES (511, '210521', '本溪满族自治县', 3, 506);
INSERT INTO `area` VALUES (512, '210522', '桓仁满族自治县', 3, 506);
INSERT INTO `area` VALUES (513, '210600', '丹东市', 2, 464);
INSERT INTO `area` VALUES (514, '210602', '元宝区', 3, 513);
INSERT INTO `area` VALUES (515, '210603', '振兴区', 3, 513);
INSERT INTO `area` VALUES (516, '210604', '振安区', 3, 513);
INSERT INTO `area` VALUES (517, '210624', '宽甸满族自治县', 3, 513);
INSERT INTO `area` VALUES (518, '210681', '东港市', 3, 513);
INSERT INTO `area` VALUES (519, '210682', '凤城市', 3, 513);
INSERT INTO `area` VALUES (520, '210700', '锦州市', 2, 464);
INSERT INTO `area` VALUES (521, '210702', '古塔区', 3, 520);
INSERT INTO `area` VALUES (522, '210703', '凌河区', 3, 520);
INSERT INTO `area` VALUES (523, '210711', '太和区', 3, 520);
INSERT INTO `area` VALUES (524, '210726', '黑山县', 3, 520);
INSERT INTO `area` VALUES (525, '210727', '义县', 3, 520);
INSERT INTO `area` VALUES (526, '210781', '凌海市', 3, 520);
INSERT INTO `area` VALUES (527, '210782', '北镇市', 3, 520);
INSERT INTO `area` VALUES (528, '210800', '营口市', 2, 464);
INSERT INTO `area` VALUES (529, '210802', '站前区', 3, 528);
INSERT INTO `area` VALUES (530, '210803', '西市区', 3, 528);
INSERT INTO `area` VALUES (531, '210804', '鲅鱼圈区', 3, 528);
INSERT INTO `area` VALUES (532, '210811', '老边区', 3, 528);
INSERT INTO `area` VALUES (533, '210881', '盖州市', 3, 528);
INSERT INTO `area` VALUES (534, '210882', '大石桥市', 3, 528);
INSERT INTO `area` VALUES (535, '210900', '阜新市', 2, 464);
INSERT INTO `area` VALUES (536, '210902', '海州区', 3, 535);
INSERT INTO `area` VALUES (537, '210903', '新邱区', 3, 535);
INSERT INTO `area` VALUES (538, '210904', '太平区', 3, 535);
INSERT INTO `area` VALUES (539, '210905', '清河门区', 3, 535);
INSERT INTO `area` VALUES (540, '210911', '细河区', 3, 535);
INSERT INTO `area` VALUES (541, '210921', '阜新蒙古族自治县', 3, 535);
INSERT INTO `area` VALUES (542, '210922', '彰武县', 3, 535);
INSERT INTO `area` VALUES (543, '211000', '辽阳市', 2, 464);
INSERT INTO `area` VALUES (544, '211002', '白塔区', 3, 543);
INSERT INTO `area` VALUES (545, '211003', '文圣区', 3, 543);
INSERT INTO `area` VALUES (546, '211004', '宏伟区', 3, 543);
INSERT INTO `area` VALUES (547, '211005', '弓长岭区', 3, 543);
INSERT INTO `area` VALUES (548, '211011', '太子河区', 3, 543);
INSERT INTO `area` VALUES (549, '211021', '辽阳县', 3, 543);
INSERT INTO `area` VALUES (550, '211081', '灯塔市', 3, 543);
INSERT INTO `area` VALUES (551, '211100', '盘锦市', 2, 464);
INSERT INTO `area` VALUES (552, '211102', '双台子区', 3, 551);
INSERT INTO `area` VALUES (553, '211103', '兴隆台区', 3, 551);
INSERT INTO `area` VALUES (554, '211104', '大洼区', 3, 551);
INSERT INTO `area` VALUES (555, '211122', '盘山县', 3, 551);
INSERT INTO `area` VALUES (556, '211200', '铁岭市', 2, 464);
INSERT INTO `area` VALUES (557, '211202', '银州区', 3, 556);
INSERT INTO `area` VALUES (558, '211204', '清河区', 3, 556);
INSERT INTO `area` VALUES (559, '211221', '铁岭县', 3, 556);
INSERT INTO `area` VALUES (560, '211223', '西丰县', 3, 556);
INSERT INTO `area` VALUES (561, '211224', '昌图县', 3, 556);
INSERT INTO `area` VALUES (562, '211281', '调兵山市', 3, 556);
INSERT INTO `area` VALUES (563, '211282', '开原市', 3, 556);
INSERT INTO `area` VALUES (564, '211300', '朝阳市', 2, 464);
INSERT INTO `area` VALUES (565, '211302', '双塔区', 3, 564);
INSERT INTO `area` VALUES (566, '211303', '龙城区', 3, 564);
INSERT INTO `area` VALUES (567, '211321', '朝阳县', 3, 564);
INSERT INTO `area` VALUES (568, '211322', '建平县', 3, 564);
INSERT INTO `area` VALUES (569, '211324', '喀喇沁左翼蒙古族自治县', 3, 564);
INSERT INTO `area` VALUES (570, '211381', '北票市', 3, 564);
INSERT INTO `area` VALUES (571, '211382', '凌源市', 3, 564);
INSERT INTO `area` VALUES (572, '211400', '葫芦岛市', 2, 464);
INSERT INTO `area` VALUES (573, '211402', '连山区', 3, 572);
INSERT INTO `area` VALUES (574, '211403', '龙港区', 3, 572);
INSERT INTO `area` VALUES (575, '211404', '南票区', 3, 572);
INSERT INTO `area` VALUES (576, '211421', '绥中县', 3, 572);
INSERT INTO `area` VALUES (577, '211422', '建昌县', 3, 572);
INSERT INTO `area` VALUES (578, '211481', '兴城市', 3, 572);
INSERT INTO `area` VALUES (579, '220000', '吉林省', 1, -1);
INSERT INTO `area` VALUES (580, '220100', '长春市', 2, 579);
INSERT INTO `area` VALUES (581, '220102', '南关区', 3, 580);
INSERT INTO `area` VALUES (582, '220103', '宽城区', 3, 580);
INSERT INTO `area` VALUES (583, '220104', '朝阳区', 3, 580);
INSERT INTO `area` VALUES (584, '220105', '二道区', 3, 580);
INSERT INTO `area` VALUES (585, '220106', '绿园区', 3, 580);
INSERT INTO `area` VALUES (586, '220112', '双阳区', 3, 580);
INSERT INTO `area` VALUES (587, '220113', '九台区', 3, 580);
INSERT INTO `area` VALUES (588, '220122', '农安县', 3, 580);
INSERT INTO `area` VALUES (589, '220182', '榆树市', 3, 580);
INSERT INTO `area` VALUES (590, '220183', '德惠市', 3, 580);
INSERT INTO `area` VALUES (591, '220200', '吉林市', 2, 579);
INSERT INTO `area` VALUES (592, '220202', '昌邑区', 3, 591);
INSERT INTO `area` VALUES (593, '220203', '龙潭区', 3, 591);
INSERT INTO `area` VALUES (594, '220204', '船营区', 3, 591);
INSERT INTO `area` VALUES (595, '220211', '丰满区', 3, 591);
INSERT INTO `area` VALUES (596, '220221', '永吉县', 3, 591);
INSERT INTO `area` VALUES (597, '220281', '蛟河市', 3, 591);
INSERT INTO `area` VALUES (598, '220282', '桦甸市', 3, 591);
INSERT INTO `area` VALUES (599, '220283', '舒兰市', 3, 591);
INSERT INTO `area` VALUES (600, '220284', '磐石市', 3, 591);
INSERT INTO `area` VALUES (601, '220300', '四平市', 2, 579);
INSERT INTO `area` VALUES (602, '220302', '铁西区', 3, 601);
INSERT INTO `area` VALUES (603, '220303', '铁东区', 3, 601);
INSERT INTO `area` VALUES (604, '220322', '梨树县', 3, 601);
INSERT INTO `area` VALUES (605, '220323', '伊通满族自治县', 3, 601);
INSERT INTO `area` VALUES (606, '220381', '公主岭市', 3, 601);
INSERT INTO `area` VALUES (607, '220382', '双辽市', 3, 601);
INSERT INTO `area` VALUES (608, '220400', '辽源市', 2, 579);
INSERT INTO `area` VALUES (609, '220402', '龙山区', 3, 608);
INSERT INTO `area` VALUES (610, '220403', '西安区', 3, 608);
INSERT INTO `area` VALUES (611, '220421', '东丰县', 3, 608);
INSERT INTO `area` VALUES (612, '220422', '东辽县', 3, 608);
INSERT INTO `area` VALUES (613, '220500', '通化市', 2, 579);
INSERT INTO `area` VALUES (614, '220502', '东昌区', 3, 613);
INSERT INTO `area` VALUES (615, '220503', '二道江区', 3, 613);
INSERT INTO `area` VALUES (616, '220521', '通化县', 3, 613);
INSERT INTO `area` VALUES (617, '220523', '辉南县', 3, 613);
INSERT INTO `area` VALUES (618, '220524', '柳河县', 3, 613);
INSERT INTO `area` VALUES (619, '220581', '梅河口市', 3, 613);
INSERT INTO `area` VALUES (620, '220582', '集安市', 3, 613);
INSERT INTO `area` VALUES (621, '220600', '白山市', 2, 579);
INSERT INTO `area` VALUES (622, '220602', '浑江区', 3, 621);
INSERT INTO `area` VALUES (623, '220605', '江源区', 3, 621);
INSERT INTO `area` VALUES (624, '220621', '抚松县', 3, 621);
INSERT INTO `area` VALUES (625, '220622', '靖宇县', 3, 621);
INSERT INTO `area` VALUES (626, '220623', '长白朝鲜族自治县', 3, 621);
INSERT INTO `area` VALUES (627, '220681', '临江市', 3, 621);
INSERT INTO `area` VALUES (628, '220700', '松原市', 2, 579);
INSERT INTO `area` VALUES (629, '220702', '宁江区', 3, 628);
INSERT INTO `area` VALUES (630, '220721', '前郭尔罗斯蒙古族自治县', 3, 628);
INSERT INTO `area` VALUES (631, '220722', '长岭县', 3, 628);
INSERT INTO `area` VALUES (632, '220723', '乾安县', 3, 628);
INSERT INTO `area` VALUES (633, '220781', '扶余市', 3, 628);
INSERT INTO `area` VALUES (634, '220800', '白城市', 2, 579);
INSERT INTO `area` VALUES (635, '220802', '洮北区', 3, 634);
INSERT INTO `area` VALUES (636, '220821', '镇赉县', 3, 634);
INSERT INTO `area` VALUES (637, '220822', '通榆县', 3, 634);
INSERT INTO `area` VALUES (638, '220881', '洮南市', 3, 634);
INSERT INTO `area` VALUES (639, '220882', '大安市', 3, 634);
INSERT INTO `area` VALUES (640, '222400', '延边朝鲜族自治州', 2, 579);
INSERT INTO `area` VALUES (641, '222401', '延吉市', 3, 640);
INSERT INTO `area` VALUES (642, '222402', '图们市', 3, 640);
INSERT INTO `area` VALUES (643, '222403', '敦化市', 3, 640);
INSERT INTO `area` VALUES (644, '222404', '珲春市', 3, 640);
INSERT INTO `area` VALUES (645, '222405', '龙井市', 3, 640);
INSERT INTO `area` VALUES (646, '222406', '和龙市', 3, 640);
INSERT INTO `area` VALUES (647, '222424', '汪清县', 3, 640);
INSERT INTO `area` VALUES (648, '222426', '安图县', 3, 640);
INSERT INTO `area` VALUES (649, '230000', '黑龙江省', 1, -1);
INSERT INTO `area` VALUES (650, '230100', '哈尔滨市', 2, 649);
INSERT INTO `area` VALUES (651, '230102', '道里区', 3, 650);
INSERT INTO `area` VALUES (652, '230103', '南岗区', 3, 650);
INSERT INTO `area` VALUES (653, '230104', '道外区', 3, 650);
INSERT INTO `area` VALUES (654, '230108', '平房区', 3, 650);
INSERT INTO `area` VALUES (655, '230109', '松北区', 3, 650);
INSERT INTO `area` VALUES (656, '230110', '香坊区', 3, 650);
INSERT INTO `area` VALUES (657, '230111', '呼兰区', 3, 650);
INSERT INTO `area` VALUES (658, '230112', '阿城区', 3, 650);
INSERT INTO `area` VALUES (659, '230113', '双城区', 3, 650);
INSERT INTO `area` VALUES (660, '230123', '依兰县', 3, 650);
INSERT INTO `area` VALUES (661, '230124', '方正县', 3, 650);
INSERT INTO `area` VALUES (662, '230125', '宾县', 3, 650);
INSERT INTO `area` VALUES (663, '230126', '巴彦县', 3, 650);
INSERT INTO `area` VALUES (664, '230127', '木兰县', 3, 650);
INSERT INTO `area` VALUES (665, '230128', '通河县', 3, 650);
INSERT INTO `area` VALUES (666, '230129', '延寿县', 3, 650);
INSERT INTO `area` VALUES (667, '230183', '尚志市', 3, 650);
INSERT INTO `area` VALUES (668, '230184', '五常市', 3, 650);
INSERT INTO `area` VALUES (669, '230200', '齐齐哈尔市', 2, 649);
INSERT INTO `area` VALUES (670, '230202', '龙沙区', 3, 669);
INSERT INTO `area` VALUES (671, '230203', '建华区', 3, 669);
INSERT INTO `area` VALUES (672, '230204', '铁锋区', 3, 669);
INSERT INTO `area` VALUES (673, '230205', '昂昂溪区', 3, 669);
INSERT INTO `area` VALUES (674, '230206', '富拉尔基区', 3, 669);
INSERT INTO `area` VALUES (675, '230207', '碾子山区', 3, 669);
INSERT INTO `area` VALUES (676, '230208', '梅里斯达斡尔族区', 3, 669);
INSERT INTO `area` VALUES (677, '230221', '龙江县', 3, 669);
INSERT INTO `area` VALUES (678, '230223', '依安县', 3, 669);
INSERT INTO `area` VALUES (679, '230224', '泰来县', 3, 669);
INSERT INTO `area` VALUES (680, '230225', '甘南县', 3, 669);
INSERT INTO `area` VALUES (681, '230227', '富裕县', 3, 669);
INSERT INTO `area` VALUES (682, '230229', '克山县', 3, 669);
INSERT INTO `area` VALUES (683, '230230', '克东县', 3, 669);
INSERT INTO `area` VALUES (684, '230231', '拜泉县', 3, 669);
INSERT INTO `area` VALUES (685, '230281', '讷河市', 3, 669);
INSERT INTO `area` VALUES (686, '230300', '鸡西市', 2, 649);
INSERT INTO `area` VALUES (687, '230302', '鸡冠区', 3, 686);
INSERT INTO `area` VALUES (688, '230303', '恒山区', 3, 686);
INSERT INTO `area` VALUES (689, '230304', '滴道区', 3, 686);
INSERT INTO `area` VALUES (690, '230305', '梨树区', 3, 686);
INSERT INTO `area` VALUES (691, '230306', '城子河区', 3, 686);
INSERT INTO `area` VALUES (692, '230307', '麻山区', 3, 686);
INSERT INTO `area` VALUES (693, '230321', '鸡东县', 3, 686);
INSERT INTO `area` VALUES (694, '230381', '虎林市', 3, 686);
INSERT INTO `area` VALUES (695, '230382', '密山市', 3, 686);
INSERT INTO `area` VALUES (696, '230400', '鹤岗市', 2, 649);
INSERT INTO `area` VALUES (697, '230402', '向阳区', 3, 696);
INSERT INTO `area` VALUES (698, '230403', '工农区', 3, 696);
INSERT INTO `area` VALUES (699, '230404', '南山区', 3, 696);
INSERT INTO `area` VALUES (700, '230405', '兴安区', 3, 696);
INSERT INTO `area` VALUES (701, '230406', '东山区', 3, 696);
INSERT INTO `area` VALUES (702, '230407', '兴山区', 3, 696);
INSERT INTO `area` VALUES (703, '230421', '萝北县', 3, 696);
INSERT INTO `area` VALUES (704, '230422', '绥滨县', 3, 696);
INSERT INTO `area` VALUES (705, '230500', '双鸭山市', 2, 649);
INSERT INTO `area` VALUES (706, '230502', '尖山区', 3, 705);
INSERT INTO `area` VALUES (707, '230503', '岭东区', 3, 705);
INSERT INTO `area` VALUES (708, '230505', '四方台区', 3, 705);
INSERT INTO `area` VALUES (709, '230506', '宝山区', 3, 705);
INSERT INTO `area` VALUES (710, '230521', '集贤县', 3, 705);
INSERT INTO `area` VALUES (711, '230522', '友谊县', 3, 705);
INSERT INTO `area` VALUES (712, '230523', '宝清县', 3, 705);
INSERT INTO `area` VALUES (713, '230524', '饶河县', 3, 705);
INSERT INTO `area` VALUES (714, '230600', '大庆市', 2, 649);
INSERT INTO `area` VALUES (715, '230602', '萨尔图区', 3, 714);
INSERT INTO `area` VALUES (716, '230603', '龙凤区', 3, 714);
INSERT INTO `area` VALUES (717, '230604', '让胡路区', 3, 714);
INSERT INTO `area` VALUES (718, '230605', '红岗区', 3, 714);
INSERT INTO `area` VALUES (719, '230606', '大同区', 3, 714);
INSERT INTO `area` VALUES (720, '230621', '肇州县', 3, 714);
INSERT INTO `area` VALUES (721, '230622', '肇源县', 3, 714);
INSERT INTO `area` VALUES (722, '230623', '林甸县', 3, 714);
INSERT INTO `area` VALUES (723, '230624', '杜尔伯特蒙古族自治县', 3, 714);
INSERT INTO `area` VALUES (724, '230700', '伊春市', 2, 649);
INSERT INTO `area` VALUES (725, '230702', '伊春区', 3, 724);
INSERT INTO `area` VALUES (726, '230703', '南岔区', 3, 724);
INSERT INTO `area` VALUES (727, '230704', '友好区', 3, 724);
INSERT INTO `area` VALUES (728, '230705', '西林区', 3, 724);
INSERT INTO `area` VALUES (729, '230706', '翠峦区', 3, 724);
INSERT INTO `area` VALUES (730, '230707', '新青区', 3, 724);
INSERT INTO `area` VALUES (731, '230708', '美溪区', 3, 724);
INSERT INTO `area` VALUES (732, '230709', '金山屯区', 3, 724);
INSERT INTO `area` VALUES (733, '230710', '五营区', 3, 724);
INSERT INTO `area` VALUES (734, '230711', '乌马河区', 3, 724);
INSERT INTO `area` VALUES (735, '230712', '汤旺河区', 3, 724);
INSERT INTO `area` VALUES (736, '230713', '带岭区', 3, 724);
INSERT INTO `area` VALUES (737, '230714', '乌伊岭区', 3, 724);
INSERT INTO `area` VALUES (738, '230715', '红星区', 3, 724);
INSERT INTO `area` VALUES (739, '230716', '上甘岭区', 3, 724);
INSERT INTO `area` VALUES (740, '230722', '嘉荫县', 3, 724);
INSERT INTO `area` VALUES (741, '230781', '铁力市', 3, 724);
INSERT INTO `area` VALUES (742, '230800', '佳木斯市', 2, 649);
INSERT INTO `area` VALUES (743, '230803', '向阳区', 3, 742);
INSERT INTO `area` VALUES (744, '230804', '前进区', 3, 742);
INSERT INTO `area` VALUES (745, '230805', '东风区', 3, 742);
INSERT INTO `area` VALUES (746, '230811', '郊区', 3, 742);
INSERT INTO `area` VALUES (747, '230822', '桦南县', 3, 742);
INSERT INTO `area` VALUES (748, '230826', '桦川县', 3, 742);
INSERT INTO `area` VALUES (749, '230828', '汤原县', 3, 742);
INSERT INTO `area` VALUES (750, '230881', '同江市', 3, 742);
INSERT INTO `area` VALUES (751, '230882', '富锦市', 3, 742);
INSERT INTO `area` VALUES (752, '230883', '抚远市', 3, 742);
INSERT INTO `area` VALUES (753, '230900', '七台河市', 2, 649);
INSERT INTO `area` VALUES (754, '230902', '新兴区', 3, 753);
INSERT INTO `area` VALUES (755, '230903', '桃山区', 3, 753);
INSERT INTO `area` VALUES (756, '230904', '茄子河区', 3, 753);
INSERT INTO `area` VALUES (757, '230921', '勃利县', 3, 753);
INSERT INTO `area` VALUES (758, '231000', '牡丹江市', 2, 649);
INSERT INTO `area` VALUES (759, '231002', '东安区', 3, 758);
INSERT INTO `area` VALUES (760, '231003', '阳明区', 3, 758);
INSERT INTO `area` VALUES (761, '231004', '爱民区', 3, 758);
INSERT INTO `area` VALUES (762, '231005', '西安区', 3, 758);
INSERT INTO `area` VALUES (763, '231025', '林口县', 3, 758);
INSERT INTO `area` VALUES (764, '231081', '绥芬河市', 3, 758);
INSERT INTO `area` VALUES (765, '231083', '海林市', 3, 758);
INSERT INTO `area` VALUES (766, '231084', '宁安市', 3, 758);
INSERT INTO `area` VALUES (767, '231085', '穆棱市', 3, 758);
INSERT INTO `area` VALUES (768, '231086', '东宁市', 3, 758);
INSERT INTO `area` VALUES (769, '231100', '黑河市', 2, 649);
INSERT INTO `area` VALUES (770, '231102', '爱辉区', 3, 769);
INSERT INTO `area` VALUES (771, '231121', '嫩江县', 3, 769);
INSERT INTO `area` VALUES (772, '231123', '逊克县', 3, 769);
INSERT INTO `area` VALUES (773, '231124', '孙吴县', 3, 769);
INSERT INTO `area` VALUES (774, '231181', '北安市', 3, 769);
INSERT INTO `area` VALUES (775, '231182', '五大连池市', 3, 769);
INSERT INTO `area` VALUES (776, '231200', '绥化市', 2, 649);
INSERT INTO `area` VALUES (777, '231202', '北林区', 3, 776);
INSERT INTO `area` VALUES (778, '231221', '望奎县', 3, 776);
INSERT INTO `area` VALUES (779, '231222', '兰西县', 3, 776);
INSERT INTO `area` VALUES (780, '231223', '青冈县', 3, 776);
INSERT INTO `area` VALUES (781, '231224', '庆安县', 3, 776);
INSERT INTO `area` VALUES (782, '231225', '明水县', 3, 776);
INSERT INTO `area` VALUES (783, '231226', '绥棱县', 3, 776);
INSERT INTO `area` VALUES (784, '231281', '安达市', 3, 776);
INSERT INTO `area` VALUES (785, '231282', '肇东市', 3, 776);
INSERT INTO `area` VALUES (786, '231283', '海伦市', 3, 776);
INSERT INTO `area` VALUES (787, '232700', '大兴安岭地区', 2, 649);
INSERT INTO `area` VALUES (788, '232701', '加格达奇区', 3, 787);
INSERT INTO `area` VALUES (789, '232721', '呼玛县', 3, 787);
INSERT INTO `area` VALUES (790, '232722', '塔河县', 3, 787);
INSERT INTO `area` VALUES (791, '232723', '漠河县', 3, 787);
INSERT INTO `area` VALUES (792, '310000', '上海市', 1, -1);
INSERT INTO `area` VALUES (793, '310100', '上海城区', 2, 792);
INSERT INTO `area` VALUES (794, '310101', '黄浦区', 3, 793);
INSERT INTO `area` VALUES (795, '310104', '徐汇区', 3, 793);
INSERT INTO `area` VALUES (796, '310105', '长宁区', 3, 793);
INSERT INTO `area` VALUES (797, '310106', '静安区', 3, 793);
INSERT INTO `area` VALUES (798, '310107', '普陀区', 3, 793);
INSERT INTO `area` VALUES (799, '310109', '虹口区', 3, 793);
INSERT INTO `area` VALUES (800, '310110', '杨浦区', 3, 793);
INSERT INTO `area` VALUES (801, '310112', '闵行区', 3, 793);
INSERT INTO `area` VALUES (802, '310113', '宝山区', 3, 793);
INSERT INTO `area` VALUES (803, '310114', '嘉定区', 3, 793);
INSERT INTO `area` VALUES (804, '310115', '浦东新区', 3, 793);
INSERT INTO `area` VALUES (805, '310116', '金山区', 3, 793);
INSERT INTO `area` VALUES (806, '310117', '松江区', 3, 793);
INSERT INTO `area` VALUES (807, '310118', '青浦区', 3, 793);
INSERT INTO `area` VALUES (808, '310120', '奉贤区', 3, 793);
INSERT INTO `area` VALUES (809, '310151', '崇明区', 3, 793);
INSERT INTO `area` VALUES (810, '320000', '江苏省', 1, -1);
INSERT INTO `area` VALUES (811, '320100', '南京市', 2, 810);
INSERT INTO `area` VALUES (812, '320102', '玄武区', 3, 811);
INSERT INTO `area` VALUES (813, '320104', '秦淮区', 3, 811);
INSERT INTO `area` VALUES (814, '320105', '建邺区', 3, 811);
INSERT INTO `area` VALUES (815, '320106', '鼓楼区', 3, 811);
INSERT INTO `area` VALUES (816, '320111', '浦口区', 3, 811);
INSERT INTO `area` VALUES (817, '320113', '栖霞区', 3, 811);
INSERT INTO `area` VALUES (818, '320114', '雨花台区', 3, 811);
INSERT INTO `area` VALUES (819, '320115', '江宁区', 3, 811);
INSERT INTO `area` VALUES (820, '320116', '六合区', 3, 811);
INSERT INTO `area` VALUES (821, '320117', '溧水区', 3, 811);
INSERT INTO `area` VALUES (822, '320118', '高淳区', 3, 811);
INSERT INTO `area` VALUES (823, '320200', '无锡市', 2, 810);
INSERT INTO `area` VALUES (824, '320205', '锡山区', 3, 823);
INSERT INTO `area` VALUES (825, '320206', '惠山区', 3, 823);
INSERT INTO `area` VALUES (826, '320211', '滨湖区', 3, 823);
INSERT INTO `area` VALUES (827, '320213', '梁溪区', 3, 823);
INSERT INTO `area` VALUES (828, '320214', '新吴区', 3, 823);
INSERT INTO `area` VALUES (829, '320281', '江阴市', 3, 823);
INSERT INTO `area` VALUES (830, '320282', '宜兴市', 3, 823);
INSERT INTO `area` VALUES (831, '320300', '徐州市', 2, 810);
INSERT INTO `area` VALUES (832, '320302', '鼓楼区', 3, 831);
INSERT INTO `area` VALUES (833, '320303', '云龙区', 3, 831);
INSERT INTO `area` VALUES (834, '320305', '贾汪区', 3, 831);
INSERT INTO `area` VALUES (835, '320311', '泉山区', 3, 831);
INSERT INTO `area` VALUES (836, '320312', '铜山区', 3, 831);
INSERT INTO `area` VALUES (837, '320321', '丰县', 3, 831);
INSERT INTO `area` VALUES (838, '320322', '沛县', 3, 831);
INSERT INTO `area` VALUES (839, '320324', '睢宁县', 3, 831);
INSERT INTO `area` VALUES (840, '320381', '新沂市', 3, 831);
INSERT INTO `area` VALUES (841, '320382', '邳州市', 3, 831);
INSERT INTO `area` VALUES (842, '320400', '常州市', 2, 810);
INSERT INTO `area` VALUES (843, '320402', '天宁区', 3, 842);
INSERT INTO `area` VALUES (844, '320404', '钟楼区', 3, 842);
INSERT INTO `area` VALUES (845, '320411', '新北区', 3, 842);
INSERT INTO `area` VALUES (846, '320412', '武进区', 3, 842);
INSERT INTO `area` VALUES (847, '320413', '金坛区', 3, 842);
INSERT INTO `area` VALUES (848, '320481', '溧阳市', 3, 842);
INSERT INTO `area` VALUES (849, '320500', '苏州市', 2, 810);
INSERT INTO `area` VALUES (850, '320505', '虎丘区', 3, 849);
INSERT INTO `area` VALUES (851, '320506', '吴中区', 3, 849);
INSERT INTO `area` VALUES (852, '320507', '相城区', 3, 849);
INSERT INTO `area` VALUES (853, '320508', '姑苏区', 3, 849);
INSERT INTO `area` VALUES (854, '320509', '吴江区', 3, 849);
INSERT INTO `area` VALUES (855, '320581', '常熟市', 3, 849);
INSERT INTO `area` VALUES (856, '320582', '张家港市', 3, 849);
INSERT INTO `area` VALUES (857, '320583', '昆山市', 3, 849);
INSERT INTO `area` VALUES (858, '320585', '太仓市', 3, 849);
INSERT INTO `area` VALUES (859, '320600', '南通市', 2, 810);
INSERT INTO `area` VALUES (860, '320602', '崇川区', 3, 859);
INSERT INTO `area` VALUES (861, '320611', '港闸区', 3, 859);
INSERT INTO `area` VALUES (862, '320612', '通州区', 3, 859);
INSERT INTO `area` VALUES (863, '320621', '海安县', 3, 859);
INSERT INTO `area` VALUES (864, '320623', '如东县', 3, 859);
INSERT INTO `area` VALUES (865, '320681', '启东市', 3, 859);
INSERT INTO `area` VALUES (866, '320682', '如皋市', 3, 859);
INSERT INTO `area` VALUES (867, '320684', '海门市', 3, 859);
INSERT INTO `area` VALUES (868, '320700', '连云港市', 2, 810);
INSERT INTO `area` VALUES (869, '320703', '连云区', 3, 868);
INSERT INTO `area` VALUES (870, '320706', '海州区', 3, 868);
INSERT INTO `area` VALUES (871, '320707', '赣榆区', 3, 868);
INSERT INTO `area` VALUES (872, '320722', '东海县', 3, 868);
INSERT INTO `area` VALUES (873, '320723', '灌云县', 3, 868);
INSERT INTO `area` VALUES (874, '320724', '灌南县', 3, 868);
INSERT INTO `area` VALUES (875, '320800', '淮安市', 2, 810);
INSERT INTO `area` VALUES (876, '320812', '清江浦区', 3, 875);
INSERT INTO `area` VALUES (877, '320803', '淮安区', 3, 875);
INSERT INTO `area` VALUES (878, '320804', '淮阴区', 3, 875);
INSERT INTO `area` VALUES (879, '320813', '洪泽区', 3, 875);
INSERT INTO `area` VALUES (880, '320826', '涟水县', 3, 875);
INSERT INTO `area` VALUES (881, '320830', '盱眙县', 3, 875);
INSERT INTO `area` VALUES (882, '320831', '金湖县', 3, 875);
INSERT INTO `area` VALUES (883, '320900', '盐城市', 2, 810);
INSERT INTO `area` VALUES (884, '320902', '亭湖区', 3, 883);
INSERT INTO `area` VALUES (885, '320903', '盐都区', 3, 883);
INSERT INTO `area` VALUES (886, '320904', '大丰区', 3, 883);
INSERT INTO `area` VALUES (887, '320921', '响水县', 3, 883);
INSERT INTO `area` VALUES (888, '320922', '滨海县', 3, 883);
INSERT INTO `area` VALUES (889, '320923', '阜宁县', 3, 883);
INSERT INTO `area` VALUES (890, '320924', '射阳县', 3, 883);
INSERT INTO `area` VALUES (891, '320925', '建湖县', 3, 883);
INSERT INTO `area` VALUES (892, '320981', '东台市', 3, 883);
INSERT INTO `area` VALUES (893, '321000', '扬州市', 2, 810);
INSERT INTO `area` VALUES (894, '321002', '广陵区', 3, 893);
INSERT INTO `area` VALUES (895, '321003', '邗江区', 3, 893);
INSERT INTO `area` VALUES (896, '321012', '江都区', 3, 893);
INSERT INTO `area` VALUES (897, '321023', '宝应县', 3, 893);
INSERT INTO `area` VALUES (898, '321081', '仪征市', 3, 893);
INSERT INTO `area` VALUES (899, '321084', '高邮市', 3, 893);
INSERT INTO `area` VALUES (900, '321100', '镇江市', 2, 810);
INSERT INTO `area` VALUES (901, '321102', '京口区', 3, 900);
INSERT INTO `area` VALUES (902, '321111', '润州区', 3, 900);
INSERT INTO `area` VALUES (903, '321112', '丹徒区', 3, 900);
INSERT INTO `area` VALUES (904, '321181', '丹阳市', 3, 900);
INSERT INTO `area` VALUES (905, '321182', '扬中市', 3, 900);
INSERT INTO `area` VALUES (906, '321183', '句容市', 3, 900);
INSERT INTO `area` VALUES (907, '321200', '泰州市', 2, 810);
INSERT INTO `area` VALUES (908, '321202', '海陵区', 3, 907);
INSERT INTO `area` VALUES (909, '321203', '高港区', 3, 907);
INSERT INTO `area` VALUES (910, '321204', '姜堰区', 3, 907);
INSERT INTO `area` VALUES (911, '321281', '兴化市', 3, 907);
INSERT INTO `area` VALUES (912, '321282', '靖江市', 3, 907);
INSERT INTO `area` VALUES (913, '321283', '泰兴市', 3, 907);
INSERT INTO `area` VALUES (914, '321300', '宿迁市', 2, 810);
INSERT INTO `area` VALUES (915, '321302', '宿城区', 3, 914);
INSERT INTO `area` VALUES (916, '321311', '宿豫区', 3, 914);
INSERT INTO `area` VALUES (917, '321322', '沭阳县', 3, 914);
INSERT INTO `area` VALUES (918, '321323', '泗阳县', 3, 914);
INSERT INTO `area` VALUES (919, '321324', '泗洪县', 3, 914);
INSERT INTO `area` VALUES (920, '330000', '浙江省', 1, -1);
INSERT INTO `area` VALUES (921, '330100', '杭州市', 2, 920);
INSERT INTO `area` VALUES (922, '330102', '上城区', 3, 921);
INSERT INTO `area` VALUES (923, '330103', '下城区', 3, 921);
INSERT INTO `area` VALUES (924, '330104', '江干区', 3, 921);
INSERT INTO `area` VALUES (925, '330105', '拱墅区', 3, 921);
INSERT INTO `area` VALUES (926, '330106', '西湖区', 3, 921);
INSERT INTO `area` VALUES (927, '330108', '滨江区', 3, 921);
INSERT INTO `area` VALUES (928, '330109', '萧山区', 3, 921);
INSERT INTO `area` VALUES (929, '330110', '余杭区', 3, 921);
INSERT INTO `area` VALUES (930, '330111', '富阳区', 3, 921);
INSERT INTO `area` VALUES (931, '330122', '桐庐县', 3, 921);
INSERT INTO `area` VALUES (932, '330127', '淳安县', 3, 921);
INSERT INTO `area` VALUES (933, '330182', '建德市', 3, 921);
INSERT INTO `area` VALUES (934, '330185', '临安市', 3, 921);
INSERT INTO `area` VALUES (935, '330200', '宁波市', 2, 920);
INSERT INTO `area` VALUES (936, '330203', '海曙区', 3, 935);
INSERT INTO `area` VALUES (937, '330205', '江北区', 3, 935);
INSERT INTO `area` VALUES (938, '330206', '北仑区', 3, 935);
INSERT INTO `area` VALUES (939, '330211', '镇海区', 3, 935);
INSERT INTO `area` VALUES (940, '330212', '鄞州区', 3, 935);
INSERT INTO `area` VALUES (941, '330225', '象山县', 3, 935);
INSERT INTO `area` VALUES (942, '330226', '宁海县', 3, 935);
INSERT INTO `area` VALUES (943, '330281', '余姚市', 3, 935);
INSERT INTO `area` VALUES (944, '330282', '慈溪市', 3, 935);
INSERT INTO `area` VALUES (945, '330213', '奉化区', 3, 935);
INSERT INTO `area` VALUES (946, '330300', '温州市', 2, 920);
INSERT INTO `area` VALUES (947, '330302', '鹿城区', 3, 946);
INSERT INTO `area` VALUES (948, '330303', '龙湾区', 3, 946);
INSERT INTO `area` VALUES (949, '330304', '瓯海区', 3, 946);
INSERT INTO `area` VALUES (950, '330305', '洞头区', 3, 946);
INSERT INTO `area` VALUES (951, '330324', '永嘉县', 3, 946);
INSERT INTO `area` VALUES (952, '330326', '平阳县', 3, 946);
INSERT INTO `area` VALUES (953, '330327', '苍南县', 3, 946);
INSERT INTO `area` VALUES (954, '330328', '文成县', 3, 946);
INSERT INTO `area` VALUES (955, '330329', '泰顺县', 3, 946);
INSERT INTO `area` VALUES (956, '330381', '瑞安市', 3, 946);
INSERT INTO `area` VALUES (957, '330382', '乐清市', 3, 946);
INSERT INTO `area` VALUES (958, '330400', '嘉兴市', 2, 920);
INSERT INTO `area` VALUES (959, '330402', '南湖区', 3, 958);
INSERT INTO `area` VALUES (960, '330411', '秀洲区', 3, 958);
INSERT INTO `area` VALUES (961, '330421', '嘉善县', 3, 958);
INSERT INTO `area` VALUES (962, '330424', '海盐县', 3, 958);
INSERT INTO `area` VALUES (963, '330481', '海宁市', 3, 958);
INSERT INTO `area` VALUES (964, '330482', '平湖市', 3, 958);
INSERT INTO `area` VALUES (965, '330483', '桐乡市', 3, 958);
INSERT INTO `area` VALUES (966, '330500', '湖州市', 2, 920);
INSERT INTO `area` VALUES (967, '330502', '吴兴区', 3, 966);
INSERT INTO `area` VALUES (968, '330503', '南浔区', 3, 966);
INSERT INTO `area` VALUES (969, '330521', '德清县', 3, 966);
INSERT INTO `area` VALUES (970, '330522', '长兴县', 3, 966);
INSERT INTO `area` VALUES (971, '330523', '安吉县', 3, 966);
INSERT INTO `area` VALUES (972, '330600', '绍兴市', 2, 920);
INSERT INTO `area` VALUES (973, '330602', '越城区', 3, 972);
INSERT INTO `area` VALUES (974, '330603', '柯桥区', 3, 972);
INSERT INTO `area` VALUES (975, '330604', '上虞区', 3, 972);
INSERT INTO `area` VALUES (976, '330624', '新昌县', 3, 972);
INSERT INTO `area` VALUES (977, '330681', '诸暨市', 3, 972);
INSERT INTO `area` VALUES (978, '330683', '嵊州市', 3, 972);
INSERT INTO `area` VALUES (979, '330700', '金华市', 2, 920);
INSERT INTO `area` VALUES (980, '330702', '婺城区', 3, 979);
INSERT INTO `area` VALUES (981, '330703', '金东区', 3, 979);
INSERT INTO `area` VALUES (982, '330723', '武义县', 3, 979);
INSERT INTO `area` VALUES (983, '330726', '浦江县', 3, 979);
INSERT INTO `area` VALUES (984, '330727', '磐安县', 3, 979);
INSERT INTO `area` VALUES (985, '330781', '兰溪市', 3, 979);
INSERT INTO `area` VALUES (986, '330782', '义乌市', 3, 979);
INSERT INTO `area` VALUES (987, '330783', '东阳市', 3, 979);
INSERT INTO `area` VALUES (988, '330784', '永康市', 3, 979);
INSERT INTO `area` VALUES (989, '330800', '衢州市', 2, 920);
INSERT INTO `area` VALUES (990, '330802', '柯城区', 3, 989);
INSERT INTO `area` VALUES (991, '330803', '衢江区', 3, 989);
INSERT INTO `area` VALUES (992, '330822', '常山县', 3, 989);
INSERT INTO `area` VALUES (993, '330824', '开化县', 3, 989);
INSERT INTO `area` VALUES (994, '330825', '龙游县', 3, 989);
INSERT INTO `area` VALUES (995, '330881', '江山市', 3, 989);
INSERT INTO `area` VALUES (996, '330900', '舟山市', 2, 920);
INSERT INTO `area` VALUES (997, '330902', '定海区', 3, 996);
INSERT INTO `area` VALUES (998, '330903', '普陀区', 3, 996);
INSERT INTO `area` VALUES (999, '330921', '岱山县', 3, 996);
INSERT INTO `area` VALUES (1000, '330922', '嵊泗县', 3, 996);
INSERT INTO `area` VALUES (1001, '331000', '台州市', 2, 920);
INSERT INTO `area` VALUES (1002, '331002', '椒江区', 3, 1001);
INSERT INTO `area` VALUES (1003, '331003', '黄岩区', 3, 1001);
INSERT INTO `area` VALUES (1004, '331004', '路桥区', 3, 1001);
INSERT INTO `area` VALUES (1005, '331021', '玉环市', 3, 1001);
INSERT INTO `area` VALUES (1006, '331022', '三门县', 3, 1001);
INSERT INTO `area` VALUES (1007, '331023', '天台县', 3, 1001);
INSERT INTO `area` VALUES (1008, '331024', '仙居县', 3, 1001);
INSERT INTO `area` VALUES (1009, '331081', '温岭市', 3, 1001);
INSERT INTO `area` VALUES (1010, '331082', '临海市', 3, 1001);
INSERT INTO `area` VALUES (1011, '331100', '丽水市', 2, 920);
INSERT INTO `area` VALUES (1012, '331102', '莲都区', 3, 1011);
INSERT INTO `area` VALUES (1013, '331121', '青田县', 3, 1011);
INSERT INTO `area` VALUES (1014, '331122', '缙云县', 3, 1011);
INSERT INTO `area` VALUES (1015, '331123', '遂昌县', 3, 1011);
INSERT INTO `area` VALUES (1016, '331124', '松阳县', 3, 1011);
INSERT INTO `area` VALUES (1017, '331125', '云和县', 3, 1011);
INSERT INTO `area` VALUES (1018, '331126', '庆元县', 3, 1011);
INSERT INTO `area` VALUES (1019, '331127', '景宁畲族自治县', 3, 1011);
INSERT INTO `area` VALUES (1020, '331181', '龙泉市', 3, 1011);
INSERT INTO `area` VALUES (1021, '340000', '安徽省', 1, -1);
INSERT INTO `area` VALUES (1022, '340100', '合肥市', 2, 1021);
INSERT INTO `area` VALUES (1023, '340102', '瑶海区', 3, 1022);
INSERT INTO `area` VALUES (1024, '340103', '庐阳区', 3, 1022);
INSERT INTO `area` VALUES (1025, '340104', '蜀山区', 3, 1022);
INSERT INTO `area` VALUES (1026, '340111', '包河区', 3, 1022);
INSERT INTO `area` VALUES (1027, '340121', '长丰县', 3, 1022);
INSERT INTO `area` VALUES (1028, '340122', '肥东县', 3, 1022);
INSERT INTO `area` VALUES (1029, '340123', '肥西县', 3, 1022);
INSERT INTO `area` VALUES (1030, '340124', '庐江县', 3, 1022);
INSERT INTO `area` VALUES (1031, '340181', '巢湖市', 3, 1022);
INSERT INTO `area` VALUES (1032, '340200', '芜湖市', 2, 1021);
INSERT INTO `area` VALUES (1033, '340202', '镜湖区', 3, 1032);
INSERT INTO `area` VALUES (1034, '340203', '弋江区', 3, 1032);
INSERT INTO `area` VALUES (1035, '340207', '鸠江区', 3, 1032);
INSERT INTO `area` VALUES (1036, '340208', '三山区', 3, 1032);
INSERT INTO `area` VALUES (1037, '340221', '芜湖县', 3, 1032);
INSERT INTO `area` VALUES (1038, '340222', '繁昌县', 3, 1032);
INSERT INTO `area` VALUES (1039, '340223', '南陵县', 3, 1032);
INSERT INTO `area` VALUES (1040, '340225', '无为县', 3, 1032);
INSERT INTO `area` VALUES (1041, '340300', '蚌埠市', 2, 1021);
INSERT INTO `area` VALUES (1042, '340302', '龙子湖区', 3, 1041);
INSERT INTO `area` VALUES (1043, '340303', '蚌山区', 3, 1041);
INSERT INTO `area` VALUES (1044, '340304', '禹会区', 3, 1041);
INSERT INTO `area` VALUES (1045, '340311', '淮上区', 3, 1041);
INSERT INTO `area` VALUES (1046, '340321', '怀远县', 3, 1041);
INSERT INTO `area` VALUES (1047, '340322', '五河县', 3, 1041);
INSERT INTO `area` VALUES (1048, '340323', '固镇县', 3, 1041);
INSERT INTO `area` VALUES (1049, '340400', '淮南市', 2, 1021);
INSERT INTO `area` VALUES (1050, '340402', '大通区', 3, 1049);
INSERT INTO `area` VALUES (1051, '340403', '田家庵区', 3, 1049);
INSERT INTO `area` VALUES (1052, '340404', '谢家集区', 3, 1049);
INSERT INTO `area` VALUES (1053, '340405', '八公山区', 3, 1049);
INSERT INTO `area` VALUES (1054, '340406', '潘集区', 3, 1049);
INSERT INTO `area` VALUES (1055, '340421', '凤台县', 3, 1049);
INSERT INTO `area` VALUES (1056, '340422', '寿县', 3, 1049);
INSERT INTO `area` VALUES (1057, '340500', '马鞍山市', 2, 1021);
INSERT INTO `area` VALUES (1058, '340503', '花山区', 3, 1057);
INSERT INTO `area` VALUES (1059, '340504', '雨山区', 3, 1057);
INSERT INTO `area` VALUES (1060, '340506', '博望区', 3, 1057);
INSERT INTO `area` VALUES (1061, '340521', '当涂县', 3, 1057);
INSERT INTO `area` VALUES (1062, '340522', '含山县', 3, 1057);
INSERT INTO `area` VALUES (1063, '340523', '和县', 3, 1057);
INSERT INTO `area` VALUES (1064, '340600', '淮北市', 2, 1021);
INSERT INTO `area` VALUES (1065, '340602', '杜集区', 3, 1064);
INSERT INTO `area` VALUES (1066, '340603', '相山区', 3, 1064);
INSERT INTO `area` VALUES (1067, '340604', '烈山区', 3, 1064);
INSERT INTO `area` VALUES (1068, '340621', '濉溪县', 3, 1064);
INSERT INTO `area` VALUES (1069, '340700', '铜陵市', 2, 1021);
INSERT INTO `area` VALUES (1070, '340705', '铜官区', 3, 1069);
INSERT INTO `area` VALUES (1071, '340706', '义安区', 3, 1069);
INSERT INTO `area` VALUES (1072, '340711', '郊区', 3, 1069);
INSERT INTO `area` VALUES (1073, '340722', '枞阳县', 3, 1069);
INSERT INTO `area` VALUES (1074, '340800', '安庆市', 2, 1021);
INSERT INTO `area` VALUES (1075, '340802', '迎江区', 3, 1074);
INSERT INTO `area` VALUES (1076, '340803', '大观区', 3, 1074);
INSERT INTO `area` VALUES (1077, '340811', '宜秀区', 3, 1074);
INSERT INTO `area` VALUES (1078, '340822', '怀宁县', 3, 1074);
INSERT INTO `area` VALUES (1079, '340824', '潜山县', 3, 1074);
INSERT INTO `area` VALUES (1080, '340825', '太湖县', 3, 1074);
INSERT INTO `area` VALUES (1081, '340826', '宿松县', 3, 1074);
INSERT INTO `area` VALUES (1082, '340827', '望江县', 3, 1074);
INSERT INTO `area` VALUES (1083, '340828', '岳西县', 3, 1074);
INSERT INTO `area` VALUES (1084, '340881', '桐城市', 3, 1074);
INSERT INTO `area` VALUES (1085, '341000', '黄山市', 2, 1021);
INSERT INTO `area` VALUES (1086, '341002', '屯溪区', 3, 1085);
INSERT INTO `area` VALUES (1087, '341003', '黄山区', 3, 1085);
INSERT INTO `area` VALUES (1088, '341004', '徽州区', 3, 1085);
INSERT INTO `area` VALUES (1089, '341021', '歙县', 3, 1085);
INSERT INTO `area` VALUES (1090, '341022', '休宁县', 3, 1085);
INSERT INTO `area` VALUES (1091, '341023', '黟县', 3, 1085);
INSERT INTO `area` VALUES (1092, '341024', '祁门县', 3, 1085);
INSERT INTO `area` VALUES (1093, '341100', '滁州市', 2, 1021);
INSERT INTO `area` VALUES (1094, '341102', '琅琊区', 3, 1093);
INSERT INTO `area` VALUES (1095, '341103', '南谯区', 3, 1093);
INSERT INTO `area` VALUES (1096, '341122', '来安县', 3, 1093);
INSERT INTO `area` VALUES (1097, '341124', '全椒县', 3, 1093);
INSERT INTO `area` VALUES (1098, '341125', '定远县', 3, 1093);
INSERT INTO `area` VALUES (1099, '341126', '凤阳县', 3, 1093);
INSERT INTO `area` VALUES (1100, '341181', '天长市', 3, 1093);
INSERT INTO `area` VALUES (1101, '341182', '明光市', 3, 1093);
INSERT INTO `area` VALUES (1102, '341200', '阜阳市', 2, 1021);
INSERT INTO `area` VALUES (1103, '341202', '颍州区', 3, 1102);
INSERT INTO `area` VALUES (1104, '341203', '颍东区', 3, 1102);
INSERT INTO `area` VALUES (1105, '341204', '颍泉区', 3, 1102);
INSERT INTO `area` VALUES (1106, '341221', '临泉县', 3, 1102);
INSERT INTO `area` VALUES (1107, '341222', '太和县', 3, 1102);
INSERT INTO `area` VALUES (1108, '341225', '阜南县', 3, 1102);
INSERT INTO `area` VALUES (1109, '341226', '颍上县', 3, 1102);
INSERT INTO `area` VALUES (1110, '341282', '界首市', 3, 1102);
INSERT INTO `area` VALUES (1111, '341300', '宿州市', 2, 1021);
INSERT INTO `area` VALUES (1112, '341302', '埇桥区', 3, 1111);
INSERT INTO `area` VALUES (1113, '341321', '砀山县', 3, 1111);
INSERT INTO `area` VALUES (1114, '341322', '萧县', 3, 1111);
INSERT INTO `area` VALUES (1115, '341323', '灵璧县', 3, 1111);
INSERT INTO `area` VALUES (1116, '341324', '泗县', 3, 1111);
INSERT INTO `area` VALUES (1117, '341500', '六安市', 2, 1021);
INSERT INTO `area` VALUES (1118, '341502', '金安区', 3, 1117);
INSERT INTO `area` VALUES (1119, '341503', '裕安区', 3, 1117);
INSERT INTO `area` VALUES (1120, '341504', '叶集区', 3, 1117);
INSERT INTO `area` VALUES (1121, '341522', '霍邱县', 3, 1117);
INSERT INTO `area` VALUES (1122, '341523', '舒城县', 3, 1117);
INSERT INTO `area` VALUES (1123, '341524', '金寨县', 3, 1117);
INSERT INTO `area` VALUES (1124, '341525', '霍山县', 3, 1117);
INSERT INTO `area` VALUES (1125, '341600', '亳州市', 2, 1021);
INSERT INTO `area` VALUES (1126, '341602', '谯城区', 3, 1125);
INSERT INTO `area` VALUES (1127, '341621', '涡阳县', 3, 1125);
INSERT INTO `area` VALUES (1128, '341622', '蒙城县', 3, 1125);
INSERT INTO `area` VALUES (1129, '341623', '利辛县', 3, 1125);
INSERT INTO `area` VALUES (1130, '341700', '池州市', 2, 1021);
INSERT INTO `area` VALUES (1131, '341702', '贵池区', 3, 1130);
INSERT INTO `area` VALUES (1132, '341721', '东至县', 3, 1130);
INSERT INTO `area` VALUES (1133, '341722', '石台县', 3, 1130);
INSERT INTO `area` VALUES (1134, '341723', '青阳县', 3, 1130);
INSERT INTO `area` VALUES (1135, '341800', '宣城市', 2, 1021);
INSERT INTO `area` VALUES (1136, '341802', '宣州区', 3, 1135);
INSERT INTO `area` VALUES (1137, '341821', '郎溪县', 3, 1135);
INSERT INTO `area` VALUES (1138, '341822', '广德县', 3, 1135);
INSERT INTO `area` VALUES (1139, '341823', '泾县', 3, 1135);
INSERT INTO `area` VALUES (1140, '341824', '绩溪县', 3, 1135);
INSERT INTO `area` VALUES (1141, '341825', '旌德县', 3, 1135);
INSERT INTO `area` VALUES (1142, '341881', '宁国市', 3, 1135);
INSERT INTO `area` VALUES (1143, '350000', '福建省', 1, -1);
INSERT INTO `area` VALUES (1144, '350100', '福州市', 2, 1143);
INSERT INTO `area` VALUES (1145, '350102', '鼓楼区', 3, 1144);
INSERT INTO `area` VALUES (1146, '350103', '台江区', 3, 1144);
INSERT INTO `area` VALUES (1147, '350104', '仓山区', 3, 1144);
INSERT INTO `area` VALUES (1148, '350105', '马尾区', 3, 1144);
INSERT INTO `area` VALUES (1149, '350111', '晋安区', 3, 1144);
INSERT INTO `area` VALUES (1150, '350121', '闽侯县', 3, 1144);
INSERT INTO `area` VALUES (1151, '350122', '连江县', 3, 1144);
INSERT INTO `area` VALUES (1152, '350123', '罗源县', 3, 1144);
INSERT INTO `area` VALUES (1153, '350124', '闽清县', 3, 1144);
INSERT INTO `area` VALUES (1154, '350125', '永泰县', 3, 1144);
INSERT INTO `area` VALUES (1155, '350128', '平潭县', 3, 1144);
INSERT INTO `area` VALUES (1156, '350181', '福清市', 3, 1144);
INSERT INTO `area` VALUES (1157, '350182', '长乐市', 3, 1144);
INSERT INTO `area` VALUES (1158, '350200', '厦门市', 2, 1143);
INSERT INTO `area` VALUES (1159, '350203', '思明区', 3, 1158);
INSERT INTO `area` VALUES (1160, '350205', '海沧区', 3, 1158);
INSERT INTO `area` VALUES (1161, '350206', '湖里区', 3, 1158);
INSERT INTO `area` VALUES (1162, '350211', '集美区', 3, 1158);
INSERT INTO `area` VALUES (1163, '350212', '同安区', 3, 1158);
INSERT INTO `area` VALUES (1164, '350213', '翔安区', 3, 1158);
INSERT INTO `area` VALUES (1165, '350300', '莆田市', 2, 1143);
INSERT INTO `area` VALUES (1166, '350302', '城厢区', 3, 1165);
INSERT INTO `area` VALUES (1167, '350303', '涵江区', 3, 1165);
INSERT INTO `area` VALUES (1168, '350304', '荔城区', 3, 1165);
INSERT INTO `area` VALUES (1169, '350305', '秀屿区', 3, 1165);
INSERT INTO `area` VALUES (1170, '350322', '仙游县', 3, 1165);
INSERT INTO `area` VALUES (1171, '350400', '三明市', 2, 1143);
INSERT INTO `area` VALUES (1172, '350402', '梅列区', 3, 1171);
INSERT INTO `area` VALUES (1173, '350403', '三元区', 3, 1171);
INSERT INTO `area` VALUES (1174, '350421', '明溪县', 3, 1171);
INSERT INTO `area` VALUES (1175, '350423', '清流县', 3, 1171);
INSERT INTO `area` VALUES (1176, '350424', '宁化县', 3, 1171);
INSERT INTO `area` VALUES (1177, '350425', '大田县', 3, 1171);
INSERT INTO `area` VALUES (1178, '350426', '尤溪县', 3, 1171);
INSERT INTO `area` VALUES (1179, '350427', '沙县', 3, 1171);
INSERT INTO `area` VALUES (1180, '350428', '将乐县', 3, 1171);
INSERT INTO `area` VALUES (1181, '350429', '泰宁县', 3, 1171);
INSERT INTO `area` VALUES (1182, '350430', '建宁县', 3, 1171);
INSERT INTO `area` VALUES (1183, '350481', '永安市', 3, 1171);
INSERT INTO `area` VALUES (1184, '350500', '泉州市', 2, 1143);
INSERT INTO `area` VALUES (1185, '350502', '鲤城区', 3, 1184);
INSERT INTO `area` VALUES (1186, '350503', '丰泽区', 3, 1184);
INSERT INTO `area` VALUES (1187, '350504', '洛江区', 3, 1184);
INSERT INTO `area` VALUES (1188, '350505', '泉港区', 3, 1184);
INSERT INTO `area` VALUES (1189, '350521', '惠安县', 3, 1184);
INSERT INTO `area` VALUES (1190, '350524', '安溪县', 3, 1184);
INSERT INTO `area` VALUES (1191, '350525', '永春县', 3, 1184);
INSERT INTO `area` VALUES (1192, '350526', '德化县', 3, 1184);
INSERT INTO `area` VALUES (1193, '350527', '金门县', 3, 1184);
INSERT INTO `area` VALUES (1194, '350581', '石狮市', 3, 1184);
INSERT INTO `area` VALUES (1195, '350582', '晋江市', 3, 1184);
INSERT INTO `area` VALUES (1196, '350583', '南安市', 3, 1184);
INSERT INTO `area` VALUES (1197, '350600', '漳州市', 2, 1143);
INSERT INTO `area` VALUES (1198, '350602', '芗城区', 3, 1197);
INSERT INTO `area` VALUES (1199, '350603', '龙文区', 3, 1197);
INSERT INTO `area` VALUES (1200, '350622', '云霄县', 3, 1197);
INSERT INTO `area` VALUES (1201, '350623', '漳浦县', 3, 1197);
INSERT INTO `area` VALUES (1202, '350624', '诏安县', 3, 1197);
INSERT INTO `area` VALUES (1203, '350625', '长泰县', 3, 1197);
INSERT INTO `area` VALUES (1204, '350626', '东山县', 3, 1197);
INSERT INTO `area` VALUES (1205, '350627', '南靖县', 3, 1197);
INSERT INTO `area` VALUES (1206, '350628', '平和县', 3, 1197);
INSERT INTO `area` VALUES (1207, '350629', '华安县', 3, 1197);
INSERT INTO `area` VALUES (1208, '350681', '龙海市', 3, 1197);
INSERT INTO `area` VALUES (1209, '350700', '南平市', 2, 1143);
INSERT INTO `area` VALUES (1210, '350702', '延平区', 3, 1209);
INSERT INTO `area` VALUES (1211, '350703', '建阳区', 3, 1209);
INSERT INTO `area` VALUES (1212, '350721', '顺昌县', 3, 1209);
INSERT INTO `area` VALUES (1213, '350722', '浦城县', 3, 1209);
INSERT INTO `area` VALUES (1214, '350723', '光泽县', 3, 1209);
INSERT INTO `area` VALUES (1215, '350724', '松溪县', 3, 1209);
INSERT INTO `area` VALUES (1216, '350725', '政和县', 3, 1209);
INSERT INTO `area` VALUES (1217, '350781', '邵武市', 3, 1209);
INSERT INTO `area` VALUES (1218, '350782', '武夷山市', 3, 1209);
INSERT INTO `area` VALUES (1219, '350783', '建瓯市', 3, 1209);
INSERT INTO `area` VALUES (1220, '350800', '龙岩市', 2, 1143);
INSERT INTO `area` VALUES (1221, '350802', '新罗区', 3, 1220);
INSERT INTO `area` VALUES (1222, '350803', '永定区', 3, 1220);
INSERT INTO `area` VALUES (1223, '350821', '长汀县', 3, 1220);
INSERT INTO `area` VALUES (1224, '350823', '上杭县', 3, 1220);
INSERT INTO `area` VALUES (1225, '350824', '武平县', 3, 1220);
INSERT INTO `area` VALUES (1226, '350825', '连城县', 3, 1220);
INSERT INTO `area` VALUES (1227, '350881', '漳平市', 3, 1220);
INSERT INTO `area` VALUES (1228, '350900', '宁德市', 2, 1143);
INSERT INTO `area` VALUES (1229, '350902', '蕉城区', 3, 1228);
INSERT INTO `area` VALUES (1230, '350921', '霞浦县', 3, 1228);
INSERT INTO `area` VALUES (1231, '350922', '古田县', 3, 1228);
INSERT INTO `area` VALUES (1232, '350923', '屏南县', 3, 1228);
INSERT INTO `area` VALUES (1233, '350924', '寿宁县', 3, 1228);
INSERT INTO `area` VALUES (1234, '350925', '周宁县', 3, 1228);
INSERT INTO `area` VALUES (1235, '350926', '柘荣县', 3, 1228);
INSERT INTO `area` VALUES (1236, '350981', '福安市', 3, 1228);
INSERT INTO `area` VALUES (1237, '350982', '福鼎市', 3, 1228);
INSERT INTO `area` VALUES (1238, '360000', '江西省', 1, -1);
INSERT INTO `area` VALUES (1239, '360100', '南昌市', 2, 1238);
INSERT INTO `area` VALUES (1240, '360102', '东湖区', 3, 1239);
INSERT INTO `area` VALUES (1241, '360103', '西湖区', 3, 1239);
INSERT INTO `area` VALUES (1242, '360104', '青云谱区', 3, 1239);
INSERT INTO `area` VALUES (1243, '360105', '湾里区', 3, 1239);
INSERT INTO `area` VALUES (1244, '360111', '青山湖区', 3, 1239);
INSERT INTO `area` VALUES (1245, '360112', '新建区', 3, 1239);
INSERT INTO `area` VALUES (1246, '360121', '南昌县', 3, 1239);
INSERT INTO `area` VALUES (1247, '360123', '安义县', 3, 1239);
INSERT INTO `area` VALUES (1248, '360124', '进贤县', 3, 1239);
INSERT INTO `area` VALUES (1249, '360200', '景德镇市', 2, 1238);
INSERT INTO `area` VALUES (1250, '360202', '昌江区', 3, 1249);
INSERT INTO `area` VALUES (1251, '360203', '珠山区', 3, 1249);
INSERT INTO `area` VALUES (1252, '360222', '浮梁县', 3, 1249);
INSERT INTO `area` VALUES (1253, '360281', '乐平市', 3, 1249);
INSERT INTO `area` VALUES (1254, '360300', '萍乡市', 2, 1238);
INSERT INTO `area` VALUES (1255, '360302', '安源区', 3, 1254);
INSERT INTO `area` VALUES (1256, '360313', '湘东区', 3, 1254);
INSERT INTO `area` VALUES (1257, '360321', '莲花县', 3, 1254);
INSERT INTO `area` VALUES (1258, '360322', '上栗县', 3, 1254);
INSERT INTO `area` VALUES (1259, '360323', '芦溪县', 3, 1254);
INSERT INTO `area` VALUES (1260, '360400', '九江市', 2, 1238);
INSERT INTO `area` VALUES (1261, '360402', '濂溪区', 3, 1260);
INSERT INTO `area` VALUES (1262, '360403', '浔阳区', 3, 1260);
INSERT INTO `area` VALUES (1263, '360421', '九江县', 3, 1260);
INSERT INTO `area` VALUES (1264, '360423', '武宁县', 3, 1260);
INSERT INTO `area` VALUES (1265, '360424', '修水县', 3, 1260);
INSERT INTO `area` VALUES (1266, '360425', '永修县', 3, 1260);
INSERT INTO `area` VALUES (1267, '360426', '德安县', 3, 1260);
INSERT INTO `area` VALUES (1268, '360483', '庐山市', 3, 1260);
INSERT INTO `area` VALUES (1269, '360428', '都昌县', 3, 1260);
INSERT INTO `area` VALUES (1270, '360429', '湖口县', 3, 1260);
INSERT INTO `area` VALUES (1271, '360430', '彭泽县', 3, 1260);
INSERT INTO `area` VALUES (1272, '360481', '瑞昌市', 3, 1260);
INSERT INTO `area` VALUES (1273, '360482', '共青城市', 3, 1260);
INSERT INTO `area` VALUES (1274, '360500', '新余市', 2, 1238);
INSERT INTO `area` VALUES (1275, '360502', '渝水区', 3, 1274);
INSERT INTO `area` VALUES (1276, '360521', '分宜县', 3, 1274);
INSERT INTO `area` VALUES (1277, '360600', '鹰潭市', 2, 1238);
INSERT INTO `area` VALUES (1278, '360602', '月湖区', 3, 1277);
INSERT INTO `area` VALUES (1279, '360622', '余江县', 3, 1277);
INSERT INTO `area` VALUES (1280, '360681', '贵溪市', 3, 1277);
INSERT INTO `area` VALUES (1281, '360700', '赣州市', 2, 1238);
INSERT INTO `area` VALUES (1282, '360702', '章贡区', 3, 1281);
INSERT INTO `area` VALUES (1283, '360703', '南康区', 3, 1281);
INSERT INTO `area` VALUES (1284, '360704', '赣县区', 3, 1281);
INSERT INTO `area` VALUES (1285, '360722', '信丰县', 3, 1281);
INSERT INTO `area` VALUES (1286, '360723', '大余县', 3, 1281);
INSERT INTO `area` VALUES (1287, '360724', '上犹县', 3, 1281);
INSERT INTO `area` VALUES (1288, '360725', '崇义县', 3, 1281);
INSERT INTO `area` VALUES (1289, '360726', '安远县', 3, 1281);
INSERT INTO `area` VALUES (1290, '360727', '龙南县', 3, 1281);
INSERT INTO `area` VALUES (1291, '360728', '定南县', 3, 1281);
INSERT INTO `area` VALUES (1292, '360729', '全南县', 3, 1281);
INSERT INTO `area` VALUES (1293, '360730', '宁都县', 3, 1281);
INSERT INTO `area` VALUES (1294, '360731', '于都县', 3, 1281);
INSERT INTO `area` VALUES (1295, '360732', '兴国县', 3, 1281);
INSERT INTO `area` VALUES (1296, '360733', '会昌县', 3, 1281);
INSERT INTO `area` VALUES (1297, '360734', '寻乌县', 3, 1281);
INSERT INTO `area` VALUES (1298, '360735', '石城县', 3, 1281);
INSERT INTO `area` VALUES (1299, '360781', '瑞金市', 3, 1281);
INSERT INTO `area` VALUES (1300, '360800', '吉安市', 2, 1238);
INSERT INTO `area` VALUES (1301, '360802', '吉州区', 3, 1300);
INSERT INTO `area` VALUES (1302, '360803', '青原区', 3, 1300);
INSERT INTO `area` VALUES (1303, '360821', '吉安县', 3, 1300);
INSERT INTO `area` VALUES (1304, '360822', '吉水县', 3, 1300);
INSERT INTO `area` VALUES (1305, '360823', '峡江县', 3, 1300);
INSERT INTO `area` VALUES (1306, '360824', '新干县', 3, 1300);
INSERT INTO `area` VALUES (1307, '360825', '永丰县', 3, 1300);
INSERT INTO `area` VALUES (1308, '360826', '泰和县', 3, 1300);
INSERT INTO `area` VALUES (1309, '360827', '遂川县', 3, 1300);
INSERT INTO `area` VALUES (1310, '360828', '万安县', 3, 1300);
INSERT INTO `area` VALUES (1311, '360829', '安福县', 3, 1300);
INSERT INTO `area` VALUES (1312, '360830', '永新县', 3, 1300);
INSERT INTO `area` VALUES (1313, '360881', '井冈山市', 3, 1300);
INSERT INTO `area` VALUES (1314, '360900', '宜春市', 2, 1238);
INSERT INTO `area` VALUES (1315, '360902', '袁州区', 3, 1314);
INSERT INTO `area` VALUES (1316, '360921', '奉新县', 3, 1314);
INSERT INTO `area` VALUES (1317, '360922', '万载县', 3, 1314);
INSERT INTO `area` VALUES (1318, '360923', '上高县', 3, 1314);
INSERT INTO `area` VALUES (1319, '360924', '宜丰县', 3, 1314);
INSERT INTO `area` VALUES (1320, '360925', '靖安县', 3, 1314);
INSERT INTO `area` VALUES (1321, '360926', '铜鼓县', 3, 1314);
INSERT INTO `area` VALUES (1322, '360981', '丰城市', 3, 1314);
INSERT INTO `area` VALUES (1323, '360982', '樟树市', 3, 1314);
INSERT INTO `area` VALUES (1324, '360983', '高安市', 3, 1314);
INSERT INTO `area` VALUES (1325, '361000', '抚州市', 2, 1238);
INSERT INTO `area` VALUES (1326, '361002', '临川区', 3, 1325);
INSERT INTO `area` VALUES (1327, '361021', '南城县', 3, 1325);
INSERT INTO `area` VALUES (1328, '361022', '黎川县', 3, 1325);
INSERT INTO `area` VALUES (1329, '361023', '南丰县', 3, 1325);
INSERT INTO `area` VALUES (1330, '361024', '崇仁县', 3, 1325);
INSERT INTO `area` VALUES (1331, '361025', '乐安县', 3, 1325);
INSERT INTO `area` VALUES (1332, '361026', '宜黄县', 3, 1325);
INSERT INTO `area` VALUES (1333, '361027', '金溪县', 3, 1325);
INSERT INTO `area` VALUES (1334, '361028', '资溪县', 3, 1325);
INSERT INTO `area` VALUES (1335, '361003', '东乡区', 3, 1325);
INSERT INTO `area` VALUES (1336, '361030', '广昌县', 3, 1325);
INSERT INTO `area` VALUES (1337, '361100', '上饶市', 2, 1238);
INSERT INTO `area` VALUES (1338, '361102', '信州区', 3, 1337);
INSERT INTO `area` VALUES (1339, '361103', '广丰区', 3, 1337);
INSERT INTO `area` VALUES (1340, '361121', '上饶县', 3, 1337);
INSERT INTO `area` VALUES (1341, '361123', '玉山县', 3, 1337);
INSERT INTO `area` VALUES (1342, '361124', '铅山县', 3, 1337);
INSERT INTO `area` VALUES (1343, '361125', '横峰县', 3, 1337);
INSERT INTO `area` VALUES (1344, '361126', '弋阳县', 3, 1337);
INSERT INTO `area` VALUES (1345, '361127', '余干县', 3, 1337);
INSERT INTO `area` VALUES (1346, '361128', '鄱阳县', 3, 1337);
INSERT INTO `area` VALUES (1347, '361129', '万年县', 3, 1337);
INSERT INTO `area` VALUES (1348, '361130', '婺源县', 3, 1337);
INSERT INTO `area` VALUES (1349, '361181', '德兴市', 3, 1337);
INSERT INTO `area` VALUES (1350, '370000', '山东省', 1, -1);
INSERT INTO `area` VALUES (1351, '370100', '济南市', 2, 1350);
INSERT INTO `area` VALUES (1352, '370102', '历下区', 3, 1351);
INSERT INTO `area` VALUES (1353, '370103', '市中区', 3, 1351);
INSERT INTO `area` VALUES (1354, '370104', '槐荫区', 3, 1351);
INSERT INTO `area` VALUES (1355, '370105', '天桥区', 3, 1351);
INSERT INTO `area` VALUES (1356, '370112', '历城区', 3, 1351);
INSERT INTO `area` VALUES (1357, '370113', '长清区', 3, 1351);
INSERT INTO `area` VALUES (1358, '370124', '平阴县', 3, 1351);
INSERT INTO `area` VALUES (1359, '370125', '济阳县', 3, 1351);
INSERT INTO `area` VALUES (1360, '370126', '商河县', 3, 1351);
INSERT INTO `area` VALUES (1361, '370114', '章丘区', 3, 1351);
INSERT INTO `area` VALUES (1362, '370200', '青岛市', 2, 1350);
INSERT INTO `area` VALUES (1363, '370202', '市南区', 3, 1362);
INSERT INTO `area` VALUES (1364, '370203', '市北区', 3, 1362);
INSERT INTO `area` VALUES (1365, '370211', '黄岛区', 3, 1362);
INSERT INTO `area` VALUES (1366, '370212', '崂山区', 3, 1362);
INSERT INTO `area` VALUES (1367, '370213', '李沧区', 3, 1362);
INSERT INTO `area` VALUES (1368, '370214', '城阳区', 3, 1362);
INSERT INTO `area` VALUES (1369, '370281', '胶州市', 3, 1362);
INSERT INTO `area` VALUES (1370, '370282', '即墨市', 3, 1362);
INSERT INTO `area` VALUES (1371, '370283', '平度市', 3, 1362);
INSERT INTO `area` VALUES (1372, '370285', '莱西市', 3, 1362);
INSERT INTO `area` VALUES (1373, '370300', '淄博市', 2, 1350);
INSERT INTO `area` VALUES (1374, '370302', '淄川区', 3, 1373);
INSERT INTO `area` VALUES (1375, '370303', '张店区', 3, 1373);
INSERT INTO `area` VALUES (1376, '370304', '博山区', 3, 1373);
INSERT INTO `area` VALUES (1377, '370305', '临淄区', 3, 1373);
INSERT INTO `area` VALUES (1378, '370306', '周村区', 3, 1373);
INSERT INTO `area` VALUES (1379, '370321', '桓台县', 3, 1373);
INSERT INTO `area` VALUES (1380, '370322', '高青县', 3, 1373);
INSERT INTO `area` VALUES (1381, '370323', '沂源县', 3, 1373);
INSERT INTO `area` VALUES (1382, '370400', '枣庄市', 2, 1350);
INSERT INTO `area` VALUES (1383, '370402', '市中区', 3, 1382);
INSERT INTO `area` VALUES (1384, '370403', '薛城区', 3, 1382);
INSERT INTO `area` VALUES (1385, '370404', '峄城区', 3, 1382);
INSERT INTO `area` VALUES (1386, '370405', '台儿庄区', 3, 1382);
INSERT INTO `area` VALUES (1387, '370406', '山亭区', 3, 1382);
INSERT INTO `area` VALUES (1388, '370481', '滕州市', 3, 1382);
INSERT INTO `area` VALUES (1389, '370500', '东营市', 2, 1350);
INSERT INTO `area` VALUES (1390, '370502', '东营区', 3, 1389);
INSERT INTO `area` VALUES (1391, '370503', '河口区', 3, 1389);
INSERT INTO `area` VALUES (1392, '370505', '垦利区', 3, 1389);
INSERT INTO `area` VALUES (1393, '370522', '利津县', 3, 1389);
INSERT INTO `area` VALUES (1394, '370523', '广饶县', 3, 1389);
INSERT INTO `area` VALUES (1395, '370600', '烟台市', 2, 1350);
INSERT INTO `area` VALUES (1396, '370602', '芝罘区', 3, 1395);
INSERT INTO `area` VALUES (1397, '370611', '福山区', 3, 1395);
INSERT INTO `area` VALUES (1398, '370612', '牟平区', 3, 1395);
INSERT INTO `area` VALUES (1399, '370613', '莱山区', 3, 1395);
INSERT INTO `area` VALUES (1400, '370634', '长岛县', 3, 1395);
INSERT INTO `area` VALUES (1401, '370681', '龙口市', 3, 1395);
INSERT INTO `area` VALUES (1402, '370682', '莱阳市', 3, 1395);
INSERT INTO `area` VALUES (1403, '370683', '莱州市', 3, 1395);
INSERT INTO `area` VALUES (1404, '370684', '蓬莱市', 3, 1395);
INSERT INTO `area` VALUES (1405, '370685', '招远市', 3, 1395);
INSERT INTO `area` VALUES (1406, '370686', '栖霞市', 3, 1395);
INSERT INTO `area` VALUES (1407, '370687', '海阳市', 3, 1395);
INSERT INTO `area` VALUES (1408, '370700', '潍坊市', 2, 1350);
INSERT INTO `area` VALUES (1409, '370702', '潍城区', 3, 1408);
INSERT INTO `area` VALUES (1410, '370703', '寒亭区', 3, 1408);
INSERT INTO `area` VALUES (1411, '370704', '坊子区', 3, 1408);
INSERT INTO `area` VALUES (1412, '370705', '奎文区', 3, 1408);
INSERT INTO `area` VALUES (1413, '370724', '临朐县', 3, 1408);
INSERT INTO `area` VALUES (1414, '370725', '昌乐县', 3, 1408);
INSERT INTO `area` VALUES (1415, '370781', '青州市', 3, 1408);
INSERT INTO `area` VALUES (1416, '370782', '诸城市', 3, 1408);
INSERT INTO `area` VALUES (1417, '370783', '寿光市', 3, 1408);
INSERT INTO `area` VALUES (1418, '370784', '安丘市', 3, 1408);
INSERT INTO `area` VALUES (1419, '370785', '高密市', 3, 1408);
INSERT INTO `area` VALUES (1420, '370786', '昌邑市', 3, 1408);
INSERT INTO `area` VALUES (1421, '370800', '济宁市', 2, 1350);
INSERT INTO `area` VALUES (1422, '370811', '任城区', 3, 1421);
INSERT INTO `area` VALUES (1423, '370812', '兖州区', 3, 1421);
INSERT INTO `area` VALUES (1424, '370826', '微山县', 3, 1421);
INSERT INTO `area` VALUES (1425, '370827', '鱼台县', 3, 1421);
INSERT INTO `area` VALUES (1426, '370828', '金乡县', 3, 1421);
INSERT INTO `area` VALUES (1427, '370829', '嘉祥县', 3, 1421);
INSERT INTO `area` VALUES (1428, '370830', '汶上县', 3, 1421);
INSERT INTO `area` VALUES (1429, '370831', '泗水县', 3, 1421);
INSERT INTO `area` VALUES (1430, '370832', '梁山县', 3, 1421);
INSERT INTO `area` VALUES (1431, '370881', '曲阜市', 3, 1421);
INSERT INTO `area` VALUES (1432, '370883', '邹城市', 3, 1421);
INSERT INTO `area` VALUES (1433, '370900', '泰安市', 2, 1350);
INSERT INTO `area` VALUES (1434, '370902', '泰山区', 3, 1433);
INSERT INTO `area` VALUES (1435, '370911', '岱岳区', 3, 1433);
INSERT INTO `area` VALUES (1436, '370921', '宁阳县', 3, 1433);
INSERT INTO `area` VALUES (1437, '370923', '东平县', 3, 1433);
INSERT INTO `area` VALUES (1438, '370982', '新泰市', 3, 1433);
INSERT INTO `area` VALUES (1439, '370983', '肥城市', 3, 1433);
INSERT INTO `area` VALUES (1440, '371000', '威海市', 2, 1350);
INSERT INTO `area` VALUES (1441, '371002', '环翠区', 3, 1440);
INSERT INTO `area` VALUES (1442, '371003', '文登区', 3, 1440);
INSERT INTO `area` VALUES (1443, '371082', '荣成市', 3, 1440);
INSERT INTO `area` VALUES (1444, '371083', '乳山市', 3, 1440);
INSERT INTO `area` VALUES (1445, '371100', '日照市', 2, 1350);
INSERT INTO `area` VALUES (1446, '371102', '东港区', 3, 1445);
INSERT INTO `area` VALUES (1447, '371103', '岚山区', 3, 1445);
INSERT INTO `area` VALUES (1448, '371121', '五莲县', 3, 1445);
INSERT INTO `area` VALUES (1449, '371122', '莒县', 3, 1445);
INSERT INTO `area` VALUES (1450, '371200', '莱芜市', 2, 1350);
INSERT INTO `area` VALUES (1451, '371202', '莱城区', 3, 1450);
INSERT INTO `area` VALUES (1452, '371203', '钢城区', 3, 1450);
INSERT INTO `area` VALUES (1453, '371300', '临沂市', 2, 1350);
INSERT INTO `area` VALUES (1454, '371302', '兰山区', 3, 1453);
INSERT INTO `area` VALUES (1455, '371311', '罗庄区', 3, 1453);
INSERT INTO `area` VALUES (1456, '371312', '河东区', 3, 1453);
INSERT INTO `area` VALUES (1457, '371321', '沂南县', 3, 1453);
INSERT INTO `area` VALUES (1458, '371322', '郯城县', 3, 1453);
INSERT INTO `area` VALUES (1459, '371323', '沂水县', 3, 1453);
INSERT INTO `area` VALUES (1460, '371324', '兰陵县', 3, 1453);
INSERT INTO `area` VALUES (1461, '371325', '费县', 3, 1453);
INSERT INTO `area` VALUES (1462, '371326', '平邑县', 3, 1453);
INSERT INTO `area` VALUES (1463, '371327', '莒南县', 3, 1453);
INSERT INTO `area` VALUES (1464, '371328', '蒙阴县', 3, 1453);
INSERT INTO `area` VALUES (1465, '371329', '临沭县', 3, 1453);
INSERT INTO `area` VALUES (1466, '371400', '德州市', 2, 1350);
INSERT INTO `area` VALUES (1467, '371402', '德城区', 3, 1466);
INSERT INTO `area` VALUES (1468, '371403', '陵城区', 3, 1466);
INSERT INTO `area` VALUES (1469, '371422', '宁津县', 3, 1466);
INSERT INTO `area` VALUES (1470, '371423', '庆云县', 3, 1466);
INSERT INTO `area` VALUES (1471, '371424', '临邑县', 3, 1466);
INSERT INTO `area` VALUES (1472, '371425', '齐河县', 3, 1466);
INSERT INTO `area` VALUES (1473, '371426', '平原县', 3, 1466);
INSERT INTO `area` VALUES (1474, '371427', '夏津县', 3, 1466);
INSERT INTO `area` VALUES (1475, '371428', '武城县', 3, 1466);
INSERT INTO `area` VALUES (1476, '371481', '乐陵市', 3, 1466);
INSERT INTO `area` VALUES (1477, '371482', '禹城市', 3, 1466);
INSERT INTO `area` VALUES (1478, '371500', '聊城市', 2, 1350);
INSERT INTO `area` VALUES (1479, '371502', '东昌府区', 3, 1478);
INSERT INTO `area` VALUES (1480, '371521', '阳谷县', 3, 1478);
INSERT INTO `area` VALUES (1481, '371522', '莘县', 3, 1478);
INSERT INTO `area` VALUES (1482, '371523', '茌平县', 3, 1478);
INSERT INTO `area` VALUES (1483, '371524', '东阿县', 3, 1478);
INSERT INTO `area` VALUES (1484, '371525', '冠县', 3, 1478);
INSERT INTO `area` VALUES (1485, '371526', '高唐县', 3, 1478);
INSERT INTO `area` VALUES (1486, '371581', '临清市', 3, 1478);
INSERT INTO `area` VALUES (1487, '371600', '滨州市', 2, 1350);
INSERT INTO `area` VALUES (1488, '371602', '滨城区', 3, 1487);
INSERT INTO `area` VALUES (1489, '371603', '沾化区', 3, 1487);
INSERT INTO `area` VALUES (1490, '371621', '惠民县', 3, 1487);
INSERT INTO `area` VALUES (1491, '371622', '阳信县', 3, 1487);
INSERT INTO `area` VALUES (1492, '371623', '无棣县', 3, 1487);
INSERT INTO `area` VALUES (1493, '371625', '博兴县', 3, 1487);
INSERT INTO `area` VALUES (1494, '371626', '邹平县', 3, 1487);
INSERT INTO `area` VALUES (1495, '371700', '菏泽市', 2, 1350);
INSERT INTO `area` VALUES (1496, '371702', '牡丹区', 3, 1495);
INSERT INTO `area` VALUES (1497, '371703', '定陶区', 3, 1495);
INSERT INTO `area` VALUES (1498, '371721', '曹县', 3, 1495);
INSERT INTO `area` VALUES (1499, '371722', '单县', 3, 1495);
INSERT INTO `area` VALUES (1500, '371723', '成武县', 3, 1495);
INSERT INTO `area` VALUES (1501, '371724', '巨野县', 3, 1495);
INSERT INTO `area` VALUES (1502, '371725', '郓城县', 3, 1495);
INSERT INTO `area` VALUES (1503, '371726', '鄄城县', 3, 1495);
INSERT INTO `area` VALUES (1504, '371728', '东明县', 3, 1495);
INSERT INTO `area` VALUES (1505, '410000', '河南省', 1, -1);
INSERT INTO `area` VALUES (1506, '410100', '郑州市', 2, 1505);
INSERT INTO `area` VALUES (1507, '410102', '中原区', 3, 1506);
INSERT INTO `area` VALUES (1508, '410103', '二七区', 3, 1506);
INSERT INTO `area` VALUES (1509, '410104', '管城回族区', 3, 1506);
INSERT INTO `area` VALUES (1510, '410105', '金水区', 3, 1506);
INSERT INTO `area` VALUES (1511, '410106', '上街区', 3, 1506);
INSERT INTO `area` VALUES (1512, '410108', '惠济区', 3, 1506);
INSERT INTO `area` VALUES (1513, '410122', '中牟县', 3, 1506);
INSERT INTO `area` VALUES (1514, '410181', '巩义市', 3, 1506);
INSERT INTO `area` VALUES (1515, '410182', '荥阳市', 3, 1506);
INSERT INTO `area` VALUES (1516, '410183', '新密市', 3, 1506);
INSERT INTO `area` VALUES (1517, '410184', '新郑市', 3, 1506);
INSERT INTO `area` VALUES (1518, '410185', '登封市', 3, 1506);
INSERT INTO `area` VALUES (1519, '410200', '开封市', 2, 1505);
INSERT INTO `area` VALUES (1520, '410202', '龙亭区', 3, 1519);
INSERT INTO `area` VALUES (1521, '410203', '顺河回族区', 3, 1519);
INSERT INTO `area` VALUES (1522, '410204', '鼓楼区', 3, 1519);
INSERT INTO `area` VALUES (1523, '410205', '禹王台区', 3, 1519);
INSERT INTO `area` VALUES (1524, '410212', '祥符区', 3, 1519);
INSERT INTO `area` VALUES (1525, '410221', '杞县', 3, 1519);
INSERT INTO `area` VALUES (1526, '410222', '通许县', 3, 1519);
INSERT INTO `area` VALUES (1527, '410223', '尉氏县', 3, 1519);
INSERT INTO `area` VALUES (1528, '410225', '兰考县', 3, 1519);
INSERT INTO `area` VALUES (1529, '410300', '洛阳市', 2, 1505);
INSERT INTO `area` VALUES (1530, '410302', '老城区', 3, 1529);
INSERT INTO `area` VALUES (1531, '410303', '西工区', 3, 1529);
INSERT INTO `area` VALUES (1532, '410304', '瀍河回族区', 3, 1529);
INSERT INTO `area` VALUES (1533, '410305', '涧西区', 3, 1529);
INSERT INTO `area` VALUES (1534, '410306', '吉利区', 3, 1529);
INSERT INTO `area` VALUES (1535, '410311', '洛龙区', 3, 1529);
INSERT INTO `area` VALUES (1536, '410322', '孟津县', 3, 1529);
INSERT INTO `area` VALUES (1537, '410323', '新安县', 3, 1529);
INSERT INTO `area` VALUES (1538, '410324', '栾川县', 3, 1529);
INSERT INTO `area` VALUES (1539, '410325', '嵩县', 3, 1529);
INSERT INTO `area` VALUES (1540, '410326', '汝阳县', 3, 1529);
INSERT INTO `area` VALUES (1541, '410327', '宜阳县', 3, 1529);
INSERT INTO `area` VALUES (1542, '410328', '洛宁县', 3, 1529);
INSERT INTO `area` VALUES (1543, '410329', '伊川县', 3, 1529);
INSERT INTO `area` VALUES (1544, '410381', '偃师市', 3, 1529);
INSERT INTO `area` VALUES (1545, '410400', '平顶山市', 2, 1505);
INSERT INTO `area` VALUES (1546, '410402', '新华区', 3, 1545);
INSERT INTO `area` VALUES (1547, '410403', '卫东区', 3, 1545);
INSERT INTO `area` VALUES (1548, '410404', '石龙区', 3, 1545);
INSERT INTO `area` VALUES (1549, '410411', '湛河区', 3, 1545);
INSERT INTO `area` VALUES (1550, '410421', '宝丰县', 3, 1545);
INSERT INTO `area` VALUES (1551, '410422', '叶县', 3, 1545);
INSERT INTO `area` VALUES (1552, '410423', '鲁山县', 3, 1545);
INSERT INTO `area` VALUES (1553, '410425', '郏县', 3, 1545);
INSERT INTO `area` VALUES (1554, '410481', '舞钢市', 3, 1545);
INSERT INTO `area` VALUES (1555, '410482', '汝州市', 3, 1545);
INSERT INTO `area` VALUES (1556, '410500', '安阳市', 2, 1505);
INSERT INTO `area` VALUES (1557, '410502', '文峰区', 3, 1556);
INSERT INTO `area` VALUES (1558, '410503', '北关区', 3, 1556);
INSERT INTO `area` VALUES (1559, '410505', '殷都区', 3, 1556);
INSERT INTO `area` VALUES (1560, '410506', '龙安区', 3, 1556);
INSERT INTO `area` VALUES (1561, '410522', '安阳县', 3, 1556);
INSERT INTO `area` VALUES (1562, '410523', '汤阴县', 3, 1556);
INSERT INTO `area` VALUES (1563, '410526', '滑县', 3, 1556);
INSERT INTO `area` VALUES (1564, '410527', '内黄县', 3, 1556);
INSERT INTO `area` VALUES (1565, '410581', '林州市', 3, 1556);
INSERT INTO `area` VALUES (1566, '410600', '鹤壁市', 2, 1505);
INSERT INTO `area` VALUES (1567, '410602', '鹤山区', 3, 1566);
INSERT INTO `area` VALUES (1568, '410603', '山城区', 3, 1566);
INSERT INTO `area` VALUES (1569, '410611', '淇滨区', 3, 1566);
INSERT INTO `area` VALUES (1570, '410621', '浚县', 3, 1566);
INSERT INTO `area` VALUES (1571, '410622', '淇县', 3, 1566);
INSERT INTO `area` VALUES (1572, '410700', '新乡市', 2, 1505);
INSERT INTO `area` VALUES (1573, '410702', '红旗区', 3, 1572);
INSERT INTO `area` VALUES (1574, '410703', '卫滨区', 3, 1572);
INSERT INTO `area` VALUES (1575, '410704', '凤泉区', 3, 1572);
INSERT INTO `area` VALUES (1576, '410711', '牧野区', 3, 1572);
INSERT INTO `area` VALUES (1577, '410721', '新乡县', 3, 1572);
INSERT INTO `area` VALUES (1578, '410724', '获嘉县', 3, 1572);
INSERT INTO `area` VALUES (1579, '410725', '原阳县', 3, 1572);
INSERT INTO `area` VALUES (1580, '410726', '延津县', 3, 1572);
INSERT INTO `area` VALUES (1581, '410727', '封丘县', 3, 1572);
INSERT INTO `area` VALUES (1582, '410728', '长垣县', 3, 1572);
INSERT INTO `area` VALUES (1583, '410781', '卫辉市', 3, 1572);
INSERT INTO `area` VALUES (1584, '410782', '辉县市', 3, 1572);
INSERT INTO `area` VALUES (1585, '410800', '焦作市', 2, 1505);
INSERT INTO `area` VALUES (1586, '410802', '解放区', 3, 1585);
INSERT INTO `area` VALUES (1587, '410803', '中站区', 3, 1585);
INSERT INTO `area` VALUES (1588, '410804', '马村区', 3, 1585);
INSERT INTO `area` VALUES (1589, '410811', '山阳区', 3, 1585);
INSERT INTO `area` VALUES (1590, '410821', '修武县', 3, 1585);
INSERT INTO `area` VALUES (1591, '410822', '博爱县', 3, 1585);
INSERT INTO `area` VALUES (1592, '410823', '武陟县', 3, 1585);
INSERT INTO `area` VALUES (1593, '410825', '温县', 3, 1585);
INSERT INTO `area` VALUES (1594, '410882', '沁阳市', 3, 1585);
INSERT INTO `area` VALUES (1595, '410883', '孟州市', 3, 1585);
INSERT INTO `area` VALUES (1596, '410900', '濮阳市', 2, 1505);
INSERT INTO `area` VALUES (1597, '410902', '华龙区', 3, 1596);
INSERT INTO `area` VALUES (1598, '410922', '清丰县', 3, 1596);
INSERT INTO `area` VALUES (1599, '410923', '南乐县', 3, 1596);
INSERT INTO `area` VALUES (1600, '410926', '范县', 3, 1596);
INSERT INTO `area` VALUES (1601, '410927', '台前县', 3, 1596);
INSERT INTO `area` VALUES (1602, '410928', '濮阳县', 3, 1596);
INSERT INTO `area` VALUES (1603, '411000', '许昌市', 2, 1505);
INSERT INTO `area` VALUES (1604, '411002', '魏都区', 3, 1603);
INSERT INTO `area` VALUES (1605, '411003', '建安区', 3, 1603);
INSERT INTO `area` VALUES (1606, '411024', '鄢陵县', 3, 1603);
INSERT INTO `area` VALUES (1607, '411025', '襄城县', 3, 1603);
INSERT INTO `area` VALUES (1608, '411081', '禹州市', 3, 1603);
INSERT INTO `area` VALUES (1609, '411082', '长葛市', 3, 1603);
INSERT INTO `area` VALUES (1610, '411100', '漯河市', 2, 1505);
INSERT INTO `area` VALUES (1611, '411102', '源汇区', 3, 1610);
INSERT INTO `area` VALUES (1612, '411103', '郾城区', 3, 1610);
INSERT INTO `area` VALUES (1613, '411104', '召陵区', 3, 1610);
INSERT INTO `area` VALUES (1614, '411121', '舞阳县', 3, 1610);
INSERT INTO `area` VALUES (1615, '411122', '临颍县', 3, 1610);
INSERT INTO `area` VALUES (1616, '411200', '三门峡市', 2, 1505);
INSERT INTO `area` VALUES (1617, '411202', '湖滨区', 3, 1616);
INSERT INTO `area` VALUES (1618, '411203', '陕州区', 3, 1616);
INSERT INTO `area` VALUES (1619, '411221', '渑池县', 3, 1616);
INSERT INTO `area` VALUES (1620, '411224', '卢氏县', 3, 1616);
INSERT INTO `area` VALUES (1621, '411281', '义马市', 3, 1616);
INSERT INTO `area` VALUES (1622, '411282', '灵宝市', 3, 1616);
INSERT INTO `area` VALUES (1623, '411300', '南阳市', 2, 1505);
INSERT INTO `area` VALUES (1624, '411302', '宛城区', 3, 1623);
INSERT INTO `area` VALUES (1625, '411303', '卧龙区', 3, 1623);
INSERT INTO `area` VALUES (1626, '411321', '南召县', 3, 1623);
INSERT INTO `area` VALUES (1627, '411322', '方城县', 3, 1623);
INSERT INTO `area` VALUES (1628, '411323', '西峡县', 3, 1623);
INSERT INTO `area` VALUES (1629, '411324', '镇平县', 3, 1623);
INSERT INTO `area` VALUES (1630, '411325', '内乡县', 3, 1623);
INSERT INTO `area` VALUES (1631, '411326', '淅川县', 3, 1623);
INSERT INTO `area` VALUES (1632, '411327', '社旗县', 3, 1623);
INSERT INTO `area` VALUES (1633, '411328', '唐河县', 3, 1623);
INSERT INTO `area` VALUES (1634, '411329', '新野县', 3, 1623);
INSERT INTO `area` VALUES (1635, '411330', '桐柏县', 3, 1623);
INSERT INTO `area` VALUES (1636, '411381', '邓州市', 3, 1623);
INSERT INTO `area` VALUES (1637, '411400', '商丘市', 2, 1505);
INSERT INTO `area` VALUES (1638, '411402', '梁园区', 3, 1637);
INSERT INTO `area` VALUES (1639, '411403', '睢阳区', 3, 1637);
INSERT INTO `area` VALUES (1640, '411421', '民权县', 3, 1637);
INSERT INTO `area` VALUES (1641, '411422', '睢县', 3, 1637);
INSERT INTO `area` VALUES (1642, '411423', '宁陵县', 3, 1637);
INSERT INTO `area` VALUES (1643, '411424', '柘城县', 3, 1637);
INSERT INTO `area` VALUES (1644, '411425', '虞城县', 3, 1637);
INSERT INTO `area` VALUES (1645, '411426', '夏邑县', 3, 1637);
INSERT INTO `area` VALUES (1646, '411481', '永城市', 3, 1637);
INSERT INTO `area` VALUES (1647, '411500', '信阳市', 2, 1505);
INSERT INTO `area` VALUES (1648, '411502', '浉河区', 3, 1647);
INSERT INTO `area` VALUES (1649, '411503', '平桥区', 3, 1647);
INSERT INTO `area` VALUES (1650, '411521', '罗山县', 3, 1647);
INSERT INTO `area` VALUES (1651, '411522', '光山县', 3, 1647);
INSERT INTO `area` VALUES (1652, '411523', '新县', 3, 1647);
INSERT INTO `area` VALUES (1653, '411524', '商城县', 3, 1647);
INSERT INTO `area` VALUES (1654, '411525', '固始县', 3, 1647);
INSERT INTO `area` VALUES (1655, '411526', '潢川县', 3, 1647);
INSERT INTO `area` VALUES (1656, '411527', '淮滨县', 3, 1647);
INSERT INTO `area` VALUES (1657, '411528', '息县', 3, 1647);
INSERT INTO `area` VALUES (1658, '411600', '周口市', 2, 1505);
INSERT INTO `area` VALUES (1659, '411602', '川汇区', 3, 1658);
INSERT INTO `area` VALUES (1660, '411621', '扶沟县', 3, 1658);
INSERT INTO `area` VALUES (1661, '411622', '西华县', 3, 1658);
INSERT INTO `area` VALUES (1662, '411623', '商水县', 3, 1658);
INSERT INTO `area` VALUES (1663, '411624', '沈丘县', 3, 1658);
INSERT INTO `area` VALUES (1664, '411625', '郸城县', 3, 1658);
INSERT INTO `area` VALUES (1665, '411626', '淮阳县', 3, 1658);
INSERT INTO `area` VALUES (1666, '411627', '太康县', 3, 1658);
INSERT INTO `area` VALUES (1667, '411628', '鹿邑县', 3, 1658);
INSERT INTO `area` VALUES (1668, '411681', '项城市', 3, 1658);
INSERT INTO `area` VALUES (1669, '411700', '驻马店市', 2, 1505);
INSERT INTO `area` VALUES (1670, '411702', '驿城区', 3, 1669);
INSERT INTO `area` VALUES (1671, '411721', '西平县', 3, 1669);
INSERT INTO `area` VALUES (1672, '411722', '上蔡县', 3, 1669);
INSERT INTO `area` VALUES (1673, '411723', '平舆县', 3, 1669);
INSERT INTO `area` VALUES (1674, '411724', '正阳县', 3, 1669);
INSERT INTO `area` VALUES (1675, '411725', '确山县', 3, 1669);
INSERT INTO `area` VALUES (1676, '411726', '泌阳县', 3, 1669);
INSERT INTO `area` VALUES (1677, '411727', '汝南县', 3, 1669);
INSERT INTO `area` VALUES (1678, '411728', '遂平县', 3, 1669);
INSERT INTO `area` VALUES (1679, '411729', '新蔡县', 3, 1669);
INSERT INTO `area` VALUES (1680, '419001', '济源市', 2, 1505);
INSERT INTO `area` VALUES (1681, '420000', '湖北省', 1, -1);
INSERT INTO `area` VALUES (1682, '420100', '武汉市', 2, 1681);
INSERT INTO `area` VALUES (1683, '420102', '江岸区', 3, 1682);
INSERT INTO `area` VALUES (1684, '420103', '江汉区', 3, 1682);
INSERT INTO `area` VALUES (1685, '420104', '硚口区', 3, 1682);
INSERT INTO `area` VALUES (1686, '420105', '汉阳区', 3, 1682);
INSERT INTO `area` VALUES (1687, '420106', '武昌区', 3, 1682);
INSERT INTO `area` VALUES (1688, '420107', '青山区', 3, 1682);
INSERT INTO `area` VALUES (1689, '420111', '洪山区', 3, 1682);
INSERT INTO `area` VALUES (1690, '420112', '东西湖区', 3, 1682);
INSERT INTO `area` VALUES (1691, '420113', '汉南区', 3, 1682);
INSERT INTO `area` VALUES (1692, '420114', '蔡甸区', 3, 1682);
INSERT INTO `area` VALUES (1693, '420115', '江夏区', 3, 1682);
INSERT INTO `area` VALUES (1694, '420116', '黄陂区', 3, 1682);
INSERT INTO `area` VALUES (1695, '420117', '新洲区', 3, 1682);
INSERT INTO `area` VALUES (1696, '420200', '黄石市', 2, 1681);
INSERT INTO `area` VALUES (1697, '420202', '黄石港区', 3, 1696);
INSERT INTO `area` VALUES (1698, '420203', '西塞山区', 3, 1696);
INSERT INTO `area` VALUES (1699, '420204', '下陆区', 3, 1696);
INSERT INTO `area` VALUES (1700, '420205', '铁山区', 3, 1696);
INSERT INTO `area` VALUES (1701, '420222', '阳新县', 3, 1696);
INSERT INTO `area` VALUES (1702, '420281', '大冶市', 3, 1696);
INSERT INTO `area` VALUES (1703, '420300', '十堰市', 2, 1681);
INSERT INTO `area` VALUES (1704, '420302', '茅箭区', 3, 1703);
INSERT INTO `area` VALUES (1705, '420303', '张湾区', 3, 1703);
INSERT INTO `area` VALUES (1706, '420304', '郧阳区', 3, 1703);
INSERT INTO `area` VALUES (1707, '420322', '郧西县', 3, 1703);
INSERT INTO `area` VALUES (1708, '420323', '竹山县', 3, 1703);
INSERT INTO `area` VALUES (1709, '420324', '竹溪县', 3, 1703);
INSERT INTO `area` VALUES (1710, '420325', '房县', 3, 1703);
INSERT INTO `area` VALUES (1711, '420381', '丹江口市', 3, 1703);
INSERT INTO `area` VALUES (1712, '420500', '宜昌市', 2, 1681);
INSERT INTO `area` VALUES (1713, '420502', '西陵区', 3, 1712);
INSERT INTO `area` VALUES (1714, '420503', '伍家岗区', 3, 1712);
INSERT INTO `area` VALUES (1715, '420504', '点军区', 3, 1712);
INSERT INTO `area` VALUES (1716, '420505', '猇亭区', 3, 1712);
INSERT INTO `area` VALUES (1717, '420506', '夷陵区', 3, 1712);
INSERT INTO `area` VALUES (1718, '420525', '远安县', 3, 1712);
INSERT INTO `area` VALUES (1719, '420526', '兴山县', 3, 1712);
INSERT INTO `area` VALUES (1720, '420527', '秭归县', 3, 1712);
INSERT INTO `area` VALUES (1721, '420528', '长阳土家族自治县', 3, 1712);
INSERT INTO `area` VALUES (1722, '420529', '五峰土家族自治县', 3, 1712);
INSERT INTO `area` VALUES (1723, '420581', '宜都市', 3, 1712);
INSERT INTO `area` VALUES (1724, '420582', '当阳市', 3, 1712);
INSERT INTO `area` VALUES (1725, '420583', '枝江市', 3, 1712);
INSERT INTO `area` VALUES (1726, '420600', '襄阳市', 2, 1681);
INSERT INTO `area` VALUES (1727, '420602', '襄城区', 3, 1726);
INSERT INTO `area` VALUES (1728, '420606', '樊城区', 3, 1726);
INSERT INTO `area` VALUES (1729, '420607', '襄州区', 3, 1726);
INSERT INTO `area` VALUES (1730, '420624', '南漳县', 3, 1726);
INSERT INTO `area` VALUES (1731, '420625', '谷城县', 3, 1726);
INSERT INTO `area` VALUES (1732, '420626', '保康县', 3, 1726);
INSERT INTO `area` VALUES (1733, '420682', '老河口市', 3, 1726);
INSERT INTO `area` VALUES (1734, '420683', '枣阳市', 3, 1726);
INSERT INTO `area` VALUES (1735, '420684', '宜城市', 3, 1726);
INSERT INTO `area` VALUES (1736, '420700', '鄂州市', 2, 1681);
INSERT INTO `area` VALUES (1737, '420702', '梁子湖区', 3, 1736);
INSERT INTO `area` VALUES (1738, '420703', '华容区', 3, 1736);
INSERT INTO `area` VALUES (1739, '420704', '鄂城区', 3, 1736);
INSERT INTO `area` VALUES (1740, '420800', '荆门市', 2, 1681);
INSERT INTO `area` VALUES (1741, '420802', '东宝区', 3, 1740);
INSERT INTO `area` VALUES (1742, '420804', '掇刀区', 3, 1740);
INSERT INTO `area` VALUES (1743, '420821', '京山县', 3, 1740);
INSERT INTO `area` VALUES (1744, '420822', '沙洋县', 3, 1740);
INSERT INTO `area` VALUES (1745, '420881', '钟祥市', 3, 1740);
INSERT INTO `area` VALUES (1746, '420900', '孝感市', 2, 1681);
INSERT INTO `area` VALUES (1747, '420902', '孝南区', 3, 1746);
INSERT INTO `area` VALUES (1748, '420921', '孝昌县', 3, 1746);
INSERT INTO `area` VALUES (1749, '420922', '大悟县', 3, 1746);
INSERT INTO `area` VALUES (1750, '420923', '云梦县', 3, 1746);
INSERT INTO `area` VALUES (1751, '420981', '应城市', 3, 1746);
INSERT INTO `area` VALUES (1752, '420982', '安陆市', 3, 1746);
INSERT INTO `area` VALUES (1753, '420984', '汉川市', 3, 1746);
INSERT INTO `area` VALUES (1754, '421000', '荆州市', 2, 1681);
INSERT INTO `area` VALUES (1755, '421002', '沙市区', 3, 1754);
INSERT INTO `area` VALUES (1756, '421003', '荆州区', 3, 1754);
INSERT INTO `area` VALUES (1757, '421022', '公安县', 3, 1754);
INSERT INTO `area` VALUES (1758, '421023', '监利县', 3, 1754);
INSERT INTO `area` VALUES (1759, '421024', '江陵县', 3, 1754);
INSERT INTO `area` VALUES (1760, '421081', '石首市', 3, 1754);
INSERT INTO `area` VALUES (1761, '421083', '洪湖市', 3, 1754);
INSERT INTO `area` VALUES (1762, '421087', '松滋市', 3, 1754);
INSERT INTO `area` VALUES (1763, '421100', '黄冈市', 2, 1681);
INSERT INTO `area` VALUES (1764, '421102', '黄州区', 3, 1763);
INSERT INTO `area` VALUES (1765, '421121', '团风县', 3, 1763);
INSERT INTO `area` VALUES (1766, '421122', '红安县', 3, 1763);
INSERT INTO `area` VALUES (1767, '421123', '罗田县', 3, 1763);
INSERT INTO `area` VALUES (1768, '421124', '英山县', 3, 1763);
INSERT INTO `area` VALUES (1769, '421125', '浠水县', 3, 1763);
INSERT INTO `area` VALUES (1770, '421126', '蕲春县', 3, 1763);
INSERT INTO `area` VALUES (1771, '421127', '黄梅县', 3, 1763);
INSERT INTO `area` VALUES (1772, '421181', '麻城市', 3, 1763);
INSERT INTO `area` VALUES (1773, '421182', '武穴市', 3, 1763);
INSERT INTO `area` VALUES (1774, '421200', '咸宁市', 2, 1681);
INSERT INTO `area` VALUES (1775, '421202', '咸安区', 3, 1774);
INSERT INTO `area` VALUES (1776, '421221', '嘉鱼县', 3, 1774);
INSERT INTO `area` VALUES (1777, '421222', '通城县', 3, 1774);
INSERT INTO `area` VALUES (1778, '421223', '崇阳县', 3, 1774);
INSERT INTO `area` VALUES (1779, '421224', '通山县', 3, 1774);
INSERT INTO `area` VALUES (1780, '421281', '赤壁市', 3, 1774);
INSERT INTO `area` VALUES (1781, '421300', '随州市', 2, 1681);
INSERT INTO `area` VALUES (1782, '421303', '曾都区', 3, 1781);
INSERT INTO `area` VALUES (1783, '421321', '随县', 3, 1781);
INSERT INTO `area` VALUES (1784, '421381', '广水市', 3, 1781);
INSERT INTO `area` VALUES (1785, '422800', '恩施土家族苗族自治州', 2, 1681);
INSERT INTO `area` VALUES (1786, '422801', '恩施市', 3, 1785);
INSERT INTO `area` VALUES (1787, '422802', '利川市', 3, 1785);
INSERT INTO `area` VALUES (1788, '422822', '建始县', 3, 1785);
INSERT INTO `area` VALUES (1789, '422823', '巴东县', 3, 1785);
INSERT INTO `area` VALUES (1790, '422825', '宣恩县', 3, 1785);
INSERT INTO `area` VALUES (1791, '422826', '咸丰县', 3, 1785);
INSERT INTO `area` VALUES (1792, '422827', '来凤县', 3, 1785);
INSERT INTO `area` VALUES (1793, '422828', '鹤峰县', 3, 1785);
INSERT INTO `area` VALUES (1794, '429005', '潜江市', 2, 1681);
INSERT INTO `area` VALUES (1795, '429021', '神农架林区', 2, 1681);
INSERT INTO `area` VALUES (1796, '429006', '天门市', 2, 1681);
INSERT INTO `area` VALUES (1797, '429004', '仙桃市', 2, 1681);
INSERT INTO `area` VALUES (1798, '430000', '湖南省', 1, -1);
INSERT INTO `area` VALUES (1799, '430100', '长沙市', 2, 1798);
INSERT INTO `area` VALUES (1800, '430102', '芙蓉区', 3, 1799);
INSERT INTO `area` VALUES (1801, '430103', '天心区', 3, 1799);
INSERT INTO `area` VALUES (1802, '430104', '岳麓区', 3, 1799);
INSERT INTO `area` VALUES (1803, '430105', '开福区', 3, 1799);
INSERT INTO `area` VALUES (1804, '430111', '雨花区', 3, 1799);
INSERT INTO `area` VALUES (1805, '430112', '望城区', 3, 1799);
INSERT INTO `area` VALUES (1806, '430121', '长沙县', 3, 1799);
INSERT INTO `area` VALUES (1807, '430124', '宁乡市', 3, 1799);
INSERT INTO `area` VALUES (1808, '430181', '浏阳市', 3, 1799);
INSERT INTO `area` VALUES (1809, '430200', '株洲市', 2, 1798);
INSERT INTO `area` VALUES (1810, '430202', '荷塘区', 3, 1809);
INSERT INTO `area` VALUES (1811, '430203', '芦淞区', 3, 1809);
INSERT INTO `area` VALUES (1812, '430204', '石峰区', 3, 1809);
INSERT INTO `area` VALUES (1813, '430211', '天元区', 3, 1809);
INSERT INTO `area` VALUES (1814, '430221', '株洲县', 3, 1809);
INSERT INTO `area` VALUES (1815, '430223', '攸县', 3, 1809);
INSERT INTO `area` VALUES (1816, '430224', '茶陵县', 3, 1809);
INSERT INTO `area` VALUES (1817, '430225', '炎陵县', 3, 1809);
INSERT INTO `area` VALUES (1818, '430281', '醴陵市', 3, 1809);
INSERT INTO `area` VALUES (1819, '430300', '湘潭市', 2, 1798);
INSERT INTO `area` VALUES (1820, '430302', '雨湖区', 3, 1819);
INSERT INTO `area` VALUES (1821, '430304', '岳塘区', 3, 1819);
INSERT INTO `area` VALUES (1822, '430321', '湘潭县', 3, 1819);
INSERT INTO `area` VALUES (1823, '430381', '湘乡市', 3, 1819);
INSERT INTO `area` VALUES (1824, '430382', '韶山市', 3, 1819);
INSERT INTO `area` VALUES (1825, '430400', '衡阳市', 2, 1798);
INSERT INTO `area` VALUES (1826, '430405', '珠晖区', 3, 1825);
INSERT INTO `area` VALUES (1827, '430406', '雁峰区', 3, 1825);
INSERT INTO `area` VALUES (1828, '430407', '石鼓区', 3, 1825);
INSERT INTO `area` VALUES (1829, '430408', '蒸湘区', 3, 1825);
INSERT INTO `area` VALUES (1830, '430412', '南岳区', 3, 1825);
INSERT INTO `area` VALUES (1831, '430421', '衡阳县', 3, 1825);
INSERT INTO `area` VALUES (1832, '430422', '衡南县', 3, 1825);
INSERT INTO `area` VALUES (1833, '430423', '衡山县', 3, 1825);
INSERT INTO `area` VALUES (1834, '430424', '衡东县', 3, 1825);
INSERT INTO `area` VALUES (1835, '430426', '祁东县', 3, 1825);
INSERT INTO `area` VALUES (1836, '430481', '耒阳市', 3, 1825);
INSERT INTO `area` VALUES (1837, '430482', '常宁市', 3, 1825);
INSERT INTO `area` VALUES (1838, '430500', '邵阳市', 2, 1798);
INSERT INTO `area` VALUES (1839, '430502', '双清区', 3, 1838);
INSERT INTO `area` VALUES (1840, '430503', '大祥区', 3, 1838);
INSERT INTO `area` VALUES (1841, '430511', '北塔区', 3, 1838);
INSERT INTO `area` VALUES (1842, '430521', '邵东县', 3, 1838);
INSERT INTO `area` VALUES (1843, '430522', '新邵县', 3, 1838);
INSERT INTO `area` VALUES (1844, '430523', '邵阳县', 3, 1838);
INSERT INTO `area` VALUES (1845, '430524', '隆回县', 3, 1838);
INSERT INTO `area` VALUES (1846, '430525', '洞口县', 3, 1838);
INSERT INTO `area` VALUES (1847, '430527', '绥宁县', 3, 1838);
INSERT INTO `area` VALUES (1848, '430528', '新宁县', 3, 1838);
INSERT INTO `area` VALUES (1849, '430529', '城步苗族自治县', 3, 1838);
INSERT INTO `area` VALUES (1850, '430581', '武冈市', 3, 1838);
INSERT INTO `area` VALUES (1851, '430600', '岳阳市', 2, 1798);
INSERT INTO `area` VALUES (1852, '430602', '岳阳楼区', 3, 1851);
INSERT INTO `area` VALUES (1853, '430603', '云溪区', 3, 1851);
INSERT INTO `area` VALUES (1854, '430611', '君山区', 3, 1851);
INSERT INTO `area` VALUES (1855, '430621', '岳阳县', 3, 1851);
INSERT INTO `area` VALUES (1856, '430623', '华容县', 3, 1851);
INSERT INTO `area` VALUES (1857, '430624', '湘阴县', 3, 1851);
INSERT INTO `area` VALUES (1858, '430626', '平江县', 3, 1851);
INSERT INTO `area` VALUES (1859, '430681', '汨罗市', 3, 1851);
INSERT INTO `area` VALUES (1860, '430682', '临湘市', 3, 1851);
INSERT INTO `area` VALUES (1861, '430700', '常德市', 2, 1798);
INSERT INTO `area` VALUES (1862, '430702', '武陵区', 3, 1861);
INSERT INTO `area` VALUES (1863, '430703', '鼎城区', 3, 1861);
INSERT INTO `area` VALUES (1864, '430721', '安乡县', 3, 1861);
INSERT INTO `area` VALUES (1865, '430722', '汉寿县', 3, 1861);
INSERT INTO `area` VALUES (1866, '430723', '澧县', 3, 1861);
INSERT INTO `area` VALUES (1867, '430724', '临澧县', 3, 1861);
INSERT INTO `area` VALUES (1868, '430725', '桃源县', 3, 1861);
INSERT INTO `area` VALUES (1869, '430726', '石门县', 3, 1861);
INSERT INTO `area` VALUES (1870, '430781', '津市市', 3, 1861);
INSERT INTO `area` VALUES (1871, '430800', '张家界市', 2, 1798);
INSERT INTO `area` VALUES (1872, '430802', '永定区', 3, 1871);
INSERT INTO `area` VALUES (1873, '430811', '武陵源区', 3, 1871);
INSERT INTO `area` VALUES (1874, '430821', '慈利县', 3, 1871);
INSERT INTO `area` VALUES (1875, '430822', '桑植县', 3, 1871);
INSERT INTO `area` VALUES (1876, '430900', '益阳市', 2, 1798);
INSERT INTO `area` VALUES (1877, '430902', '资阳区', 3, 1876);
INSERT INTO `area` VALUES (1878, '430903', '赫山区', 3, 1876);
INSERT INTO `area` VALUES (1879, '430921', '南县', 3, 1876);
INSERT INTO `area` VALUES (1880, '430922', '桃江县', 3, 1876);
INSERT INTO `area` VALUES (1881, '430923', '安化县', 3, 1876);
INSERT INTO `area` VALUES (1882, '430981', '沅江市', 3, 1876);
INSERT INTO `area` VALUES (1883, '431000', '郴州市', 2, 1798);
INSERT INTO `area` VALUES (1884, '431002', '北湖区', 3, 1883);
INSERT INTO `area` VALUES (1885, '431003', '苏仙区', 3, 1883);
INSERT INTO `area` VALUES (1886, '431021', '桂阳县', 3, 1883);
INSERT INTO `area` VALUES (1887, '431022', '宜章县', 3, 1883);
INSERT INTO `area` VALUES (1888, '431023', '永兴县', 3, 1883);
INSERT INTO `area` VALUES (1889, '431024', '嘉禾县', 3, 1883);
INSERT INTO `area` VALUES (1890, '431025', '临武县', 3, 1883);
INSERT INTO `area` VALUES (1891, '431026', '汝城县', 3, 1883);
INSERT INTO `area` VALUES (1892, '431027', '桂东县', 3, 1883);
INSERT INTO `area` VALUES (1893, '431028', '安仁县', 3, 1883);
INSERT INTO `area` VALUES (1894, '431081', '资兴市', 3, 1883);
INSERT INTO `area` VALUES (1895, '431100', '永州市', 2, 1798);
INSERT INTO `area` VALUES (1896, '431102', '零陵区', 3, 1895);
INSERT INTO `area` VALUES (1897, '431103', '冷水滩区', 3, 1895);
INSERT INTO `area` VALUES (1898, '431121', '祁阳县', 3, 1895);
INSERT INTO `area` VALUES (1899, '431122', '东安县', 3, 1895);
INSERT INTO `area` VALUES (1900, '431123', '双牌县', 3, 1895);
INSERT INTO `area` VALUES (1901, '431124', '道县', 3, 1895);
INSERT INTO `area` VALUES (1902, '431125', '江永县', 3, 1895);
INSERT INTO `area` VALUES (1903, '431126', '宁远县', 3, 1895);
INSERT INTO `area` VALUES (1904, '431127', '蓝山县', 3, 1895);
INSERT INTO `area` VALUES (1905, '431128', '新田县', 3, 1895);
INSERT INTO `area` VALUES (1906, '431129', '江华瑶族自治县', 3, 1895);
INSERT INTO `area` VALUES (1907, '431200', '怀化市', 2, 1798);
INSERT INTO `area` VALUES (1908, '431202', '鹤城区', 3, 1907);
INSERT INTO `area` VALUES (1909, '431221', '中方县', 3, 1907);
INSERT INTO `area` VALUES (1910, '431222', '沅陵县', 3, 1907);
INSERT INTO `area` VALUES (1911, '431223', '辰溪县', 3, 1907);
INSERT INTO `area` VALUES (1912, '431224', '溆浦县', 3, 1907);
INSERT INTO `area` VALUES (1913, '431225', '会同县', 3, 1907);
INSERT INTO `area` VALUES (1914, '431226', '麻阳苗族自治县', 3, 1907);
INSERT INTO `area` VALUES (1915, '431227', '新晃侗族自治县', 3, 1907);
INSERT INTO `area` VALUES (1916, '431228', '芷江侗族自治县', 3, 1907);
INSERT INTO `area` VALUES (1917, '431229', '靖州苗族侗族自治县', 3, 1907);
INSERT INTO `area` VALUES (1918, '431230', '通道侗族自治县', 3, 1907);
INSERT INTO `area` VALUES (1919, '431281', '洪江市', 3, 1907);
INSERT INTO `area` VALUES (1920, '431300', '娄底市', 2, 1798);
INSERT INTO `area` VALUES (1921, '431302', '娄星区', 3, 1920);
INSERT INTO `area` VALUES (1922, '431321', '双峰县', 3, 1920);
INSERT INTO `area` VALUES (1923, '431322', '新化县', 3, 1920);
INSERT INTO `area` VALUES (1924, '431381', '冷水江市', 3, 1920);
INSERT INTO `area` VALUES (1925, '431382', '涟源市', 3, 1920);
INSERT INTO `area` VALUES (1926, '433100', '湘西土家族苗族自治州', 2, 1798);
INSERT INTO `area` VALUES (1927, '433101', '吉首市', 3, 1926);
INSERT INTO `area` VALUES (1928, '433122', '泸溪县', 3, 1926);
INSERT INTO `area` VALUES (1929, '433123', '凤凰县', 3, 1926);
INSERT INTO `area` VALUES (1930, '433124', '花垣县', 3, 1926);
INSERT INTO `area` VALUES (1931, '433125', '保靖县', 3, 1926);
INSERT INTO `area` VALUES (1932, '433126', '古丈县', 3, 1926);
INSERT INTO `area` VALUES (1933, '433127', '永顺县', 3, 1926);
INSERT INTO `area` VALUES (1934, '433130', '龙山县', 3, 1926);
INSERT INTO `area` VALUES (1935, '440000', '广东省', 1, -1);
INSERT INTO `area` VALUES (1936, '440100', '广州市', 2, 1935);
INSERT INTO `area` VALUES (1937, '440103', '荔湾区', 3, 1936);
INSERT INTO `area` VALUES (1938, '440104', '越秀区', 3, 1936);
INSERT INTO `area` VALUES (1939, '440105', '海珠区', 3, 1936);
INSERT INTO `area` VALUES (1940, '440106', '天河区', 3, 1936);
INSERT INTO `area` VALUES (1941, '440111', '白云区', 3, 1936);
INSERT INTO `area` VALUES (1942, '440112', '黄埔区', 3, 1936);
INSERT INTO `area` VALUES (1943, '440113', '番禺区', 3, 1936);
INSERT INTO `area` VALUES (1944, '440114', '花都区', 3, 1936);
INSERT INTO `area` VALUES (1945, '440115', '南沙区', 3, 1936);
INSERT INTO `area` VALUES (1946, '440117', '从化区', 3, 1936);
INSERT INTO `area` VALUES (1947, '440118', '增城区', 3, 1936);
INSERT INTO `area` VALUES (1948, '440200', '韶关市', 2, 1935);
INSERT INTO `area` VALUES (1949, '440203', '武江区', 3, 1948);
INSERT INTO `area` VALUES (1950, '440204', '浈江区', 3, 1948);
INSERT INTO `area` VALUES (1951, '440205', '曲江区', 3, 1948);
INSERT INTO `area` VALUES (1952, '440222', '始兴县', 3, 1948);
INSERT INTO `area` VALUES (1953, '440224', '仁化县', 3, 1948);
INSERT INTO `area` VALUES (1954, '440229', '翁源县', 3, 1948);
INSERT INTO `area` VALUES (1955, '440232', '乳源瑶族自治县', 3, 1948);
INSERT INTO `area` VALUES (1956, '440233', '新丰县', 3, 1948);
INSERT INTO `area` VALUES (1957, '440281', '乐昌市', 3, 1948);
INSERT INTO `area` VALUES (1958, '440282', '南雄市', 3, 1948);
INSERT INTO `area` VALUES (1959, '440300', '深圳市', 2, 1935);
INSERT INTO `area` VALUES (1960, '440303', '罗湖区', 3, 1959);
INSERT INTO `area` VALUES (1961, '440304', '福田区', 3, 1959);
INSERT INTO `area` VALUES (1962, '440305', '南山区', 3, 1959);
INSERT INTO `area` VALUES (1963, '440306', '宝安区', 3, 1959);
INSERT INTO `area` VALUES (1964, '440307', '龙岗区', 3, 1959);
INSERT INTO `area` VALUES (1965, '440308', '盐田区', 3, 1959);
INSERT INTO `area` VALUES (1966, '440309', '龙华区', 3, 1959);
INSERT INTO `area` VALUES (1967, '440310', '坪山区', 3, 1959);
INSERT INTO `area` VALUES (1968, '440400', '珠海市', 2, 1935);
INSERT INTO `area` VALUES (1969, '440402', '香洲区', 3, 1968);
INSERT INTO `area` VALUES (1970, '440403', '斗门区', 3, 1968);
INSERT INTO `area` VALUES (1971, '440404', '金湾区', 3, 1968);
INSERT INTO `area` VALUES (1972, '440500', '汕头市', 2, 1935);
INSERT INTO `area` VALUES (1973, '440507', '龙湖区', 3, 1972);
INSERT INTO `area` VALUES (1974, '440511', '金平区', 3, 1972);
INSERT INTO `area` VALUES (1975, '440512', '濠江区', 3, 1972);
INSERT INTO `area` VALUES (1976, '440513', '潮阳区', 3, 1972);
INSERT INTO `area` VALUES (1977, '440514', '潮南区', 3, 1972);
INSERT INTO `area` VALUES (1978, '440515', '澄海区', 3, 1972);
INSERT INTO `area` VALUES (1979, '440523', '南澳县', 3, 1972);
INSERT INTO `area` VALUES (1980, '440600', '佛山市', 2, 1935);
INSERT INTO `area` VALUES (1981, '440604', '禅城区', 3, 1980);
INSERT INTO `area` VALUES (1982, '440605', '南海区', 3, 1980);
INSERT INTO `area` VALUES (1983, '440606', '顺德区', 3, 1980);
INSERT INTO `area` VALUES (1984, '440607', '三水区', 3, 1980);
INSERT INTO `area` VALUES (1985, '440608', '高明区', 3, 1980);
INSERT INTO `area` VALUES (1986, '440700', '江门市', 2, 1935);
INSERT INTO `area` VALUES (1987, '440703', '蓬江区', 3, 1986);
INSERT INTO `area` VALUES (1988, '440704', '江海区', 3, 1986);
INSERT INTO `area` VALUES (1989, '440705', '新会区', 3, 1986);
INSERT INTO `area` VALUES (1990, '440781', '台山市', 3, 1986);
INSERT INTO `area` VALUES (1991, '440783', '开平市', 3, 1986);
INSERT INTO `area` VALUES (1992, '440784', '鹤山市', 3, 1986);
INSERT INTO `area` VALUES (1993, '440785', '恩平市', 3, 1986);
INSERT INTO `area` VALUES (1994, '440800', '湛江市', 2, 1935);
INSERT INTO `area` VALUES (1995, '440802', '赤坎区', 3, 1994);
INSERT INTO `area` VALUES (1996, '440803', '霞山区', 3, 1994);
INSERT INTO `area` VALUES (1997, '440804', '坡头区', 3, 1994);
INSERT INTO `area` VALUES (1998, '440811', '麻章区', 3, 1994);
INSERT INTO `area` VALUES (1999, '440823', '遂溪县', 3, 1994);
INSERT INTO `area` VALUES (2000, '440825', '徐闻县', 3, 1994);
INSERT INTO `area` VALUES (2001, '440881', '廉江市', 3, 1994);
INSERT INTO `area` VALUES (2002, '440882', '雷州市', 3, 1994);
INSERT INTO `area` VALUES (2003, '440883', '吴川市', 3, 1994);
INSERT INTO `area` VALUES (2004, '440900', '茂名市', 2, 1935);
INSERT INTO `area` VALUES (2005, '440902', '茂南区', 3, 2004);
INSERT INTO `area` VALUES (2006, '440904', '电白区', 3, 2004);
INSERT INTO `area` VALUES (2007, '440981', '高州市', 3, 2004);
INSERT INTO `area` VALUES (2008, '440982', '化州市', 3, 2004);
INSERT INTO `area` VALUES (2009, '440983', '信宜市', 3, 2004);
INSERT INTO `area` VALUES (2010, '441200', '肇庆市', 2, 1935);
INSERT INTO `area` VALUES (2011, '441202', '端州区', 3, 2010);
INSERT INTO `area` VALUES (2012, '441203', '鼎湖区', 3, 2010);
INSERT INTO `area` VALUES (2013, '441204', '高要区', 3, 2010);
INSERT INTO `area` VALUES (2014, '441223', '广宁县', 3, 2010);
INSERT INTO `area` VALUES (2015, '441224', '怀集县', 3, 2010);
INSERT INTO `area` VALUES (2016, '441225', '封开县', 3, 2010);
INSERT INTO `area` VALUES (2017, '441226', '德庆县', 3, 2010);
INSERT INTO `area` VALUES (2018, '441284', '四会市', 3, 2010);
INSERT INTO `area` VALUES (2019, '441300', '惠州市', 2, 1935);
INSERT INTO `area` VALUES (2020, '441302', '惠城区', 3, 2019);
INSERT INTO `area` VALUES (2021, '441303', '惠阳区', 3, 2019);
INSERT INTO `area` VALUES (2022, '441322', '博罗县', 3, 2019);
INSERT INTO `area` VALUES (2023, '441323', '惠东县', 3, 2019);
INSERT INTO `area` VALUES (2024, '441324', '龙门县', 3, 2019);
INSERT INTO `area` VALUES (2025, '441400', '梅州市', 2, 1935);
INSERT INTO `area` VALUES (2026, '441402', '梅江区', 3, 2025);
INSERT INTO `area` VALUES (2027, '441403', '梅县区', 3, 2025);
INSERT INTO `area` VALUES (2028, '441422', '大埔县', 3, 2025);
INSERT INTO `area` VALUES (2029, '441423', '丰顺县', 3, 2025);
INSERT INTO `area` VALUES (2030, '441424', '五华县', 3, 2025);
INSERT INTO `area` VALUES (2031, '441426', '平远县', 3, 2025);
INSERT INTO `area` VALUES (2032, '441427', '蕉岭县', 3, 2025);
INSERT INTO `area` VALUES (2033, '441481', '兴宁市', 3, 2025);
INSERT INTO `area` VALUES (2034, '441500', '汕尾市', 2, 1935);
INSERT INTO `area` VALUES (2035, '441502', '城区', 3, 2034);
INSERT INTO `area` VALUES (2036, '441521', '海丰县', 3, 2034);
INSERT INTO `area` VALUES (2037, '441523', '陆河县', 3, 2034);
INSERT INTO `area` VALUES (2038, '441581', '陆丰市', 3, 2034);
INSERT INTO `area` VALUES (2039, '441600', '河源市', 2, 1935);
INSERT INTO `area` VALUES (2040, '441602', '源城区', 3, 2039);
INSERT INTO `area` VALUES (2041, '441621', '紫金县', 3, 2039);
INSERT INTO `area` VALUES (2042, '441622', '龙川县', 3, 2039);
INSERT INTO `area` VALUES (2043, '441623', '连平县', 3, 2039);
INSERT INTO `area` VALUES (2044, '441624', '和平县', 3, 2039);
INSERT INTO `area` VALUES (2045, '441625', '东源县', 3, 2039);
INSERT INTO `area` VALUES (2046, '441700', '阳江市', 2, 1935);
INSERT INTO `area` VALUES (2047, '441702', '江城区', 3, 2046);
INSERT INTO `area` VALUES (2048, '441704', '阳东区', 3, 2046);
INSERT INTO `area` VALUES (2049, '441721', '阳西县', 3, 2046);
INSERT INTO `area` VALUES (2050, '441781', '阳春市', 3, 2046);
INSERT INTO `area` VALUES (2051, '441800', '清远市', 2, 1935);
INSERT INTO `area` VALUES (2052, '441802', '清城区', 3, 2051);
INSERT INTO `area` VALUES (2053, '441803', '清新区', 3, 2051);
INSERT INTO `area` VALUES (2054, '441821', '佛冈县', 3, 2051);
INSERT INTO `area` VALUES (2055, '441823', '阳山县', 3, 2051);
INSERT INTO `area` VALUES (2056, '441825', '连山壮族瑶族自治县', 3, 2051);
INSERT INTO `area` VALUES (2057, '441826', '连南瑶族自治县', 3, 2051);
INSERT INTO `area` VALUES (2058, '441881', '英德市', 3, 2051);
INSERT INTO `area` VALUES (2059, '441882', '连州市', 3, 2051);
INSERT INTO `area` VALUES (2060, '441900', '东莞市', 2, 1935);
INSERT INTO `area` VALUES (2061, '442000', '中山市', 2, 1935);
INSERT INTO `area` VALUES (2062, '445100', '潮州市', 2, 1935);
INSERT INTO `area` VALUES (2063, '445102', '湘桥区', 3, 2062);
INSERT INTO `area` VALUES (2064, '445103', '潮安区', 3, 2062);
INSERT INTO `area` VALUES (2065, '445122', '饶平县', 3, 2062);
INSERT INTO `area` VALUES (2066, '445200', '揭阳市', 2, 1935);
INSERT INTO `area` VALUES (2067, '445202', '榕城区', 3, 2066);
INSERT INTO `area` VALUES (2068, '445203', '揭东区', 3, 2066);
INSERT INTO `area` VALUES (2069, '445222', '揭西县', 3, 2066);
INSERT INTO `area` VALUES (2070, '445224', '惠来县', 3, 2066);
INSERT INTO `area` VALUES (2071, '445281', '普宁市', 3, 2066);
INSERT INTO `area` VALUES (2072, '445300', '云浮市', 2, 1935);
INSERT INTO `area` VALUES (2073, '445302', '云城区', 3, 2072);
INSERT INTO `area` VALUES (2074, '445303', '云安区', 3, 2072);
INSERT INTO `area` VALUES (2075, '445321', '新兴县', 3, 2072);
INSERT INTO `area` VALUES (2076, '445322', '郁南县', 3, 2072);
INSERT INTO `area` VALUES (2077, '445381', '罗定市', 3, 2072);
INSERT INTO `area` VALUES (2078, '442100', '东沙群岛', 2, 1935);
INSERT INTO `area` VALUES (2079, '450000', '广西壮族自治区', 1, -1);
INSERT INTO `area` VALUES (2080, '450100', '南宁市', 2, 2079);
INSERT INTO `area` VALUES (2081, '450102', '兴宁区', 3, 2080);
INSERT INTO `area` VALUES (2082, '450103', '青秀区', 3, 2080);
INSERT INTO `area` VALUES (2083, '450105', '江南区', 3, 2080);
INSERT INTO `area` VALUES (2084, '450107', '西乡塘区', 3, 2080);
INSERT INTO `area` VALUES (2085, '450108', '良庆区', 3, 2080);
INSERT INTO `area` VALUES (2086, '450109', '邕宁区', 3, 2080);
INSERT INTO `area` VALUES (2087, '450110', '武鸣区', 3, 2080);
INSERT INTO `area` VALUES (2088, '450123', '隆安县', 3, 2080);
INSERT INTO `area` VALUES (2089, '450124', '马山县', 3, 2080);
INSERT INTO `area` VALUES (2090, '450125', '上林县', 3, 2080);
INSERT INTO `area` VALUES (2091, '450126', '宾阳县', 3, 2080);
INSERT INTO `area` VALUES (2092, '450127', '横县', 3, 2080);
INSERT INTO `area` VALUES (2093, '450200', '柳州市', 2, 2079);
INSERT INTO `area` VALUES (2094, '450202', '城中区', 3, 2093);
INSERT INTO `area` VALUES (2095, '450203', '鱼峰区', 3, 2093);
INSERT INTO `area` VALUES (2096, '450204', '柳南区', 3, 2093);
INSERT INTO `area` VALUES (2097, '450205', '柳北区', 3, 2093);
INSERT INTO `area` VALUES (2098, '450206', '柳江区', 3, 2093);
INSERT INTO `area` VALUES (2099, '450222', '柳城县', 3, 2093);
INSERT INTO `area` VALUES (2100, '450223', '鹿寨县', 3, 2093);
INSERT INTO `area` VALUES (2101, '450224', '融安县', 3, 2093);
INSERT INTO `area` VALUES (2102, '450225', '融水苗族自治县', 3, 2093);
INSERT INTO `area` VALUES (2103, '450226', '三江侗族自治县', 3, 2093);
INSERT INTO `area` VALUES (2104, '450300', '桂林市', 2, 2079);
INSERT INTO `area` VALUES (2105, '450302', '秀峰区', 3, 2104);
INSERT INTO `area` VALUES (2106, '450303', '叠彩区', 3, 2104);
INSERT INTO `area` VALUES (2107, '450304', '象山区', 3, 2104);
INSERT INTO `area` VALUES (2108, '450305', '七星区', 3, 2104);
INSERT INTO `area` VALUES (2109, '450311', '雁山区', 3, 2104);
INSERT INTO `area` VALUES (2110, '450312', '临桂区', 3, 2104);
INSERT INTO `area` VALUES (2111, '450321', '阳朔县', 3, 2104);
INSERT INTO `area` VALUES (2112, '450323', '灵川县', 3, 2104);
INSERT INTO `area` VALUES (2113, '450324', '全州县', 3, 2104);
INSERT INTO `area` VALUES (2114, '450325', '兴安县', 3, 2104);
INSERT INTO `area` VALUES (2115, '450326', '永福县', 3, 2104);
INSERT INTO `area` VALUES (2116, '450327', '灌阳县', 3, 2104);
INSERT INTO `area` VALUES (2117, '450328', '龙胜各族自治县', 3, 2104);
INSERT INTO `area` VALUES (2118, '450329', '资源县', 3, 2104);
INSERT INTO `area` VALUES (2119, '450330', '平乐县', 3, 2104);
INSERT INTO `area` VALUES (2120, '450331', '荔浦县', 3, 2104);
INSERT INTO `area` VALUES (2121, '450332', '恭城瑶族自治县', 3, 2104);
INSERT INTO `area` VALUES (2122, '450400', '梧州市', 2, 2079);
INSERT INTO `area` VALUES (2123, '450403', '万秀区', 3, 2122);
INSERT INTO `area` VALUES (2124, '450405', '长洲区', 3, 2122);
INSERT INTO `area` VALUES (2125, '450406', '龙圩区', 3, 2122);
INSERT INTO `area` VALUES (2126, '450421', '苍梧县', 3, 2122);
INSERT INTO `area` VALUES (2127, '450422', '藤县', 3, 2122);
INSERT INTO `area` VALUES (2128, '450423', '蒙山县', 3, 2122);
INSERT INTO `area` VALUES (2129, '450481', '岑溪市', 3, 2122);
INSERT INTO `area` VALUES (2130, '450500', '北海市', 2, 2079);
INSERT INTO `area` VALUES (2131, '450502', '海城区', 3, 2130);
INSERT INTO `area` VALUES (2132, '450503', '银海区', 3, 2130);
INSERT INTO `area` VALUES (2133, '450512', '铁山港区', 3, 2130);
INSERT INTO `area` VALUES (2134, '450521', '合浦县', 3, 2130);
INSERT INTO `area` VALUES (2135, '450600', '防城港市', 2, 2079);
INSERT INTO `area` VALUES (2136, '450602', '港口区', 3, 2135);
INSERT INTO `area` VALUES (2137, '450603', '防城区', 3, 2135);
INSERT INTO `area` VALUES (2138, '450621', '上思县', 3, 2135);
INSERT INTO `area` VALUES (2139, '450681', '东兴市', 3, 2135);
INSERT INTO `area` VALUES (2140, '450700', '钦州市', 2, 2079);
INSERT INTO `area` VALUES (2141, '450702', '钦南区', 3, 2140);
INSERT INTO `area` VALUES (2142, '450703', '钦北区', 3, 2140);
INSERT INTO `area` VALUES (2143, '450721', '灵山县', 3, 2140);
INSERT INTO `area` VALUES (2144, '450722', '浦北县', 3, 2140);
INSERT INTO `area` VALUES (2145, '450800', '贵港市', 2, 2079);
INSERT INTO `area` VALUES (2146, '450802', '港北区', 3, 2145);
INSERT INTO `area` VALUES (2147, '450803', '港南区', 3, 2145);
INSERT INTO `area` VALUES (2148, '450804', '覃塘区', 3, 2145);
INSERT INTO `area` VALUES (2149, '450821', '平南县', 3, 2145);
INSERT INTO `area` VALUES (2150, '450881', '桂平市', 3, 2145);
INSERT INTO `area` VALUES (2151, '450900', '玉林市', 2, 2079);
INSERT INTO `area` VALUES (2152, '450902', '玉州区', 3, 2151);
INSERT INTO `area` VALUES (2153, '450903', '福绵区', 3, 2151);
INSERT INTO `area` VALUES (2154, '450921', '容县', 3, 2151);
INSERT INTO `area` VALUES (2155, '450922', '陆川县', 3, 2151);
INSERT INTO `area` VALUES (2156, '450923', '博白县', 3, 2151);
INSERT INTO `area` VALUES (2157, '450924', '兴业县', 3, 2151);
INSERT INTO `area` VALUES (2158, '450981', '北流市', 3, 2151);
INSERT INTO `area` VALUES (2159, '451000', '百色市', 2, 2079);
INSERT INTO `area` VALUES (2160, '451002', '右江区', 3, 2159);
INSERT INTO `area` VALUES (2161, '451021', '田阳县', 3, 2159);
INSERT INTO `area` VALUES (2162, '451022', '田东县', 3, 2159);
INSERT INTO `area` VALUES (2163, '451023', '平果县', 3, 2159);
INSERT INTO `area` VALUES (2164, '451024', '德保县', 3, 2159);
INSERT INTO `area` VALUES (2165, '451026', '那坡县', 3, 2159);
INSERT INTO `area` VALUES (2166, '451027', '凌云县', 3, 2159);
INSERT INTO `area` VALUES (2167, '451028', '乐业县', 3, 2159);
INSERT INTO `area` VALUES (2168, '451029', '田林县', 3, 2159);
INSERT INTO `area` VALUES (2169, '451030', '西林县', 3, 2159);
INSERT INTO `area` VALUES (2170, '451031', '隆林各族自治县', 3, 2159);
INSERT INTO `area` VALUES (2171, '451081', '靖西市', 3, 2159);
INSERT INTO `area` VALUES (2172, '451100', '贺州市', 2, 2079);
INSERT INTO `area` VALUES (2173, '451102', '八步区', 3, 2172);
INSERT INTO `area` VALUES (2174, '451103', '平桂区', 3, 2172);
INSERT INTO `area` VALUES (2175, '451121', '昭平县', 3, 2172);
INSERT INTO `area` VALUES (2176, '451122', '钟山县', 3, 2172);
INSERT INTO `area` VALUES (2177, '451123', '富川瑶族自治县', 3, 2172);
INSERT INTO `area` VALUES (2178, '451200', '河池市', 2, 2079);
INSERT INTO `area` VALUES (2179, '451202', '金城江区', 3, 2178);
INSERT INTO `area` VALUES (2180, '451221', '南丹县', 3, 2178);
INSERT INTO `area` VALUES (2181, '451222', '天峨县', 3, 2178);
INSERT INTO `area` VALUES (2182, '451223', '凤山县', 3, 2178);
INSERT INTO `area` VALUES (2183, '451224', '东兰县', 3, 2178);
INSERT INTO `area` VALUES (2184, '451225', '罗城仫佬族自治县', 3, 2178);
INSERT INTO `area` VALUES (2185, '451226', '环江毛南族自治县', 3, 2178);
INSERT INTO `area` VALUES (2186, '451227', '巴马瑶族自治县', 3, 2178);
INSERT INTO `area` VALUES (2187, '451228', '都安瑶族自治县', 3, 2178);
INSERT INTO `area` VALUES (2188, '451229', '大化瑶族自治县', 3, 2178);
INSERT INTO `area` VALUES (2189, '451203', '宜州区', 3, 2178);
INSERT INTO `area` VALUES (2190, '451300', '来宾市', 2, 2079);
INSERT INTO `area` VALUES (2191, '451302', '兴宾区', 3, 2190);
INSERT INTO `area` VALUES (2192, '451321', '忻城县', 3, 2190);
INSERT INTO `area` VALUES (2193, '451322', '象州县', 3, 2190);
INSERT INTO `area` VALUES (2194, '451323', '武宣县', 3, 2190);
INSERT INTO `area` VALUES (2195, '451324', '金秀瑶族自治县', 3, 2190);
INSERT INTO `area` VALUES (2196, '451381', '合山市', 3, 2190);
INSERT INTO `area` VALUES (2197, '451400', '崇左市', 2, 2079);
INSERT INTO `area` VALUES (2198, '451402', '江州区', 3, 2197);
INSERT INTO `area` VALUES (2199, '451421', '扶绥县', 3, 2197);
INSERT INTO `area` VALUES (2200, '451422', '宁明县', 3, 2197);
INSERT INTO `area` VALUES (2201, '451423', '龙州县', 3, 2197);
INSERT INTO `area` VALUES (2202, '451424', '大新县', 3, 2197);
INSERT INTO `area` VALUES (2203, '451425', '天等县', 3, 2197);
INSERT INTO `area` VALUES (2204, '451481', '凭祥市', 3, 2197);
INSERT INTO `area` VALUES (2205, '460000', '海南省', 1, -1);
INSERT INTO `area` VALUES (2206, '469025', '白沙黎族自治县', 2, 2205);
INSERT INTO `area` VALUES (2207, '469029', '保亭黎族苗族自治县', 2, 2205);
INSERT INTO `area` VALUES (2208, '469026', '昌江黎族自治县', 2, 2205);
INSERT INTO `area` VALUES (2209, '469023', '澄迈县', 2, 2205);
INSERT INTO `area` VALUES (2210, '460100', '海口市', 2, 2205);
INSERT INTO `area` VALUES (2211, '460105', '秀英区', 3, 2210);
INSERT INTO `area` VALUES (2212, '460106', '龙华区', 3, 2210);
INSERT INTO `area` VALUES (2213, '460107', '琼山区', 3, 2210);
INSERT INTO `area` VALUES (2214, '460108', '美兰区', 3, 2210);
INSERT INTO `area` VALUES (2215, '460200', '三亚市', 2, 2205);
INSERT INTO `area` VALUES (2216, '460202', '海棠区', 3, 2215);
INSERT INTO `area` VALUES (2217, '460203', '吉阳区', 3, 2215);
INSERT INTO `area` VALUES (2218, '460204', '天涯区', 3, 2215);
INSERT INTO `area` VALUES (2219, '460205', '崖州区', 3, 2215);
INSERT INTO `area` VALUES (2220, '460300', '三沙市', 2, 2205);
INSERT INTO `area` VALUES (2221, '460321', '西沙群岛', 3, 2220);
INSERT INTO `area` VALUES (2222, '460322', '南沙群岛', 3, 2220);
INSERT INTO `area` VALUES (2223, '460323', '中沙群岛的岛礁及其海域', 3, 2220);
INSERT INTO `area` VALUES (2224, '460400', '儋州市', 2, 2205);
INSERT INTO `area` VALUES (2225, '469021', '定安县', 2, 2205);
INSERT INTO `area` VALUES (2226, '469007', '东方市', 2, 2205);
INSERT INTO `area` VALUES (2227, '469027', '乐东黎族自治县', 2, 2205);
INSERT INTO `area` VALUES (2228, '469024', '临高县', 2, 2205);
INSERT INTO `area` VALUES (2229, '469028', '陵水黎族自治县', 2, 2205);
INSERT INTO `area` VALUES (2230, '469002', '琼海市', 2, 2205);
INSERT INTO `area` VALUES (2231, '469030', '琼中黎族苗族自治县', 2, 2205);
INSERT INTO `area` VALUES (2232, '469022', '屯昌县', 2, 2205);
INSERT INTO `area` VALUES (2233, '469006', '万宁市', 2, 2205);
INSERT INTO `area` VALUES (2234, '469005', '文昌市', 2, 2205);
INSERT INTO `area` VALUES (2235, '469001', '五指山市', 2, 2205);
INSERT INTO `area` VALUES (2236, '500000', '重庆市', 1, -1);
INSERT INTO `area` VALUES (2237, '500100', '重庆城区', 2, 2236);
INSERT INTO `area` VALUES (2238, '500101', '万州区', 3, 2237);
INSERT INTO `area` VALUES (2239, '500102', '涪陵区', 3, 2237);
INSERT INTO `area` VALUES (2240, '500103', '渝中区', 3, 2237);
INSERT INTO `area` VALUES (2241, '500104', '大渡口区', 3, 2237);
INSERT INTO `area` VALUES (2242, '500105', '江北区', 3, 2237);
INSERT INTO `area` VALUES (2243, '500106', '沙坪坝区', 3, 2237);
INSERT INTO `area` VALUES (2244, '500107', '九龙坡区', 3, 2237);
INSERT INTO `area` VALUES (2245, '500108', '南岸区', 3, 2237);
INSERT INTO `area` VALUES (2246, '500109', '北碚区', 3, 2237);
INSERT INTO `area` VALUES (2247, '500110', '綦江区', 3, 2237);
INSERT INTO `area` VALUES (2248, '500111', '大足区', 3, 2237);
INSERT INTO `area` VALUES (2249, '500112', '渝北区', 3, 2237);
INSERT INTO `area` VALUES (2250, '500113', '巴南区', 3, 2237);
INSERT INTO `area` VALUES (2251, '500114', '黔江区', 3, 2237);
INSERT INTO `area` VALUES (2252, '500115', '长寿区', 3, 2237);
INSERT INTO `area` VALUES (2253, '500116', '江津区', 3, 2237);
INSERT INTO `area` VALUES (2254, '500117', '合川区', 3, 2237);
INSERT INTO `area` VALUES (2255, '500118', '永川区', 3, 2237);
INSERT INTO `area` VALUES (2256, '500119', '南川区', 3, 2237);
INSERT INTO `area` VALUES (2257, '500120', '璧山区', 3, 2237);
INSERT INTO `area` VALUES (2258, '500151', '铜梁区', 3, 2237);
INSERT INTO `area` VALUES (2259, '500152', '潼南区', 3, 2237);
INSERT INTO `area` VALUES (2260, '500153', '荣昌区', 3, 2237);
INSERT INTO `area` VALUES (2261, '500154', '开州区', 3, 2237);
INSERT INTO `area` VALUES (2262, '500200', '重庆郊县', 2, 2236);
INSERT INTO `area` VALUES (2263, '500155', '梁平区', 3, 2262);
INSERT INTO `area` VALUES (2264, '500229', '城口县', 3, 2262);
INSERT INTO `area` VALUES (2265, '500230', '丰都县', 3, 2262);
INSERT INTO `area` VALUES (2266, '500231', '垫江县', 3, 2262);
INSERT INTO `area` VALUES (2267, '500156', '武隆区', 3, 2262);
INSERT INTO `area` VALUES (2268, '500233', '忠县', 3, 2262);
INSERT INTO `area` VALUES (2269, '500235', '云阳县', 3, 2262);
INSERT INTO `area` VALUES (2270, '500236', '奉节县', 3, 2262);
INSERT INTO `area` VALUES (2271, '500237', '巫山县', 3, 2262);
INSERT INTO `area` VALUES (2272, '500238', '巫溪县', 3, 2262);
INSERT INTO `area` VALUES (2273, '500240', '石柱土家族自治县', 3, 2262);
INSERT INTO `area` VALUES (2274, '500241', '秀山土家族苗族自治县', 3, 2262);
INSERT INTO `area` VALUES (2275, '500242', '酉阳土家族苗族自治县', 3, 2262);
INSERT INTO `area` VALUES (2276, '500243', '彭水苗族土家族自治县', 3, 2262);
INSERT INTO `area` VALUES (2277, '510000', '四川省', 1, -1);
INSERT INTO `area` VALUES (2278, '510100', '成都市', 2, 2277);
INSERT INTO `area` VALUES (2279, '510104', '锦江区', 3, 2278);
INSERT INTO `area` VALUES (2280, '510105', '青羊区', 3, 2278);
INSERT INTO `area` VALUES (2281, '510106', '金牛区', 3, 2278);
INSERT INTO `area` VALUES (2282, '510107', '武侯区', 3, 2278);
INSERT INTO `area` VALUES (2283, '510108', '成华区', 3, 2278);
INSERT INTO `area` VALUES (2284, '510112', '龙泉驿区', 3, 2278);
INSERT INTO `area` VALUES (2285, '510113', '青白江区', 3, 2278);
INSERT INTO `area` VALUES (2286, '510114', '新都区', 3, 2278);
INSERT INTO `area` VALUES (2287, '510115', '温江区', 3, 2278);
INSERT INTO `area` VALUES (2288, '510116', '双流区', 3, 2278);
INSERT INTO `area` VALUES (2289, '510121', '金堂县', 3, 2278);
INSERT INTO `area` VALUES (2290, '510117', '郫都区', 3, 2278);
INSERT INTO `area` VALUES (2291, '510129', '大邑县', 3, 2278);
INSERT INTO `area` VALUES (2292, '510131', '蒲江县', 3, 2278);
INSERT INTO `area` VALUES (2293, '510132', '新津县', 3, 2278);
INSERT INTO `area` VALUES (2294, '510185', '简阳市', 3, 2278);
INSERT INTO `area` VALUES (2295, '510181', '都江堰市', 3, 2278);
INSERT INTO `area` VALUES (2296, '510182', '彭州市', 3, 2278);
INSERT INTO `area` VALUES (2297, '510183', '邛崃市', 3, 2278);
INSERT INTO `area` VALUES (2298, '510184', '崇州市', 3, 2278);
INSERT INTO `area` VALUES (2299, '510300', '自贡市', 2, 2277);
INSERT INTO `area` VALUES (2300, '510302', '自流井区', 3, 2299);
INSERT INTO `area` VALUES (2301, '510303', '贡井区', 3, 2299);
INSERT INTO `area` VALUES (2302, '510304', '大安区', 3, 2299);
INSERT INTO `area` VALUES (2303, '510311', '沿滩区', 3, 2299);
INSERT INTO `area` VALUES (2304, '510321', '荣县', 3, 2299);
INSERT INTO `area` VALUES (2305, '510322', '富顺县', 3, 2299);
INSERT INTO `area` VALUES (2306, '510400', '攀枝花市', 2, 2277);
INSERT INTO `area` VALUES (2307, '510402', '东区', 3, 2306);
INSERT INTO `area` VALUES (2308, '510403', '西区', 3, 2306);
INSERT INTO `area` VALUES (2309, '510411', '仁和区', 3, 2306);
INSERT INTO `area` VALUES (2310, '510421', '米易县', 3, 2306);
INSERT INTO `area` VALUES (2311, '510422', '盐边县', 3, 2306);
INSERT INTO `area` VALUES (2312, '510500', '泸州市', 2, 2277);
INSERT INTO `area` VALUES (2313, '510502', '江阳区', 3, 2312);
INSERT INTO `area` VALUES (2314, '510503', '纳溪区', 3, 2312);
INSERT INTO `area` VALUES (2315, '510504', '龙马潭区', 3, 2312);
INSERT INTO `area` VALUES (2316, '510521', '泸县', 3, 2312);
INSERT INTO `area` VALUES (2317, '510522', '合江县', 3, 2312);
INSERT INTO `area` VALUES (2318, '510524', '叙永县', 3, 2312);
INSERT INTO `area` VALUES (2319, '510525', '古蔺县', 3, 2312);
INSERT INTO `area` VALUES (2320, '510600', '德阳市', 2, 2277);
INSERT INTO `area` VALUES (2321, '510603', '旌阳区', 3, 2320);
INSERT INTO `area` VALUES (2322, '510623', '中江县', 3, 2320);
INSERT INTO `area` VALUES (2323, '510626', '罗江县', 3, 2320);
INSERT INTO `area` VALUES (2324, '510681', '广汉市', 3, 2320);
INSERT INTO `area` VALUES (2325, '510682', '什邡市', 3, 2320);
INSERT INTO `area` VALUES (2326, '510683', '绵竹市', 3, 2320);
INSERT INTO `area` VALUES (2327, '510700', '绵阳市', 2, 2277);
INSERT INTO `area` VALUES (2328, '510703', '涪城区', 3, 2327);
INSERT INTO `area` VALUES (2329, '510704', '游仙区', 3, 2327);
INSERT INTO `area` VALUES (2330, '510705', '安州区', 3, 2327);
INSERT INTO `area` VALUES (2331, '510722', '三台县', 3, 2327);
INSERT INTO `area` VALUES (2332, '510723', '盐亭县', 3, 2327);
INSERT INTO `area` VALUES (2333, '510725', '梓潼县', 3, 2327);
INSERT INTO `area` VALUES (2334, '510726', '北川羌族自治县', 3, 2327);
INSERT INTO `area` VALUES (2335, '510727', '平武县', 3, 2327);
INSERT INTO `area` VALUES (2336, '510781', '江油市', 3, 2327);
INSERT INTO `area` VALUES (2337, '510800', '广元市', 2, 2277);
INSERT INTO `area` VALUES (2338, '510802', '利州区', 3, 2337);
INSERT INTO `area` VALUES (2339, '510811', '昭化区', 3, 2337);
INSERT INTO `area` VALUES (2340, '510812', '朝天区', 3, 2337);
INSERT INTO `area` VALUES (2341, '510821', '旺苍县', 3, 2337);
INSERT INTO `area` VALUES (2342, '510822', '青川县', 3, 2337);
INSERT INTO `area` VALUES (2343, '510823', '剑阁县', 3, 2337);
INSERT INTO `area` VALUES (2344, '510824', '苍溪县', 3, 2337);
INSERT INTO `area` VALUES (2345, '510900', '遂宁市', 2, 2277);
INSERT INTO `area` VALUES (2346, '510903', '船山区', 3, 2345);
INSERT INTO `area` VALUES (2347, '510904', '安居区', 3, 2345);
INSERT INTO `area` VALUES (2348, '510921', '蓬溪县', 3, 2345);
INSERT INTO `area` VALUES (2349, '510922', '射洪县', 3, 2345);
INSERT INTO `area` VALUES (2350, '510923', '大英县', 3, 2345);
INSERT INTO `area` VALUES (2351, '511000', '内江市', 2, 2277);
INSERT INTO `area` VALUES (2352, '511002', '市中区', 3, 2351);
INSERT INTO `area` VALUES (2353, '511011', '东兴区', 3, 2351);
INSERT INTO `area` VALUES (2354, '511024', '威远县', 3, 2351);
INSERT INTO `area` VALUES (2355, '511025', '资中县', 3, 2351);
INSERT INTO `area` VALUES (2356, '511028', '隆昌市', 3, 2351);
INSERT INTO `area` VALUES (2357, '511100', '乐山市', 2, 2277);
INSERT INTO `area` VALUES (2358, '511102', '市中区', 3, 2357);
INSERT INTO `area` VALUES (2359, '511111', '沙湾区', 3, 2357);
INSERT INTO `area` VALUES (2360, '511112', '五通桥区', 3, 2357);
INSERT INTO `area` VALUES (2361, '511113', '金口河区', 3, 2357);
INSERT INTO `area` VALUES (2362, '511123', '犍为县', 3, 2357);
INSERT INTO `area` VALUES (2363, '511124', '井研县', 3, 2357);
INSERT INTO `area` VALUES (2364, '511126', '夹江县', 3, 2357);
INSERT INTO `area` VALUES (2365, '511129', '沐川县', 3, 2357);
INSERT INTO `area` VALUES (2366, '511132', '峨边彝族自治县', 3, 2357);
INSERT INTO `area` VALUES (2367, '511133', '马边彝族自治县', 3, 2357);
INSERT INTO `area` VALUES (2368, '511181', '峨眉山市', 3, 2357);
INSERT INTO `area` VALUES (2369, '511300', '南充市', 2, 2277);
INSERT INTO `area` VALUES (2370, '511302', '顺庆区', 3, 2369);
INSERT INTO `area` VALUES (2371, '511303', '高坪区', 3, 2369);
INSERT INTO `area` VALUES (2372, '511304', '嘉陵区', 3, 2369);
INSERT INTO `area` VALUES (2373, '511321', '南部县', 3, 2369);
INSERT INTO `area` VALUES (2374, '511322', '营山县', 3, 2369);
INSERT INTO `area` VALUES (2375, '511323', '蓬安县', 3, 2369);
INSERT INTO `area` VALUES (2376, '511324', '仪陇县', 3, 2369);
INSERT INTO `area` VALUES (2377, '511325', '西充县', 3, 2369);
INSERT INTO `area` VALUES (2378, '511381', '阆中市', 3, 2369);
INSERT INTO `area` VALUES (2379, '511400', '眉山市', 2, 2277);
INSERT INTO `area` VALUES (2380, '511402', '东坡区', 3, 2379);
INSERT INTO `area` VALUES (2381, '511403', '彭山区', 3, 2379);
INSERT INTO `area` VALUES (2382, '511421', '仁寿县', 3, 2379);
INSERT INTO `area` VALUES (2383, '511423', '洪雅县', 3, 2379);
INSERT INTO `area` VALUES (2384, '511424', '丹棱县', 3, 2379);
INSERT INTO `area` VALUES (2385, '511425', '青神县', 3, 2379);
INSERT INTO `area` VALUES (2386, '511500', '宜宾市', 2, 2277);
INSERT INTO `area` VALUES (2387, '511502', '翠屏区', 3, 2386);
INSERT INTO `area` VALUES (2388, '511503', '南溪区', 3, 2386);
INSERT INTO `area` VALUES (2389, '511521', '宜宾县', 3, 2386);
INSERT INTO `area` VALUES (2390, '511523', '江安县', 3, 2386);
INSERT INTO `area` VALUES (2391, '511524', '长宁县', 3, 2386);
INSERT INTO `area` VALUES (2392, '511525', '高县', 3, 2386);
INSERT INTO `area` VALUES (2393, '511526', '珙县', 3, 2386);
INSERT INTO `area` VALUES (2394, '511527', '筠连县', 3, 2386);
INSERT INTO `area` VALUES (2395, '511528', '兴文县', 3, 2386);
INSERT INTO `area` VALUES (2396, '511529', '屏山县', 3, 2386);
INSERT INTO `area` VALUES (2397, '511600', '广安市', 2, 2277);
INSERT INTO `area` VALUES (2398, '511602', '广安区', 3, 2397);
INSERT INTO `area` VALUES (2399, '511603', '前锋区', 3, 2397);
INSERT INTO `area` VALUES (2400, '511621', '岳池县', 3, 2397);
INSERT INTO `area` VALUES (2401, '511622', '武胜县', 3, 2397);
INSERT INTO `area` VALUES (2402, '511623', '邻水县', 3, 2397);
INSERT INTO `area` VALUES (2403, '511681', '华蓥市', 3, 2397);
INSERT INTO `area` VALUES (2404, '511700', '达州市', 2, 2277);
INSERT INTO `area` VALUES (2405, '511702', '通川区', 3, 2404);
INSERT INTO `area` VALUES (2406, '511703', '达川区', 3, 2404);
INSERT INTO `area` VALUES (2407, '511722', '宣汉县', 3, 2404);
INSERT INTO `area` VALUES (2408, '511723', '开江县', 3, 2404);
INSERT INTO `area` VALUES (2409, '511724', '大竹县', 3, 2404);
INSERT INTO `area` VALUES (2410, '511725', '渠县', 3, 2404);
INSERT INTO `area` VALUES (2411, '511781', '万源市', 3, 2404);
INSERT INTO `area` VALUES (2412, '511800', '雅安市', 2, 2277);
INSERT INTO `area` VALUES (2413, '511802', '雨城区', 3, 2412);
INSERT INTO `area` VALUES (2414, '511803', '名山区', 3, 2412);
INSERT INTO `area` VALUES (2415, '511822', '荥经县', 3, 2412);
INSERT INTO `area` VALUES (2416, '511823', '汉源县', 3, 2412);
INSERT INTO `area` VALUES (2417, '511824', '石棉县', 3, 2412);
INSERT INTO `area` VALUES (2418, '511825', '天全县', 3, 2412);
INSERT INTO `area` VALUES (2419, '511826', '芦山县', 3, 2412);
INSERT INTO `area` VALUES (2420, '511827', '宝兴县', 3, 2412);
INSERT INTO `area` VALUES (2421, '511900', '巴中市', 2, 2277);
INSERT INTO `area` VALUES (2422, '511902', '巴州区', 3, 2421);
INSERT INTO `area` VALUES (2423, '511903', '恩阳区', 3, 2421);
INSERT INTO `area` VALUES (2424, '511921', '通江县', 3, 2421);
INSERT INTO `area` VALUES (2425, '511922', '南江县', 3, 2421);
INSERT INTO `area` VALUES (2426, '511923', '平昌县', 3, 2421);
INSERT INTO `area` VALUES (2427, '512000', '资阳市', 2, 2277);
INSERT INTO `area` VALUES (2428, '512002', '雁江区', 3, 2427);
INSERT INTO `area` VALUES (2429, '512021', '安岳县', 3, 2427);
INSERT INTO `area` VALUES (2430, '512022', '乐至县', 3, 2427);
INSERT INTO `area` VALUES (2431, '513200', '阿坝藏族羌族自治州', 2, 2277);
INSERT INTO `area` VALUES (2432, '513201', '马尔康市', 3, 2431);
INSERT INTO `area` VALUES (2433, '513221', '汶川县', 3, 2431);
INSERT INTO `area` VALUES (2434, '513222', '理县', 3, 2431);
INSERT INTO `area` VALUES (2435, '513223', '茂县', 3, 2431);
INSERT INTO `area` VALUES (2436, '513224', '松潘县', 3, 2431);
INSERT INTO `area` VALUES (2437, '513225', '九寨沟县', 3, 2431);
INSERT INTO `area` VALUES (2438, '513226', '金川县', 3, 2431);
INSERT INTO `area` VALUES (2439, '513227', '小金县', 3, 2431);
INSERT INTO `area` VALUES (2440, '513228', '黑水县', 3, 2431);
INSERT INTO `area` VALUES (2441, '513230', '壤塘县', 3, 2431);
INSERT INTO `area` VALUES (2442, '513231', '阿坝县', 3, 2431);
INSERT INTO `area` VALUES (2443, '513232', '若尔盖县', 3, 2431);
INSERT INTO `area` VALUES (2444, '513233', '红原县', 3, 2431);
INSERT INTO `area` VALUES (2445, '513300', '甘孜藏族自治州', 2, 2277);
INSERT INTO `area` VALUES (2446, '513301', '康定市', 3, 2445);
INSERT INTO `area` VALUES (2447, '513322', '泸定县', 3, 2445);
INSERT INTO `area` VALUES (2448, '513323', '丹巴县', 3, 2445);
INSERT INTO `area` VALUES (2449, '513324', '九龙县', 3, 2445);
INSERT INTO `area` VALUES (2450, '513325', '雅江县', 3, 2445);
INSERT INTO `area` VALUES (2451, '513326', '道孚县', 3, 2445);
INSERT INTO `area` VALUES (2452, '513327', '炉霍县', 3, 2445);
INSERT INTO `area` VALUES (2453, '513328', '甘孜县', 3, 2445);
INSERT INTO `area` VALUES (2454, '513329', '新龙县', 3, 2445);
INSERT INTO `area` VALUES (2455, '513330', '德格县', 3, 2445);
INSERT INTO `area` VALUES (2456, '513331', '白玉县', 3, 2445);
INSERT INTO `area` VALUES (2457, '513332', '石渠县', 3, 2445);
INSERT INTO `area` VALUES (2458, '513333', '色达县', 3, 2445);
INSERT INTO `area` VALUES (2459, '513334', '理塘县', 3, 2445);
INSERT INTO `area` VALUES (2460, '513335', '巴塘县', 3, 2445);
INSERT INTO `area` VALUES (2461, '513336', '乡城县', 3, 2445);
INSERT INTO `area` VALUES (2462, '513337', '稻城县', 3, 2445);
INSERT INTO `area` VALUES (2463, '513338', '得荣县', 3, 2445);
INSERT INTO `area` VALUES (2464, '513400', '凉山彝族自治州', 2, 2277);
INSERT INTO `area` VALUES (2465, '513401', '西昌市', 3, 2464);
INSERT INTO `area` VALUES (2466, '513422', '木里藏族自治县', 3, 2464);
INSERT INTO `area` VALUES (2467, '513423', '盐源县', 3, 2464);
INSERT INTO `area` VALUES (2468, '513424', '德昌县', 3, 2464);
INSERT INTO `area` VALUES (2469, '513425', '会理县', 3, 2464);
INSERT INTO `area` VALUES (2470, '513426', '会东县', 3, 2464);
INSERT INTO `area` VALUES (2471, '513427', '宁南县', 3, 2464);
INSERT INTO `area` VALUES (2472, '513428', '普格县', 3, 2464);
INSERT INTO `area` VALUES (2473, '513429', '布拖县', 3, 2464);
INSERT INTO `area` VALUES (2474, '513430', '金阳县', 3, 2464);
INSERT INTO `area` VALUES (2475, '513431', '昭觉县', 3, 2464);
INSERT INTO `area` VALUES (2476, '513432', '喜德县', 3, 2464);
INSERT INTO `area` VALUES (2477, '513433', '冕宁县', 3, 2464);
INSERT INTO `area` VALUES (2478, '513434', '越西县', 3, 2464);
INSERT INTO `area` VALUES (2479, '513435', '甘洛县', 3, 2464);
INSERT INTO `area` VALUES (2480, '513436', '美姑县', 3, 2464);
INSERT INTO `area` VALUES (2481, '513437', '雷波县', 3, 2464);
INSERT INTO `area` VALUES (2482, '520000', '贵州省', 1, -1);
INSERT INTO `area` VALUES (2483, '520100', '贵阳市', 2, 2482);
INSERT INTO `area` VALUES (2484, '520102', '南明区', 3, 2483);
INSERT INTO `area` VALUES (2485, '520103', '云岩区', 3, 2483);
INSERT INTO `area` VALUES (2486, '520111', '花溪区', 3, 2483);
INSERT INTO `area` VALUES (2487, '520112', '乌当区', 3, 2483);
INSERT INTO `area` VALUES (2488, '520113', '白云区', 3, 2483);
INSERT INTO `area` VALUES (2489, '520115', '观山湖区', 3, 2483);
INSERT INTO `area` VALUES (2490, '520121', '开阳县', 3, 2483);
INSERT INTO `area` VALUES (2491, '520122', '息烽县', 3, 2483);
INSERT INTO `area` VALUES (2492, '520123', '修文县', 3, 2483);
INSERT INTO `area` VALUES (2493, '520181', '清镇市', 3, 2483);
INSERT INTO `area` VALUES (2494, '520200', '六盘水市', 2, 2482);
INSERT INTO `area` VALUES (2495, '520201', '钟山区', 3, 2494);
INSERT INTO `area` VALUES (2496, '520203', '六枝特区', 3, 2494);
INSERT INTO `area` VALUES (2497, '520221', '水城县', 3, 2494);
INSERT INTO `area` VALUES (2498, '520222', '盘州市', 3, 2494);
INSERT INTO `area` VALUES (2499, '520300', '遵义市', 2, 2482);
INSERT INTO `area` VALUES (2500, '520302', '红花岗区', 3, 2499);
INSERT INTO `area` VALUES (2501, '520303', '汇川区', 3, 2499);
INSERT INTO `area` VALUES (2502, '520304', '播州区', 3, 2499);
INSERT INTO `area` VALUES (2503, '520322', '桐梓县', 3, 2499);
INSERT INTO `area` VALUES (2504, '520323', '绥阳县', 3, 2499);
INSERT INTO `area` VALUES (2505, '520324', '正安县', 3, 2499);
INSERT INTO `area` VALUES (2506, '520325', '道真仡佬族苗族自治县', 3, 2499);
INSERT INTO `area` VALUES (2507, '520326', '务川仡佬族苗族自治县', 3, 2499);
INSERT INTO `area` VALUES (2508, '520327', '凤冈县', 3, 2499);
INSERT INTO `area` VALUES (2509, '520328', '湄潭县', 3, 2499);
INSERT INTO `area` VALUES (2510, '520329', '余庆县', 3, 2499);
INSERT INTO `area` VALUES (2511, '520330', '习水县', 3, 2499);
INSERT INTO `area` VALUES (2512, '520381', '赤水市', 3, 2499);
INSERT INTO `area` VALUES (2513, '520382', '仁怀市', 3, 2499);
INSERT INTO `area` VALUES (2514, '520400', '安顺市', 2, 2482);
INSERT INTO `area` VALUES (2515, '520402', '西秀区', 3, 2514);
INSERT INTO `area` VALUES (2516, '520403', '平坝区', 3, 2514);
INSERT INTO `area` VALUES (2517, '520422', '普定县', 3, 2514);
INSERT INTO `area` VALUES (2518, '520423', '镇宁布依族苗族自治县', 3, 2514);
INSERT INTO `area` VALUES (2519, '520424', '关岭布依族苗族自治县', 3, 2514);
INSERT INTO `area` VALUES (2520, '520425', '紫云苗族布依族自治县', 3, 2514);
INSERT INTO `area` VALUES (2521, '520500', '毕节市', 2, 2482);
INSERT INTO `area` VALUES (2522, '520502', '七星关区', 3, 2521);
INSERT INTO `area` VALUES (2523, '520521', '大方县', 3, 2521);
INSERT INTO `area` VALUES (2524, '520522', '黔西县', 3, 2521);
INSERT INTO `area` VALUES (2525, '520523', '金沙县', 3, 2521);
INSERT INTO `area` VALUES (2526, '520524', '织金县', 3, 2521);
INSERT INTO `area` VALUES (2527, '520525', '纳雍县', 3, 2521);
INSERT INTO `area` VALUES (2528, '520526', '威宁彝族回族苗族自治县', 3, 2521);
INSERT INTO `area` VALUES (2529, '520527', '赫章县', 3, 2521);
INSERT INTO `area` VALUES (2530, '520600', '铜仁市', 2, 2482);
INSERT INTO `area` VALUES (2531, '520602', '碧江区', 3, 2530);
INSERT INTO `area` VALUES (2532, '520603', '万山区', 3, 2530);
INSERT INTO `area` VALUES (2533, '520621', '江口县', 3, 2530);
INSERT INTO `area` VALUES (2534, '520622', '玉屏侗族自治县', 3, 2530);
INSERT INTO `area` VALUES (2535, '520623', '石阡县', 3, 2530);
INSERT INTO `area` VALUES (2536, '520624', '思南县', 3, 2530);
INSERT INTO `area` VALUES (2537, '520625', '印江土家族苗族自治县', 3, 2530);
INSERT INTO `area` VALUES (2538, '520626', '德江县', 3, 2530);
INSERT INTO `area` VALUES (2539, '520627', '沿河土家族自治县', 3, 2530);
INSERT INTO `area` VALUES (2540, '520628', '松桃苗族自治县', 3, 2530);
INSERT INTO `area` VALUES (2541, '522300', '黔西南布依族苗族自治州', 2, 2482);
INSERT INTO `area` VALUES (2542, '522301', '兴义市', 3, 2541);
INSERT INTO `area` VALUES (2543, '522322', '兴仁县', 3, 2541);
INSERT INTO `area` VALUES (2544, '522323', '普安县', 3, 2541);
INSERT INTO `area` VALUES (2545, '522324', '晴隆县', 3, 2541);
INSERT INTO `area` VALUES (2546, '522325', '贞丰县', 3, 2541);
INSERT INTO `area` VALUES (2547, '522326', '望谟县', 3, 2541);
INSERT INTO `area` VALUES (2548, '522327', '册亨县', 3, 2541);
INSERT INTO `area` VALUES (2549, '522328', '安龙县', 3, 2541);
INSERT INTO `area` VALUES (2550, '522600', '黔东南苗族侗族自治州', 2, 2482);
INSERT INTO `area` VALUES (2551, '522601', '凯里市', 3, 2550);
INSERT INTO `area` VALUES (2552, '522622', '黄平县', 3, 2550);
INSERT INTO `area` VALUES (2553, '522623', '施秉县', 3, 2550);
INSERT INTO `area` VALUES (2554, '522624', '三穗县', 3, 2550);
INSERT INTO `area` VALUES (2555, '522625', '镇远县', 3, 2550);
INSERT INTO `area` VALUES (2556, '522626', '岑巩县', 3, 2550);
INSERT INTO `area` VALUES (2557, '522627', '天柱县', 3, 2550);
INSERT INTO `area` VALUES (2558, '522628', '锦屏县', 3, 2550);
INSERT INTO `area` VALUES (2559, '522629', '剑河县', 3, 2550);
INSERT INTO `area` VALUES (2560, '522630', '台江县', 3, 2550);
INSERT INTO `area` VALUES (2561, '522631', '黎平县', 3, 2550);
INSERT INTO `area` VALUES (2562, '522632', '榕江县', 3, 2550);
INSERT INTO `area` VALUES (2563, '522633', '从江县', 3, 2550);
INSERT INTO `area` VALUES (2564, '522634', '雷山县', 3, 2550);
INSERT INTO `area` VALUES (2565, '522635', '麻江县', 3, 2550);
INSERT INTO `area` VALUES (2566, '522636', '丹寨县', 3, 2550);
INSERT INTO `area` VALUES (2567, '522700', '黔南布依族苗族自治州', 2, 2482);
INSERT INTO `area` VALUES (2568, '522701', '都匀市', 3, 2567);
INSERT INTO `area` VALUES (2569, '522702', '福泉市', 3, 2567);
INSERT INTO `area` VALUES (2570, '522722', '荔波县', 3, 2567);
INSERT INTO `area` VALUES (2571, '522723', '贵定县', 3, 2567);
INSERT INTO `area` VALUES (2572, '522725', '瓮安县', 3, 2567);
INSERT INTO `area` VALUES (2573, '522726', '独山县', 3, 2567);
INSERT INTO `area` VALUES (2574, '522727', '平塘县', 3, 2567);
INSERT INTO `area` VALUES (2575, '522728', '罗甸县', 3, 2567);
INSERT INTO `area` VALUES (2576, '522729', '长顺县', 3, 2567);
INSERT INTO `area` VALUES (2577, '522730', '龙里县', 3, 2567);
INSERT INTO `area` VALUES (2578, '522731', '惠水县', 3, 2567);
INSERT INTO `area` VALUES (2579, '522732', '三都水族自治县', 3, 2567);
INSERT INTO `area` VALUES (2580, '530000', '云南省', 1, -1);
INSERT INTO `area` VALUES (2581, '530100', '昆明市', 2, 2580);
INSERT INTO `area` VALUES (2582, '530102', '五华区', 3, 2581);
INSERT INTO `area` VALUES (2583, '530103', '盘龙区', 3, 2581);
INSERT INTO `area` VALUES (2584, '530111', '官渡区', 3, 2581);
INSERT INTO `area` VALUES (2585, '530112', '西山区', 3, 2581);
INSERT INTO `area` VALUES (2586, '530113', '东川区', 3, 2581);
INSERT INTO `area` VALUES (2587, '530114', '呈贡区', 3, 2581);
INSERT INTO `area` VALUES (2588, '530115', '晋宁区', 3, 2581);
INSERT INTO `area` VALUES (2589, '530124', '富民县', 3, 2581);
INSERT INTO `area` VALUES (2590, '530125', '宜良县', 3, 2581);
INSERT INTO `area` VALUES (2591, '530126', '石林彝族自治县', 3, 2581);
INSERT INTO `area` VALUES (2592, '530127', '嵩明县', 3, 2581);
INSERT INTO `area` VALUES (2593, '530128', '禄劝彝族苗族自治县', 3, 2581);
INSERT INTO `area` VALUES (2594, '530129', '寻甸回族彝族自治县', 3, 2581);
INSERT INTO `area` VALUES (2595, '530181', '安宁市', 3, 2581);
INSERT INTO `area` VALUES (2596, '530300', '曲靖市', 2, 2580);
INSERT INTO `area` VALUES (2597, '530302', '麒麟区', 3, 2596);
INSERT INTO `area` VALUES (2598, '530303', '沾益区', 3, 2596);
INSERT INTO `area` VALUES (2599, '530321', '马龙县', 3, 2596);
INSERT INTO `area` VALUES (2600, '530322', '陆良县', 3, 2596);
INSERT INTO `area` VALUES (2601, '530323', '师宗县', 3, 2596);
INSERT INTO `area` VALUES (2602, '530324', '罗平县', 3, 2596);
INSERT INTO `area` VALUES (2603, '530325', '富源县', 3, 2596);
INSERT INTO `area` VALUES (2604, '530326', '会泽县', 3, 2596);
INSERT INTO `area` VALUES (2605, '530381', '宣威市', 3, 2596);
INSERT INTO `area` VALUES (2606, '530400', '玉溪市', 2, 2580);
INSERT INTO `area` VALUES (2607, '530402', '红塔区', 3, 2606);
INSERT INTO `area` VALUES (2608, '530403', '江川区', 3, 2606);
INSERT INTO `area` VALUES (2609, '530422', '澄江县', 3, 2606);
INSERT INTO `area` VALUES (2610, '530423', '通海县', 3, 2606);
INSERT INTO `area` VALUES (2611, '530424', '华宁县', 3, 2606);
INSERT INTO `area` VALUES (2612, '530425', '易门县', 3, 2606);
INSERT INTO `area` VALUES (2613, '530426', '峨山彝族自治县', 3, 2606);
INSERT INTO `area` VALUES (2614, '530427', '新平彝族傣族自治县', 3, 2606);
INSERT INTO `area` VALUES (2615, '530428', '元江哈尼族彝族傣族自治县', 3, 2606);
INSERT INTO `area` VALUES (2616, '530500', '保山市', 2, 2580);
INSERT INTO `area` VALUES (2617, '530502', '隆阳区', 3, 2616);
INSERT INTO `area` VALUES (2618, '530521', '施甸县', 3, 2616);
INSERT INTO `area` VALUES (2619, '530523', '龙陵县', 3, 2616);
INSERT INTO `area` VALUES (2620, '530524', '昌宁县', 3, 2616);
INSERT INTO `area` VALUES (2621, '530581', '腾冲市', 3, 2616);
INSERT INTO `area` VALUES (2622, '530600', '昭通市', 2, 2580);
INSERT INTO `area` VALUES (2623, '530602', '昭阳区', 3, 2622);
INSERT INTO `area` VALUES (2624, '530621', '鲁甸县', 3, 2622);
INSERT INTO `area` VALUES (2625, '530622', '巧家县', 3, 2622);
INSERT INTO `area` VALUES (2626, '530623', '盐津县', 3, 2622);
INSERT INTO `area` VALUES (2627, '530624', '大关县', 3, 2622);
INSERT INTO `area` VALUES (2628, '530625', '永善县', 3, 2622);
INSERT INTO `area` VALUES (2629, '530626', '绥江县', 3, 2622);
INSERT INTO `area` VALUES (2630, '530627', '镇雄县', 3, 2622);
INSERT INTO `area` VALUES (2631, '530628', '彝良县', 3, 2622);
INSERT INTO `area` VALUES (2632, '530629', '威信县', 3, 2622);
INSERT INTO `area` VALUES (2633, '530630', '水富县', 3, 2622);
INSERT INTO `area` VALUES (2634, '530700', '丽江市', 2, 2580);
INSERT INTO `area` VALUES (2635, '530702', '古城区', 3, 2634);
INSERT INTO `area` VALUES (2636, '530721', '玉龙纳西族自治县', 3, 2634);
INSERT INTO `area` VALUES (2637, '530722', '永胜县', 3, 2634);
INSERT INTO `area` VALUES (2638, '530723', '华坪县', 3, 2634);
INSERT INTO `area` VALUES (2639, '530724', '宁蒗彝族自治县', 3, 2634);
INSERT INTO `area` VALUES (2640, '530800', '普洱市', 2, 2580);
INSERT INTO `area` VALUES (2641, '530802', '思茅区', 3, 2640);
INSERT INTO `area` VALUES (2642, '530821', '宁洱哈尼族彝族自治县', 3, 2640);
INSERT INTO `area` VALUES (2643, '530822', '墨江哈尼族自治县', 3, 2640);
INSERT INTO `area` VALUES (2644, '530823', '景东彝族自治县', 3, 2640);
INSERT INTO `area` VALUES (2645, '530824', '景谷傣族彝族自治县', 3, 2640);
INSERT INTO `area` VALUES (2646, '530825', '镇沅彝族哈尼族拉祜族自治县', 3, 2640);
INSERT INTO `area` VALUES (2647, '530826', '江城哈尼族彝族自治县', 3, 2640);
INSERT INTO `area` VALUES (2648, '530827', '孟连傣族拉祜族佤族自治县', 3, 2640);
INSERT INTO `area` VALUES (2649, '530828', '澜沧拉祜族自治县', 3, 2640);
INSERT INTO `area` VALUES (2650, '530829', '西盟佤族自治县', 3, 2640);
INSERT INTO `area` VALUES (2651, '530900', '临沧市', 2, 2580);
INSERT INTO `area` VALUES (2652, '530902', '临翔区', 3, 2651);
INSERT INTO `area` VALUES (2653, '530921', '凤庆县', 3, 2651);
INSERT INTO `area` VALUES (2654, '530922', '云县', 3, 2651);
INSERT INTO `area` VALUES (2655, '530923', '永德县', 3, 2651);
INSERT INTO `area` VALUES (2656, '530924', '镇康县', 3, 2651);
INSERT INTO `area` VALUES (2657, '530925', '双江拉祜族佤族布朗族傣族自治县', 3, 2651);
INSERT INTO `area` VALUES (2658, '530926', '耿马傣族佤族自治县', 3, 2651);
INSERT INTO `area` VALUES (2659, '530927', '沧源佤族自治县', 3, 2651);
INSERT INTO `area` VALUES (2660, '532300', '楚雄彝族自治州', 2, 2580);
INSERT INTO `area` VALUES (2661, '532301', '楚雄市', 3, 2660);
INSERT INTO `area` VALUES (2662, '532322', '双柏县', 3, 2660);
INSERT INTO `area` VALUES (2663, '532323', '牟定县', 3, 2660);
INSERT INTO `area` VALUES (2664, '532324', '南华县', 3, 2660);
INSERT INTO `area` VALUES (2665, '532325', '姚安县', 3, 2660);
INSERT INTO `area` VALUES (2666, '532326', '大姚县', 3, 2660);
INSERT INTO `area` VALUES (2667, '532327', '永仁县', 3, 2660);
INSERT INTO `area` VALUES (2668, '532328', '元谋县', 3, 2660);
INSERT INTO `area` VALUES (2669, '532329', '武定县', 3, 2660);
INSERT INTO `area` VALUES (2670, '532331', '禄丰县', 3, 2660);
INSERT INTO `area` VALUES (2671, '532500', '红河哈尼族彝族自治州', 2, 2580);
INSERT INTO `area` VALUES (2672, '532501', '个旧市', 3, 2671);
INSERT INTO `area` VALUES (2673, '532502', '开远市', 3, 2671);
INSERT INTO `area` VALUES (2674, '532503', '蒙自市', 3, 2671);
INSERT INTO `area` VALUES (2675, '532504', '弥勒市', 3, 2671);
INSERT INTO `area` VALUES (2676, '532523', '屏边苗族自治县', 3, 2671);
INSERT INTO `area` VALUES (2677, '532524', '建水县', 3, 2671);
INSERT INTO `area` VALUES (2678, '532525', '石屏县', 3, 2671);
INSERT INTO `area` VALUES (2679, '532527', '泸西县', 3, 2671);
INSERT INTO `area` VALUES (2680, '532528', '元阳县', 3, 2671);
INSERT INTO `area` VALUES (2681, '532529', '红河县', 3, 2671);
INSERT INTO `area` VALUES (2682, '532530', '金平苗族瑶族傣族自治县', 3, 2671);
INSERT INTO `area` VALUES (2683, '532531', '绿春县', 3, 2671);
INSERT INTO `area` VALUES (2684, '532532', '河口瑶族自治县', 3, 2671);
INSERT INTO `area` VALUES (2685, '532600', '文山壮族苗族自治州', 2, 2580);
INSERT INTO `area` VALUES (2686, '532601', '文山市', 3, 2685);
INSERT INTO `area` VALUES (2687, '532622', '砚山县', 3, 2685);
INSERT INTO `area` VALUES (2688, '532623', '西畴县', 3, 2685);
INSERT INTO `area` VALUES (2689, '532624', '麻栗坡县', 3, 2685);
INSERT INTO `area` VALUES (2690, '532625', '马关县', 3, 2685);
INSERT INTO `area` VALUES (2691, '532626', '丘北县', 3, 2685);
INSERT INTO `area` VALUES (2692, '532627', '广南县', 3, 2685);
INSERT INTO `area` VALUES (2693, '532628', '富宁县', 3, 2685);
INSERT INTO `area` VALUES (2694, '532800', '西双版纳傣族自治州', 2, 2580);
INSERT INTO `area` VALUES (2695, '532801', '景洪市', 3, 2694);
INSERT INTO `area` VALUES (2696, '532822', '勐海县', 3, 2694);
INSERT INTO `area` VALUES (2697, '532823', '勐腊县', 3, 2694);
INSERT INTO `area` VALUES (2698, '532900', '大理白族自治州', 2, 2580);
INSERT INTO `area` VALUES (2699, '532901', '大理市', 3, 2698);
INSERT INTO `area` VALUES (2700, '532922', '漾濞彝族自治县', 3, 2698);
INSERT INTO `area` VALUES (2701, '532923', '祥云县', 3, 2698);
INSERT INTO `area` VALUES (2702, '532924', '宾川县', 3, 2698);
INSERT INTO `area` VALUES (2703, '532925', '弥渡县', 3, 2698);
INSERT INTO `area` VALUES (2704, '532926', '南涧彝族自治县', 3, 2698);
INSERT INTO `area` VALUES (2705, '532927', '巍山彝族回族自治县', 3, 2698);
INSERT INTO `area` VALUES (2706, '532928', '永平县', 3, 2698);
INSERT INTO `area` VALUES (2707, '532929', '云龙县', 3, 2698);
INSERT INTO `area` VALUES (2708, '532930', '洱源县', 3, 2698);
INSERT INTO `area` VALUES (2709, '532931', '剑川县', 3, 2698);
INSERT INTO `area` VALUES (2710, '532932', '鹤庆县', 3, 2698);
INSERT INTO `area` VALUES (2711, '533100', '德宏傣族景颇族自治州', 2, 2580);
INSERT INTO `area` VALUES (2712, '533102', '瑞丽市', 3, 2711);
INSERT INTO `area` VALUES (2713, '533103', '芒市', 3, 2711);
INSERT INTO `area` VALUES (2714, '533122', '梁河县', 3, 2711);
INSERT INTO `area` VALUES (2715, '533123', '盈江县', 3, 2711);
INSERT INTO `area` VALUES (2716, '533124', '陇川县', 3, 2711);
INSERT INTO `area` VALUES (2717, '533300', '怒江傈僳族自治州', 2, 2580);
INSERT INTO `area` VALUES (2718, '533301', '泸水市', 3, 2717);
INSERT INTO `area` VALUES (2719, '533323', '福贡县', 3, 2717);
INSERT INTO `area` VALUES (2720, '533324', '贡山独龙族怒族自治县', 3, 2717);
INSERT INTO `area` VALUES (2721, '533325', '兰坪白族普米族自治县', 3, 2717);
INSERT INTO `area` VALUES (2722, '533400', '迪庆藏族自治州', 2, 2580);
INSERT INTO `area` VALUES (2723, '533401', '香格里拉市', 3, 2722);
INSERT INTO `area` VALUES (2724, '533422', '德钦县', 3, 2722);
INSERT INTO `area` VALUES (2725, '533423', '维西傈僳族自治县', 3, 2722);
INSERT INTO `area` VALUES (2726, '540000', '西藏自治区', 1, -1);
INSERT INTO `area` VALUES (2727, '540100', '拉萨市', 2, 2726);
INSERT INTO `area` VALUES (2728, '540102', '城关区', 3, 2727);
INSERT INTO `area` VALUES (2729, '540103', '堆龙德庆区', 3, 2727);
INSERT INTO `area` VALUES (2730, '540121', '林周县', 3, 2727);
INSERT INTO `area` VALUES (2731, '540122', '当雄县', 3, 2727);
INSERT INTO `area` VALUES (2732, '540123', '尼木县', 3, 2727);
INSERT INTO `area` VALUES (2733, '540124', '曲水县', 3, 2727);
INSERT INTO `area` VALUES (2734, '540126', '达孜县', 3, 2727);
INSERT INTO `area` VALUES (2735, '540127', '墨竹工卡县', 3, 2727);
INSERT INTO `area` VALUES (2736, '540200', '日喀则市', 2, 2726);
INSERT INTO `area` VALUES (2737, '540202', '桑珠孜区', 3, 2736);
INSERT INTO `area` VALUES (2738, '540221', '南木林县', 3, 2736);
INSERT INTO `area` VALUES (2739, '540222', '江孜县', 3, 2736);
INSERT INTO `area` VALUES (2740, '540223', '定日县', 3, 2736);
INSERT INTO `area` VALUES (2741, '540224', '萨迦县', 3, 2736);
INSERT INTO `area` VALUES (2742, '540225', '拉孜县', 3, 2736);
INSERT INTO `area` VALUES (2743, '540226', '昂仁县', 3, 2736);
INSERT INTO `area` VALUES (2744, '540227', '谢通门县', 3, 2736);
INSERT INTO `area` VALUES (2745, '540228', '白朗县', 3, 2736);
INSERT INTO `area` VALUES (2746, '540229', '仁布县', 3, 2736);
INSERT INTO `area` VALUES (2747, '540230', '康马县', 3, 2736);
INSERT INTO `area` VALUES (2748, '540231', '定结县', 3, 2736);
INSERT INTO `area` VALUES (2749, '540232', '仲巴县', 3, 2736);
INSERT INTO `area` VALUES (2750, '540233', '亚东县', 3, 2736);
INSERT INTO `area` VALUES (2751, '540234', '吉隆县', 3, 2736);
INSERT INTO `area` VALUES (2752, '540235', '聂拉木县', 3, 2736);
INSERT INTO `area` VALUES (2753, '540236', '萨嘎县', 3, 2736);
INSERT INTO `area` VALUES (2754, '540237', '岗巴县', 3, 2736);
INSERT INTO `area` VALUES (2755, '540300', '昌都市', 2, 2726);
INSERT INTO `area` VALUES (2756, '540302', '卡若区', 3, 2755);
INSERT INTO `area` VALUES (2757, '540321', '江达县', 3, 2755);
INSERT INTO `area` VALUES (2758, '540322', '贡觉县', 3, 2755);
INSERT INTO `area` VALUES (2759, '540323', '类乌齐县', 3, 2755);
INSERT INTO `area` VALUES (2760, '540324', '丁青县', 3, 2755);
INSERT INTO `area` VALUES (2761, '540325', '察雅县', 3, 2755);
INSERT INTO `area` VALUES (2762, '540326', '八宿县', 3, 2755);
INSERT INTO `area` VALUES (2763, '540327', '左贡县', 3, 2755);
INSERT INTO `area` VALUES (2764, '540328', '芒康县', 3, 2755);
INSERT INTO `area` VALUES (2765, '540329', '洛隆县', 3, 2755);
INSERT INTO `area` VALUES (2766, '540330', '边坝县', 3, 2755);
INSERT INTO `area` VALUES (2767, '540400', '林芝市', 2, 2726);
INSERT INTO `area` VALUES (2768, '540402', '巴宜区', 3, 2767);
INSERT INTO `area` VALUES (2769, '540421', '工布江达县', 3, 2767);
INSERT INTO `area` VALUES (2770, '540422', '米林县', 3, 2767);
INSERT INTO `area` VALUES (2771, '540423', '墨脱县', 3, 2767);
INSERT INTO `area` VALUES (2772, '540424', '波密县', 3, 2767);
INSERT INTO `area` VALUES (2773, '540425', '察隅县', 3, 2767);
INSERT INTO `area` VALUES (2774, '540426', '朗县', 3, 2767);
INSERT INTO `area` VALUES (2775, '540500', '山南市', 2, 2726);
INSERT INTO `area` VALUES (2776, '540502', '乃东区', 3, 2775);
INSERT INTO `area` VALUES (2777, '540521', '扎囊县', 3, 2775);
INSERT INTO `area` VALUES (2778, '540522', '贡嘎县', 3, 2775);
INSERT INTO `area` VALUES (2779, '540523', '桑日县', 3, 2775);
INSERT INTO `area` VALUES (2780, '540524', '琼结县', 3, 2775);
INSERT INTO `area` VALUES (2781, '540525', '曲松县', 3, 2775);
INSERT INTO `area` VALUES (2782, '540526', '措美县', 3, 2775);
INSERT INTO `area` VALUES (2783, '540527', '洛扎县', 3, 2775);
INSERT INTO `area` VALUES (2784, '540528', '加查县', 3, 2775);
INSERT INTO `area` VALUES (2785, '540529', '隆子县', 3, 2775);
INSERT INTO `area` VALUES (2786, '540530', '错那县', 3, 2775);
INSERT INTO `area` VALUES (2787, '540531', '浪卡子县', 3, 2775);
INSERT INTO `area` VALUES (2788, '542400', '那曲地区', 2, 2726);
INSERT INTO `area` VALUES (2789, '542421', '那曲县', 3, 2788);
INSERT INTO `area` VALUES (2790, '542422', '嘉黎县', 3, 2788);
INSERT INTO `area` VALUES (2791, '542423', '比如县', 3, 2788);
INSERT INTO `area` VALUES (2792, '542424', '聂荣县', 3, 2788);
INSERT INTO `area` VALUES (2793, '542425', '安多县', 3, 2788);
INSERT INTO `area` VALUES (2794, '542426', '申扎县', 3, 2788);
INSERT INTO `area` VALUES (2795, '542427', '索县', 3, 2788);
INSERT INTO `area` VALUES (2796, '542428', '班戈县', 3, 2788);
INSERT INTO `area` VALUES (2797, '542429', '巴青县', 3, 2788);
INSERT INTO `area` VALUES (2798, '542430', '尼玛县', 3, 2788);
INSERT INTO `area` VALUES (2799, '542431', '双湖县', 3, 2788);
INSERT INTO `area` VALUES (2800, '542500', '阿里地区', 2, 2726);
INSERT INTO `area` VALUES (2801, '542521', '普兰县', 3, 2800);
INSERT INTO `area` VALUES (2802, '542522', '札达县', 3, 2800);
INSERT INTO `area` VALUES (2803, '542523', '噶尔县', 3, 2800);
INSERT INTO `area` VALUES (2804, '542524', '日土县', 3, 2800);
INSERT INTO `area` VALUES (2805, '542525', '革吉县', 3, 2800);
INSERT INTO `area` VALUES (2806, '542526', '改则县', 3, 2800);
INSERT INTO `area` VALUES (2807, '542527', '措勤县', 3, 2800);
INSERT INTO `area` VALUES (2808, '610000', '陕西省', 1, -1);
INSERT INTO `area` VALUES (2809, '610100', '西安市', 2, 2808);
INSERT INTO `area` VALUES (2810, '610102', '新城区', 3, 2809);
INSERT INTO `area` VALUES (2811, '610103', '碑林区', 3, 2809);
INSERT INTO `area` VALUES (2812, '610104', '莲湖区', 3, 2809);
INSERT INTO `area` VALUES (2813, '610111', '灞桥区', 3, 2809);
INSERT INTO `area` VALUES (2814, '610112', '未央区', 3, 2809);
INSERT INTO `area` VALUES (2815, '610113', '雁塔区', 3, 2809);
INSERT INTO `area` VALUES (2816, '610114', '阎良区', 3, 2809);
INSERT INTO `area` VALUES (2817, '610115', '临潼区', 3, 2809);
INSERT INTO `area` VALUES (2818, '610116', '长安区', 3, 2809);
INSERT INTO `area` VALUES (2819, '610117', '高陵区', 3, 2809);
INSERT INTO `area` VALUES (2820, '610122', '蓝田县', 3, 2809);
INSERT INTO `area` VALUES (2821, '610124', '周至县', 3, 2809);
INSERT INTO `area` VALUES (2822, '610118', '鄠邑区', 3, 2809);
INSERT INTO `area` VALUES (2823, '610200', '铜川市', 2, 2808);
INSERT INTO `area` VALUES (2824, '610202', '王益区', 3, 2823);
INSERT INTO `area` VALUES (2825, '610203', '印台区', 3, 2823);
INSERT INTO `area` VALUES (2826, '610204', '耀州区', 3, 2823);
INSERT INTO `area` VALUES (2827, '610222', '宜君县', 3, 2823);
INSERT INTO `area` VALUES (2828, '610300', '宝鸡市', 2, 2808);
INSERT INTO `area` VALUES (2829, '610302', '渭滨区', 3, 2828);
INSERT INTO `area` VALUES (2830, '610303', '金台区', 3, 2828);
INSERT INTO `area` VALUES (2831, '610304', '陈仓区', 3, 2828);
INSERT INTO `area` VALUES (2832, '610322', '凤翔县', 3, 2828);
INSERT INTO `area` VALUES (2833, '610323', '岐山县', 3, 2828);
INSERT INTO `area` VALUES (2834, '610324', '扶风县', 3, 2828);
INSERT INTO `area` VALUES (2835, '610326', '眉县', 3, 2828);
INSERT INTO `area` VALUES (2836, '610327', '陇县', 3, 2828);
INSERT INTO `area` VALUES (2837, '610328', '千阳县', 3, 2828);
INSERT INTO `area` VALUES (2838, '610329', '麟游县', 3, 2828);
INSERT INTO `area` VALUES (2839, '610330', '凤县', 3, 2828);
INSERT INTO `area` VALUES (2840, '610331', '太白县', 3, 2828);
INSERT INTO `area` VALUES (2841, '610400', '咸阳市', 2, 2808);
INSERT INTO `area` VALUES (2842, '610402', '秦都区', 3, 2841);
INSERT INTO `area` VALUES (2843, '610403', '杨陵区', 3, 2841);
INSERT INTO `area` VALUES (2844, '610404', '渭城区', 3, 2841);
INSERT INTO `area` VALUES (2845, '610422', '三原县', 3, 2841);
INSERT INTO `area` VALUES (2846, '610423', '泾阳县', 3, 2841);
INSERT INTO `area` VALUES (2847, '610424', '乾县', 3, 2841);
INSERT INTO `area` VALUES (2848, '610425', '礼泉县', 3, 2841);
INSERT INTO `area` VALUES (2849, '610426', '永寿县', 3, 2841);
INSERT INTO `area` VALUES (2850, '610427', '彬县', 3, 2841);
INSERT INTO `area` VALUES (2851, '610428', '长武县', 3, 2841);
INSERT INTO `area` VALUES (2852, '610429', '旬邑县', 3, 2841);
INSERT INTO `area` VALUES (2853, '610430', '淳化县', 3, 2841);
INSERT INTO `area` VALUES (2854, '610431', '武功县', 3, 2841);
INSERT INTO `area` VALUES (2855, '610481', '兴平市', 3, 2841);
INSERT INTO `area` VALUES (2856, '610500', '渭南市', 2, 2808);
INSERT INTO `area` VALUES (2857, '610502', '临渭区', 3, 2856);
INSERT INTO `area` VALUES (2858, '610503', '华州区', 3, 2856);
INSERT INTO `area` VALUES (2859, '610522', '潼关县', 3, 2856);
INSERT INTO `area` VALUES (2860, '610523', '大荔县', 3, 2856);
INSERT INTO `area` VALUES (2861, '610524', '合阳县', 3, 2856);
INSERT INTO `area` VALUES (2862, '610525', '澄城县', 3, 2856);
INSERT INTO `area` VALUES (2863, '610526', '蒲城县', 3, 2856);
INSERT INTO `area` VALUES (2864, '610527', '白水县', 3, 2856);
INSERT INTO `area` VALUES (2865, '610528', '富平县', 3, 2856);
INSERT INTO `area` VALUES (2866, '610581', '韩城市', 3, 2856);
INSERT INTO `area` VALUES (2867, '610582', '华阴市', 3, 2856);
INSERT INTO `area` VALUES (2868, '610600', '延安市', 2, 2808);
INSERT INTO `area` VALUES (2869, '610602', '宝塔区', 3, 2868);
INSERT INTO `area` VALUES (2870, '610621', '延长县', 3, 2868);
INSERT INTO `area` VALUES (2871, '610622', '延川县', 3, 2868);
INSERT INTO `area` VALUES (2872, '610623', '子长县', 3, 2868);
INSERT INTO `area` VALUES (2873, '610603', '安塞区', 3, 2868);
INSERT INTO `area` VALUES (2874, '610625', '志丹县', 3, 2868);
INSERT INTO `area` VALUES (2875, '610626', '吴起县', 3, 2868);
INSERT INTO `area` VALUES (2876, '610627', '甘泉县', 3, 2868);
INSERT INTO `area` VALUES (2877, '610628', '富县', 3, 2868);
INSERT INTO `area` VALUES (2878, '610629', '洛川县', 3, 2868);
INSERT INTO `area` VALUES (2879, '610630', '宜川县', 3, 2868);
INSERT INTO `area` VALUES (2880, '610631', '黄龙县', 3, 2868);
INSERT INTO `area` VALUES (2881, '610632', '黄陵县', 3, 2868);
INSERT INTO `area` VALUES (2882, '610700', '汉中市', 2, 2808);
INSERT INTO `area` VALUES (2883, '610702', '汉台区', 3, 2882);
INSERT INTO `area` VALUES (2884, '610721', '南郑县', 3, 2882);
INSERT INTO `area` VALUES (2885, '610722', '城固县', 3, 2882);
INSERT INTO `area` VALUES (2886, '610723', '洋县', 3, 2882);
INSERT INTO `area` VALUES (2887, '610724', '西乡县', 3, 2882);
INSERT INTO `area` VALUES (2888, '610725', '勉县', 3, 2882);
INSERT INTO `area` VALUES (2889, '610726', '宁强县', 3, 2882);
INSERT INTO `area` VALUES (2890, '610727', '略阳县', 3, 2882);
INSERT INTO `area` VALUES (2891, '610728', '镇巴县', 3, 2882);
INSERT INTO `area` VALUES (2892, '610729', '留坝县', 3, 2882);
INSERT INTO `area` VALUES (2893, '610730', '佛坪县', 3, 2882);
INSERT INTO `area` VALUES (2894, '610800', '榆林市', 2, 2808);
INSERT INTO `area` VALUES (2895, '610802', '榆阳区', 3, 2894);
INSERT INTO `area` VALUES (2896, '610803', '横山区', 3, 2894);
INSERT INTO `area` VALUES (2897, '610881', '神木市', 3, 2894);
INSERT INTO `area` VALUES (2898, '610822', '府谷县', 3, 2894);
INSERT INTO `area` VALUES (2899, '610824', '靖边县', 3, 2894);
INSERT INTO `area` VALUES (2900, '610825', '定边县', 3, 2894);
INSERT INTO `area` VALUES (2901, '610826', '绥德县', 3, 2894);
INSERT INTO `area` VALUES (2902, '610827', '米脂县', 3, 2894);
INSERT INTO `area` VALUES (2903, '610828', '佳县', 3, 2894);
INSERT INTO `area` VALUES (2904, '610829', '吴堡县', 3, 2894);
INSERT INTO `area` VALUES (2905, '610830', '清涧县', 3, 2894);
INSERT INTO `area` VALUES (2906, '610831', '子洲县', 3, 2894);
INSERT INTO `area` VALUES (2907, '610900', '安康市', 2, 2808);
INSERT INTO `area` VALUES (2908, '610902', '汉滨区', 3, 2907);
INSERT INTO `area` VALUES (2909, '610921', '汉阴县', 3, 2907);
INSERT INTO `area` VALUES (2910, '610922', '石泉县', 3, 2907);
INSERT INTO `area` VALUES (2911, '610923', '宁陕县', 3, 2907);
INSERT INTO `area` VALUES (2912, '610924', '紫阳县', 3, 2907);
INSERT INTO `area` VALUES (2913, '610925', '岚皋县', 3, 2907);
INSERT INTO `area` VALUES (2914, '610926', '平利县', 3, 2907);
INSERT INTO `area` VALUES (2915, '610927', '镇坪县', 3, 2907);
INSERT INTO `area` VALUES (2916, '610928', '旬阳县', 3, 2907);
INSERT INTO `area` VALUES (2917, '610929', '白河县', 3, 2907);
INSERT INTO `area` VALUES (2918, '611000', '商洛市', 2, 2808);
INSERT INTO `area` VALUES (2919, '611002', '商州区', 3, 2918);
INSERT INTO `area` VALUES (2920, '611021', '洛南县', 3, 2918);
INSERT INTO `area` VALUES (2921, '611022', '丹凤县', 3, 2918);
INSERT INTO `area` VALUES (2922, '611023', '商南县', 3, 2918);
INSERT INTO `area` VALUES (2923, '611024', '山阳县', 3, 2918);
INSERT INTO `area` VALUES (2924, '611025', '镇安县', 3, 2918);
INSERT INTO `area` VALUES (2925, '611026', '柞水县', 3, 2918);
INSERT INTO `area` VALUES (2926, '620000', '甘肃省', 1, -1);
INSERT INTO `area` VALUES (2927, '620100', '兰州市', 2, 2926);
INSERT INTO `area` VALUES (2928, '620102', '城关区', 3, 2927);
INSERT INTO `area` VALUES (2929, '620103', '七里河区', 3, 2927);
INSERT INTO `area` VALUES (2930, '620104', '西固区', 3, 2927);
INSERT INTO `area` VALUES (2931, '620105', '安宁区', 3, 2927);
INSERT INTO `area` VALUES (2932, '620111', '红古区', 3, 2927);
INSERT INTO `area` VALUES (2933, '620121', '永登县', 3, 2927);
INSERT INTO `area` VALUES (2934, '620122', '皋兰县', 3, 2927);
INSERT INTO `area` VALUES (2935, '620123', '榆中县', 3, 2927);
INSERT INTO `area` VALUES (2936, '620200', '嘉峪关市', 2, 2926);
INSERT INTO `area` VALUES (2937, '620300', '金昌市', 2, 2926);
INSERT INTO `area` VALUES (2938, '620302', '金川区', 3, 2937);
INSERT INTO `area` VALUES (2939, '620321', '永昌县', 3, 2937);
INSERT INTO `area` VALUES (2940, '620400', '白银市', 2, 2926);
INSERT INTO `area` VALUES (2941, '620402', '白银区', 3, 2940);
INSERT INTO `area` VALUES (2942, '620403', '平川区', 3, 2940);
INSERT INTO `area` VALUES (2943, '620421', '靖远县', 3, 2940);
INSERT INTO `area` VALUES (2944, '620422', '会宁县', 3, 2940);
INSERT INTO `area` VALUES (2945, '620423', '景泰县', 3, 2940);
INSERT INTO `area` VALUES (2946, '620500', '天水市', 2, 2926);
INSERT INTO `area` VALUES (2947, '620502', '秦州区', 3, 2946);
INSERT INTO `area` VALUES (2948, '620503', '麦积区', 3, 2946);
INSERT INTO `area` VALUES (2949, '620521', '清水县', 3, 2946);
INSERT INTO `area` VALUES (2950, '620522', '秦安县', 3, 2946);
INSERT INTO `area` VALUES (2951, '620523', '甘谷县', 3, 2946);
INSERT INTO `area` VALUES (2952, '620524', '武山县', 3, 2946);
INSERT INTO `area` VALUES (2953, '620525', '张家川回族自治县', 3, 2946);
INSERT INTO `area` VALUES (2954, '620600', '武威市', 2, 2926);
INSERT INTO `area` VALUES (2955, '620602', '凉州区', 3, 2954);
INSERT INTO `area` VALUES (2956, '620621', '民勤县', 3, 2954);
INSERT INTO `area` VALUES (2957, '620622', '古浪县', 3, 2954);
INSERT INTO `area` VALUES (2958, '620623', '天祝藏族自治县', 3, 2954);
INSERT INTO `area` VALUES (2959, '620700', '张掖市', 2, 2926);
INSERT INTO `area` VALUES (2960, '620702', '甘州区', 3, 2959);
INSERT INTO `area` VALUES (2961, '620721', '肃南裕固族自治县', 3, 2959);
INSERT INTO `area` VALUES (2962, '620722', '民乐县', 3, 2959);
INSERT INTO `area` VALUES (2963, '620723', '临泽县', 3, 2959);
INSERT INTO `area` VALUES (2964, '620724', '高台县', 3, 2959);
INSERT INTO `area` VALUES (2965, '620725', '山丹县', 3, 2959);
INSERT INTO `area` VALUES (2966, '620800', '平凉市', 2, 2926);
INSERT INTO `area` VALUES (2967, '620802', '崆峒区', 3, 2966);
INSERT INTO `area` VALUES (2968, '620821', '泾川县', 3, 2966);
INSERT INTO `area` VALUES (2969, '620822', '灵台县', 3, 2966);
INSERT INTO `area` VALUES (2970, '620823', '崇信县', 3, 2966);
INSERT INTO `area` VALUES (2971, '620824', '华亭县', 3, 2966);
INSERT INTO `area` VALUES (2972, '620825', '庄浪县', 3, 2966);
INSERT INTO `area` VALUES (2973, '620826', '静宁县', 3, 2966);
INSERT INTO `area` VALUES (2974, '620900', '酒泉市', 2, 2926);
INSERT INTO `area` VALUES (2975, '620902', '肃州区', 3, 2974);
INSERT INTO `area` VALUES (2976, '620921', '金塔县', 3, 2974);
INSERT INTO `area` VALUES (2977, '620922', '瓜州县', 3, 2974);
INSERT INTO `area` VALUES (2978, '620923', '肃北蒙古族自治县', 3, 2974);
INSERT INTO `area` VALUES (2979, '620924', '阿克塞哈萨克族自治县', 3, 2974);
INSERT INTO `area` VALUES (2980, '620981', '玉门市', 3, 2974);
INSERT INTO `area` VALUES (2981, '620982', '敦煌市', 3, 2974);
INSERT INTO `area` VALUES (2982, '621000', '庆阳市', 2, 2926);
INSERT INTO `area` VALUES (2983, '621002', '西峰区', 3, 2982);
INSERT INTO `area` VALUES (2984, '621021', '庆城县', 3, 2982);
INSERT INTO `area` VALUES (2985, '621022', '环县', 3, 2982);
INSERT INTO `area` VALUES (2986, '621023', '华池县', 3, 2982);
INSERT INTO `area` VALUES (2987, '621024', '合水县', 3, 2982);
INSERT INTO `area` VALUES (2988, '621025', '正宁县', 3, 2982);
INSERT INTO `area` VALUES (2989, '621026', '宁县', 3, 2982);
INSERT INTO `area` VALUES (2990, '621027', '镇原县', 3, 2982);
INSERT INTO `area` VALUES (2991, '621100', '定西市', 2, 2926);
INSERT INTO `area` VALUES (2992, '621102', '安定区', 3, 2991);
INSERT INTO `area` VALUES (2993, '621121', '通渭县', 3, 2991);
INSERT INTO `area` VALUES (2994, '621122', '陇西县', 3, 2991);
INSERT INTO `area` VALUES (2995, '621123', '渭源县', 3, 2991);
INSERT INTO `area` VALUES (2996, '621124', '临洮县', 3, 2991);
INSERT INTO `area` VALUES (2997, '621125', '漳县', 3, 2991);
INSERT INTO `area` VALUES (2998, '621126', '岷县', 3, 2991);
INSERT INTO `area` VALUES (2999, '621200', '陇南市', 2, 2926);
INSERT INTO `area` VALUES (3000, '621202', '武都区', 3, 2999);
INSERT INTO `area` VALUES (3001, '621221', '成县', 3, 2999);
INSERT INTO `area` VALUES (3002, '621222', '文县', 3, 2999);
INSERT INTO `area` VALUES (3003, '621223', '宕昌县', 3, 2999);
INSERT INTO `area` VALUES (3004, '621224', '康县', 3, 2999);
INSERT INTO `area` VALUES (3005, '621225', '西和县', 3, 2999);
INSERT INTO `area` VALUES (3006, '621226', '礼县', 3, 2999);
INSERT INTO `area` VALUES (3007, '621227', '徽县', 3, 2999);
INSERT INTO `area` VALUES (3008, '621228', '两当县', 3, 2999);
INSERT INTO `area` VALUES (3009, '622900', '临夏回族自治州', 2, 2926);
INSERT INTO `area` VALUES (3010, '622901', '临夏市', 3, 3009);
INSERT INTO `area` VALUES (3011, '622921', '临夏县', 3, 3009);
INSERT INTO `area` VALUES (3012, '622922', '康乐县', 3, 3009);
INSERT INTO `area` VALUES (3013, '622923', '永靖县', 3, 3009);
INSERT INTO `area` VALUES (3014, '622924', '广河县', 3, 3009);
INSERT INTO `area` VALUES (3015, '622925', '和政县', 3, 3009);
INSERT INTO `area` VALUES (3016, '622926', '东乡族自治县', 3, 3009);
INSERT INTO `area` VALUES (3017, '622927', '积石山保安族东乡族撒拉族自治县', 3, 3009);
INSERT INTO `area` VALUES (3018, '623000', '甘南藏族自治州', 2, 2926);
INSERT INTO `area` VALUES (3019, '623001', '合作市', 3, 3018);
INSERT INTO `area` VALUES (3020, '623021', '临潭县', 3, 3018);
INSERT INTO `area` VALUES (3021, '623022', '卓尼县', 3, 3018);
INSERT INTO `area` VALUES (3022, '623023', '舟曲县', 3, 3018);
INSERT INTO `area` VALUES (3023, '623024', '迭部县', 3, 3018);
INSERT INTO `area` VALUES (3024, '623025', '玛曲县', 3, 3018);
INSERT INTO `area` VALUES (3025, '623026', '碌曲县', 3, 3018);
INSERT INTO `area` VALUES (3026, '623027', '夏河县', 3, 3018);
INSERT INTO `area` VALUES (3027, '630000', '青海省', 1, -1);
INSERT INTO `area` VALUES (3028, '630100', '西宁市', 2, 3027);
INSERT INTO `area` VALUES (3029, '630102', '城东区', 3, 3028);
INSERT INTO `area` VALUES (3030, '630103', '城中区', 3, 3028);
INSERT INTO `area` VALUES (3031, '630104', '城西区', 3, 3028);
INSERT INTO `area` VALUES (3032, '630105', '城北区', 3, 3028);
INSERT INTO `area` VALUES (3033, '630121', '大通回族土族自治县', 3, 3028);
INSERT INTO `area` VALUES (3034, '630122', '湟中县', 3, 3028);
INSERT INTO `area` VALUES (3035, '630123', '湟源县', 3, 3028);
INSERT INTO `area` VALUES (3036, '630200', '海东市', 2, 3027);
INSERT INTO `area` VALUES (3037, '630202', '乐都区', 3, 3036);
INSERT INTO `area` VALUES (3038, '630203', '平安区', 3, 3036);
INSERT INTO `area` VALUES (3039, '630222', '民和回族土族自治县', 3, 3036);
INSERT INTO `area` VALUES (3040, '630223', '互助土族自治县', 3, 3036);
INSERT INTO `area` VALUES (3041, '630224', '化隆回族自治县', 3, 3036);
INSERT INTO `area` VALUES (3042, '630225', '循化撒拉族自治县', 3, 3036);
INSERT INTO `area` VALUES (3043, '632200', '海北藏族自治州', 2, 3027);
INSERT INTO `area` VALUES (3044, '632221', '门源回族自治县', 3, 3043);
INSERT INTO `area` VALUES (3045, '632222', '祁连县', 3, 3043);
INSERT INTO `area` VALUES (3046, '632223', '海晏县', 3, 3043);
INSERT INTO `area` VALUES (3047, '632224', '刚察县', 3, 3043);
INSERT INTO `area` VALUES (3048, '632300', '黄南藏族自治州', 2, 3027);
INSERT INTO `area` VALUES (3049, '632321', '同仁县', 3, 3048);
INSERT INTO `area` VALUES (3050, '632322', '尖扎县', 3, 3048);
INSERT INTO `area` VALUES (3051, '632323', '泽库县', 3, 3048);
INSERT INTO `area` VALUES (3052, '632324', '河南蒙古族自治县', 3, 3048);
INSERT INTO `area` VALUES (3053, '632500', '海南藏族自治州', 2, 3027);
INSERT INTO `area` VALUES (3054, '632521', '共和县', 3, 3053);
INSERT INTO `area` VALUES (3055, '632522', '同德县', 3, 3053);
INSERT INTO `area` VALUES (3056, '632523', '贵德县', 3, 3053);
INSERT INTO `area` VALUES (3057, '632524', '兴海县', 3, 3053);
INSERT INTO `area` VALUES (3058, '632525', '贵南县', 3, 3053);
INSERT INTO `area` VALUES (3059, '632600', '果洛藏族自治州', 2, 3027);
INSERT INTO `area` VALUES (3060, '632621', '玛沁县', 3, 3059);
INSERT INTO `area` VALUES (3061, '632622', '班玛县', 3, 3059);
INSERT INTO `area` VALUES (3062, '632623', '甘德县', 3, 3059);
INSERT INTO `area` VALUES (3063, '632624', '达日县', 3, 3059);
INSERT INTO `area` VALUES (3064, '632625', '久治县', 3, 3059);
INSERT INTO `area` VALUES (3065, '632626', '玛多县', 3, 3059);
INSERT INTO `area` VALUES (3066, '632700', '玉树藏族自治州', 2, 3027);
INSERT INTO `area` VALUES (3067, '632701', '玉树市', 3, 3066);
INSERT INTO `area` VALUES (3068, '632722', '杂多县', 3, 3066);
INSERT INTO `area` VALUES (3069, '632723', '称多县', 3, 3066);
INSERT INTO `area` VALUES (3070, '632724', '治多县', 3, 3066);
INSERT INTO `area` VALUES (3071, '632725', '囊谦县', 3, 3066);
INSERT INTO `area` VALUES (3072, '632726', '曲麻莱县', 3, 3066);
INSERT INTO `area` VALUES (3073, '632800', '海西蒙古族藏族自治州', 2, 3027);
INSERT INTO `area` VALUES (3074, '632801', '格尔木市', 3, 3073);
INSERT INTO `area` VALUES (3075, '632802', '德令哈市', 3, 3073);
INSERT INTO `area` VALUES (3076, '632821', '乌兰县', 3, 3073);
INSERT INTO `area` VALUES (3077, '632822', '都兰县', 3, 3073);
INSERT INTO `area` VALUES (3078, '632823', '天峻县', 3, 3073);
INSERT INTO `area` VALUES (3079, '632825', '海西蒙古族藏族自治州直辖', 3, 3073);
INSERT INTO `area` VALUES (3080, '640000', '宁夏回族自治区', 1, -1);
INSERT INTO `area` VALUES (3081, '640100', '银川市', 2, 3080);
INSERT INTO `area` VALUES (3082, '640104', '兴庆区', 3, 3081);
INSERT INTO `area` VALUES (3083, '640105', '西夏区', 3, 3081);
INSERT INTO `area` VALUES (3084, '640106', '金凤区', 3, 3081);
INSERT INTO `area` VALUES (3085, '640121', '永宁县', 3, 3081);
INSERT INTO `area` VALUES (3086, '640122', '贺兰县', 3, 3081);
INSERT INTO `area` VALUES (3087, '640181', '灵武市', 3, 3081);
INSERT INTO `area` VALUES (3088, '640200', '石嘴山市', 2, 3080);
INSERT INTO `area` VALUES (3089, '640202', '大武口区', 3, 3088);
INSERT INTO `area` VALUES (3090, '640205', '惠农区', 3, 3088);
INSERT INTO `area` VALUES (3091, '640221', '平罗县', 3, 3088);
INSERT INTO `area` VALUES (3092, '640300', '吴忠市', 2, 3080);
INSERT INTO `area` VALUES (3093, '640302', '利通区', 3, 3092);
INSERT INTO `area` VALUES (3094, '640303', '红寺堡区', 3, 3092);
INSERT INTO `area` VALUES (3095, '640323', '盐池县', 3, 3092);
INSERT INTO `area` VALUES (3096, '640324', '同心县', 3, 3092);
INSERT INTO `area` VALUES (3097, '640381', '青铜峡市', 3, 3092);
INSERT INTO `area` VALUES (3098, '640400', '固原市', 2, 3080);
INSERT INTO `area` VALUES (3099, '640402', '原州区', 3, 3098);
INSERT INTO `area` VALUES (3100, '640422', '西吉县', 3, 3098);
INSERT INTO `area` VALUES (3101, '640423', '隆德县', 3, 3098);
INSERT INTO `area` VALUES (3102, '640424', '泾源县', 3, 3098);
INSERT INTO `area` VALUES (3103, '640425', '彭阳县', 3, 3098);
INSERT INTO `area` VALUES (3104, '640500', '中卫市', 2, 3080);
INSERT INTO `area` VALUES (3105, '640502', '沙坡头区', 3, 3104);
INSERT INTO `area` VALUES (3106, '640521', '中宁县', 3, 3104);
INSERT INTO `area` VALUES (3107, '640522', '海原县', 3, 3104);
INSERT INTO `area` VALUES (3108, '650000', '新疆维吾尔自治区', 1, -1);
INSERT INTO `area` VALUES (3109, '659002', '阿拉尔市', 2, 3108);
INSERT INTO `area` VALUES (3110, '659005', '北屯市', 2, 3108);
INSERT INTO `area` VALUES (3111, '659008', '可克达拉市', 2, 3108);
INSERT INTO `area` VALUES (3112, '659009', '昆玉市', 2, 3108);
INSERT INTO `area` VALUES (3113, '659001', '石河子市', 2, 3108);
INSERT INTO `area` VALUES (3114, '659007', '双河市', 2, 3108);
INSERT INTO `area` VALUES (3115, '650100', '乌鲁木齐市', 2, 3108);
INSERT INTO `area` VALUES (3116, '650102', '天山区', 3, 3115);
INSERT INTO `area` VALUES (3117, '650103', '沙依巴克区', 3, 3115);
INSERT INTO `area` VALUES (3118, '650104', '新市区', 3, 3115);
INSERT INTO `area` VALUES (3119, '650105', '水磨沟区', 3, 3115);
INSERT INTO `area` VALUES (3120, '650106', '头屯河区', 3, 3115);
INSERT INTO `area` VALUES (3121, '650107', '达坂城区', 3, 3115);
INSERT INTO `area` VALUES (3122, '650109', '米东区', 3, 3115);
INSERT INTO `area` VALUES (3123, '650121', '乌鲁木齐县', 3, 3115);
INSERT INTO `area` VALUES (3124, '650200', '克拉玛依市', 2, 3108);
INSERT INTO `area` VALUES (3125, '650202', '独山子区', 3, 3124);
INSERT INTO `area` VALUES (3126, '650203', '克拉玛依区', 3, 3124);
INSERT INTO `area` VALUES (3127, '650204', '白碱滩区', 3, 3124);
INSERT INTO `area` VALUES (3128, '650205', '乌尔禾区', 3, 3124);
INSERT INTO `area` VALUES (3129, '650400', '吐鲁番市', 2, 3108);
INSERT INTO `area` VALUES (3130, '650402', '高昌区', 3, 3129);
INSERT INTO `area` VALUES (3131, '650421', '鄯善县', 3, 3129);
INSERT INTO `area` VALUES (3132, '650422', '托克逊县', 3, 3129);
INSERT INTO `area` VALUES (3133, '650500', '哈密市', 2, 3108);
INSERT INTO `area` VALUES (3134, '650502', '伊州区', 3, 3133);
INSERT INTO `area` VALUES (3135, '650521', '巴里坤哈萨克自治县', 3, 3133);
INSERT INTO `area` VALUES (3136, '650522', '伊吾县', 3, 3133);
INSERT INTO `area` VALUES (3137, '652300', '昌吉回族自治州', 2, 3108);
INSERT INTO `area` VALUES (3138, '652301', '昌吉市', 3, 3137);
INSERT INTO `area` VALUES (3139, '652302', '阜康市', 3, 3137);
INSERT INTO `area` VALUES (3140, '652323', '呼图壁县', 3, 3137);
INSERT INTO `area` VALUES (3141, '652324', '玛纳斯县', 3, 3137);
INSERT INTO `area` VALUES (3142, '652325', '奇台县', 3, 3137);
INSERT INTO `area` VALUES (3143, '652327', '吉木萨尔县', 3, 3137);
INSERT INTO `area` VALUES (3144, '652328', '木垒哈萨克自治县', 3, 3137);
INSERT INTO `area` VALUES (3145, '652700', '博尔塔拉蒙古自治州', 2, 3108);
INSERT INTO `area` VALUES (3146, '652701', '博乐市', 3, 3145);
INSERT INTO `area` VALUES (3147, '652702', '阿拉山口市', 3, 3145);
INSERT INTO `area` VALUES (3148, '652722', '精河县', 3, 3145);
INSERT INTO `area` VALUES (3149, '652723', '温泉县', 3, 3145);
INSERT INTO `area` VALUES (3150, '652800', '巴音郭楞蒙古自治州', 2, 3108);
INSERT INTO `area` VALUES (3151, '652801', '库尔勒市', 3, 3150);
INSERT INTO `area` VALUES (3152, '652822', '轮台县', 3, 3150);
INSERT INTO `area` VALUES (3153, '652823', '尉犁县', 3, 3150);
INSERT INTO `area` VALUES (3154, '652824', '若羌县', 3, 3150);
INSERT INTO `area` VALUES (3155, '652825', '且末县', 3, 3150);
INSERT INTO `area` VALUES (3156, '652826', '焉耆回族自治县', 3, 3150);
INSERT INTO `area` VALUES (3157, '652827', '和静县', 3, 3150);
INSERT INTO `area` VALUES (3158, '652828', '和硕县', 3, 3150);
INSERT INTO `area` VALUES (3159, '652829', '博湖县', 3, 3150);
INSERT INTO `area` VALUES (3160, '652900', '阿克苏地区', 2, 3108);
INSERT INTO `area` VALUES (3161, '652901', '阿克苏市', 3, 3160);
INSERT INTO `area` VALUES (3162, '652922', '温宿县', 3, 3160);
INSERT INTO `area` VALUES (3163, '652923', '库车县', 3, 3160);
INSERT INTO `area` VALUES (3164, '652924', '沙雅县', 3, 3160);
INSERT INTO `area` VALUES (3165, '652925', '新和县', 3, 3160);
INSERT INTO `area` VALUES (3166, '652926', '拜城县', 3, 3160);
INSERT INTO `area` VALUES (3167, '652927', '乌什县', 3, 3160);
INSERT INTO `area` VALUES (3168, '652928', '阿瓦提县', 3, 3160);
INSERT INTO `area` VALUES (3169, '652929', '柯坪县', 3, 3160);
INSERT INTO `area` VALUES (3170, '653000', '克孜勒苏柯尔克孜自治州', 2, 3108);
INSERT INTO `area` VALUES (3171, '653001', '阿图什市', 3, 3170);
INSERT INTO `area` VALUES (3172, '653022', '阿克陶县', 3, 3170);
INSERT INTO `area` VALUES (3173, '653023', '阿合奇县', 3, 3170);
INSERT INTO `area` VALUES (3174, '653024', '乌恰县', 3, 3170);
INSERT INTO `area` VALUES (3175, '653100', '喀什地区', 2, 3108);
INSERT INTO `area` VALUES (3176, '653101', '喀什市', 3, 3175);
INSERT INTO `area` VALUES (3177, '653121', '疏附县', 3, 3175);
INSERT INTO `area` VALUES (3178, '653122', '疏勒县', 3, 3175);
INSERT INTO `area` VALUES (3179, '653123', '英吉沙县', 3, 3175);
INSERT INTO `area` VALUES (3180, '653124', '泽普县', 3, 3175);
INSERT INTO `area` VALUES (3181, '653125', '莎车县', 3, 3175);
INSERT INTO `area` VALUES (3182, '653126', '叶城县', 3, 3175);
INSERT INTO `area` VALUES (3183, '653127', '麦盖提县', 3, 3175);
INSERT INTO `area` VALUES (3184, '653128', '岳普湖县', 3, 3175);
INSERT INTO `area` VALUES (3185, '653129', '伽师县', 3, 3175);
INSERT INTO `area` VALUES (3186, '653130', '巴楚县', 3, 3175);
INSERT INTO `area` VALUES (3187, '653131', '塔什库尔干塔吉克自治县', 3, 3175);
INSERT INTO `area` VALUES (3188, '653200', '和田地区', 2, 3108);
INSERT INTO `area` VALUES (3189, '653201', '和田市', 3, 3188);
INSERT INTO `area` VALUES (3190, '653221', '和田县', 3, 3188);
INSERT INTO `area` VALUES (3191, '653222', '墨玉县', 3, 3188);
INSERT INTO `area` VALUES (3192, '653223', '皮山县', 3, 3188);
INSERT INTO `area` VALUES (3193, '653224', '洛浦县', 3, 3188);
INSERT INTO `area` VALUES (3194, '653225', '策勒县', 3, 3188);
INSERT INTO `area` VALUES (3195, '653226', '于田县', 3, 3188);
INSERT INTO `area` VALUES (3196, '653227', '民丰县', 3, 3188);
INSERT INTO `area` VALUES (3197, '654000', '伊犁哈萨克自治州', 2, 3108);
INSERT INTO `area` VALUES (3198, '654002', '伊宁市', 3, 3197);
INSERT INTO `area` VALUES (3199, '654003', '奎屯市', 3, 3197);
INSERT INTO `area` VALUES (3200, '654004', '霍尔果斯市', 3, 3197);
INSERT INTO `area` VALUES (3201, '654021', '伊宁县', 3, 3197);
INSERT INTO `area` VALUES (3202, '654022', '察布查尔锡伯自治县', 3, 3197);
INSERT INTO `area` VALUES (3203, '654023', '霍城县', 3, 3197);
INSERT INTO `area` VALUES (3204, '654024', '巩留县', 3, 3197);
INSERT INTO `area` VALUES (3205, '654025', '新源县', 3, 3197);
INSERT INTO `area` VALUES (3206, '654026', '昭苏县', 3, 3197);
INSERT INTO `area` VALUES (3207, '654027', '特克斯县', 3, 3197);
INSERT INTO `area` VALUES (3208, '654028', '尼勒克县', 3, 3197);
INSERT INTO `area` VALUES (3209, '654200', '塔城地区', 2, 3108);
INSERT INTO `area` VALUES (3210, '654201', '塔城市', 3, 3209);
INSERT INTO `area` VALUES (3211, '654202', '乌苏市', 3, 3209);
INSERT INTO `area` VALUES (3212, '654221', '额敏县', 3, 3209);
INSERT INTO `area` VALUES (3213, '654223', '沙湾县', 3, 3209);
INSERT INTO `area` VALUES (3214, '654224', '托里县', 3, 3209);
INSERT INTO `area` VALUES (3215, '654225', '裕民县', 3, 3209);
INSERT INTO `area` VALUES (3216, '654226', '和布克赛尔蒙古自治县', 3, 3209);
INSERT INTO `area` VALUES (3217, '654300', '阿勒泰地区', 2, 3108);
INSERT INTO `area` VALUES (3218, '654301', '阿勒泰市', 3, 3217);
INSERT INTO `area` VALUES (3219, '654321', '布尔津县', 3, 3217);
INSERT INTO `area` VALUES (3220, '654322', '富蕴县', 3, 3217);
INSERT INTO `area` VALUES (3221, '654323', '福海县', 3, 3217);
INSERT INTO `area` VALUES (3222, '654324', '哈巴河县', 3, 3217);
INSERT INTO `area` VALUES (3223, '654325', '青河县', 3, 3217);
INSERT INTO `area` VALUES (3224, '654326', '吉木乃县', 3, 3217);
INSERT INTO `area` VALUES (3225, '659006', '铁门关市', 2, 3108);
INSERT INTO `area` VALUES (3226, '659003', '图木舒克市', 2, 3108);
INSERT INTO `area` VALUES (3227, '659004', '五家渠市', 2, 3108);
INSERT INTO `area` VALUES (3228, '710000', '台湾省', 1, -1);
INSERT INTO `area` VALUES (3229, '810000', '香港特别行政区', 1, -1);
INSERT INTO `area` VALUES (3230, '810001', '中西区', 3, 3229);
INSERT INTO `area` VALUES (3231, '810002', '湾仔区', 3, 3229);
INSERT INTO `area` VALUES (3232, '810003', '东区', 3, 3229);
INSERT INTO `area` VALUES (3233, '810004', '南区', 3, 3229);
INSERT INTO `area` VALUES (3234, '810005', '油尖旺区', 3, 3229);
INSERT INTO `area` VALUES (3235, '810006', '深水埗区', 3, 3229);
INSERT INTO `area` VALUES (3236, '810007', '九龙城区', 3, 3229);
INSERT INTO `area` VALUES (3237, '810008', '黄大仙区', 3, 3229);
INSERT INTO `area` VALUES (3238, '810009', '观塘区', 3, 3229);
INSERT INTO `area` VALUES (3239, '810010', '荃湾区', 3, 3229);
INSERT INTO `area` VALUES (3240, '810011', '屯门区', 3, 3229);
INSERT INTO `area` VALUES (3241, '810012', '元朗区', 3, 3229);
INSERT INTO `area` VALUES (3243, '810013', '北区', 3, 3229);
INSERT INTO `area` VALUES (3245, '810014', '大埔区', 3, 3229);
INSERT INTO `area` VALUES (3246, '810015', '西贡区', 3, 3229);
INSERT INTO `area` VALUES (3247, '810016', '沙田区', 3, 3229);
INSERT INTO `area` VALUES (3248, '810017', '葵青区', 3, 3229);
INSERT INTO `area` VALUES (3249, '810018', '离岛区', 3, 3229);
INSERT INTO `area` VALUES (3251, '820000', '澳门特别行政区', 1, -1);
INSERT INTO `area` VALUES (3252, '820001', '花地玛堂区', 3, 3251);
INSERT INTO `area` VALUES (3253, '820002', '花王堂区', 3, 3251);
INSERT INTO `area` VALUES (3254, '820003', '望德堂区', 3, 3251);
INSERT INTO `area` VALUES (3255, '820004', '大堂区', 3, 3251);
INSERT INTO `area` VALUES (3256, '820005', '风顺堂区', 3, 3251);
INSERT INTO `area` VALUES (3257, '820006', '嘉模堂区', 3, 3251);
INSERT INTO `area` VALUES (3258, '820007', '路凼填海区', 3, 3251);
INSERT INTO `area` VALUES (3259, '820008', '圣方济各堂区', 3, 3251);

-- ----------------------------
-- Table structure for zj_banner
-- ----------------------------
DROP TABLE IF EXISTS `zj_banner`;
CREATE TABLE `zj_banner`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '轮播图id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '轮播图名称',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '轮播图图片',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '轮播图跳转地址',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态(0:禁用;1:启用)',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除(0:未删除;1:已删除)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '轮播图表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of zj_banner
-- ----------------------------
INSERT INTO `zj_banner` VALUES (1, '1', 'http://127.0.0.1:8001/upload/20190614/4dbfabce14347111d9055c81b1293da3.png', '', 0, 1, '2019-06-14 01:38:44', '2019-06-14 01:38:44', 0);
INSERT INTO `zj_banner` VALUES (2, '2', 'http://127.0.0.1:8001/upload/20190614/38823471cea55aad277f4c70f2745304.png', '', 0, 1, '2019-06-14 01:38:51', '2019-06-14 01:38:51', 0);
INSERT INTO `zj_banner` VALUES (3, '3', 'http://127.0.0.1:8001/upload/20190614/1eecadd4d8870492b12dfaecd18458f7.png', '', 0, 1, '2019-06-14 01:38:58', '2019-06-14 01:38:58', 0);
INSERT INTO `zj_banner` VALUES (4, '4', 'http://127.0.0.1:8001/upload/20190614/38e372e4e9e1e8f81c29ea6e2a4b45a9.png', '', 0, 1, '2019-06-14 01:39:04', '2019-06-14 01:39:04', 0);

-- ----------------------------
-- Table structure for zj_commission
-- ----------------------------
DROP TABLE IF EXISTS `zj_commission`;
CREATE TABLE `zj_commission`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '佣金id',
  `type` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '佣金类型(1:一级佣金;2:二级佣金)',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户id',
  `money` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '金额',
  `from_user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '佣金来源用户id',
  `task_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '任务id',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除(0:未删除;1:已删除)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '佣金表' ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of zj_commission
-- ----------------------------
INSERT INTO `zj_commission` VALUES (1, 1, 3, 1900, 2, 1, '2019-06-14 04:11:24', '2019-06-14 04:16:16', 0);
INSERT INTO `zj_commission` VALUES (2, 2, 3, 1200, 5, 1, '2019-06-14 14:01:05', '2019-06-14 14:02:04', 0);

-- ----------------------------
-- Table structure for zj_commission_conf
-- ----------------------------
DROP TABLE IF EXISTS `zj_commission_conf`;
CREATE TABLE `zj_commission_conf`  (
  `id` int(11) NOT NULL COMMENT '佣金配置id',
  `level` int(11) NOT NULL COMMENT '佣金等级',
  `value` int(11) NOT NULL COMMENT '佣金比例',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '佣金配置表' ROW_FORMAT = Fixed;

-- ----------------------------
-- Table structure for zj_link
-- ----------------------------
DROP TABLE IF EXISTS `zj_link`;
CREATE TABLE `zj_link`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '链接id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '链接名称',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '链接图片',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '链接跳转地址',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态(0:禁用;1:启用)',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除(0:未删除;1:已删除)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '链接表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of zj_link
-- ----------------------------
INSERT INTO `zj_link` VALUES (1, '1', 'http://127.0.0.1:8001/upload/20190614/f44f0c9df54d5b29332f6853f2808cbb.png', 'www.baidu.com', 0, 1, '2019-06-14 01:40:02', '2019-06-14 01:40:02', 0);
INSERT INTO `zj_link` VALUES (2, '2', 'http://127.0.0.1:8001/upload/20190614/02631b977ee8d63a51e54978e900ae29.png', 'www.baidu.com', 0, 1, '2019-06-14 01:40:07', '2019-06-14 01:40:07', 0);
INSERT INTO `zj_link` VALUES (3, '3', 'http://127.0.0.1:8001/upload/20190614/02d2cc0211de69ca2e05556254609952.png', 'www.baidu.com', 0, 1, '2019-06-14 01:40:12', '2019-06-14 01:40:12', 0);
INSERT INTO `zj_link` VALUES (4, '4', 'http://127.0.0.1:8001/upload/20190614/78ef72a72755e0d5591e5f39d2af7c72.png', 'www.baidu.com', 0, 1, '2019-06-14 01:40:18', '2019-06-14 01:40:18', 0);

-- ----------------------------
-- Table structure for zj_task
-- ----------------------------
DROP TABLE IF EXISTS `zj_task`;
CREATE TABLE `zj_task`  (
  `task_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '任务id',
  `task_type_id` int(11) UNSIGNED NOT NULL COMMENT '任务类型id',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务标题',
  `money` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '任务金额',
  `number` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '任务数量',
  `have_number` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '已领数量',
  `end_date` date NOT NULL COMMENT '截止日期',
  `check_duration` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '验收时长(小时)',
  `finish_duration` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '完成时长',
  `is_repeat` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否重复(0:不重复;1重复:)',
  `province` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '省(0:全国)',
  `city` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '市(0:全国)',
  `link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '任务链接',
  `step` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '任务步骤',
  `show_img` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '图片展示',
  `take_care` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '注意事项',
  `device` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '设备类型(0:不限;1:安卓;2IOS:)',
  `submit_way` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '提交方式(1:文本;2:文本截图)',
  `submit_notice` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '提交说明',
  `submit_img` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '提交图片',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态(0:禁用;1:启用)',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除(0:未删除;1:已删除)',
  PRIMARY KEY (`task_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of zj_task
-- ----------------------------
INSERT INTO `zj_task` VALUES (1, 1, '【百度口碑】好评即可不下载', 100, 10, 0, '2019-06-30', 72, 2, 1, 110000, 110100, 'www.baidu.com', '（评语请加微信号377047364，备注：百度口碑+你的手机品牌，客服通过你的好友验证发评语给你）%,%一定要加客服等客服给你评语在做任务，不是客服给的评语不合格%,%（复制注意事项中的链接到浏览器进入，点击登陆账号，给五星好评+评语+上传图片即可%,%（需要有百度账号，如已有账号，直接登录评价，如果没有自行注册一个号%,%一人只能评论一次，设置不限次数是因为怕有的超时没办法提交', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', '1、一个手机只能注册一次，注册过的用户不能再注册，新用户收到借条额度通过通知和成功借款的用户才有奖励；\n2、可以随意借一笔款，几天后还款，利息按日计算，红包可以抵扣利息；', 1, 1, '1、必须扫图中二维码；\n2、成功之后必须有当天赠送的卡券；', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', 1, '2019-06-14 01:51:25', '2019-06-14 17:28:18', 0);
INSERT INTO `zj_task` VALUES (2, 1, '【百度口碑】好评即可不下载', 100, 10, 0, '2019-06-30', 72, 30, 1, 110000, 110100, 'www.baidu.com', '（评语请加微信号377047364，备注：百度口碑+你的手机品牌，客服通过你的好友验证发评语给你）%,%一定要加客服等客服给你评语在做任务，不是客服给的评语不合格%,%（复制注意事项中的链接到浏览器进入，点击登陆账号，给五星好评+评语+上传图片即可%,%（需要有百度账号，如已有账号，直接登录评价，如果没有自行注册一个号%,%一人只能评论一次，设置不限次数是因为怕有的超时没办法提交', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', '1、一个手机只能注册一次，注册过的用户不能再注册，新用户收到借条额度通过通知和成功借款的用户才有奖励；\n2、可以随意借一笔款，几天后还款，利息按日计算，红包可以抵扣利息；', 1, 1, '1、必须扫图中二维码；\n2、成功之后必须有当天赠送的卡券；', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', 1, '2019-06-14 01:51:25', '2019-06-14 17:28:23', 0);
INSERT INTO `zj_task` VALUES (3, 1, '【百度口碑】好评即可不下载', 100, 10, 0, '2019-06-30', 72, 2, 1, 110000, 110100, 'www.baidu.com', '（评语请加微信号377047364，备注：百度口碑+你的手机品牌，客服通过你的好友验证发评语给你）%,%一定要加客服等客服给你评语在做任务，不是客服给的评语不合格%,%（复制注意事项中的链接到浏览器进入，点击登陆账号，给五星好评+评语+上传图片即可%,%（需要有百度账号，如已有账号，直接登录评价，如果没有自行注册一个号%,%一人只能评论一次，设置不限次数是因为怕有的超时没办法提交', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', '1、一个手机只能注册一次，注册过的用户不能再注册，新用户收到借条额度通过通知和成功借款的用户才有奖励；\n2、可以随意借一笔款，几天后还款，利息按日计算，红包可以抵扣利息；', 1, 1, '1、必须扫图中二维码；\n2、成功之后必须有当天赠送的卡券；', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', 1, '2019-06-14 01:51:25', '2019-06-14 17:28:23', 0);
INSERT INTO `zj_task` VALUES (4, 1, '【百度口碑】好评即可不下载', 100, 10, 0, '2019-06-30', 72, 2, 1, 110000, 110100, 'www.baidu.com', '（评语请加微信号377047364，备注：百度口碑+你的手机品牌，客服通过你的好友验证发评语给你）%,%一定要加客服等客服给你评语在做任务，不是客服给的评语不合格%,%（复制注意事项中的链接到浏览器进入，点击登陆账号，给五星好评+评语+上传图片即可%,%（需要有百度账号，如已有账号，直接登录评价，如果没有自行注册一个号%,%一人只能评论一次，设置不限次数是因为怕有的超时没办法提交', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', '1、一个手机只能注册一次，注册过的用户不能再注册，新用户收到借条额度通过通知和成功借款的用户才有奖励；\n2、可以随意借一笔款，几天后还款，利息按日计算，红包可以抵扣利息；', 1, 1, '1、必须扫图中二维码；\n2、成功之后必须有当天赠送的卡券；', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', 1, '2019-06-14 01:51:25', '2019-06-14 17:28:23', 0);
INSERT INTO `zj_task` VALUES (5, 1, '【百度口碑】好评即可不下载', 100, 10, 0, '2019-06-30', 72, 2, 1, 110000, 110100, 'www.baidu.com', '（评语请加微信号377047364，备注：百度口碑+你的手机品牌，客服通过你的好友验证发评语给你）%,%一定要加客服等客服给你评语在做任务，不是客服给的评语不合格%,%（复制注意事项中的链接到浏览器进入，点击登陆账号，给五星好评+评语+上传图片即可%,%（需要有百度账号，如已有账号，直接登录评价，如果没有自行注册一个号%,%一人只能评论一次，设置不限次数是因为怕有的超时没办法提交', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', '1、一个手机只能注册一次，注册过的用户不能再注册，新用户收到借条额度通过通知和成功借款的用户才有奖励；\n2、可以随意借一笔款，几天后还款，利息按日计算，红包可以抵扣利息；', 1, 1, '1、必须扫图中二维码；\n2、成功之后必须有当天赠送的卡券；', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', 1, '2019-06-14 01:51:25', '2019-06-14 17:28:23', 0);
INSERT INTO `zj_task` VALUES (6, 1, '【百度口碑】好评即可不下载', 100, 10, 0, '2019-06-30', 72, 2, 1, 110000, 110100, 'www.baidu.com', '（评语请加微信号377047364，备注：百度口碑+你的手机品牌，客服通过你的好友验证发评语给你）%,%一定要加客服等客服给你评语在做任务，不是客服给的评语不合格%,%（复制注意事项中的链接到浏览器进入，点击登陆账号，给五星好评+评语+上传图片即可%,%（需要有百度账号，如已有账号，直接登录评价，如果没有自行注册一个号%,%一人只能评论一次，设置不限次数是因为怕有的超时没办法提交', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', '1、一个手机只能注册一次，注册过的用户不能再注册，新用户收到借条额度通过通知和成功借款的用户才有奖励；\n2、可以随意借一笔款，几天后还款，利息按日计算，红包可以抵扣利息；', 1, 1, '1、必须扫图中二维码；\n2、成功之后必须有当天赠送的卡券；', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', 1, '2019-06-14 01:51:25', '2019-06-14 17:28:23', 0);
INSERT INTO `zj_task` VALUES (7, 1, '【百度口碑】好评即可不下载', 100, 10, 0, '2019-06-30', 72, 2, 1, 110000, 110100, 'www.baidu.com', '（评语请加微信号377047364，备注：百度口碑+你的手机品牌，客服通过你的好友验证发评语给你）%,%一定要加客服等客服给你评语在做任务，不是客服给的评语不合格%,%（复制注意事项中的链接到浏览器进入，点击登陆账号，给五星好评+评语+上传图片即可%,%（需要有百度账号，如已有账号，直接登录评价，如果没有自行注册一个号%,%一人只能评论一次，设置不限次数是因为怕有的超时没办法提交', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', '1、一个手机只能注册一次，注册过的用户不能再注册，新用户收到借条额度通过通知和成功借款的用户才有奖励；\n2、可以随意借一笔款，几天后还款，利息按日计算，红包可以抵扣利息；', 1, 1, '1、必须扫图中二维码；\n2、成功之后必须有当天赠送的卡券；', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', 1, '2019-06-14 01:51:25', '2019-06-14 17:28:23', 0);
INSERT INTO `zj_task` VALUES (8, 1, '【百度口碑】好评即可不下载', 100, 10, 0, '2019-06-30', 72, 2, 1, 110000, 110100, 'www.baidu.com', '（评语请加微信号377047364，备注：百度口碑+你的手机品牌，客服通过你的好友验证发评语给你）%,%一定要加客服等客服给你评语在做任务，不是客服给的评语不合格%,%（复制注意事项中的链接到浏览器进入，点击登陆账号，给五星好评+评语+上传图片即可%,%（需要有百度账号，如已有账号，直接登录评价，如果没有自行注册一个号%,%一人只能评论一次，设置不限次数是因为怕有的超时没办法提交', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', '1、一个手机只能注册一次，注册过的用户不能再注册，新用户收到借条额度通过通知和成功借款的用户才有奖励；\n2、可以随意借一笔款，几天后还款，利息按日计算，红包可以抵扣利息；', 1, 1, '1、必须扫图中二维码；\n2、成功之后必须有当天赠送的卡券；', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', 1, '2019-06-14 01:51:25', '2019-06-14 17:28:23', 0);
INSERT INTO `zj_task` VALUES (9, 1, '【百度口碑】好评即可不下载', 100, 10, 0, '2019-06-30', 72, 2, 1, 110000, 110100, 'www.baidu.com', '（评语请加微信号377047364，备注：百度口碑+你的手机品牌，客服通过你的好友验证发评语给你）%,%一定要加客服等客服给你评语在做任务，不是客服给的评语不合格%,%（复制注意事项中的链接到浏览器进入，点击登陆账号，给五星好评+评语+上传图片即可%,%（需要有百度账号，如已有账号，直接登录评价，如果没有自行注册一个号%,%一人只能评论一次，设置不限次数是因为怕有的超时没办法提交', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', '1、一个手机只能注册一次，注册过的用户不能再注册，新用户收到借条额度通过通知和成功借款的用户才有奖励；\n2、可以随意借一笔款，几天后还款，利息按日计算，红包可以抵扣利息；', 1, 1, '1、必须扫图中二维码；\n2、成功之后必须有当天赠送的卡券；', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', 1, '2019-06-14 01:51:25', '2019-06-14 17:28:23', 0);
INSERT INTO `zj_task` VALUES (10, 1, '【百度口碑】好评即可不下载', 100, 10, 0, '2019-06-30', 72, 2, 1, 110000, 110100, 'www.baidu.com', '（评语请加微信号377047364，备注：百度口碑+你的手机品牌，客服通过你的好友验证发评语给你）%,%一定要加客服等客服给你评语在做任务，不是客服给的评语不合格%,%（复制注意事项中的链接到浏览器进入，点击登陆账号，给五星好评+评语+上传图片即可%,%（需要有百度账号，如已有账号，直接登录评价，如果没有自行注册一个号%,%一人只能评论一次，设置不限次数是因为怕有的超时没办法提交', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', '1、一个手机只能注册一次，注册过的用户不能再注册，新用户收到借条额度通过通知和成功借款的用户才有奖励；\n2、可以随意借一笔款，几天后还款，利息按日计算，红包可以抵扣利息；', 1, 1, '1、必须扫图中二维码；\n2、成功之后必须有当天赠送的卡券；', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', 1, '2019-06-14 01:51:25', '2019-06-14 17:28:23', 0);
INSERT INTO `zj_task` VALUES (11, 1, '【百度口碑】好评即可不下载', 100, 10, 0, '2019-06-30', 72, 2, 1, 110000, 110100, 'www.baidu.com', '（评语请加微信号377047364，备注：百度口碑+你的手机品牌，客服通过你的好友验证发评语给你）%,%一定要加客服等客服给你评语在做任务，不是客服给的评语不合格%,%（复制注意事项中的链接到浏览器进入，点击登陆账号，给五星好评+评语+上传图片即可%,%（需要有百度账号，如已有账号，直接登录评价，如果没有自行注册一个号%,%一人只能评论一次，设置不限次数是因为怕有的超时没办法提交', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', '1、一个手机只能注册一次，注册过的用户不能再注册，新用户收到借条额度通过通知和成功借款的用户才有奖励；\n2、可以随意借一笔款，几天后还款，利息按日计算，红包可以抵扣利息；', 1, 1, '1、必须扫图中二维码；\n2、成功之后必须有当天赠送的卡券；', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', 1, '2019-06-14 01:51:25', '2019-06-14 17:28:23', 0);
INSERT INTO `zj_task` VALUES (12, 1, '【百度口碑】好评即可不下载', 100, 10, 0, '2019-06-30', 72, 2, 1, 110000, 110100, 'www.baidu.com', '（评语请加微信号377047364，备注：百度口碑+你的手机品牌，客服通过你的好友验证发评语给你）%,%一定要加客服等客服给你评语在做任务，不是客服给的评语不合格%,%（复制注意事项中的链接到浏览器进入，点击登陆账号，给五星好评+评语+上传图片即可%,%（需要有百度账号，如已有账号，直接登录评价，如果没有自行注册一个号%,%一人只能评论一次，设置不限次数是因为怕有的超时没办法提交', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', '1、一个手机只能注册一次，注册过的用户不能再注册，新用户收到借条额度通过通知和成功借款的用户才有奖励；\n2、可以随意借一笔款，几天后还款，利息按日计算，红包可以抵扣利息；', 1, 1, '1、必须扫图中二维码；\n2、成功之后必须有当天赠送的卡券；', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', 1, '2019-06-14 01:51:25', '2019-06-14 17:28:23', 0);
INSERT INTO `zj_task` VALUES (13, 1, '【百度口碑】好评即可不下载', 100, 10, 0, '2019-06-30', 72, 2, 1, 110000, 110100, 'www.baidu.com', '（评语请加微信号377047364，备注：百度口碑+你的手机品牌，客服通过你的好友验证发评语给你）%,%一定要加客服等客服给你评语在做任务，不是客服给的评语不合格%,%（复制注意事项中的链接到浏览器进入，点击登陆账号，给五星好评+评语+上传图片即可%,%（需要有百度账号，如已有账号，直接登录评价，如果没有自行注册一个号%,%一人只能评论一次，设置不限次数是因为怕有的超时没办法提交', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', '1、一个手机只能注册一次，注册过的用户不能再注册，新用户收到借条额度通过通知和成功借款的用户才有奖励；\n2、可以随意借一笔款，几天后还款，利息按日计算，红包可以抵扣利息；', 1, 1, '1、必须扫图中二维码；\n2、成功之后必须有当天赠送的卡券；', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', 1, '2019-06-14 01:51:25', '2019-06-14 17:28:23', 0);
INSERT INTO `zj_task` VALUES (14, 1, '【百度口碑】好评即可不下载', 100, 10, 0, '2019-06-30', 72, 2, 1, 110000, 110100, 'www.baidu.com', '（评语请加微信号377047364，备注：百度口碑+你的手机品牌，客服通过你的好友验证发评语给你）%,%一定要加客服等客服给你评语在做任务，不是客服给的评语不合格%,%（复制注意事项中的链接到浏览器进入，点击登陆账号，给五星好评+评语+上传图片即可%,%（需要有百度账号，如已有账号，直接登录评价，如果没有自行注册一个号%,%一人只能评论一次，设置不限次数是因为怕有的超时没办法提交', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', '1、一个手机只能注册一次，注册过的用户不能再注册，新用户收到借条额度通过通知和成功借款的用户才有奖励；\n2、可以随意借一笔款，几天后还款，利息按日计算，红包可以抵扣利息；', 1, 1, '1、必须扫图中二维码；\n2、成功之后必须有当天赠送的卡券；', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', 1, '2019-06-14 01:51:25', '2019-06-14 17:28:23', 0);
INSERT INTO `zj_task` VALUES (15, 1, '【百度口碑】好评即可不下载', 100, 10, 0, '2019-06-30', 72, 2, 1, 110000, 110100, 'www.baidu.com', '（评语请加微信号377047364，备注：百度口碑+你的手机品牌，客服通过你的好友验证发评语给你）%,%一定要加客服等客服给你评语在做任务，不是客服给的评语不合格%,%（复制注意事项中的链接到浏览器进入，点击登陆账号，给五星好评+评语+上传图片即可%,%（需要有百度账号，如已有账号，直接登录评价，如果没有自行注册一个号%,%一人只能评论一次，设置不限次数是因为怕有的超时没办法提交', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', '1、一个手机只能注册一次，注册过的用户不能再注册，新用户收到借条额度通过通知和成功借款的用户才有奖励；\n2、可以随意借一笔款，几天后还款，利息按日计算，红包可以抵扣利息；', 1, 1, '1、必须扫图中二维码；\n2、成功之后必须有当天赠送的卡券；', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', 1, '2019-06-14 01:51:25', '2019-06-14 17:28:23', 0);
INSERT INTO `zj_task` VALUES (16, 1, '【百度口碑】好评即可不下载', 900, 10, 0, '2019-06-30', 72, 2, 1, 110000, 110100, 'www.baidu.com', '（评语请加微信号377047364，备注：百度口碑+你的手机品牌，客服通过你的好友验证发评语给你）%,%一定要加客服等客服给你评语在做任务，不是客服给的评语不合格%,%（复制注意事项中的链接到浏览器进入，点击登陆账号，给五星好评+评语+上传图片即可%,%（需要有百度账号，如已有账号，直接登录评价，如果没有自行注册一个号%,%一人只能评论一次，设置不限次数是因为怕有的超时没办法提交', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', '1、一个手机只能注册一次，注册过的用户不能再注册，新用户收到借条额度通过通知和成功借款的用户才有奖励；\n2、可以随意借一笔款，几天后还款，利息按日计算，红包可以抵扣利息；', 1, 1, '1、必须扫图中二维码；\n2、成功之后必须有当天赠送的卡券；', 'http://127.0.0.1:8001/upload/20190614/4c292520ae632633af81f9403a6e8576.png%,%http://127.0.0.1:8001/upload/20190614/48603eff30e52d9ac393854553703710.png', 1, '2019-06-14 01:51:25', '2019-06-14 17:28:23', 0);

-- ----------------------------
-- Table structure for zj_task_type
-- ----------------------------
DROP TABLE IF EXISTS `zj_task_type`;
CREATE TABLE `zj_task_type`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '任务类型id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '类型名称',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '类型图片',
  `comment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '类型描述',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态(0:禁用;1:启用)',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除(0:未删除;1:已删除)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of zj_task_type
-- ----------------------------
INSERT INTO `zj_task_type` VALUES (1, '游戏', 'http://127.0.0.1:8001/upload/20190614/93775dab78f8b737a9f11690d90e71df.png', '', 0, 1, '2019-06-14 01:40:52', '2019-06-14 01:40:52', 0);
INSERT INTO `zj_task_type` VALUES (2, '购物', 'http://127.0.0.1:8001/upload/20190614/14b206df4643b99b3888d43ea8cd2ad4.png', '', 0, 1, '2019-06-14 01:40:59', '2019-06-14 01:40:59', 0);

-- ----------------------------
-- Table structure for zj_user
-- ----------------------------
DROP TABLE IF EXISTS `zj_user`;
CREATE TABLE `zj_user`  (
  `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `superior_user_id` int(10) UNSIGNED NOT NULL COMMENT '上级用户id',
  `superior_superior_user_id` int(10) UNSIGNED NOT NULL COMMENT '上上级用户id',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户码',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户昵称',
  `avatarurl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户头像',
  `openid` varchar(0) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户openid',
  `phone` char(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户手机号',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户密码',
  `withdraw_password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '提现密码',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除(0:未删除;1:已删除)',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of zj_user
-- ----------------------------
INSERT INTO `zj_user` VALUES (2, 3, 0, '2222', '2222', 'https://wx.qlogo.cn/mmopen/vi_32/94FG2F7ADdrbWF8Hlml5fERlibf4pjlthU0bAAlyZ3gNyZbOiaWXQWZA2ETciaCxJVLKGX2B8P7SiaSfusFJQUlvpA/132', NULL, '18328607281', 'e10adc3949ba59abbe56e057f20f883e', NULL, '2019-06-14 03:26:20', '2019-06-14 05:51:07', 0);
INSERT INTO `zj_user` VALUES (3, 0, 0, '3333', '3333', 'https://wx.qlogo.cn/mmopen/vi_32/h3GVU1Iz7BaOmSSK6NrSBOibq9BzPMo4f4Gaic5pIS95CGMJEMouJQEjjSNPfjqbc11ibicnKJNqicFlLJatGQQNx2g/132', NULL, '13412341234', 'e10adc3949ba59abbe56e057f20f883e', NULL, '2019-06-14 03:42:02', '2019-06-14 05:51:04', 0);
INSERT INTO `zj_user` VALUES (5, 2, 3, '1234', '4444', 'https://wx.qlogo.cn/mmopen/vi_32/h3GVU1Iz7BaOmSSK6NrSBOibq9BzPMo4f4Gaic5pIS95CGMJEMouJQEjjSNPfjqbc11ibicnKJNqicFlLJatGQQNx2g/132', NULL, '13512341234', 'e10adc3949ba59abbe56e057f20f883e', NULL, '2019-06-14 05:53:03', '2019-06-14 05:54:37', 0);

-- ----------------------------
-- Table structure for zj_user_income
-- ----------------------------
DROP TABLE IF EXISTS `zj_user_income`;
CREATE TABLE `zj_user_income`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '收入id',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户id',
  `task_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '任务id',
  `money` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '收入金额',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态(0:禁用;1:启用)',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除(0:未删除;1:已删除)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户收入表' ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of zj_user_income
-- ----------------------------
INSERT INTO `zj_user_income` VALUES (1, 3, 1, 1900, 1, '2019-06-14 03:58:46', '2019-06-14 03:58:46', 0);

-- ----------------------------
-- Table structure for zj_user_notice
-- ----------------------------
DROP TABLE IF EXISTS `zj_user_notice`;
CREATE TABLE `zj_user_notice`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '消息id',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户id',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '消息标题',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '消息内容',
  `is_read` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否已读(0:未读;1:已读)',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除(0:未删除;1:已删除)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户消息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of zj_user_notice
-- ----------------------------
INSERT INTO `zj_user_notice` VALUES (1, 3, '12', '123123123', 0, '2019-06-14 04:34:54', '2019-06-14 04:34:54', 0);

-- ----------------------------
-- Table structure for zj_user_task
-- ----------------------------
DROP TABLE IF EXISTS `zj_user_task`;
CREATE TABLE `zj_user_task`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户任务id',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户id',
  `task_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '任务id',
  `submit_img` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '上传图片',
  `submit_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '上传文本',
  `submit_time` datetime(0) NULL DEFAULT NULL COMMENT '提交时间',
  `check_time` datetime(0) NULL DEFAULT NULL COMMENT '审核时间',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态(0:执行中;1:待审核;2:已通过;3:未通过;4:已放弃)',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除(0:未删除;1:已删除)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of zj_user_task
-- ----------------------------
INSERT INTO `zj_user_task` VALUES (14, 3, 2, NULL, NULL, NULL, NULL, 3, '2019-06-14 17:30:47', '2019-06-14 18:29:19', 0);
INSERT INTO `zj_user_task` VALUES (11, 3, 2, NULL, NULL, NULL, NULL, 2, '2019-06-14 16:57:00', '2019-06-14 18:29:18', 0);
INSERT INTO `zj_user_task` VALUES (16, 3, 1, NULL, NULL, NULL, NULL, 4, '2019-06-14 19:33:55', '2019-06-14 19:34:21', 0);
INSERT INTO `zj_user_task` VALUES (4, 3, 2, NULL, NULL, '2019-06-14 15:54:06', NULL, 1, '2019-06-14 16:11:00', '2019-06-14 18:29:18', 0);
INSERT INTO `zj_user_task` VALUES (19, 3, 1, NULL, NULL, NULL, NULL, 0, '2019-06-14 19:36:39', '2019-06-14 19:36:39', 0);
INSERT INTO `zj_user_task` VALUES (18, 3, 3, NULL, NULL, NULL, NULL, 0, '2019-06-14 19:34:10', '2019-06-14 19:34:10', 0);
INSERT INTO `zj_user_task` VALUES (17, 3, 1, '', '', '2019-06-14 19:35:43', NULL, 4, '2019-06-14 19:34:00', '2019-06-14 19:36:30', 0);
INSERT INTO `zj_user_task` VALUES (15, 3, 2, '', '', '2019-06-14 19:27:15', NULL, 1, '2019-06-14 19:10:43', '2019-06-14 19:27:15', 0);

-- ----------------------------
-- Table structure for zj_withdraw
-- ----------------------------
DROP TABLE IF EXISTS `zj_withdraw`;
CREATE TABLE `zj_withdraw`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '提现id',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户id',
  `money` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '金额',
  `withdraw_way_id` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '提现方式id',
  `account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '提现帐号',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态(0:提现中;1:成功;2:失败;3:已取消)',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除(0:未删除;1:已删除)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '提现表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of zj_withdraw
-- ----------------------------
INSERT INTO `zj_withdraw` VALUES (1, 3, 9900, 1, '123123', 1, '2019-06-14 04:39:44', '2019-06-14 04:39:44', 0);

-- ----------------------------
-- Table structure for zj_withdraw_way
-- ----------------------------
DROP TABLE IF EXISTS `zj_withdraw_way`;
CREATE TABLE `zj_withdraw_way`  (
  `withdraw_way_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '提现方式id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '提现方式名称',
  `min_money` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '提现最小金额',
  `max_money` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '提现最大金额',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态(0:禁用;1:启用)',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除(0:未删除;1:已删除)',
  PRIMARY KEY (`withdraw_way_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '提现方式表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of zj_withdraw_way
-- ----------------------------
INSERT INTO `zj_withdraw_way` VALUES (1, '支付宝提现', 2000, 10000, 1, '2019-06-14 04:40:06', '2019-06-14 04:40:06', 0);

SET FOREIGN_KEY_CHECKS = 1;
