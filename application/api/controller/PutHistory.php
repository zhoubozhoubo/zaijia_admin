<?php

namespace app\api\controller;


use think\Db;

class PutHistory extends Base
{

    public function index()
    {
        //获取参数
        $post = $this->request->post();
        $id=Db::name('user')->where('openid',$post['openid'])->value('id');
        //累计提现
        $money=Db::name('Sale')->where(['uid' => $id, 'type' => 3])->sum('money');
        //记录列表
        $list = Db::name('sale')->where(['uid'=>$id,'type'=>3])->page($post['page'], $post['limit'])->order('time desc')->select();
        //记录总条数
        $count = Db::name('sale')->where(['uid'=>$id,'type'=>3])->count();
        if(!isset($count)){
            $count=0;
        }
        //记录总页数
        $total_page = ceil($count / $post['limit']);
        //组装数据
        $data = [
            'list' => $list,
            'count' => $count,
            'total_page' => $total_page,
            'total_money'=>number_format($money,2)
        ];
        return $this->buildSuccess($data);
    }
}
