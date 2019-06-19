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
Route::rule('api/5d0253080db26','api/Index/areaList', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0286898878a','api/Index/bannerList', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0286b4ea311','api/Index/linkList', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0286cb35cb3','api/Task/taskList', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0286f251c4d','api/Task/taskDetails', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d02871310048','api/User/sendCode', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d02872f6e368','api/User/register', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0287415a574','api/User/login', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d028757a9784','api/User/info', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d02876d5d982','api/UserIncome/myIncomeList', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d02879991352','api/User/myTeamList', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0287d22f573','api/UserIncome/teamIncomeList', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0287e451a4c','api/WithDraw/withdrawList', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0287facb879','api/UserTask/taskList', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0288178f14a','api/UserTask/addTask', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d02882d0a05a','api/UserTask/submitTask', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0288414ff33','api/UserTask/delTask', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d02b2c1a7b23','api/UserNotice/noticeList', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0379759b283','api/UserTask/taskDetails', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d04437d3bcd4','api/WithDraw/addWithdraw', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0460e82d9c3','api/UserNotice/readNotice', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0793b7e8f50','api/User/get', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d08606042e0e','api/Index/upload', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d0928d42c8e4','api/NewsType/newsTypeList', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d092b3207a43','api/News/newsList', '*', ['after_behavior' => $afterBehavior]);Route::rule('api/5d092d1e330fa','api/News/newsDetails', '*', ['after_behavior' => $afterBehavior]);