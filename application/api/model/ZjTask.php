<?php

namespace app\api\model;

use think\Model;

class ZjTask extends Model
{
    /**
     * 获取金额
     * @param $value
     * @return string
     */
    public function getMoneyAttr($value){
        return number_format($value / 100, 2, '.', '');
    }

    public function getStepAttr($value){
        return explode('%,%',$value);
    }

    public function getShowImgAttr($value){
        return explode('%,%',$value);
    }

    public function getSubmitImgAttr($value){
        return explode('%,%',$value);
    }

    public function getPassRatioAttr($value, $data){
        return explode('%,%',$value);
    }

    /**
     * 关联任务类型
     * @return \think\model\relation\HasOne
     */
    public function taskType(){
        $where=[
            'status'=>1,
            'is_delete'=>0
        ];
        return $this->hasOne('ZjTaskType','id','task_type_id')
            ->where($where)
            ->field('id,img');
    }

    /**
     * 获取完成时长
     * @param $value
     * @return float
     */
    public function getFinishDurationAttr($value){
        return $value === 30 ? 0.5 : $value;
    }

}