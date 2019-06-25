<?php

namespace app\index\model;

use think\Model;

class Area extends Model
{
    /**
     * 关联城市列表
     * @return \think\model\relation\HasMany
     */
    public function City(){
        return $this->hasMany('Area','pid','id')->where(['level'=>2])->field('id,code as value,name as label');
    }
}