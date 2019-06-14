<?php

namespace app\api\controller;

use app\api\model\ZjTask;
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
        $this->requestType();
        $getData = $this->request->get();
        $where = [
            'status' => 1,
            'is_delete' => 0
        ];
        $res = ZjTask::where($where)->field('status,gmt_create,gmt_modified,is_delete', true)->find($getData['task_id']);
        if (!$res) {
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND, '记录未找到', '');
        }
        return $this->buildSuccess($res);
    }










}
