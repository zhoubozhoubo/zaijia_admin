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
}