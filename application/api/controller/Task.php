<?php

namespace app\api\controller;

use app\api\model\ZjTask;
use app\api\model\ZjUserTask;
use app\util\ReturnCode;

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
                        if ($userTask['status'] === 0 || $userTask['status'] === 1) {
                            $surplusTime = 0;
                            //执行中、待审核时无法领取
                            $res['can_receive'] = 0;
                            if ($userTask['status'] === 0) {
                                //执行中返回执行剩余时间
                                $finishDuration = $res['finish_duration'] * 60 * 60;
                                $surplusTime = $finishDuration - (time() - strtotime($userTask['gmt_create']));
                                //当时间小于0时，表示阶段已结束，进行订单放弃处理
                                if ($surplusTime <= 0) {
                                    ZjUserTask::update(['id' => $userTask['id'], 'status' => 4]);
                                }
                            } else if ($userTask['status'] === 1) {
                                //执行中返回审核剩余时间
                                $checkDuration = $res['check_duration'] * 60 * 60;
                                $surplusTime = $checkDuration - (time() - strtotime($userTask['submit_time']));
                                //当时间小于0时，表示阶段已结束，进行订单自动通过处理
                                if ($surplusTime <= 0) {
                                    ZjUserTask::update(['id' => $userTask['id'], 'status' => 2]);
                                }
                            }
                            $res['surplus_time'] = $surplusTime * 1000;
                        } else {
                            //已通过、未通过、已放弃时可领取
                            $res['can_receive'] = 1;
                        }
                        $res['user_task_id'] = $userTask['id'];
                        $res['status'] = $userTask['status'];
                    } else {
                        $res['can_receive'] = 1;
                    }
                } else {
                    $res['can_receive'] = 1;
                }
            }else{
                //不可重复
                //查找当前用户是否已领取过该任务
                $userTaskNum = ZjUserTask::where($where)->count();
                if($userTaskNum>0){
                    //判断当前用户该任务状态
                    $userTask = ZjUserTask::where($where)->field('id,submit_time,status,gmt_create')->find();
                    $surplusTime = 0;
                    if($userTask['status'] === 0){
                        //执行中返回执行剩余时间
                        $finishDuration = $res['finish_duration']*60*60;
                        $surplusTime = $finishDuration-(time()-strtotime($userTask['gmt_create']));
                        //当时间小于0时，表示阶段已结束，进行订单放弃处理
                        if ($surplusTime <= 0) {
                            ZjUserTask::update(['id' => $userTask['id'], 'status' => 4]);
                        }
                    }else if($userTask['status'] === 1){
                        //执行中返回审核剩余时间
                        $checkDuration = $res['check_duration']*60*60;
                        $surplusTime = $checkDuration-(time()-strtotime($userTask['submit_time']));
                        //当时间小于0时，表示阶段已结束，进行订单自动通过处理
                        if ($surplusTime <= 0) {
                            ZjUserTask::update(['id' => $userTask['id'], 'status' => 2]);
                        }
                    }
                    $res['user_task_id'] = $userTask['id'];
                    $res['surplus_time'] = $surplusTime*1000;
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










}
