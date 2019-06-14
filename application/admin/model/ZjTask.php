<?php

namespace app\admin\model;

use think\Model;

class ZjTask extends Model
{
    public function getMoneyAttr($value){
        return number_format($value / 100, 2, '.', '');
    }
}