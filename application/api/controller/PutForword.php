<?php

namespace app\api\controller;


use think\Db;

class PutForword extends Base
{

    /**
     * 提现首页
     */
    public function index()
    {
        //用户余额
        $money = Db::name('User')->where('openid', $_POST['openid'])->value('money');
        //单次最低提现金额
        $forward_once = extconf('forward_once');

        //组装数据
        $data = [
            'money' => $money,
            'forward_once' => $forward_once
        ];
        return $this->buildSuccess($data);
    }

    /**
     * 提现接口
     */
    public function put()
    {
        $post=$this->request->post();
        //查询用户ID
        $user = Db::name('User')->field('id,username')->where('openid', $post['openid'])->find();
        //查询当前用户是否绑定银行卡
        $card = Db::name('user')->where('id', $user['id'])->find();
        if ($card['card'] == "" || $card['card_name'] == "") {
            return $this->buildFailed(400,'还未绑定银行卡不能提现');
        }
        //开启事务
        Db::startTrans();
        try {
            //查询当前余额
            $money=Db::name('User')->where('id', $user['id'])->value('money');
            if($post['money']>$money){
                return $this->buildFailed(500,'提现金额不能大于余额');
            }
            //用户余额减少
            $db = Db::name('user')->where('id', $user['id'])->setDec('money', $post['money']);
            if ($db > 0) {
                //生成提现记录
                $data = [
                    'uid' => $user['id'],
                    'username' => $user['username'],
                    'money' => $post['money'],
                    'time' => date('Y-m-d H:i:s'),
                    'status' => 1,
                    'type' => 3
                ];
                $in = Db::name('sale')->insert($data);
                //提交事务
                Db::commit();
                if ($in > 0) {
                    $data = [
                        'msg' => '提现成功'
                    ];
                    return $this->buildSuccess($data);
                } else {
                    return $this->buildFailed(500,'服务器繁忙,请稍后再试');
                }
            } else {
                return $this->buildFailed(500,'服务器繁忙,请稍后再试');
            }
        } catch (\Exception $e) {
            // 回滚事务
            Db::rollback();
            return $this->buildFailed(500,'服务器繁忙,请稍后再试');
        }
    }
}
