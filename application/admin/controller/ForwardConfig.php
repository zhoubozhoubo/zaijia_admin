<?php
/**
 * Created by PhpStorm.
 * User: wj
 * Date: 2018/11/30
 * Time: 14:20
 */
namespace app\admin\controller;
use think\Db;

/** 提现配置
 * Class ForwardConfig
 * @package app\admin\controller
 */
class ForwardConfig extends Base{

    public $table = 'ExtractConfig';

    public function index()
    {
        $db = Db::name($this->table)->column('name,value');
        return $this->buildSuccess($db);
    }

    /**
     * 更新提现配置
     */
    public function update(){
        $post = $this->request->post();

        foreach ($post as $key=>$v){
            Db::name($this->table)->where('name',$key)->update(['value'=>$v]);
        }
        return $this->buildSuccess('','更新成功');
    }
}