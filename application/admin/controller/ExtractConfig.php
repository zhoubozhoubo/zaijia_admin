<?php
/**
 * Created by PhpStorm.
 * User: wj
 * Date: 2018/11/30
 * Time: 12:03
 */
namespace app\admin\controller;
use think\Db;

/** 提成配置
 * Class ExtractConfig
 * @package app\admin\controller
 */
class ExtractConfig extends Base{

    public $table = 'ExtractConfig';

    public function index()
    {
        $db = Db::name($this->table)->column('name,value');
        return $this->buildSuccess($db);
    }


    /**
     * 更新提成配置
     */
    public function update(){
        $post = $this->request->post();

        foreach ($post as $key=>$v){
            Db::name($this->table)->where('name',$key)->update(['value'=>$v]);
        }
        return $this->buildSuccess('','更新成功');
    }
}