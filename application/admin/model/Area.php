<?php

namespace app\admin\model;

use think\Model;

class Area extends Model
{
    public function City(){
        return $this->hasMany('Area','pid','id')->where(['level'=>2])->field('id,code as value,name as label');
    }
}