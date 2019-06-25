<?php
namespace app\model;

use think\Model;


/**
 * 微信通知
 * Class Template
 * @package app\model
 */
class Template extends Model {

    public $withdrawTempId = '';

    //初始化配置
    public $config = [
        'appid' => 'wxc5b8b08c2e2b506f',
        'appsecret' => '3e0301d69ff031f7c7024e2c01ce05ea'
    ];

    /**
     * 提现通知
     *
     * {{first.DATA}}
     * 时间：{{keyword1.DATA}}
     * 金额：{{keyword2.DATA}}
     * {{remark.DATA}}
     *
     * @param $openid
     * @param $title
     * @param $money
     * @param $content
     * @throws \WeChat\Exceptions\InvalidResponseException
     * @throws \WeChat\Exceptions\LocalCacheException
     */
    public function withdraw($openid,$title,$money,$content){
        $tpl=new \WeChat\Template($this->config);
        $data=[
            'touser'=>$openid,                       //接收消息用户id
            'template_id'=>$this->withdrawTempId,    //消息模板id
            'data'=>[
                //标题
                'first'=>[
                    'value'=>$title,
                    'color'=>'#173177'
                ],
                //时间
                'keyword1'=>[
                    'value'=>date('Y年m月d日 H:i:s'),
                    'color'=>'#173177'
                ],
                //金额
                'keyword2'=>[
                    'value'=>number_format($money,2,'.',''),
                    'color'=>'#173177'
                ],
                //底部内容
                'remark'=>[
                    'value'=>$content,
                    'color'=>'#173177'
                ]
            ]
        ];
        $tpl->send($data);
    }



}
