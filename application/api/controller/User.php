<?php

namespace app\api\controller;

use app\api\model\ZjBasicConf;
use app\api\model\ZjCommission;
use app\api\model\ZjUser;
use app\api\model\ZjUserIncome;
use app\api\model\ZjUserNotice;
use app\api\model\ZjWithdrawWay;
use app\model\Template;
use app\util\ReturnCode;
use WeChat\Exceptions\InvalidArgumentException;
use think\Exception;
use Endroid\QrCode\QrCode;
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
            'openid'=>$this->userInfo['openid'],
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
//        $website = ZjBasicConf::where(['name'=>'website'])->value('value');
//        $res['qr_code'] = $website.'/api/5d0287415a574/?invitationCode='.$res['code'];
        //邀请技巧
        $invite = ZjBasicConf::where(['name'=>'invite'])->value('value');
        $res['invite'] = explode('%,%',$invite);
        //联系客服
        $customer = ZjBasicConf::where(['name'=>'customer'])->value('value');
        $res['customer'] = explode('%,%',$customer);
        //最新消息数量
        $noticeNum = ZjUserNotice::where(['user_id'=>$res['user_id'],'is_read'=>0])->count();
        $res['notice_num']=$noticeNum;
        //用户分享二维码海报
        $res['qr_code']= $this->qrCode($this->userInfo['openid']);

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
        $getData = $this->request->get();
        //邀请码
        if(isset($getData['invitationCode']) && $getData['invitationCode']!==''){
            $invitationCode = $getData['invitationCode'];
        }else{
            $invitationCode=0;
        }
        //入口页面
        if(isset($getData['page']) && $getData['page']==0){
            $page = 0;
        }else{
            $page=1;
        }

        $state = $invitationCode.$page;

        //获取code
        $code = $Oauth->getOauthRedirect("http://zaijia.huiyuancaifu.cn/api/5d0793b7e8f50", $state,'snsapi_userinfo');
        // $code = $Oauth->getOauthRedirect(AdminUrl() . "/api/5bfcff58cdf2f", 'state', 'snsapi_base');

