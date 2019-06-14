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