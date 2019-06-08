<?php
namespace app\api\model;

use think\Model;


/** 微信通知
 * Class Template
 * @package app\index\model
 */
class Template extends Model {


    //初始化配置
    public $config = [
        'appid' => 'wx5dea67cc0fa4cbc7',
        'appsecret' => 'e1728bf7ef804d43b092a10b3bb1f3d3',
    ];

    /** 货款通知
     * @param $openid
     * @param $title    通知标题
     * @param $code     订单号
     * @param $money    支付金额
     * @param $money2   到账金额
     * @param $time     日期
     *
     *    亲爱的从前从前，您的货款已收到！我们会尽快给您安排发货，请耐心等候！
     *    订单编号：171524894553
     *    支付金额：100
     *    到账金额：100
     *    支付时间：2018年5月2日 10:36
     *    一起购
     *
     *   {{first.DATA}}
     *   订单编号：{{keyword1.DATA}}
     *   支付金额：{{keyword2.DATA}}
     *   到账金额：{{keyword3.DATA}}
     *   支付时间：{{keyword4.DATA}}
     *   {{remark.DATA}}
     *
     */
    public function payment($openid,$title,$code,$money,$money2,$time){

        $tpl=new \WeChat\Template($this->config);

        $data=[
            'touser'=>$openid,//接收消息用户id
            'template_id'=>'_hlan9FA08jCTTO2K4GiElp0j-UqEPaiYr5QQPecphk',//消息模板id
            'miniprogram'=>[
                'appid'=>'',
                'pagepath'=>'',
            ],
            'data'=>[
                //标题
                'first'=>[
                    'value'=>$title,
                    'color'=>'#173177'
                ],
                //订单编号
                'keyword1'=>[
                    'value'=>$code,
                    'color'=>'#173177'
                ],
                //支付金额
                'keyword2'=>[
                    'value'=>number_format($money,2,'.',''),
                    'color'=>'#173177'
                ],
                //到账金额
                'keyword3'=>[
                    'value'=>number_format($money2,2,'.',''),
                    'color'=>'#173177'
                ],
                //支付时间
                'keyword4'=>[
                    'value'=>format_datetime($time),
                    'color'=>'#173177'
                ],
                //底部内容
                'remark'=>[
                    'value'=>'一起购品质馆',
                    'color'=>'#173177'
                ]
            ]
        ];

        $tpl->send($data);
    }


    /** 升级通知
     * @param $openid   openid
     * @param $title    通知标题
     * @param $username 用户名
     * @param $time     日期
     *
     * 恭喜您升级为新管家！
     * 会员昵称：tomcat
     * 生效时间：2014-07-21 18:36
     * 一起购
     *
     * {{first.DATA}}
     * 会员昵称：{{keyword1.DATA}}
     * 生效时间：{{keyword2.DATA}}
     * {{remark.DATA}}
     *
     *
     */
    public function up($openid,$title,$username,$time){

        $tpl=new \WeChat\Template($this->config);

        $data=[
            'touser'=>$openid,//接收消息用户id
            'template_id'=>'82quj2ZEC8VI8Wa9Yur5bh01qDSfHSu8B-jxCON1cRw',//消息模板id
            'miniprogram'=>[
                'appid'=>'',
                'pagepath'=>'',
            ],
            'data'=>[
                //标题
                'first'=>[
                    'value'=>$title,
                    'color'=>'#173177'
                ],
                //用户名
                'keyword1'=>[
                    'value'=>$username,
                    'color'=>'#173177'
                ],
                //日期
                'keyword2'=>[
                    'value'=>format_datetime($time),
                    'color'=>'#173177'
                ],
                //底部内容
                'remark'=>[
                    'value'=>'一起购品质馆',
                    'color'=>'#173177'
                ]
            ]
        ];

        $tpl->send($data);
    }


    /** 返点通知
     * @param $openid   openid
     * @param $title    标题
     * @param $code     订单号
     * @param $money    订单金额
     * @param $money2   返点金额
     * @param $time     日期
     *
     * 您好，您的管家从前从前又出单啦！
     * 订单号：201502078888
     * 订单金额：888元
     * 返现金额：20元
     * 一起购
     *
     *
     * {{first.DATA}}
     * 订单号：{{keyword1.DATA}}
     * 订单金额：{{keyword2.DATA}}
     * 分成金额：{{keyword3.DATA}}
     * 时间：{{keyword4.DATA}}
     * {{remark.DATA}}
     *
     *
     */
    public function Extract($openid,$title,$code,$money,$money2,$time){
        $tpl=new \WeChat\Template($this->config);

        $data=[
            'touser'=>$openid,//接收消息用户id
            'template_id'=>'4Rn2x_sbSJo70CgSRnswOuIvDSHBtc1FKdnUCTCXOvA',//消息模板id
            'miniprogram'=>[
                'appid'=>'',
                'pagepath'=>'',
            ],
            'data'=>[
                //标题
                'first'=>[
                    'value'=>$title,
                    'color'=>'#173177'
                ],
                //订单号
                'keyword1'=>[
                    'value'=>$code,
                    'color'=>'#173177'
                ],
                //支付金额
                'keyword2'=>[
                    'value'=>number_format($money,2,'.',''),
                    'color'=>'#173177'
                ],
                //到账金额
                'keyword3'=>[
                    'value'=>number_format($money2,2,'.',''),
                    'color'=>'#173177'
                ],
                //日期
                'keyword4'=>[
                    'value'=>format_datetime($time),
                    'color'=>'#173177'
                ],
                //底部内容
                'remark'=>[
                    'value'=>'一起购品质馆',
                    'color'=>'#173177'
                ]
            ]
        ];

        $tpl->send($data);
    }


    /** 返现通知
     * @param $openid   openid
     * @param $title    标题
     * @param $code     订单号
     * @param $money    订单金额
     * @param $money2   返点金额
     * @param $time     日期
     *
     * 您好，您的管家从前从前又出单啦！
     * 订单号：201502078888
     * 订单金额：888元
     * 返现金额：20元
     * 一起购
     *
     *
     * {{first.DATA}}
     * 订单号：{{keyword1.DATA}}
     * 订单金额：{{keyword2.DATA}}
     * 分成金额：{{keyword3.DATA}}
     * 时间：{{keyword4.DATA}}
     * {{remark.DATA}}
     *
     *
     */
    public function Fanxian($openid,$title,$code,$money,$money2,$time){
        $tpl=new \WeChat\Template($this->config);

        $data=[
            'touser'=>$openid,//接收消息用户id
            'template_id'=>'4Rn2x_sbSJo70CgSRnswOuIvDSHBtc1FKdnUCTCXOvA',//消息模板id
            'miniprogram'=>[
                'appid'=>'',
                'pagepath'=>'',
            ],
            'data'=>[
                //标题
                'first'=>[
                    'value'=>$title,
                    'color'=>'#173177'
                ],
                //订单号
                'keyword1'=>[
                    'value'=>$code,
                    'color'=>'#173177'
                ],
                //支付金额
                'keyword2'=>[
                    'value'=>number_format($money,2,'.',''),
                    'color'=>'#173177'
                ],
                //到账金额
                'keyword3'=>[
                    'value'=>number_format($money2,2,'.',''),
                    'color'=>'#173177'
                ],
                //日期
                'keyword4'=>[
                    'value'=>format_datetime($time),
                    'color'=>'#173177'
                ],
                //底部内容
                'remark'=>[
                    'value'=>'一起购品质馆',
                    'color'=>'#173177'
                ]
            ]
        ];

        $tpl->send($data);
    }


}
