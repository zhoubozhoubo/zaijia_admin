<?php

namespace app\api\controller;

use app\api\model\ZjUser;
use app\api\model\ZjWithdraw;
use app\api\model\ZjWithdrawWay;
use app\util\ReturnCode;
use think\Db;

/**
 * 用户提现Controller
 * Class UserWithDraw
 * @package app\api\controller
 */
class WithDraw extends Base
{

    /**
     * 提现列表
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function withdrawList(){
        $this->requestType('POST');
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $where = [
            'user_id'=>$this->userInfo['user_id'],
            'is_delete'=>0
        ];
        $res = ZjWithdraw::where($where)->field('gmt_modified,is_delete',true)->paginate();
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND,'记录未找到','');
        }
        foreach ($res as $item){
            $item->withdrawType;
        }
        return $this->buildSuccess($res);
    }

    /**
     * 添加提现申请
     * @return \think\response\Json
     * @throws \think\Exception
     */
    public function addWithdraw(){
        $this->requestType('POST');
        $money = $this->request->post('money','');
        $name = $this->request->post('name','');
        $account = $this->request->post('account','');
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        if($money===''){
            return $this->buildFailed(ReturnCode::PARAM_DEFECT, '缺少提现金额', '');
        }
        //提现方式信息
        $withdrawWay = ZjWithdrawWay::where(['withdraw_way_id'=>1,'status'=>1,'is_delete'=>0])->field('gmt_create,gmt_modified,is_delete',true)->find();
        //判断提现金额
        if($money<$withdrawWay['min_money']){
            return $this->buildFailed(ReturnCode::ADD_FAILED,'提现金额最低'.$withdrawWay['min_money'].'元','');
        }
        if($money > $withdrawWay['max_money']){
            return $this->buildFailed(ReturnCode::ADD_FAILED,'提现金额最高'.$withdrawWay['max_money'].'元','');
        }
        if($name===''){
            return $this->buildFailed(ReturnCode::PARAM_DEFECT, '缺少账户姓名', '');
        }
        if($account===''){
            return $this->buildFailed(ReturnCode::PARAM_DEFECT, '缺少帐号信息', '');
        }
        $userMoney = ZjUser::where(['user_id'=>$this->userInfo['user_id']])->value('money');
        if($money > $userMoney){
            return $this->buildFailed(ReturnCode::PARAM_DEFECT, '提现金额不能大于余额', '');
        }
        // 启动事务
        Db::startTrans();
        try {
            $data = [
                'user_id'=>$this->userInfo['user_id'],
                'money'=>$money,
                'withdraw_way_id'=>1,
                'name'=>$name,
                'account'=>$account
            ];
            $res = ZjWithdraw::create($data);
            //用户余额减少
            ZjUser::where(['user_id'=>$this->userInfo['user_id']])->setDec('money',$money*100);
            // 提交事务
            Db::commit();
            return $this->buildSuccess($res,'申请提现成功');
        } catch (\Exception $e) {
            // 回滚事务
            Db::rollback();
            return $this->buildFailed(ReturnCode::ADD_FAILED,'申请提现失败','');
        }

    }



}
