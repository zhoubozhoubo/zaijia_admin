<?php

namespace app\api\model;

use think\Model;

class ZjWithdrawWay extends Model
{
    /**
     * 获取最低money处理
     * @param $value
     * @return string
     */
    public function getMinMoneyAttr($value){
        return number_format($value / 100, 2, '.', '');
    }

    /**
     * 获取最高money处理
     * @param $value
     * @return string
     */
    public function getMaxMoneyAttr($value){
        return number_format($value / 100, 2, '.', '');
    }

}