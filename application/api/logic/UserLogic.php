<?php

namespace app\api\logic;

use app\api\model\ZjUser;
use app\util\ReturnCode;

/**
 * 用户逻辑
 * Class UserLogic
 * @package app\api\logic
 */
class UserLogic extends Base
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
        if(!isset($postData['phone']) || $postData['phone'] === ''){
            return $this->resultFailed(ReturnCode::PARAM_DEFECT,'请输入手机号','');
        }
        if(!isset($postData['password']) || $postData['password'] === ''){
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

    /**
     * 用户注册
     * @param $postData
     * @return array
     * @throws \think\Exception
     */
    public function register($postData){
        if(!isset($postData['phone']) || $postData['phone'] === ''){
            return $this->resultFailed(ReturnCode::PARAM_DEFECT,'请输入手机号','');
        }
        if(!isset($postData['code']) || $postData['code'] === ''){
            return $this->resultFailed(ReturnCode::PARAM_DEFECT,'请输入验证码','');
        }
        if(!isset($postData['password']) || $postData['password'] === ''){
            return $this->resultFailed(ReturnCode::PARAM_DEFECT,'请输入密码','');
        }
        $phone = $postData['phone'];
        $code = $postData['code'];
        $password = $postData['password'];
        //邀请码
        $invitationCode = $postData['invitationCode'];
        $res = ZjUser::where('phone', $phone)->count();
        if ($res > 0) {
            return $this->resultFailed(ReturnCode::RECORD_NOT_FOUND,'账号已注册','');
        }
        if($code != cache($phone)){
            return $this->resultFailed(ReturnCode::CODE_ERROR,'验证码错误','');
        }
        $code = $this->createCode();
        $user = [
            'phone'=>$phone,
            'password'=>md5($password),
            'code'=>$code,
            'nickname'=>'惠元财富会员'.$code
        ];
        if($invitationCode){
            //根据邀请码绑定上级及上上级
            $superior = ZjUser::where(['code'=>$invitationCode,'is_delete'=>0])->field('user_id,superior_user_id')->find();
            if($superior){
                $user['superior_user_id'] =  $superior['user_id'];
                $user['superior_superior_user_id'] =  $superior['superior_user_id'];
            }
        }

        $res = ZjUser::create($user);
        if (!$res) {
            return $this->resultFailed(ReturnCode::UPDATE_FAILED,'注册失败','');
        }
        return $this->resultSuccess($res);
    }

    /**
     * 发送验证码
     * @param $postData
     * @return array
     */
    public function sendCode($postData){
        if(!isset($postData['phone'])){
            return $this->resultFailed(ReturnCode::PARAM_DEFECT,'请输入手机号','');
        }
        $phone = $postData['phone'];

        if (!isPhone($phone)) {
            return $this->resultFailed(ReturnCode::PARAM_INVALID,'手机号格式错误','');
        }
        $code = mt_rand(1000,9999);
        cache($phone,$code,60);
        return $this->resultSuccess($code);
    }

    /**
     * 生成token
     * @param $user
     * @return array
     */
    public function createToken($user){
        $str = mt_rand(1000,9999);
        $str = uniqid("$str.", true);
        $token = md5($str);
        cache($token, json_encode($user));
        return ['token'=>$token];
    }

    /**
     * 生成code
     * @return int
     */
    public function createCode(){
        $nowMaxCode = ZjUser::order('code DESC')->limit(1)->value('code');
        return $nowMaxCode+1;
    }
}
