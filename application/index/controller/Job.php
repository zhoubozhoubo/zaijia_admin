<?php

namespace app\index\controller;

use app\index\model\ZjTask;
use think\Controller;

class Job extends Controller
{
    public function index(){
        //兼职列表
        $where = [
            'status' => 1,
            'is_delete' => 0
        ];
        $jobs = ZjTask::where($where)
            ->field('task_id,task_type_id,title,money,number,have_number,(number-have_number) as surplus_number')
            ->where('number - have_number','>',0)
            ->order('gmt_create DESC')
            ->limit(10);
        $this->assign('jobs',$jobs);
        return $this->fetch();
    }
}