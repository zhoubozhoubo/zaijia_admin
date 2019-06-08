<?php
/**
 * Created by PhpStorm.
 * User: yajunyu
 * Date: 2018/11/20
 * Time: 09:49
 */

namespace app\admin\controller;
use app\util\ReturnCode;
use think\Db;

/** 提现管理
 * Class Withdrawal
 * @package app\admin\controller
 */
class Withdrawal extends Base
{
    public $table="sale";

    /** 提现列表
     * @return array|string
     * @throws \think\Exception
     * @throws \think\exception\DbException
     */
    public function index(){
        $this->title = '提现管理';
        list($get, $db) = [$this->request->get(), Db::view(['sale'=>'a'],'id,username,money,make_status,time')->view(['user'=>'b'],'card,card_name','a.uid=b.id','LEFT')];
        foreach (['username','make_status'] as $key) {
            (isset($get[$key]) && $get[$key] !== '') && $db->whereLike($key, "%{$get[$key]}%");
        }

        return parent::_list($db->where('a.type',3)->order('time desc'));
    }


    /**
     * 转账状态
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     */
    public function resume()
    {
        $id = $this->request->post('id');
        $update= [
            'make_status'=> 1,
            'make_time'=>date('Y-m-d H:i:s')
        ];
        $res =Db::name($this->table)->where('id',$id)->update($update);
        if ($res < 1) {
            return $this->buildFailed(ReturnCode::DB_SAVE_ERROR, '操作失败');
        } else {
            return $this->buildSuccess([]);
        }
    }

    /** 提现统计
     * @return array|string
     * @throws \think\Exception
     * @throws \think\exception\DbException
     */
    public function count(){
        $count=Db::name($this->table)->where(['type'=>3,'make_status'=>1])->sum('money');

        list($get, $db) = [$this->request->get(), Db::name($this->table)];
        if (isset($get['make_time']) && $get['make_time'] !== '') {
            $start = strtotime($get['make_time'][0]);
            $start = date('Y-m-d H:i:s',$start);
            $end = strtotime($get['make_time'][1]);
            $end = date('Y-m-d H:i:s',$end);
            $start = str_replace('00:00:00',null,$start);
            $end = str_replace('00:00:00',null,$end);
            $db->whereBetween('make_time', ["{$start} 00:00:00", "{$end} 23:59:59"]);
        }
        $db = $db->field('make_time,sum(money) as money')->where(['type'=>3,'make_status'=>1])->group('DAY (make_time)')->order('make_time desc');

        return parent::_list($db,$count);
    }

}