<?php
/**
 * Created by PhpStorm.
 * User: wj
 * Date: 2018/11/28
 * Time: 09:47
 */
namespace app\api\controller;
use app\admin\controller\Config;
use app\api\model\Fandian;
use app\api\model\Template;
use think\Db;

class OpenCode extends Base{

    //初始化配置
    public $config = [
        'token' => 'PCd4Gcdd55a4X440996pc9Y5tP90IP6K',
        'appid' => 'wxc7338b8f1cc708e3',
        'appsecret' => 'ca15b6f6e7015e4e44b12a5d0a8b336b',
        'encodingaeskey' => '',
        // 配置商户支付参数（可选，在使用支付功能时需要）
        'mch_id' => '1434724302',
        'mch_key' => 'gdhx87y3bsu9uyqbe898y3ggyigyiggy',
        // 配置商户支付双向证书目录（可选，在使用退款|打款|红包时需要）
        'ssl_key' => '',
        'ssl_cer' => '',
        // 缓存目录配置（可选,需拥有读写权限）
        'cache_path' => '',
    ];

    /** 开码初始化检查当前活动是否开启 开启则开码0.01，并且不返现
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function index(){
        return $this->buildSuccess(Db::name('re')->find()['status']);
    }

    /**
     * 短信接口
     */
    public function sms()
    {
        //手机号
        $phone = $_POST['phone'];

        //验证码
        $code = rand(1000, 9999);
        //$code = 9636;

        //储存验证码
        session('sms_code', $code);
        $data = ['code' => $code];

        $sms = Sms::sendMsg($phone, $data, SmsCode);

        //return $this->buildSuccess(['Message'=>'OK','code'=>session('sms_code')]);
        return $this->buildSuccess($sms);
    }

    /**
     * 开码下单前检测接口
     */
    public function pay(){
        $str = $this->request->post();
        if(!preg_match("/^[\x{4e00}-\x{9fa5}]+$/u",$str['name'])){
            return $this->buildFailed(500,'姓名不能含特殊字符');
        }

        //检查验证码
        if ($str['sms'] != session('sms_code')) {
            return $this->buildFailed(500,'验证码错误');
        }

        //检查手机号码
        $check_phone=Db::name('user')->where('phone', $str['phone'])->count();
        if($check_phone == 1){
            return $this->buildFailed(500,'手机号已存在');
        }

        //检查邀请码
        $code=Db::name('user')->field('username')->where('code', $str['code'])->find();
        if ($code > 0) {
            return $this->buildSuccess($code['username']);
        } else {
            return $this->buildFailed(500,'邀请码不存在');
        }
    }

    /** 微信下单接口
     * @return \think\response\Json
     * @throws \WeChat\Exceptions\InvalidResponseException
     * @throws \WeChat\Exceptions\LocalCacheException
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function WeChatPay(){
        $str = $this->request->post();

        $pay = new \WeChat\Pay($this->config);

        //查询当前是否开启开码0.01活动
        if( Db::name('re')->find()['status'] == 2 ){
            $money=299;
        }else{
            $money=0.01;
        }

        //查询当前下单用户信息用户信息
        $user=Db::name('user')->where('openid',$str['openid'])->find();
        //请求参数
        $option = [
            //随机字符串
            'nonce_str' => $this->srt(),
            //商品描述
            'body' => '管家开码',
            //订单号
            'out_trade_no' => $this->out_trade_no(),
            //金额
            'total_fee' => $money*100,
            //终端ip
            'spbill_create_ip' => '127.0.0.1',
            //通知地址
            'notify_url' => AdminUrl().'/api/5bfe08e5a7edc',
            //交易类型
            'trade_type' => 'JSAPI',
            //下单用户openid
            'openid' => $str['openid'],

            //额外参数 真实姓名-手机号-地址-code-id-微信用户名-支付金额
            'attach' => "{$str['name']}-{$str['phone']}-{$str['address']}-{$str['code']}-{$user['id']}-f-{$money}",
        ];

        //下单
        $pay = $pay->createOrder($option);

        //下单成功,二次签名
        if ($pay['return_code'] == 'SUCCESS' && $pay['return_msg'] == "OK") {

            //返回支付参数
            $data = $this->api($pay['prepay_id']);

            //附加额外下单参数一起返回
            $data['out_trade_no'] = $option['out_trade_no'];

            return $this->buildSuccess($data);

        } else {
            return $this->buildFailed(500,'下单失败,请稍后再试');
        }

    }

    /** 创建JsApi及H5支付参数
     * @param $id
     * @return array
     */
    public function api($id)
    {
        $api = new \WeChat\Pay($this->config);
        $config = $api->createParamsForJsApi($id);
        return $config;
    }


