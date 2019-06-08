<?php
/**
 * Created by PhpStorm.
 * User: yajunyu
 * Date: 2018/11/20
 * Time: 14:56
 */

namespace app\admin\controller;


use think\Db;

/** 返利统计
 * Class Rebate
 * @package app\admin\controller
 */
class Rebate extends Base
{
    public $table="sale";

    public function index(){
        $count=Db::name($this->table)->where('zf_type',1)->whereIn('type',[5,6,7,8,9,10])->sum('money');

        list($get, $db) = [$this->request->get(), Db::name($this->table)];
        if (isset($get['time']) && $get['time'][0] !== '') {
            $start = strtotime($get['time'][0]);
            $start = date('Y-m-d H:i:s',$start);
            $end = strtotime($get['time'][1]);//加一天
            $end = date('Y-m-d H:i:s',$end);
            $start = str_replace('00:00:00',null,$start);
            $end = str_replace('00:00:00',null,$end);
            $db->whereBetween('time', ["{$start} 00:00:00", "{$end} 23:59:59"]);
        }
        $db = $db->field('time,sum(money) as money')->where('zf_type',1)->whereIn('type',[5,6,7,8,9,10])->group('DAY (time)')->order('time desc');
        return parent::_list($db,$count);
    }

}