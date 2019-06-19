<?php

namespace app\api\model;

use think\Model;

class ZjNews extends Model
{
    /**
     * 获取创建日期
     * @param $value
     * @return false|string
     */
    public function getGmtCreateAttr($value){
        return date('Y-m-d', strtotime($value));
    }
}