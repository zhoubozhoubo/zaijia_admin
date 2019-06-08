<?php

namespace app\api\controller;


use think\Db;

class Wallet extends Base
{

    public function index()
    {
        //查询用户id
        $id=Db::name('user')->where('openid',$_POST['openid'])->value('id');
        //用户余额
        $money=Db::name('User')->where('id',$id)->value('money');
        //累计提现
        $put_money=Db::name('Sale')->where(['uid' => $id, 'type' => 3])->sum('money');
        //组装数据
        $data = [
            'money' => number_format($money,2),
            'put_money' => number_format($put_money,2)
        ];
        return $this->buildSuccess($data);
    }
}
