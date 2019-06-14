<?php

namespace app\api\model;

use think\Model;

class ZjUserTask extends Model
{
    /**
     * 关联任务信息
     * @return \think\model\relation\HasOne
     */
    public function task(){
        $where=[
            'status'=>1,
            'is_delete'=>0
        ];
        return $this->hasOne('ZjTask','task_id','task_id')
            ->where($where)
            ->field('status,gmt_create,gmt_modified,is_delete',true)
            ->with('taskType');
    }
}