<?php

namespace app\api\model;

use think\Model;

class ZjWithdraw extends Model
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
     * 存储money处理
     * @param $value
     * @return float|int
     */
    public function setMoneyAttr($value){
        return $value * 100;
    }

    /**
     * 关联提现方式信息
     * @return \think\model\relation\HasOne
     */
    public function withdrawType(){
        $where=[
            'status'=>1,
            'is_delete'=>0
        ];
        return $this->hasOne('ZjWithdrawWay','withdraw_way_id','withdraw_way_id')
            ->where($where)
            ->field('name');
    }

}