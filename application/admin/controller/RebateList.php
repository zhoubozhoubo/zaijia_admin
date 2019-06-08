<?php
/**
 * Created by PhpStorm.
 * User: yajunyu
 * Date: 2018/11/20
 * Time: 14:42
 */

namespace app\admin\controller;


use think\Db;

/** 返利明细
 * Class RebateList
 * @package app\admin\controller
 */
class RebateList extends Base
{
    public $table="sale";

    public function index(){
        list($get, $db) = [$this->request->get(), Db::name('sale')];
        foreach (['username','tusername','out_trade_no','type'] as $key) {
            (isset($get[$key]) && $get[$key] !== '') && $db->whereLike($key, "%{$get[$key]}%");
        }

        if (isset($get['time']) && $get['time'][0] !== '') {
            $start = strtotime($get['time'][0]);
            $start = date('Y-m-d H:i:s',$start);
            $end = strtotime($get['time'][1]);
            $end = date('Y-m-d H:i:s',$end);
            $start = str_replace('00:00:00',null,$start);
            $end = str_replace('00:00:00',null,$end);
            $db->whereBetween('time', ["{$start} 00:00:00", "{$end} 23:59:59"]);
        }

        return parent::_list($db->where('zf_type',1)->whereIn('type',[5,6,7,8,9,10])->order('time desc'));
    }

}