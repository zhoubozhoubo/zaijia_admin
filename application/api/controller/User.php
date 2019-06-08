<?php
/**
 * Created by PhpStorm.
 * User: wj
 * Date: 2018/11/27
 * Time: 17:58
 */
namespace app\api\controller;
use think\Db;

/** 用户信息控制器
 * Class User
 * @package app\api\controller
 */
class User extends Base{

    /** 用户信息
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function index(){

        $openid=$_POST['openid'];
        $user = Db::name('User')->where('openid', $openid)->find();

        if (!isset($user['id'])) {
            $user = [
                'userimg' => null
                , 'username' => null
                , 'exp' => null
                , 'xjrs' => null
                , 'money' => null
            ];
        } else {
            //下级人数
            $str = rtrim(GetDiguiId($user['id']), ',');
            $str_arr = explode(',', $str);
            $user['x_num'] = count($str_arr) - 1;
        }

        $count = Db::name('user')->where('fid', $user['id'])->count();

        $data=[
            'data'=>$user,
            'count'=>$count
        ];

        return $this->buildSuccess($data);
    }
}