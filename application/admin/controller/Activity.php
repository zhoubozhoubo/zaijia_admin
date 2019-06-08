<?php
/**
 * Created by PhpStorm.
 * User: wj
 * Date: 2018/11/30
 * Time: 14:38
 */
namespace app\admin\controller;
use think\Db;

/** 开码活动配置
 * Class Activity
 * @package app\admin\controller
 */
class Activity extends Base{

    public $table="re";

    public function index(){

        $db = Db::name($this->table)->select();
        $db[0]['name']='开码0.01活动';
        return $this->buildSuccess($db);
    }

    public function update(){
        $status = $this->request->post()['status'];
        $db=Db::name($this->table)->where('id',1)->update(['status'=>$status]);

        if($db>0){
            return $this->buildSuccess('','操作成功');
        }
    }
}