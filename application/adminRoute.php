<?php

use think\Route;

$afterBehavior = [
    '\app\admin\behavior\ApiAuth',
    '\app\admin\behavior\ApiPermission',
    '\app\admin\behavior\AdminLog'
];

Route::group('admin', function () use ($afterBehavior) {
    //一些带有特殊参数的路由写到这里
    Route::rule([
        'Login/index' => [
            'admin/Login/index',
            ['method' => 'post']
        ],
        'Index/upload' => [
            'admin/Index/upload',
            [
                'method' => 'post',
                'after_behavior' => [
                    '\app\admin\behavior\ApiAuth',
                    '\app\admin\behavior\AdminLog'
                ]
            ]
        ],
        'Login/logout' => [
            'admin/Login/logout',
            [
                'method' => 'get',
                'after_behavior' => [
                    '\app\admin\behavior\ApiAuth',
                    '\app\admin\behavior\AdminLog'
                ]
            ]
        ]
    ]);
    //大部分控制器的路由都以分组的形式写到这里
    Route::group('Menu', [
        'index' => [
            'admin/Menu/index',
            ['method' => 'get']
        ],
        'changeStatus' => [
            'admin/Menu/changeStatus',
            ['method' => 'get']
        ],
        'add' => [
            'admin/Menu/add',
            ['method' => 'post']
        ],
        'edit' => [
            'admin/Menu/edit',
            ['method' => 'post']
        ],
        'del' => [
            'admin/Menu/del',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('User', [
        'index' => [
            'admin/User/index',
            ['method' => 'get']
        ],
        'getUsers' => [
            'admin/User/getUsers',
            ['method' => 'get']
        ],
        'changeStatus' => [
            'admin/User/changeStatus',
            ['method' => 'get']
        ],
        'add' => [
            'admin/User/add',
            ['method' => 'post']
        ],
        'own' => [
            'admin/User/own',
            ['method' => 'post']
        ],
        'edit' => [
            'admin/User/edit',
            ['method' => 'post']
        ],
        'del' => [
            'admin/User/del',
            ['method' => 'get']
        ],
    ], ['after_behavior' => $afterBehavior]);
    Route::group('Auth', [
        'index' => [
            'admin/Auth/index',
            ['method' => 'get']
        ],
        'changeStatus' => [
            'admin/Auth/changeStatus',
            ['method' => 'get']
        ],
        'add' => [
            'admin/Auth/add',
            ['method' => 'post']
        ],
        'delMember' => [
            'admin/Auth/delMember',
            ['method' => 'get']
        ],
        'edit' => [
            'admin/Auth/edit',
            ['method' => 'post']
        ],
        'del' => [
            'admin/Auth/del',
            ['method' => 'get']
        ],
        'getGroups' => [
            'admin/Auth/getGroups',
            ['method' => 'get']
        ],
        'getRuleList' => [
            'admin/Auth/getRuleList',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('App', [
        'index' => [
            'admin/App/index',
            ['method' => 'get']
        ],
        'refreshAppSecret' => [
            'admin/App/refreshAppSecret',
            ['method' => 'get']
        ],
        'changeStatus' => [
            'admin/App/changeStatus',
            ['method' => 'get']
        ],
        'add' => [
            'admin/App/add',
            ['method' => 'post']
        ],
        'getAppInfo' => [
            'admin/App/getAppInfo',
            ['method' => 'get']
        ],
        'edit' => [
            'admin/App/edit',
            ['method' => 'post']
        ],
        'del' => [
            'admin/App/del',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('InterfaceList', [
        'index' => [
            'admin/InterfaceList/index',
            ['method' => 'get']
        ],
        'changeStatus' => [
            'admin/InterfaceList/changeStatus',
            ['method' => 'get']
        ],
        'add' => [
            'admin/InterfaceList/add',
            ['method' => 'post']
        ],
        'refresh' => [
            'admin/InterfaceList/refresh',
            ['method' => 'get']
        ],
        'edit' => [
            'admin/InterfaceList/edit',
            ['method' => 'post']
        ],
        'del' => [
            'admin/InterfaceList/del',
            ['method' => 'get']
        ],
        'getHash' => [
            'admin/InterfaceList/getHash',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('Fields', [
        'index' => [
            'admin/Fields/index',
            ['method' => 'get']
        ],
        'request' => [
            'admin/Fields/request',
            ['method' => 'get']
        ],
        'add' => [
            'admin/Fields/add',
            ['method' => 'post']
        ],
        'response' => [
            'admin/Fields/response',
            ['method' => 'get']
        ],
        'edit' => [
            'admin/Fields/edit',
            ['method' => 'post']
        ],
        'del' => [
            'admin/Fields/del',
            ['method' => 'get']
        ],
        'upload' => [
            'admin/Fields/upload',
            ['method' => 'post']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('InterfaceGroup', [
        'index' => [
            'admin/InterfaceGroup/index',
            ['method' => 'get']
        ],
        'getAll' => [
            'admin/InterfaceGroup/getAll',
            ['method' => 'get']
        ],
        'add' => [
            'admin/InterfaceGroup/add',
            ['method' => 'post']
        ],
        'changeStatus' => [
            'admin/InterfaceGroup/changeStatus',
            ['method' => 'get']
        ],
        'edit' => [
            'admin/InterfaceGroup/edit',
            ['method' => 'post']
        ],
        'del' => [
            'admin/InterfaceGroup/del',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('AppGroup', [
        'index' => [
            'admin/AppGroup/index',
            ['method' => 'get']
        ],
        'getAll' => [
            'admin/AppGroup/getAll',
            ['method' => 'get']
        ],
        'add' => [
            'admin/AppGroup/add',
            ['method' => 'post']
        ],
        'changeStatus' => [
            'admin/AppGroup/changeStatus',
            ['method' => 'get']
        ],
        'edit' => [
            'admin/AppGroup/edit',
            ['method' => 'post']
        ],
        'del' => [
            'admin/AppGroup/del',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('Log', [
        'index' => [
            'admin/Log/index',
            ['method' => 'get']
        ],
        'del' => [
            'admin/Log/del',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('AppUser', [
        'index' => [
            'admin/AppUser/index',
            ['method' => 'get']
        ],
        'getUsers' => [
            'admin/User/getUsers',
            ['method' => 'get']
        ],
        'changeStatus' => [
            'admin/User/changeStatus',
            ['method' => 'get']
        ],
        'add' => [
            'admin/User/add',
            ['method' => 'post']
        ],
        'own' => [
            'admin/User/own',
            ['method' => 'post']
        ],
        'edit' => [
            'admin/AppUser/edit',
            ['method' => 'post']
        ],
        'del' => [
            'admin/AppUser/del',
            ['method' => 'get']
        ],
        'reset' => [
            'admin/AppUser/reset',
            ['method' => 'get']
        ],
        'cw' => [
            'admin/AppUser/cw',
            ['method' => 'get']
        ],
        'cw_change' => [
            'admin/AppUser/cw_change',
            ['method' => 'post']
        ],
    ], ['after_behavior' => $afterBehavior]);
    Route::group('AreaCon', [
        'getList' => [
            'admin/AreaCon/getList',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('DbTable', [
        'index' => [
            'admin/DbTable/index',
            ['method' => 'post']
        ],
        'getTableList' => [
            'admin/DbTable/getTableList',
            ['method' => 'get']
        ],
        'getTableFullFields' => [
            'admin/DbTable/getTableFullFields',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('Banner', [
        'getList' => [
            'admin/Banner/getList',
            ['method' => 'get']
        ],
        'save' => [
            'admin/Banner/save',
            ['method' => 'post']
        ],
        'change' => [
            'admin/Banner/change',
            ['method' => 'post']
        ],
        'delete' => [
            'admin/Banner/delete',
            ['method' => 'post']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('Link', [
        'getList' => [
            'admin/Link/getList',
            ['method' => 'get']
        ],
        'save' => [
            'admin/Link/save',
            ['method' => 'post']
        ],
        'change' => [
            'admin/Link/change',
            ['method' => 'post']
        ],
        'delete' => [
            'admin/Link/delete',
            ['method' => 'post']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('UserCon', [
        'getList' => [
            'admin/UserCon/getList',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('UserIncome', [
        'getList' => [
            'admin/UserIncome/getList',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('UserNotice', [
        'getList' => [
            'admin/UserNotice/getList',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('UserTask', [
        'getList' => [
            'admin/UserTask/getList',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('Withdraw', [
        'getList' => [
            'admin/Withdraw/getList',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('WithdrawWay', [
        'getList' => [
            'admin/WithdrawWay/getList',
            ['method' => 'get']
        ],
        'change' => [
            'admin/WithdrawWay/change',
            ['method' => 'post']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('Commission', [
        'getList' => [
            'admin/Commission/getList',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('CommissionConf', [
        'getList' => [
            'admin/CommissionConf/getList',
            ['method' => 'get']
        ],
        'save' => [
            'admin/CommissionConf/save',
            ['method' => 'post']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('Task', [
        'getList' => [
            'admin/Task/getList',
            ['method' => 'get']
        ],
        'save' => [
            'admin/Task/save',
            ['method' => 'post']
        ],
        'change' => [
            'admin/Task/change',
            ['method' => 'post']
        ],
        'delete' => [
            'admin/Task/delete',
            ['method' => 'post']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('TaskType', [
        'getList' => [
            'admin/TaskType/getList',
            ['method' => 'get']
        ],
        'save' => [
            'admin/TaskType/save',
            ['method' => 'post']
        ],
        'change' => [
            'admin/TaskType/change',
            ['method' => 'post']
        ],
        'delete' => [
            'admin/TaskType/delete',
            ['method' => 'post']
        ]
    ], ['after_behavior' => $afterBehavior]);

    Route::miss('admin/Miss/index');
});
