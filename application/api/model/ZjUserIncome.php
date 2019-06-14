<?php

namespace app\api\model;

use think\Model;

class ZjUserIncome extends Model
{
    /**
     * 获取money处理
     * @param $value
     * @return string
     */
    public function getMoneyAttr($value){
        return number_format($value / 100, 2, '.', '');
    }

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
            ->field('title');
    }
}