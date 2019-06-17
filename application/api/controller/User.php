<?php

namespace app\api\controller;

use app\admin\model\ZjBasicConf;
use app\api\model\ZjUser;
use app\api\model\ZjUserNotice;
use app\api\model\ZjWithdrawWay;
use app\util\ReturnCode;
use WeChat\Exceptions\InvalidArgumentException;
use think\Exception;
use WeChat\Oauth;

/**
 * 用户Controller
 * Class User
 * @package app\api\controller
 */
class User extends Base
{
    //初始化配置
    public $config = [
        'token' => 'xtcyivubohibxrctyvubn6rty',
        'appid' => 'wxc5b8b08c2e2b506f',
        'appsecret' => '3e0301d69ff031f7c7024e2c01ce05ea'
    ];

    /*function __construct() {
        $this->config = [
            'token' => 'xtcyivubohibxrctyvubn6rty',
            'appid' => 'wxc5b8b08c2e2b506f',
            'appsecret' => '3e0301d69ff031f7c7024e2c01ce05ea'
//            'token' => 'PCd4Gcdd55a4X440996pc9Y5tP90IP6K',
//            'appid' => 'wxc7338b8f1cc708e3',
//            'appsecret' => 'ca15b6f6e7015e4e44b12a5d0a8b336b'
        ];
    }*/