//        $res = [
//            'data'=>"<script>window.location.href='{$code}'</script>"
//        ];
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
        //判断code是否已使用
        $code = isset($_GET['code']) ? $_GET['code'] : '';
        if(cache('code') && $code === cache('code')){
            echo "<script>window.location.href='http://wap.huiyuancaifu.cn/#/';</script>";
        }
        try {
            $Oauth = new Oauth($this->config);
            $state = isset($_GET['state']) ? $_GET['state'] : '';

            $invitationCode = substr($state,0,strlen($state)-1);

            $page = substr($state,-1);

            $token = $Oauth->getOauthAccessToken();
            cache($token['openid'],$invitationCode);
            cache($token['openid'].'_page',$page);

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
        //检测用户是否关注公众号
        $Oauth = new Oauth($this->config);
        $userInfo = $Oauth->getUser($info['openid']);
        $subScribe = $userInfo['subscribe'];
//        if(!$userInfo['subscribe']){
//            echo "<script>window.location.href='https://mp.weixin.qq.com/mp/profile_ext?action=home&__biz=MzU2Mjc3NDE1Mw==&scene=126&bizpsid=0#wechat_redirect';</script>";
//        }
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
//            echo "<script>window.location.href='http://jianzhi.hmdog.com:8003/#/User?token=".$token."&subscribe=".$subScribe."';</script>";
        }else{
            //不存在则创建用户信息
            $user=[
                'code'=>$this->createCode(),
                'nickname'=>$info['nickname'],
                'avatarurl'=>$info['headimgurl'],
                'openid'=>$info['openid']
            ];
            $invitationCode = cache($info['openid']);
            if($invitationCode){
                //根据邀请码绑定上级及上上级
                $superior = ZjUser::where(['code'=>$invitationCode,'is_delete'=>0])->field('user_id,superior_user_id')->find();
                if($superior){
                    $user['superior_user_id'] =  $superior['user_id'];
                    $user['superior_superior_user_id'] =  $superior['superior_user_id'];
                    //发送微信消息给用户
                    $openId = ZjUser::where('user_id',$user['superior_user_id'])->value('openid');
                    $template = new Template();
                    $template->bindSuccess($openId,$user['nickname']);
                }
            }
            $res = ZjUser::create($user);
            if (!$res) {
                return $this->buildFailed(ReturnCode::UPDATE_FAILED,'注册失败','');
            }
            $user = ZjUser::where($where)->find();
            $token = $this->createToken($user);
//            return $this->buildSuccess($res,'注册成功');
//            echo "<script>window.location.href='http://jianzhi.hmdog.com:8003/#/User?token=".$token."&subscribe=".$subScribe."';</script>";
        }

        //用户未首次关注公众号，关注公众号奖励
        if(!$user['first_follow'] && $subScribe == 1){
            //获取首次关注奖励
            $firstFollowMoney = ZjBasicConf::where(['name'=>'first_follow_money'])->value('value');
            //添加用户收入数据
            $userIncome = [
                'user_id'=>$user['user_id'],
                'task_id'=>0,
                'money'=>$firstFollowMoney/100
            ];
            ZjUserIncome::create($userIncome);
            //用户增加金额
            ZjUser::where(['user_id'=>$user['user_id']])->setInc('money',$firstFollowMoney);

            //如果存在上级，则进行上级奖励
            if($user['superior_user_id']){
                //获取邀请新人关注奖励
                $inviteNewMoney = ZjBasicConf::where(['name'=>'invite_new_money'])->value('value');
                //添加佣金数据
                $commission = [
                    'type'=>3,
                    'user_id'=>$user['superior_user_id'],
                    'money'=>$inviteNewMoney/100,
                    'from_user_id'=>$user['user_id'],
                    'task_id'=>0
                ];
                ZjCommission::create($commission);
                //用户增加金额
                ZjUser::where(['user_id'=>$user['superior_user_id']])->setInc('money',$inviteNewMoney);
            }

            //更新用户首次关注信息
            ZjUser::where('user_id',$user['user_id'])->update(['first_follow'=>1]);
        }

        $page = cache($info['openid'].'_page');
        if($page == 0){
            echo "<script>window.location.href='http://wap.huiyuancaifu.cn/#/?token=".$token."&subscribe=".$subScribe."';</script>";
        }else if($page == 1){
            echo "<script>window.location.href='http://wap.huiyuancaifu.cn/#/User?token=".$token."&subscribe=".$subScribe."';</script>";
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
        if(!$nowMaxCode){
            $nowMaxCode = 1000;
        }
        return $nowMaxCode+1;
    }

    /**
     * @param $openid
     * @return string
     */
    public function qrCode($openid) {
        //获取域名配置
        $website = ZjBasicConf::where(['name'=>'website'])->value('value');
        //用户信息
        $user = ZjUser::where(['openid'=>$openid])->find();
        //如果用户头像不存在域名字符则下载微信头像到本地
        if (!strstr($user['avatarurl'], $website)) {
            //下载用户头像到本地
            $avatarurl = local_image($user['avatarurl']);
            //更新数据库头像地址
            ZjUser::where(['openid'=>$openid])->update(['avatarurl'=>$avatarurl]);
            $img = explode('/', $avatarurl);
        } else {
            $img = explode('/', $user['avatarurl']);
        }
        $name = ROOT_PATH . 'public/upload/qrCode/' . $user['code'] . '.png';
        //判断二维码是否存在
        if (!file_exists($name)) {
            //logo
            $logo = $img[3] . '/' . $img[4] . '/' . $img[5] . '/' . $img[6] . '/' . $img[7];
            $url = $website.'/api/5d0287415a574/?invitationCode='.$user['code'];
            //实例化Qrcode类
            $qrCode = new QrCode();
            $qrCode->setText($url)
                ->setSize(300)
                ->setPadding(10)
                ->setErrorCorrection('high')
                ->setForegroundColor(array('r' => 0, 'g' => 0, 'b' => 0, 'a' => 0))
                ->setBackgroundColor(array('r' => 255, 'g' => 255, 'b' => 255, 'a' => 0))
                ->setLogo($logo)
                ->setLogoSize(80)
                ->setLabelFontSize(16);
            //返回图片
            $qrCode->save($name);
        }
        //背景海报
        $bigImgPath =ZjBasicConf::where(['name' => 'wechat_qr_code'])->value('value');
        //用户二维码
        $qCodePath = $website.'/upload/qrCode/' . $user['code'] . '.png';

        $bigImg = imagecreatefromstring(file_get_contents($bigImgPath));
        $qCodeImg = imagecreatefromstring(file_get_contents($qCodePath));

        list($qCodeWidth, $qCodeHight) = getimagesize($qCodePath);

        imagecopymerge($bigImg, $qCodeImg, 120, 250, 0, 0, $qCodeWidth, $qCodeHight, 100);

        imagejpeg($bigImg,ROOT_PATH . 'public/upload/qrCode/' . $user['code'] . '.jpg');

        return $website.'/upload/qrCode/' . $user['code'] . '.jpg';

    }








}