    /**
     * 随机字符串
     */
    public function srt()
    {
        $str = '0123456789abcdefghijklmnopqrstuvwxyz';
        $str = str_shuffle($str);
        $str = substr($str, 1, 15);
        cookie('nonce_str', $str);
        return $str;
    }

    /**
     * 订单号
     */
    public function out_trade_no()
    {
        $str = '订单号';
        $str = md5($str) . time();
        $str = str_shuffle($str);
        $str = substr($str, 10, 25);
        $str=$str.rand(1000,999).session('id');
        return $str;
    }

    /** 开码成功回调
     * @return string|void
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function Callback()
    {

        //开启事务
        Db::startTrans();
        try {

            //获取返回的xml
            $testxml = file_get_contents("php://input");

            //将xml转化为json格式
            $jsonxml = json_encode(simplexml_load_string($testxml, 'SimpleXMLElement', LIBXML_NOCDATA));

            //将json转换为数组
            $arr = json_decode($jsonxml, true);


            //查询是有重复订单
            if (Db::name('sale')->where(['transaction_id' => $arr['transaction_id'], 'out_trade_no' => $arr['out_trade_no']])->count() > 0) {
                $xml = "<xml>
            <return_code><![CDATA[SUCCESS]]></return_code>
            <return_msg><![CDATA[OK]]></return_msg>
            </xml>";
                return $xml;
            }


            //获取下单时的额外参数
            $attach = explode('-', $arr['attach']);

            //真实姓名
            $uname = $attach[0];

            //手机号
            $phone = $attach[1];

            //地址
            $address = $attach[2];

            //code
            $ucode = $attach[3];

            //id
            $id = $attach[4];

            //金额
            $num=$attach[6];

//            $data=$this->request->post();
//            $id = session('id');

            //生成自己的邀请码
            $code = code();

            if ($ucode == 0) {
                //提升等级为新管家
                Db::name('User')->where('id', $id)->update(['exp' => 2, 'code' => $code, 'uname' => $uname, 'phone' => $phone, 'address' => $address]);
            } else {
                //查询当前code的 用户信息
                $codeid = Db::name('user')->where('code', $ucode)->find();

                $fid = $codeid['id'];
                $sid = $codeid['fid'];
                //提升等级为新管家
                Db::name('User')->where('id', $id)->update(['fid' => $fid, 'sid' => $sid, 'exp' => 2, 'code' => $code, 'uname' => $uname, 'phone' => $phone, 'address' => $address]);
            }


            $user = Db::name('User')->find($id);


            //添加开码数据记录
            $km = array(
                'uid' => $id,
                'username' => $user['username'],
                'money' => $num,
                'status' => 1,
                'type' => 1,//开码
                'zf_type' => 2,//微信支付
                'time' => date('Y-m-d H:i:s'),
                'transaction_id' => $arr['transaction_id'],//微信单号
                'out_trade_no' => $arr['out_trade_no'],//商户单号
            );
            Db::name('Sale')->insert($km);


            //读取提成配置
            $extract = Db::name('ExtractConfig')->select();
            foreach ($extract as $k => $v) {
                $extract_config[$v['name']] = $v['value'];
            }

            //上级返现
            //匹配直接推荐人
            if ($user['fid'] != 0) {
                $fuser = Db::name('User')->find($user['fid']);
                if ($fuser) {

                    if (re() == 2) {


                        //根据直接推荐人等级返现
                        $zjfanxian = array(
                            'uid' => $user['id'],
                            'username' => $user['username'],
                            'tid' => $fuser['id'],
                            'tusername' => $fuser['username'],
                            'status' => 2,
                            'type' => 5,//直接推荐返现
                            'time' => date('Y-m-d H:i:s'),
                            'out_trade_no' => $this->out_trade_no()
                        );
                        if ($fuser['exp'] == 2) {
                            //管家(gj_zj_fx)+150
                            Db::name('User')->where('id', $fuser['id'])->update(['money' => $fuser['money'] + $extract_config['gj_zj_fx']]);
                            $zjfanxian['money'] = $extract_config['gj_zj_fx'];
                        } elseif ($fuser['exp'] == 3) {
                            //大管家(dgj_zj_fx)+210
                            Db::name('User')->where('id', $fuser['id'])->update(['money' => $fuser['money'] + $extract_config['dgj_zj_fx']]);
                            $zjfanxian['money'] = $extract_config['dgj_zj_fx'];
                        } elseif ($fuser['exp'] == 4) {
                            //连创人(lcr_zj_fx)+250
                            Db::name('User')->where('id', $fuser['id'])->update(['money' => $fuser['money'] + $extract_config['lcr_zj_fx']]);
                            $zjfanxian['money'] = $extract_config['lcr_zj_fx'];
                        }
                        //添加直接推荐返现记录数据
                        Db::name('Sale')->insert($zjfanxian);

                        //发送微信消息
                        $uname = Db::name('User')->where('id', $user['fid'])->value('username');
                        $name = Db::name('User')->where('id', $id)->value('username');
                        $openid = Db::name('User')->where('id', $user['fid'])->value('openid');
                        $title = "亲爱的'{$uname}',您的下级用户中'{$name}'开码成功，您得到返现{$zjfanxian['money']}元!";
                        $code = $zjfanxian['out_trade_no'];
                        $money = '299';
                        $money2 = $zjfanxian['money'];
                        $time = date('Y-m-d H:i:s');
                        //$temp = new Template();
                        //$temp->Fanxian($openid, $title, $code, $money, $money2, $time);

                        //间接返现
                        if ($fuser['fid'] != 0) {
                            //匹配间接推荐人
                            $suser = Db::name('User')->find($fuser['fid']);
                            $jjfanxian = array(
                                'uid' => $user['id'],
                                'username' => $user['username'],
                                'tid' => $suser['id'],
                                'tusername' => $suser['username'],
                                'status' => 2,
                                'type' => 6,//间接推荐返现
                                'time' => date('Y-m-d H:i:s'),
                                'out_trade_no' => $this->out_trade_no()
                            );
                            //根据间接推荐人等级返现
                            if ($suser['exp'] == 3) {
                                //大管家(dgj_jj_fx)+30
                                Db::name('User')->where('id', $suser['id'])->update(['money' => $suser['money'] + $extract_config['dgj_jj_fx']]);
                                $jjfanxian['money'] = $extract_config['dgj_jj_fx'];
                                //添加间接推荐返现记录数据
                                Db::name('Sale')->insert($jjfanxian);
                            } elseif ($suser['exp'] == 4) {
                                //连创人(lcr_jj_fx)+60
                                Db::name('User')->where('id', $suser['id'])->update(['money' => $suser['money'] + $extract_config['lcr_jj_fx']]);
                                $jjfanxian['money'] = $extract_config['lcr_jj_fx'];
                                //添加间接推荐返现记录数据
                                Db::name('Sale')->insert($jjfanxian);
                            }

                            //发送微信消息
                            $uname = Db::name('User')->where('id', $suser['id'])->value('username');
                            $name = Db::name('User')->where('id', $id)->value('username');
                            $openid = Db::name('User')->where('id', $suser['id'])->value('openid');
                            $title = "亲爱的'{$uname}',您的间接用户中'{$name}'开码成功，您得到返现{$jjfanxian['money']}元!";
                            $code = $jjfanxian['out_trade_no'];
                            $money = '299';
                            $money2 = $jjfanxian['money'];
                            $time = date('Y-m-d H:i:s');
                            //$temp = new Template();
                            //$temp->Fanxian($openid, $title, $code, $money, $money2, $time);
                        }

                        //团队返现
                        if ($user['vid'] != 0) {
                            //有团队
                            $fanxian = new Fandian();
                            $fanxian->id = $user['id'];
                            $fanxian->vuser($user['vid']);
                        }
                    }

                    //推荐人推荐人数+1
                    Db::name('User')->where('id', $fuser['id'])->update(['rem_num' => $fuser['rem_num'] + 1]);
                    //推荐人邀请人数达到标准推荐人等级提升
                    $rem_num = Db::name('User')->where('id', $fuser['id'])->value('rem_num');
                    //管家升级为大管家
                    if ($rem_num == 30) {
                        if(Db::name('User')->where('id', $fuser['id'])->value('exp')==2){
                            //升级为大管家
                            $exp = Db::name('User')->where('id', $fuser['id'])->update(['exp' => 3]);

                            //发送微信消息
                            $openid = $fuser['openid'];
                            $title = "恭喜您,升级成为大管家";
                            $uname = $fuser['username'];
                            $time = date('Y-m-d H:i:s');
                            $up = new Template();
                            $up->up($openid, $title, $uname, $time);

                            //如果有大管家产生，则看是否有联创人产生
                            if ($exp) {
                                //查询大管家是否有父级
                                $fid = Db::name('User')->where('id', $fuser['id'])->value('fid');
                                if ($fid) {
                                    $use = Db::name('User')->where('id', $fid)->find();
                                    //查询大管家父级等级
                                    $fexp = Db::name('User')->where('id', $fid)->value('exp');
                                    if ($fexp == 3) {
                                        //判断大管家父级下面的大管家是否满足15名
                                        $num = Db::name('User')->where(['fid' => $fid, 'exp' => 3])->count();
                                        if ($num == 15) {
                                            if(Db::name('User')->where('id', $fuser['id'])->value('exp')==3){
                                                //满足15名，大管家父级升级为联创人
                                                Db::name('User')->where('id', $fid)->update(['exp' => 4]);

                                                //发送微信消息
                                                $openid = $use['openid'];
                                                $title = "恭喜您,升级成为联创人";
                                                $uname = $use['username'];
                                                $time = date('Y-m-d H:i:s');
                                                //$up = new Template();
                                                //$up->up($openid, $title, $uname, $time);

                                                //有联创人产生时，生成团队
                                                $this->createteam($fid);
                                            }
                                        }
                                    }
                                }

                                //判断该大管家下面的大管家是否满足15名
                                $num = Db::name('User')->where(['fid' => $fuser['id'], 'exp' => 3])->count();
                                if ($num >= 15) {
                                    if(Db::name('User')->where('id', $fuser['id'])->value('exp')==3){
                                        //满足15名，大管家升级为联创人
                                        Db::name('User')->where('id', $fuser['id'])->update(['exp' => 4]);

                                        //发送微信消息
                                        $openid = $fuser['openid'];
                                        $title = "恭喜您,升级成为联创人";
                                        $uname = $fuser['username'];
                                        $time = date('Y-m-d H:i:s');
                                        //$up = new Template();
                                        //$up->up($openid, $title, $uname, $time);

                                        //有联创人产生时，生成团队
                                        $this->createteam($fuser['id']);
                                    }
                                }
                            }
                        }
                    }
                }
            }

            //提交事务
            Db::commit();

        } catch (\Exception $e) {
            //回滚事务
            Db::rollback();
            //throw new InvalidArgumentException($e);
            return;
        }

        //开码成功微信通知
        //$user = Db::name('user')->where('id', $id)->find();
        //$up = new Template();
        //$up->up($user['openid'], "恭喜您,开码成功,成为新管家", $user['username'], date('Y-m-d H:i:s'));

        $xml = "<xml>
            <return_code><![CDATA[SUCCESS]]></return_code>
            <return_msg><![CDATA[OK]]></return_msg>
            </xml>";
        return $xml;


    }

    /** 创建团队
     * @param $id
     */
    public function createteam($id)
    {
        //找出下面所有用户
        $str = rtrim(GetDiguiId($id), ',');
        $str_arr = explode(',', $str);
        unset($str_arr[0]);
//        print_r($str);exit;
        $user = Db::name('User')->whereIn('id', $str_arr)->field('id,vid')->select();
//        print_r($user);
        foreach ($user as $k => $v) {
            //没有团队时，团队为联创人
            if ($v['vid'] == 0) {
                Db::name('User')->where('id', $v['id'])->update(['vid' => $id]);
            } else {
                //存在团队时
                if (!in_array($v['vid'], $str_arr)) {
                    Db::name('User')->where('id', $v['id'])->update(['vid' => $id]);
                }
            }
        }
    }

    /**
     * 查询支付结果
     */
    public function query()
    {
        $data = $this->request->post();

        if (Db::name('sale')->where(['out_trade_no' => $data['out_trade_no']])->count() > 0) {

            return $this->buildSuccess('支付成功');
        } else {
            return $this->buildFailed(500,'查询订单不存在');
        }

    }

}