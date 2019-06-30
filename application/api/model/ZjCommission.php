<?php

namespace app\api\model;

use think\Model;

class ZjCommission extends Model
{
    /**
     * 获取金额
     * @param $value
     * @return string
     */
    public function getMoneyAttr($value){
        return number_format($value / 100, 2, '.', '');
    }
    public function setMoneyAttr($value){
        return $value * 100;
    }

    /**
     * 关联任务信息
     * @return \think\model\relation\HasOne
     */
    public function task(){
        $where=[
            'is_delete'=>0
        ];
        return $this->hasOne('ZjTask','task_id','task_id')
            ->where($where)
            ->field('title');
    }

    /**
     * 关联来源用户信息
     * @return \think\model\relation\HasOne
     */
    public function fromUser(){
        $where=[
            'is_delete'=>0
        ];
        return $this->hasOne('ZjUser','user_id','from_user_id')
            ->where($where)
            ->field('nickname');
    }
}