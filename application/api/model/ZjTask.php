<?php

namespace app\api\model;

use think\Model;

class ZjTask extends Model
{
    /**
     * 关联任务类型
     * @return \think\model\relation\HasOne
     */
    public function taskType(){
        $where=[
            'status'=>1,
            'is_delete'=>0
        ];
        return $this->hasOne('ZjTaskType','id','task_type_id')
            ->where($where)
            ->field('img');
    }

}