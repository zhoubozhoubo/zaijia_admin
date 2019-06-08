<?php
/**
 * Created by PhpStorm.
 * User: wj
 * Date: 2018/11/28
 * Time: 11:40
 */
namespace app\api\controller;
use app\api\model\Fandian;
use think\Db;

class Payment extends Base{

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

    /**
     * 查询今日销售冠军和当前用户余额
     */
    public function index(){
        $str=$this->request->post();
        //当前用户余额
        $money = Db::name('user')->where('openid',$str['openid'])->value('money');
        //今日销售冠军
        $max = Db::name('sale')->field('username,sum(money) as money')->whereTime('time', 'today')->where('type', 2)->order('money desc')->group('uid')->page(1, 1)->find();

        $data=[
            'money'=>$money,
            'max_name'=>$max['username']
        ];
        return $this->buildSuccess($data);
    }

    /** 余额支付
     * @return \think\response\Json
     */
    public function Blance(){
        $post = $this->request->post();
        $id = Db::name('user')->where('openid',$post['openid'])->value('id');
        //开启事务
        Db::startTrans();
        try {
            //余额支付
            //用户余额减少
            $money = Db::name('User')->where('id', $id)->value('money');
            Db::name('User')->where('id', $id)->update(['money' => $money - $post['money']]);
            $data = array(
                'uid' => $id,
                'username' => Db::name('User')->where('id', $id)->value('username'),
                'money' => $post['money'],
                'status' => 1,
                'type' => 2,//货款
                'zf_type'=>3,//余额支付
                'time' => date('Y-m-d H:i:s'),
                'out_trade_no'=>$this->out_trade_no()
            );
            //添加交易记录数据
            Db::name('Sale')->insert($data);

            //发送微信消息
            $uname=Db::name('User')->where('id',$id)->value('username');
            $openid=Db::name('User')->where('id',$id)->value('openid');
            $title="亲爱的'{$uname}'，您的货款已收到！我们会尽快给您安排发货，请耐心等候！";
            $code=$data['out_trade_no'];
            $money=$post['money'];
            $money2=$post['money'];
            $time=date('Y-m-d H:i:s');
            //$temp=new Template();
            //$temp->payment($openid,$title,$code,$money,$money2,$time);

            if ($post['money'] >= 1) {
                //返点
                $fandian = new Fandian();
                $fandian->id = $id;
                $fandian->money = $post['money'];
                $fandian->index();
            }

            // 提交事务
            Db::commit();
        } catch (\Exception $e) {
            // 回滚事务
            Db::rollback();

            return $this->buildFailed(500,'支付失败请稍后再试');
        }

        return $this->buildSuccess('支付成功');
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


    /** 统一下单
     * @return array
     */
    public function WeChatPay()
    {
        header("Access-Control-Allow-Origin:*");
        if ($this->request->isPost()) {


            $pay = new \WeChat\Pay($this->config);
            $post=$this->request->post();

            //金额
            $money = $post['money'] * 100;

            //用户id
            $id = Db::name('user')->where('openid',$post['openid'])->value('id');

            //请求参数
            $option = [
                //随机字符串
                'nonce_str' => $this->srt(),
                //商品描述
                'body' => '今日货款支付',
                //订单号
                'out_trade_no' => $this->out_trade_no(),
                //金额
                'total_fee' => $money,
                //终端ip
                'spbill_create_ip' => $_SERVER['SERVER_ADDR'],
                //通知地址
                'notify_url' => AdminUrl().'/api/5bfe131c96f60',
                //交易类型
                'trade_type' => 'JSAPI',
                //下单用户openid
                'openid' => $post['openid'],
                //额外参数 金额-用户id
                'attach' => "$money-$id",
            ];

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
        } else {
            return $this->buildFailed(500,'下单失败,请稍后再试');
        }

    }

    /** 微信异步通知地址
     * @return string|void
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function Callback()
    {

        if ($this->request->isPost()) {

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
            $wx_money = $attach[0] / 100;
            $id = $attach[1];


            //开启事务
            Db::startTrans();
            try {
                $data = array(
                    'uid' => $id,
                    'username' => Db::name('User')->where('id', $id)->value('username'),
                    'money' => $wx_money,
                    'status' => 1,
                    'type' => 2,//货款
                    'zf_type'=>2,//微信支付
                    'time' => date('Y-m-d H:i:s'),
                    'transaction_id' => $arr['transaction_id'],//微信单号
                    'out_trade_no' => $arr['out_trade_no'],//商户单号
                );
                //添加交易记录数据
                Db::name('Sale')->insert($data);

                if ($wx_money >= 1) {
                    //返点
                    $fandian = new Fandian();
                    $fandian->id = $id;
                    $fandian->money = $wx_money;
                    $fandian->index();
                }

                // 提交事务
                Db::commit();
            } catch (\Exception $e) {
                // 回滚事务
                Db::rollback();
                //throw new InvalidArgumentException($e);
                return;
            }

            //给下单用户发送货款消息
            //$user=Db::name('user')->field('username,openid')->where('id',$id)->find();

            //$up=new Template();
            //$up->payment($user['openid'],"亲爱的${user['username']}，您的货款已收到！我们会尽快给您安排发货，请耐心等候！",$arr['out_trade_no'],$wx_money,$wx_money,date('Y-m-d H:i:s'));

            //$data=['user'=>$user['username']];
            //Sms::sendMsg($user['phone'],$data,SmsPayemnt);

            $xml = "<xml>
            <return_code><![CDATA[SUCCESS]]></return_code>
            <return_msg><![CDATA[OK]]></return_msg>
            </xml>";

            return $xml;
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