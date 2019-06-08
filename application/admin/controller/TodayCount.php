<?php
/**
 * Created by PhpStorm.
 * User: yajunyu
 * Date: 2018/11/20
 * Time: 15:03
 */

namespace app\admin\controller;
use think\Db;

/** 今日货款统计
 * Class TodayCount
 * @package app\admin\controller
 */
class TodayCount extends Base
{
    public $table = "sale";

    public function index()
    {
        //微信交易总计
        $count=Db::name($this->table)->where('zf_type',2)->sum('money');

        list($get, $db) = [$this->request->get(), Db::name($this->table)];

        if (isset($get['time']) && $get['time'][0] !== '') {
            $start = strtotime($get['time'][0]);
            $start = date('Y-m-d H:i:s',$start);
            $end = strtotime($get['time'][1]);
            $end = date('Y-m-d H:i:s',$end);
            $start = str_replace('00:00:00',null,$start);
            $end = str_replace('00:00:00',null,$end);
            $db->whereBetween('time', ["{$start} 00:00:00", "{$end} 23:59:59"]);
        }
        $db = $db =$db->field('time,sum(money) as money')->where(['type' => 2, 'zf_type' => 2])->group('DAY (time)')->order('time desc');
        return parent::_list($db,$count);
    }

}