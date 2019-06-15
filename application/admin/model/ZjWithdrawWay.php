<?php

namespace app\admin\model;

use think\Model;

class ZjWithdrawWay extends Model
{
    /**
     * 设置最低价格
     * @param $value
     * @return string
     */
    public function setMinMoneyAttr($value){
        return $value * 100;
    }

    /**
     * 设置最高价格
     * @param $value
     * @return string
     */
    public function setMaxMoneyAttr($value){
        return $value * 100;
    }

}