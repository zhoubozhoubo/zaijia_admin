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
        return $this->hasOne('ZjTask','task_id','task_id')
            ->field('status,gmt_create,gmt_modified,is_delete',true)
            ->with('taskType');
    }
}