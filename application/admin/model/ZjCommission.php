<?php

namespace app\admin\model;

use think\Model;

class ZjCommission extends Model
{
    /**
     * 获取价格
     * @param $value
     * @return string
     */
    public function getMoneyAttr($value){
        return number_format($value / 100, 2, '.', '');
    }
    public function setMoneyAttr($value){
        return $value * 100;
    }

}