<?php

namespace app\api\logic;

use app\api\model\ZjUser;
use app\util\ReturnCode;

/**
 * 用户收入逻辑
 * Class UserIncomeLogic
 * @package app\api\logic
 */
class UserIncomeLogic extends Base
{

    /**
     * 用户登录
     * @param $postData
     * @return array
     * @throws \think\Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function login($postData)
    {
        if(!isset($postData['phone'])){
            return $this->resultFailed(ReturnCode::PARAM_DEFECT,'请输入手机号','');
        }
        if(!isset($postData['password'])){
            return $this->resultFailed(ReturnCode::PARAM_DEFECT,'请输入密码','');
        }
        $phone = $postData['phone'];
        $password = $postData['password'];
        $res = ZjUser::where('phone', $phone)->count();
        if ($res > 0) {
            $where=[
                'phone'=>$phone,
                'password'=>md5($password),
                'is_delete'=>0
            ];
            $user = ZjUser::where($where)->find();
            if (!$user) {
                return $this->resultFailed(ReturnCode::RECORD_NOT_FOUND,'账号密码不匹配','');
            }
            $res = $this->createToken($user);
            return $this->resultSuccess($res);
        }
        return $this->resultFailed(ReturnCode::RECORD_NOT_FOUND,'账号不存在','');
    }

}
