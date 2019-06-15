<?php

namespace app\api\model;

use think\Model;

class ZjUser extends Model
{
    /**
     * 获取价格
     * @param $value
     * @return string
     */
    public function getMoneyAttr($value){
        return number_format($value / 100, 2, '.', '');
    }

    /**
     * 关联上级用户昵称
     * @return \think\model\relation\HasOne
     */
    public function superiorUser(){
        $where=[
            'is_delete'=>0
        ];
        return $this->hasOne('ZjUser', 'user_id','superior_user_id')
            ->where($where)
            ->field('nickname');
    }

    /**
     * 关联用户个人收入
     * @param $value
     * @param $data
     * @return float|int
     */
    public function getMyIncomeAttr($value,$data){
        $where=[
            'user_id'=>$data['user_id'],
            'is_delete'=>0
        ];
        $myIncome = ZjUserIncome::where($where)->sum('money');
        return number_format($myIncome / 100, 2, '.', '');
    }

    public function getTeamIncomeAttr($value,$data){
        $where=[
            'user_id'=>$data['user_id'],
            'is_delete'=>0
        ];
        $teamIncome = ZjCommission::where($where)->sum('money');
        return number_format($teamIncome / 100, 2, '.', '');
    }







}