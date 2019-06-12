<?php

namespace app\api\controller;

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
        $this->requestType('GET');
        $getData = $this->request->get();
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $where = [
            'user_id'=>$this->userInfo['user_id'],
            'status'=>$getData['status'],
            'is_delete'=>0
        ];
        $res = ZjUserTask::where($where)->field('gmt_create,gmt_modified,is_delete',true)->select();
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND,'记录未找到','');
        }
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
            return $this->buildFailed(ReturnCode::ADD_FAILED,'添加任务失败','');
        }
        return $this->buildSuccess($res);
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
        return $this->buildSuccess($res);
    }











}
