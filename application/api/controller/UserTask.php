<?php

namespace app\api\controller;

use app\api\model\ZjTask;
use app\api\model\ZjUserTask;
use app\util\ReturnCode;

/**
 * 用户任务Controller
 * Class UserTask
 * @package app\api\controller
 */
class UserTask extends Base
{
    /**
     * 任务列表
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function taskList(){
        $this->requestType('POST');
        $postData = $this->request->post();
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $where = [
            'user_id'=>$this->userInfo['user_id'],
            'status'=>$postData['status'],
            'is_delete'=>0
        ];
        $res = ZjUserTask::where($where)->field('gmt_create,gmt_modified,is_delete',true)->paginate();
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND,'记录未找到','');
        }
        foreach ($res as $item){
            $item->task;
        }
        return $this->buildSuccess($res);
    }

    /**
     * 用户任务详情
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function taskDetails(){
        $this->requestType('POST');
        $postData = $this->request->post();
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $where = [
            'user_id'=>$this->userInfo['user_id'],
            'id'=>$postData['id'],
            'is_delete'=>0
        ];
        $res = ZjUserTask::where($where)->field('gmt_modified,is_delete',true)->find();
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND, '记录未找到', '');
        }
        $res->task;
        $surplusTime = 0;
        if ($res['status'] === 0) {
            //执行中返回执行剩余时间
            $finishDuration = $res['task']['finish_duration'] * 60 * 60;
            $surplusTime = $finishDuration - (time() - strtotime($res['gmt_create']));
            //当时间小于0时，表示阶段已结束，进行订单放弃处理
            if ($surplusTime <= 0) {
                ZjUserTask::update(['id' => $res['id'], 'status' => 4]);
                //任务已领取数量自减
                $taskId = ZjUserTask::where(['id'=>$postData['id']])->value('task_id');
                ZjTask::where(['task_id'=>$taskId])->setDec('have_number');
            }
        } else if ($res['status'] === 1) {
            //执行中返回审核剩余时间
            $checkDuration = $res['task']['check_duration'] * 60 * 60;
            $surplusTime = $checkDuration - (time() - strtotime($res['submit_time']));
            //当时间小于0时，表示阶段已结束，进行订单自动通过处理
            if ($surplusTime <= 0) {
                ZjUserTask::update(['id' => $res['id'], 'status' => 2]);
            }
        }
        $res['surplus_time'] = $surplusTime * 1000;
        return $this->buildSuccess($res);
    }

    /**
     * 添加任务
     * @return \think\response\Json
     */
    public function addTask(){
        $this->requestType('POST');
        $postData = $this->request->post();
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $data = [
            'user_id'=>$this->userInfo['user_id'],
            'task_id'=>$postData['task_id']
        ];
        $res = ZjUserTask::create($data);
        if(!$res){
            return $this->buildFailed(ReturnCode::ADD_FAILED,'领取任务失败','');
        }
        //返回任务完成时间
        $finishDuration = ZjTask::where(['task_id'=>$postData['task_id']])->field('finish_duration')->find();
        $res['finish_duration']=$finishDuration['finish_duration']*60*60*1000;
        //任务已领取数量自增
        ZjTask::where(['task_id'=>$postData['task_id']])->setInc('have_number');
        return $this->buildSuccess($res,'成功领取任务');
    }

    /**
     * 提交任务
     * @return \think\response\Json
     */
    public function submitTask(){
        $this->requestType('POST');
        $postData = $this->request->post();
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $data = [
            'id'=>$postData['id'],
            'user_id'=>$this->userInfo['user_id'],
            'submit_img'=>$postData['submit_img'],
            'submit_text'=>$postData['submit_text'],
            'submit_time'=>date('Y-m-d H:i:s'),
            'status'=>1
        ];
        $res = ZjUserTask::update($data);
        if(!$res){
            return $this->buildFailed(ReturnCode::UPDATE_FAILED,'提交任务失败','');
        }
        return $this->buildSuccess($res);
    }

    /**
     * 放弃任务
     * @return \think\response\Json
     */
    public function delTask(){
        $this->requestType('POST');
        $postData = $this->request->post();
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $data = [
            'id'=>$postData['id'],
            'user_id'=>$this->userInfo['user_id'],
            'status'=>4
        ];
        $res = ZjUserTask::update($data);
        if(!$res){
            return $this->buildFailed(ReturnCode::UPDATE_FAILED,'放弃任务失败','');
        }
        //任务已领取数量自减
        $taskId = ZjUserTask::where(['id'=>$postData['id']])->value('task_id');
        ZjTask::where(['task_id'=>$taskId])->setDec('have_number');
        return $this->buildSuccess($res);
    }











}
