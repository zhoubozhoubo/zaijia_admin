<?php
/**
 * Created by PhpStorm.
 * User: wj
 * Date: 2018/11/27
 * Time: 17:45
 */
namespace app\api\controller;
use think\Db;

class Shopping extends Base{

    /** 商品列表
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function index(){
        $db=Db::name('shopping');
        $count=Db::name('shopping');
        if($_GET['type'] !='全部商品'){
            //查询商品类型id
            $type_id=  $shopping=Db::name('shopping_type')->where('name',$_GET['type'])->value('id');
            $db->where('type_id',$type_id);
            $count->where('type_id',$type_id);
        }
        $db=$db->page($_GET['page'],10)->order('id desc')->select();
        $count=$count->count();
        $data=[
            'data'=>$db,
            'count'=>ceil($count/10)
        ];
        return $this->buildSuccess($data);
    }

    /** 商品详情
     * @return int|\think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function content(){
        $id=$_GET['id'];
        $shopping=Db::name('shopping')->where('id',$id)->find();

        return $this->buildSuccess($shopping);
    }

    /** 商品类型
     * @return int|\think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function type(){
        $shopping=Db::name('shopping_type')->field('name')->select();

        return $this->buildSuccess(array_column($shopping,'name'));
    }
}