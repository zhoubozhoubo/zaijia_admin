<?php

namespace app\index\controller;

use app\index\model\ZjTaskType;
use think\Controller;
use think\Db;

class Job extends Controller
{
    public function index(){
        //任务类型
        $where = [
            'status' => 1,
            'is_delete' => 0
        ];
        $taskType = ZjTaskType::where($where)->order('sort ASC')->field('id,name')->select();
        //task
        $task = Db::view(['zj_task'=>'a'],'title,money,end_date')->view(['zj_task_type'=>'b'],'img as type_img','a.task_type_id=b.id','LEFT')->view(['area'=>'c'],'name as city_name','a.city=c.code','LEFT')->where('a.is_delete',0)->where('a.end_date','>=',date('Y-m-d'))->where('a.number - a.have_number','>',0)->order('a.gmt_create DESC')->limit(10)->select();
        foreach ($task as &$item){
            $item['money'] = number_format($item['money'] / 100, 2, '.', '');
            if($item['city_name']==''){
                $item['city_name']='全国';
            }
        }
        $this->assign('task',$task);
        $this->assign('taskType',$taskType);
        return $this->fetch();
    }
}