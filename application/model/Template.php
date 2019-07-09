<?php
namespace app\model;

use think\Model;
use WeChat\Oauth;


/**
 * 微信通知
 * Class Template
 * @package app\model
 */
class Template extends Model {

    public $withdrawTempId = '_5IV3WZ170DCTUimJjtccVDIVIS1I5In9yavQ_2zs-o';         //提现通知
    public $bindSuccessTempId = 'ZIf6WLjSQuAhO1IOxvY9PitPvAD90OAsIPSlkBU7qQc';      //下级用户绑定通知
    public $checkSuccessTempId = '3-mgaTvuTlTUm9WvEQhn2ell8oCr0rE9YOJ8MzP2wUw';     //审核通过通知
    public $checkFailTempId = 'v-X9w7YDg7Xht49HXdLkJsaw0-h9CHfsKhoHd1_CSFs';        //审核未通过通知

    //初始化配置
    public $config = [
        'appid' => 'wxc5b8b08c2e2b506f',
        'appsecret' => '3e0301d69ff031f7c7024e2c01ce05ea'
    ];

    public function checkSubscribe($openid){
        //检测用户是否关注公众号
        $Oauth = new Oauth($this->config);
        $userInfo = $Oauth->getUser($openid);
        return $userInfo['subscribe'];
    }

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
        if(!$this->checkSubscribe($openid)){
            return;
        }
        $tpl=new \WeChat\Template($this->config);
        $data=[
            'touser'=>$openid,
            'template_id'=>$this->withdrawTempId,
            'data'=>[
                //标题
                'first'=>[
                    'value'=>'尊敬的合伙人：恭喜您！您的提现申请已通过审核，我们将在24小时内将提现税后金额转入您的支付宝账号，请您及时查收！若有疑问请联系客服(QQ2332155808)',
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
        if(!$this->checkSubscribe($openid)){
            return;
        }
        $tpl=new \WeChat\Template($this->config);
        $data=[
            'touser'=>$openid,
            'template_id'=>$this->withdrawTempId,
            'data'=>[
                //标题
                'first'=>[
                    'value'=>'尊敬的合伙人：您的提现申请未通过审核！若有疑问请联系客服(QQ2332155808)',
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
     * 用户绑定成功
     *
     * {{first.DATA}}
     * 用户账号：{{keyword1.DATA}}
     * 绑定应用：{{keyword2.DATA}}
     * 绑定时间：{{keyword3.DATA}}
     * {{remark.DATA}}
     *
     * @param $openid
     * @param $nickname
     * @throws \WeChat\Exceptions\InvalidResponseException
     * @throws \WeChat\Exceptions\LocalCacheException
     */
    public function bindSuccess($openid,$nickname){
        if(!$this->checkSubscribe($openid)){
            return;
        }
        $tpl=new \WeChat\Template($this->config);
        $data=[
            'touser'=>$openid,
            'template_id'=>$this->bindSuccessTempId,
            'data'=>[
                //标题
                'first'=>[
                    'value'=>'尊敬的合伙人：恭喜您！有新成员加入了您的团队，请维护好成员关系，并引导新成员做任务，您将获得更多推广佣金，若有不明白请联系管理员(微信lipingyuan2018),会员信息如下：',
                    'color'=>'#173177'
                ],
                //用户账号
                'keyword1'=>[
                    'value'=>$nickname,
                    'color'=>'#173177'
                ],
                //绑定应用
                'keyword2'=>[
                    'value'=>'慧元财富',
                    'color'=>'#173177'
                ],
                //绑定时间
                'keyword3'=>[
                    'value'=>date('Y年m月d日 H:i:s'),
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
     *审核通过通知
     *
     * {{first.DATA}}
     * 订单号：{{keyword1.DATA}}
     * 通过时间：{{keyword2.DATA}}
     * {{remark.DATA}}
     *
     * @param $openid
     * @param $taskTitle
     * @throws \WeChat\Exceptions\InvalidResponseException
     * @throws \WeChat\Exceptions\LocalCacheException
     */
    public function checkSuccess($openid,$taskTitle){
        if(!$this->checkSubscribe($openid)){
            return;
        }
        $tpl=new \WeChat\Template($this->config);
        $data=[
            'touser'=>$openid,
            'template_id'=>$this->checkSuccessTempId,
            'data'=>[
                //标题
                'first'=>[
                    'value'=>'您提交的任务已通过雇主验收，请您再看看其他任务或邀请好友加入，您将获得更多佣金',
                    'color'=>'#173177'
                ],
                //订单号
                'keyword1'=>[
                    'value'=>$taskTitle,
                    'color'=>'#173177'
                ],
                //通过时间
                'keyword2'=>[
                    'value'=>date('Y年m月d日 H:i:s'),
                    'color'=>'#173177'
                ],
                //底部内容
                'remark'=>[
                    'value'=>'',
                    'color'=>'#173177'
                ]
            ]
        ];
        $tpl->send($data);
    }

    /**
     * 审核未通过通知
     *
     * {{first.DATA}}
     * 审核项目：{{keyword1.DATA}}
     * 存在问题：{{keyword2.DATA}}
     * 审核时间：{{keyword3.DATA}}
     * {{remark.DATA}}
     *
     * @param $openid
     * @param $taskTitle
     * @param $refuseText
     * @throws \WeChat\Exceptions\InvalidResponseException
     * @throws \WeChat\Exceptions\LocalCacheException
     */
    public function checkFail($openid,$taskTitle,$refuseText){
        $tpl=new \WeChat\Template($this->config);
        $data=[
            'touser'=>$openid,
            'template_id'=>$this->checkFailTempId,
            'data'=>[
                //标题
                'first'=>[
                    'value'=>'您提交的任务未通过雇主验收，请您再看看其他任务或邀请好友加入，您将获得更多佣金',
                    'color'=>'#173177'
                ],
                //审核项目
                'keyword1'=>[
                    'value'=>$taskTitle,
                    'color'=>'#173177'
                ],
                //存在问题
                'keyword2'=>[
                    'value'=>$refuseText,
                    'color'=>'#173177'
                ],
                //审核时间
                'keyword3'=>[
                    'value'=>date('Y年m月d日 H:i:s'),
                    'color'=>'#173177'
                ],
                //底部内容
                'remark'=>[
                    'value'=>'若有疑问请联系我的客服QQ2332155808进行咨询.',
                    'color'=>'#173177'
                ]
            ]
        ];
        $tpl->send($data);
    }



}
