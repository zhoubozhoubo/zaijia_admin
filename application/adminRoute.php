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
    Route::group('CNews', [
        'index' => [
            'admin/CNews/index',
            ['method' => 'get']
        ],
        'add' => [
            'admin/CNews/add',
            ['method' => 'post']
        ],
        'edit' => [
            'admin/CNews/edit',
            ['method' => 'post']
        ],
        'del' => [
            'admin/CNews/del',
            ['method' => 'get']
        ],
    ], ['after_behavior' => $afterBehavior]);

    Route::group('Withdrawal', [
        //TODO 提现列表
        'index' => [
            'admin/Withdrawal/index',
            ['method' => 'get']
        ],
        //TODO 转账状态
        'resume'=>[
            'admin/Withdrawal/resume',
            ['method' => 'post']
        ],
        //TODO 提现统计
        'count'=>[
            'admin/Withdrawal/count',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('Details', [
        'index' => [
            'admin/Details/index',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('RebateList', [
        'index' => [
            'admin/RebateList/index',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('Sale', [
        'index' => [
            'admin/Sale/index',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('Rebate', [
        'index' => [
            'admin/Rebate/index',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('TodayCount', [
        'index' => [
            'admin/TodayCount/index',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('GoodType', [
        'index' => [
            'admin/GoodType/index',
            ['method' => 'get']
        ],
        'add' => [
            'admin/GoodType/add',
            ['method' => 'post']
        ],
        'edit' => [
            'admin/GoodType/edit',
            ['method' => 'post']
        ],
        'del' => [
            'admin/GoodType/del',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);
    Route::group('Good', [
        'index' => [
            'admin/Good/index',
            ['method' => 'get']
        ],
        'goodtype' => [
            'admin/Good/goodtype',
            ['method' => 'get']
        ],
        'add' => [
            'admin/Good/add',
            ['method' => 'post']
        ],
        'edit' => [
            'admin/Good/edit',
            ['method' => 'post']
        ],
        'del' => [
            'admin/Good/del',
            ['method' => 'get']
        ],
        'changeStatus' => [
            'admin/Good/changeStatus',
            ['method' => 'get']
        ]
    ], ['after_behavior' => $afterBehavior]);

    // 提成配置
    Route::group('ExtractConfig', [
        // 读取提成配置
        'index' => [
            'admin/ExtractConfig/index',
            ['method' => 'get']
        ],
        // 更新提成配置
        'update' => [
            'admin/ExtractConfig/update',
            ['method' => 'post']
        ],
    ], ['after_behavior' => $afterBehavior]);

    // 提现配置
    Route::group('ForwardConfig', [
        // 读取提现配置
        'index' => [
            'admin/ForwardConfig/index',
            ['method' => 'get']
        ],
        // 更新提现配置
        'update' => [
            'admin/ForwardConfig/update',
            ['method' => 'post']
        ],
    ], ['after_behavior' => $afterBehavior]);

    // 开码活动配置
    Route::group('Activity', [
        // 读取配置
        'index' => [
            'admin/Activity/index',
            ['method' => 'get']
        ],
        // 更新配置
        'update' => [
            'admin/Activity/update',
            ['method' => 'post']
        ],
    ], ['after_behavior' => $afterBehavior]);

    Route::miss('admin/Miss/index');
});
