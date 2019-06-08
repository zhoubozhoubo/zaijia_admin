<?php
/**
 * Created by PhpStorm.
 * User: wj
 * Date: 2018/11/27
 * Time: 15:45
 */
namespace app\api\controller;
use think\Db;
use think\Exception;
use WeChat\Exceptions\InvalidArgumentException;
use WeChat\Oauth;

/** 用户登录
 * Class Login
 * @package app\api\controller
 */
class Login extends Base{

    //初始化配置
    public $config = [
        'token' => 'PCd4Gcdd55a4X440996pc9Y5tP90IP6K',
        'appid' => 'wxc7338b8f1cc708e3',
        'appsecret' => 'ca15b6f6e7015e4e44b12a5d0a8b336b',
        'encodingaeskey' => '',
        // 配置商户支付参数（可选，在使用支付功能时需要）
        'mch_id' => "",
        'mch_key' => '',
        // 配置商户支付双向证书目录（可选，在使用退款|打款|红包时需要）
        'ssl_key' => '',
        'ssl_cer' => '',
        // 缓存目录配置（可选,需拥有读写权限）
        'cache_path' => '',
    ];


    public $table = "User";

    public function Login(){
        //请求授权
        $Oauth = new \WeChat\Oauth($this->config);

        //获取code
        $code = $Oauth->getOauthRedirect(AdminUrl()."/api/5bfcff58cdf2f", 'state');

        echo "<script>window.location.href='{$code}'</script>";
    }

    /** 获取 公众号AccessToken
     * @return array|bool
     */
    public function get()
    {
        try {
            $Oauth = new \WeChat\Oauth($this->config);

            $token = $Oauth->getOauthAccessToken();

            $this->GetToken($token,$Oauth);
        } catch (Exception $e) {

            return $e->getMessage() . PHP_EOL;

        }

    }

    /**
     * 获取用户token
     * @param $token
     */
    public function GetToken($token,$Oauth)
    {
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

    /** 获取用户信息
     * @param $token
     * @return string
     */
    public function GetInfo($token)
    {
        try {
            $Oauth = new \WeChat\Oauth($this->config);

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
    public function add($info)
    {
        //检查该用户是否存在
        $db = Db::name($this->table)->where('openid', $info['openid'])->find();
        if ($db) {
            //用户存在设置登陆信息
//            session('id', $db['id']);
//            session('username', $db['username']);
//            session('userimg', $db['userimg']);
//            session('exp', $db['exp']);
            $url=IndexUrl();
            echo "<script>window.location.href='{$url}/#/?openid={$info['openid']}&exp={$db['exp']}';</script>";
        } else {
            //下载用户头像到本地
            $data = [
                //用户名
                'username' => $info['nickname'],
                //用户头像
                'userimg' => $info['headimgurl'],
                //用户openid,对当前公众唯一
                'openid' => $info['openid'],
                //新用户等级1
                'exp' => 1
            ];

            //被邀请
            if (!empty(cookie('coder'))) {
                //推荐人id
                $fid = base64_decode(cookie('coder'));
                $data['fid'] = $fid;
                //寻找爷级
                $sid = Db::name('User')->where('id', $fid)->value('fid');
                if ($sid != 0) {
                    //爷级存在
                    $data['sid'] = $sid;
                }
                //推荐人等级
                $fexp = Db::name('User')->where('id', $fid)->value('exp');
                //寻找团队
                if ($fexp == 4) {
                    //推荐人为联创人时
                    $data['vid'] = $fid;
                } else {
                    $vid = Db::name('User')->where('id', $fid)->value('vid');
                    if ($vid != 0) {
                        //团队存在
                        $data['vid'] = $vid;
                    }
                }

            }

            //检测管理用户最少的财务
//            $finances=db('SystemUser')->where('authorize',1)->column('id');
//            $finance=db('User')->group('cw_id')->where('cw_id','neq',0)->column('cw_id,count(*) as count');
//            $finance_arr=db('User')->group('cw_id')->where('cw_id','neq',0)->column('cw_id');
//
//            foreach ($finances as $key=>$val) {
//                if(!in_array($val,$finance_arr)){
//                    $finance[$val]=0;
//                }
//            }
//
//            foreach ($finance as $k=>$v) {
//                if($v==min($finance)){
//                    $cw_id=$k;
//                    break;
//                }
//            }
//            //所属财务
//            $data['cw_id'] = $cw_id;
//
            $db = Db::name($this->table)->insertGetId($data);

            if ($db > 0) {
                $db = Db::name('user')->where('id', $db)->find();

                //添加用户成功，添加登陆信息
                session('id', $db['id']);
                session('username', $db['username']);
                session('userimg', $db['userimg']);
                session('exp', $db['exp']);


                $url=IndexUrl();
                echo "<script>window.location.href='{$url}/#/?openid={$info['openid']}&exp={$db['exp']}';</script>";

            } else {
                return '登陆失败';
            }

        }
    }
}