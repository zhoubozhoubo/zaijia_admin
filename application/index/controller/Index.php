<?php

namespace app\index\controller;

use app\index\model\ZjBasicConf;
use app\index\model\ZjTask;
use think\Controller;

class Index extends Controller
{
    public function index(){
        //微信公众号二维码
        $wechatQrCode =ZjBasicConf::where(['name' => 'wechat_qr_code'])->value('value');
        //兼职列表
        $where = [
            'status' => 1,
            'is_delete' => 0
        ];
        $jobs = ZjTask::where($where)
            ->field('task_id,task_type_id,title,money,number,have_number,(number-have_number) as surplus_number')
            ->where('number - have_number','>',0)
            ->order('gmt_create DESC')
            ->limit(10);
        $this->assign('wechatQrCode',$wechatQrCode);
        $this->assign('jobs',$jobs);
        return $this->fetch();
    }
}