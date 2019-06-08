<?php

namespace app\api\controller;


use think\Db;

class Card extends Base
{
    /**
     * 银行卡
     */
    public function index()
    {
        $openid=$_POST['openid'];
        $data=Db::name('user')->field('card,card_name')->where('openid',$openid)->find();
        return $this->buildSuccess($data);
    }

    /**
     * 绑定银行卡
     */
    public function bind()
    {
        //获取参数
        $post = $this->request->post();
        if(!isset($post['name'])){
            return $this->buildFailed(500,'请输入姓名');
        }
        if(!isset($post['card'])){
            return $this->buildFailed(500,'请输入卡号');
        }
        $db=Db::name('user')->where('openid',$post['openid'])->strict(false)->update(['card_name'=>$post['name'],'card'=>$post['card']]);
        if($db>0){
            $data=[
                'msg'=>'绑定成功'
            ];
            return $this->buildSuccess($data);
        }else{
            return $this->buildFailed(500,'绑定失败');
        }
    }
}
