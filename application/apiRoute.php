<?php
/**
 * Api路由
 */

use think\Route;

Route::group('api', function () {
    Route::miss('api/Miss/index');
});
$afterBehavior = [
    '\app\api\behavior\ApiAuth',
    '\app\api\behavior\ApiPermission',
    '\app\api\behavior\RequestFilter'
];
Route::rule('api/5cffd30dea6c1','api/api/Index/bannerList', 'GET', ['after_behavior' => $afterBehavior]);Route::rule('api/5d00685b6dca4','api/api/Link/linkList', 'GET', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0068737af3e','api/api/Task/taskList', 'GET', ['after_behavior' => $afterBehavior]);Route::rule('api/5d00723e71753','api/api/Task/taskDetails', 'GET', ['after_behavior' => $afterBehavior]);Route::rule('api/5d008754012a9','api/api/User/sendCode', 'POST', ['after_behavior' => $afterBehavior]);Route::rule('api/5d00eca54d746','api/api/User/register', 'POST', ['after_behavior' => $afterBehavior]);Route::rule('api/5d00ecbb7a93f','api/api/User/login', 'POST', ['after_behavior' => $afterBehavior]);Route::rule('api/5d00f45bf0cc1','api/api/User/info', 'GET', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0104c3dfa3e','api/api/User/myTeamList', 'GET', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0105c40f3d6','api/api/UserIncome/myIncomeList', 'GET', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0105eed7419','api/api/UserIncome/teamIncomeList', 'GET', ['after_behavior' => $afterBehavior]);Route::rule('api/5d010610a1299','api/api/UserWithDraw/withdrawList', 'GET', ['after_behavior' => $afterBehavior]);Route::rule('api/5d010660d7607','api/api/UserTask/taskList', 'GET', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0106869b7a5','api/api/UserTask/addTask', 'POST', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0106a207c3f','api/api/UserTask/submitTask', 'POST', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0106ba60b9d','api/api/UserTask/delTask', 'POST', ['after_behavior' => $afterBehavior]);Route::rule('api/5d01123d590eb','api/api/Index/areaList', 'GET', ['after_behavior' => $afterBehavior]);