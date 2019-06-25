<?php
namespace app\model;

use think\Model;


/**
 * 微信通知
 * Class Template
 * @package app\model
 */
class Template extends Model {

    public $withdrawTempId = '_5IV3WZ170DCTUimJjtccVDIVIS1I5In9yavQ_2zs-o';    //提现通知

    //初始化配置
    public $config = [
        'appid' => 'wxc5b8b08c2e2b506f',
        'appsecret' => '3e0301d69ff031f7c7024e2c01ce05ea'
    ];

    /**
     * 提现成功通知
     *
     * {{first.DATA}}
     * 时间：{{keyword1.DATA}}
     * 金额：{{keyword2.DATA}}
     * {{remark.DATA}}
     *
     * @param $openid
     * @param $money
     * @throws \WeChat\Exceptions\InvalidResponseException
     * @throws \WeChat\Exceptions\LocalCacheException
     */
    public function withdrawSuccess($openid,$money){
        $tpl=new \WeChat\Template($this->config);
        $data=[
            'touser'=>$openid,
            'template_id'=>$this->withdrawTempId,
            'data'=>[
                //标题
                'first'=>[
                    'value'=>'尊敬的合伙人：恭喜您！您的提现申请已通过审核，我们将在24小时内将提现税后金额转入您的支付宝账号，请您及时查收！若有疑问请联系客服(QQ2332155808).',
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
                    'value'=>'邀请好友，您将获得更多佣金！',
                    'color'=>'#173177'
                ]
            ]
        ];
        $tpl->send($data);
    }

    /**
     * 提现失败通知
     *
     * {{first.DATA}}
     * 时间：{{keyword1.DATA}}
     * 金额：{{keyword2.DATA}}
     * {{remark.DATA}}
     *
     * @param $openid
     * @param $money
     * @throws \WeChat\Exceptions\InvalidResponseException
     * @throws \WeChat\Exceptions\LocalCacheException
     */
    public function withdrawFail($openid,$money){
        $tpl=new \WeChat\Template($this->config);
        $data=[
            'touser'=>$openid,
            'template_id'=>$this->withdrawTempId,
            'data'=>[
                //标题
                'first'=>[
                    'value'=>'尊敬的合伙人：您的提现申请未通过审核！若有疑问请联系客服(QQ2332155808).',
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
                    'value'=>'邀请好友，您将获得更多佣金！',
                    'color'=>'#173177'
                ]
            ]
        ];
        $tpl->send($data);
    }



}
