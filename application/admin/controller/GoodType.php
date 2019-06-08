<?php
/**
 * Created by PhpStorm.
 * User: yajunyu
 * Date: 2018/11/20
 * Time: 15:22
 */

namespace app\admin\controller;


use app\model\ShoppingType;
use app\util\ReturnCode;
use think\Db;

class GoodType extends Base
{
    public $table="ShoppingType";

    public function index(){
        $this->title = '商品类型管理';
        list($get, $db) = [$this->request->get(), Db::name($this->table)];
        foreach (['name'] as $key) {
            (isset($get[$key]) && $get[$key] !== '') && $db->whereLike($key, "%{$get[$key]}%");
        }
        return parent::_list($db->order('sort desc'));
    }


    /**
     * 添加
     */
    public function add()
    {
        $post = $this->request->post();
        $result = ShoppingType::create($post);
        if ($result) {
            return $this->buildSuccess($result);
        } else {
            return $this->buildFailed(ReturnCode::EMPTY_PARAMS, '失败');
        }
    }

    /**
     * 修改
     */
    public function edit()
    {
        $post = $this->request->post();
        $result = ShoppingType::update($post);
        if ($result) {
            return $this->buildSuccess($result);
        } else {
            return $this->buildFailed(ReturnCode::EMPTY_PARAMS, '失败');
        }
    }

    /**
     * 删除
     */
    public function del()
    {
        $get = $this->request->get();
        //判断该类型下是否有商品
        $list=db('shopping')->where('type_id',$get['id'])->count();
        if($list>0){
            return $this->buildFailed(ReturnCode::EMPTY_PARAMS, '该类型下存在商品，无法删除');
        }
        $result = ShoppingType::destroy($get['id']);
        if ($result > 0) {
            return $this->buildSuccess($result);
        }
        return $this->buildFailed(ReturnCode::EMPTY_PARAMS, '失败');

    }

}