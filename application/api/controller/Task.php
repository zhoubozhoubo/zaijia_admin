<?php

namespace app\api\controller;

use app\admin\model\ZjCommissionConf;
use app\api\model\ZjCommission;
use app\api\model\ZjTask;
use app\api\model\ZjUser;
use app\api\model\ZjUserIncome;
use app\api\model\ZjUserTask;
use app\util\ReturnCode;
use think\Db;

/**
 * 任务Controller
 * Class Task
 * @package app\api\controller
 */
class Task extends Base
{
    /**
     * 任务列表
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function taskList()
    {
        $this->requestType('GET');
        $getData = $this->request->get();
        $where = [
            'status' => 1,
            'is_delete' => 0
        ];
        if($getData['city']){
            $where['city'] = $getData['city'];
        }
        switch ($getData['order']){
            case 0: //默认排序
                $order='gmt_create DESC';
                break;
            case 1: //价格高->低
                $order='money DESC';
                break;
            case 2: //价格低->高
                $order='money ASC';
                break;
            case 3: //最新发布
                $order='gmt_create DESC';
                break;
            case 4: //人气
                $order='surplus_number ASC';
                break;
            default:
                $order = '';
        }

        $res = ZjTask::where($where)
            ->field('task_id,task_type_id,title,money,number,have_number,(number-have_number) as surplus_number')
            ->where('number - have_number','>',0)
            ->order($order)
            ->paginate();
        if (!$res) {
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND, '记录未找到', '');
        }
        foreach ($res as &$item){
            $item->taskType;
        }
        return $this->buildSuccess($res);
    }

    /**
     * 任务详情
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function taskDetails(){
        $this->requestType('POST');
        $taskId = $this->request->post('task_id');
        $where = [
            'status' => 1,
            'is_delete' => 0
        ];
        $res = ZjTask::where($where)->field('status,gmt_create,gmt_modified,is_delete', true)->find($taskId);
        if (!$res) {
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND, '记录未找到', '');
        }
        //用户登录状态判断
        if($this->userInfo){
            //用户已登录，对当前任务进行状态判断
            $where=[
                'task_id'=>$taskId,
                'user_id'=>$this->userInfo['user_id']
            ];
            //判断任务是否可重复
            if ($res['is_repeat']) {
                //可重复
                //查找当前用户是否已领取过该任务
                $userTaskNum = ZjUserTask::where($where)->count();
                if ($userTaskNum > 0) {
                    //判断当前用户该任务是否存在状态
                    $userTask = ZjUserTask::where($where)->where(['status' => ['in', '0,1']])->field('id,submit_time,status,gmt_create')->find();
                    if ($userTask) {
                        $res['status'] = $userTask['status'];
                        $surplusTime = 0;
                        if ($userTask['status'] == 0) {
                            //执行中返回执行剩余时间
                            $finishDuration = $res['finish_duration'] * 60 * 60;
                            $surplusTime = $finishDuration - (time() - strtotime($userTask['gmt_create']));
                            //当时间小于0时，表示执行阶段已结束，进行订单放弃处理
                            if ($surplusTime <= 0) {
                                ZjUserTask::update(['id' => $userTask['id'], 'status' => 4]);
                                $res['status'] = 4;
                                //任务已领取数量自减
                                ZjTask::where(['task_id'=>$res['task_id']])->setDec('have_number');
                            }
                        } else if ($userTask['status'] == 1) {
                            //执行中返回审核剩余时间
                            $checkDuration = $res['check_duration'] * 60 * 60;
                            $surplusTime = $checkDuration - (time() - strtotime($userTask['submit_time']));
                            //当时间小于0时，表示审核阶段已结束，进行订单自动通过处理
                            if ($surplusTime <= 0) {
                                ZjUserTask::update(['id' => $userTask['id'],'check_time'=>date('Y-m-d H:i:s'), 'status' => 2]);
                                $res['status'] = 2;
                                // TODO 用户收入，佣金记录
                                $this->commissionShare($userTask['id']);
                            }
                        }
                        $res['user_task_id'] = $userTask['id'];
                        $res['surplus_time'] = $surplusTime * 1000;
                        //执行中、待审核时无法领取
                        $res['can_receive'] = 0;
                    } else {
                        $res['can_receive'] = 1;
                    }
                } else {
                    $res['can_receive'] = 1;
                }
            }else{
                //不可重复
                //查找当前用户是否已领取过该任务
                $userTaskNum = ZjUserTask::where($where)->where('status', 'neq', 4)->count();
                if ($userTaskNum > 0) {
                    //判断当前用户该任务状态
                    $userTask = ZjUserTask::where($where)->where('status', 'neq', 4)->field('id,task_id,submit_time,status,gmt_create')->find();
                    $surplusTime = 0;
                    if ($userTask['status'] == 0) {
                        //执行中返回执行剩余时间
                        $finishDuration = $res['finish_duration'] * 60 * 60;
                        $surplusTime = $finishDuration - (time() - strtotime($userTask['gmt_create']));
                        //当时间小于0时，表示阶段已结束，进行订单放弃处理
                        if ($surplusTime <= 0) {
                            ZjUserTask::update(['id' => $userTask['id'], 'status' => 4]);
                            //任务已领取数量自减
                            ZjTask::where(['task_id' => $userTask['task_id']])->setDec('have_number');
                        }
                    } else if ($userTask['status'] == 1) {
                        //执行中返回审核剩余时间
                        $checkDuration = $res['check_duration'] * 60 * 60;
                        $surplusTime = $checkDuration - (time() - strtotime($userTask['submit_time']));
                        //当时间小于0时，表示阶段已结束，进行订单自动通过处理
                        if ($surplusTime <= 0) {
                            ZjUserTask::update(['id' => $userTask['id'], 'status' => 2]);
                        }
                    }
                    $res['user_task_id'] = $userTask['id'];
                    $res['surplus_time'] = $surplusTime * 1000;
                    $res['status'] = $userTask['status'];
                    $res['can_receive'] = 0;


                }else{
                    $res['can_receive'] = 1;
                }
            }
        }else{
            //用户未登录，当前任务可领取
            $res['can_receive'] = 1;
        }
        return $this->buildSuccess($res);
    }


    /**
     * 佣金分享
     * @param $user_task_id
     * @return mixed
     */
    public function commissionShare($user_task_id){
        // 启动事务
        Db::startTrans();
        try {
            //用户任务数据
            $userTask = ZjUserTask::where(['id'=>$user_task_id])->field('user_id,task_id')->find();
            //任务数据
            $task = ZjTask::where(['task_id'=>$userTask['task_id']])->field('money,task_id')->find();
            //用户数据
            $user = ZjUser::where(['user_id'=>$userTask['user_id'],'is_delete'=>0])->field('superior_user_id,superior_superior_user_id,user_id')->find();
            //任务金额
            $money = $task['money'];
            //一级佣金比例
            $commissionConf = ZjCommissionConf::where(['level'=>1])->value('value');
            //一级佣金数据
            $oneCommission = [
                'type'=>1,
                'user_id'=>$user['superior_user_id'],
                'money'=>$task['money'] * $commissionConf/100,
                'from_user_id'=>$user['user_id'],
                'task_id'=>$task['task_id']
            ];
            //剩余任务金额
            $money -=$oneCommission['money'];
            if($user['superior_user_id'] !== 0){
                //存在上级 TODO 上级分享一级佣金
                //添加佣金数据
                ZjCommission::create($oneCommission);
                //上级增加金额
                ZjUser::where(['user_id'=>$user['superior_user_id']])->setInc('money',$oneCommission['money']*100);
            }
            //二级佣金比例
            $commissionConf = ZjCommissionConf::where(['level'=>2])->value('value');
            //二级佣金数据
            $twoCommission = [
                'type'=>2,
                'user_id'=>$user['superior_superior_user_id'],
                'money'=>$task['money'] * $commissionConf/100,
                'from_user_id'=>$user['user_id'],
                'task_id'=>$task['task_id']
            ];
            //剩余任务金额
            $money-=$twoCommission['money'];
            //添加佣金数
            if($user['superior_superior_user_id'] !== 0){
                //存在上上级 TODO 上上级分享二级佣金据
                ZjCommission::create($twoCommission);
                //上上级增加金额
                ZjUser::where(['user_id'=>$user['superior_superior_user_id']])->setInc('money',$twoCommission['money']*100);
            }
            //添加用户收入数据
            $userIncome = [
                'user_id'=>$user['user_id'],
                'task_id'=>$task['task_id'],
                'money'=>$money
            ];
            ZjUserIncome::create($userIncome);
            //用户增加金额
            ZjUser::where(['user_id'=>$user['user_id']])->setInc('money',$money*100);
            // 提交事务
            Db::commit();
        } catch (\Exception $e) {
            // 回滚事务
            Db::rollback();
            return $this->buildFailed('');
        }


    }









}
