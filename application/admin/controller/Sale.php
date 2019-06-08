<?php
/**
 * Created by PhpStorm.
 * User: yajunyu
 * Date: 2018/11/20
 * Time: 14:50
 */

namespace app\admin\controller;


use think\Db;

class Sale extends Base
{
    public $table = "sale";

    public function index()
    {
        $this->title = '销售管理';
        list($get, $db) = [$this->request->get(), Db::name('sale')];
        foreach (['username', 'tusername', 'out_trade_no', 'transaction_id','type', 'zf_type'] as $key) {
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

        foreach (['type', 'zf_type'] as $key) {
            (isset($get[$key]) && $get[$key] !== '') && $db->where($key, $get[$key]);
        }
        return parent::_list($db->where('type', 'neq', 3)->order('time desc'));
    }

}