    /**
     * 用户个人信息
     * @return array|\think\response\Json
     * @throws \think\exception\DbException
     */
    public function info(){
        $this->requestType('POST');
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $where = [
            'user_id'=>$this->userInfo['user_id'],
            'is_delete'=>0
        ];
        $res = ZjUser::where($where)->field('password,gmt_create,gmt_modified,is_delete',true)->find();
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND,'用户不存在','');
        }
        $res->superiorUser;
        $res['my_income'] = $res->my_income;
        $res['team_income'] = $res->team_income;
        $res['total_income'] =number_format(($res['my_income']+$res['team_income']), 2, '.', '') ;
        //提现方式信息
        $withdrawWay = ZjWithdrawWay::where(['withdraw_way_id'=>1,'status'=>1,'is_delete'=>0])->field('gmt_create,gmt_modified,is_delete',true)->find();
        $res['withdraw_notice']=$withdrawWay['notice'];
        //二维码图片内容
        //获取域名配置
        $website = ZjBasicConf::where(['name'=>'website'])->value('value');
        $res['qr_code'] = $website.'/#/Register?invitationCode='.$res['code'];
        //邀请技巧
        $invite = ZjBasicConf::where(['name'=>'invite'])->value('value');
        $res['invite'] = explode('%,%',$invite);
        //邀请技巧
        $customer = ZjBasicConf::where(['name'=>'customer'])->value('value');
        $res['customer'] = explode('%,%',$customer);
        //最新消息数量
        $noticeNum = ZjUserNotice::where(['user_id'=>$res['user_id'],'is_read'=>0])->count();
        $res['notice_num']=$noticeNum;

        return $this->buildSuccess($res);
    }

    /**
     * 用户登录
     * @return array|\think\response\Json
     */
    /*public function login(){
        $this->requestType('POST');
        $postData = $this->request->post();
        $res = $this->logic->login($postData);
        if($res['code'] !== 1){
            return $this->buildFailed($res['code'], $res['msg'], $res['data']);
        }
        return $this->buildSuccess($res['data'],'登陆成功');
    }*/

    /**
     * 用户注册
     * @return array|\think\response\Json
     */
    public function register(){
        $this->requestType('POST');
        $postData = $this->request->post();
        $res = $this->logic->register($postData);
        if($res['code'] !== 1){
            return $this->buildFailed($res['code'], $res['msg'], $res['data']);
        }
        return $this->buildSuccess($res['data'],'注册成功');
    }

    /**
     * 发送验证码
     * @return array|\think\response\Json
     */
    public function sendCode(){
        $this->requestType('POST');
        $postData = $this->request->post();
        $res = $this->logic->sendCode($postData);
        if($res['code'] !== 1){
            return $this->buildFailed($res['code'], $res['msg'], $res['data']);
        }
        return $this->buildSuccess($res['data'],'发送验证码成功');
    }

    /**
     * 用户团队列表
     * @return array|\think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function myTeamList(){
        $this->requestType('POST');
        $postData = $this->request->post();
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $where=[];
        if($postData['type'] === 1){ //一级团队成员
            $where = [
                'superior_user_id'=>$this->userInfo['user_id'],
                'is_delete'=>0
            ];
        }else if($postData['type'] === 2){ //二级团队成员
            $where = [
                'superior_superior_user_id'=>$this->userInfo['user_id'],
                'is_delete'=>0
            ];
        }
        $res = ZjUser::where($where)->field('nickname,avatarurl,gmt_create')->paginate();
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND,'记录未找到','');
        }
        return $this->buildSuccess($res);
    }


    /**
     * 用户登录
     */
    public function login() {
        //请求授权
        $Oauth = new Oauth($this->config);

        //获取code
        $code = $Oauth->getOauthRedirect("http://jianzhi.hmdog.com/api/5d0793b7e8f50", 'state','snsapi_userinfo');
        // $code = $Oauth->getOauthRedirect(AdminUrl() . "/api/5bfcff58cdf2f", 'state', 'snsapi_userinfo');

        $res = [
            'data'=>"<script>window.location.href='{$code}'</script>"
        ];
//        return $this->buildSuccess($res,'登陆成功');
        echo "<script>window.location.href='{$code}'</script>";
    }


    /**
     * 获取公众号AccessToken
     * @return string
     * @throws \WeChat\Exceptions\InvalidResponseException
     * @throws \WeChat\Exceptions\LocalCacheException
     */
    public function get() {
        try {
            $Oauth = new Oauth($this->config);
            print_r($Oauth);exit;

            $token = $Oauth->getOauthAccessToken();

            $this->GetToken($token, $Oauth);
        } catch (Exception $e) {

            return $e->getMessage() . PHP_EOL;

        }

    }

    /**
     * 获取用户token
     * @param $token
     * @param $Oauth
     * @return InvalidArgumentException|\Exception|Exception
     */
    public function GetToken($token, $Oauth) {
        try {
            //获取用户基本信息
            $tokens = $Oauth->getOauthRefreshToken($token['refresh_token']);

            $this->GetInfo($tokens);

        } catch (Exception $e) {
            return $e;
        } catch (InvalidArgumentException $e) {
            return $e;
        }
    }

    /**
     * 获取用户信息
     * @param $token
     * @return string
     * @throws \WeChat\Exceptions\InvalidResponseException
     * @throws \WeChat\Exceptions\LocalCacheException
     */
    public function GetInfo($token) {
        try {
            $Oauth = new Oauth($this->config);

            //获取用户基本信息
            $info = $Oauth->getUserInfo($token['access_token'], $token['openid']);

            $this->add($info);

        } catch (Exception $e) {
            return $e->getMessage() . PHP_EOL;
        }
    }

    /**   用户信息处理
     * @param $info
     */
    public function add($info) {
        $where = [
            'openid'=>$info['openid']
        ];
        //检查该用户是否存在
        $res = ZjUser::where($where)->count();
        if ($res > 0) {
            //存在则返回用户信息以及token
            $user = ZjUser::where($where)->find();
//            $res = [
//                'url'=>'jianzhi.hmdog.com:8003/#/User',
//                'nickname'=>$info['nickname'],
//                'headimgurl'=>$info['headimgurl'],
//                'token'=>$this->createToken($user)
//            ];
            $token = $this->createToken($user);
//            return $this->buildSuccess($res,'登陆成功');
            echo "<script>window.location.href='http://jianzhi.hmdog.com:8003/#/User?token=".$token."';</script>";
        }else{
            //不存在则创建用户信息
            $user=[
                'code'=>$this->createCode(),
                'nickname'=>$info['nickname'],
                'avatarurl'=>$info['headimgurl'],
                'openid'=>$info['openid']
            ];
            $res = ZjUser::create($user);
            if (!$res) {
                return $this->buildFailed(ReturnCode::UPDATE_FAILED,'注册失败','');
            }
            $token = $this->createToken($user);
//            return $this->buildSuccess($res,'注册成功');
            echo "<script>window.location.href='http://jianzhi.hmdog.com:8003/#/User?token=".$token."';</script>";
        }

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
        return $token;
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
