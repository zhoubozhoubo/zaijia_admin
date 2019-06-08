<?php
/**
 * Created by PhpStorm.
 * User: yajunyu
 * Date: 2018/11/20
 * Time: 14:28
 */

namespace app\admin\controller;


use think\Db;

/** 交易明细
 * Class Details
 * @package app\admin\controller
 */
class Details extends Base
{

    public $table = "sale";

    public function index()
    {
        list($get, $db) = [$this->request->get(), Db::name('sale')];
        foreach (['username','tusername','out_trade_no','transaction_id','type','zf_type'] as $key) {
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

        return parent::_list($db->whereIn('type', [1, 2])->order('time desc'));
    }


}