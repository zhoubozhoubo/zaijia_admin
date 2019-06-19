<?php

namespace app\admin\model;

use think\Model;

class ZjTask extends Model
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
     * 设置价格
     * @param $value
     * @return float|int
     */
    public function setMoneyAttr($value){
        return $value * 100;
    }

    /**
     * 获取完成时长
     * @param $value
     * @return float
     */
    public function getFinishDurationAttr($value){
        return $value = 30 ? 0.5 : $value;
    }
}