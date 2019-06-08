<?php
/**
 * Created by PhpStorm.
 * User: yajunyu
 * Date: 2018/11/20
 * Time: 15:23
 */

namespace app\admin\controller;


use app\model\Shopping;
use app\util\ReturnCode;
use think\Db;

class Good extends Base
{
    public $table = "Shopping";

    public function index()
    {
        $this->title = '商品管理';
        //记录当前页面
        cookie('shopping_url', $this->request->url());

//        $db = Db::name('shopping_type')->select();
//
//        $this->assign('db', $db);

        list($get, $db) = [$this->request->get(), Db::view(['shopping' => 'a'], '*')->view(['shopping_type' => 'b'], ['name' => 'type_name'], 'a.type_id=b.id')];
        foreach (['name'] as $key) {
            (isset($get[$key]) && $get[$key] !== '') && $db->whereLike('a.'.$key, "%{$get[$key]}%");
        }
        if (isset($get['type']) && $get['type'] !== '') {
            $db->where('b.id', $get['type']);
        }
        if (isset($_POST['action'])) {
            $db = Db::name($this->table);
        }
        return parent::_list($db->order('sort desc,id desc'));
    }

    /**
     * 获取商品类型
     */
    public function goodtype(){
        $list=db('shopping_type')->field('id,name')->select();
        $data=[
            'list'=>$list
        ];
        return json($data);
    }


    /**
     * 添加
     */
    public function add()
    {
        $post = $this->request->post();
        //判断商品类型
        if(empty($post['type_id'])){
            return $this->buildFailed(ReturnCode::EMPTY_PARAMS, '请选择商品类型');
        }
        $post['status']=1;
        $result = Shopping::create($post);
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
        $result = Shopping::update($post);
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
        $result = Shopping::destroy($get['id']);
        if ($result > 0) {
            return $this->buildSuccess($result);
        }
        return $this->buildFailed(ReturnCode::EMPTY_PARAMS, '失败');

    }

    /**
     * 状态修改
     */
    public function changeStatus(){
        $id = $this->request->get('id');
        $status = $this->request->get('status');
        $res = Shopping::update([
            'id'   => $id,
            'status' => $status
        ]);
        if ($res === false) {
            return $this->buildFailed(ReturnCode::DB_SAVE_ERROR, '操作失败');
        } else {
            return $this->buildSuccess([]);
        }
    }
//
//
//    /**
//     * 下架
//     * @throws \think\Exception
//     * @throws \think\exception\PDOException
//     */
//    public function forbid()
//    {
//        if (DataService::update($this->table)) {
//            $this->success("下架成功！", '');
//        }
//        $this->error("下架失败，请稍候再试！");
//    }
//
//    /**
//     * 上架
//     * @throws \think\Exception
//     * @throws \think\exception\PDOException
//     */
//    public function resume()
//    {
//        if (DataService::update($this->table)) {
//            $this->success("上架成功！", '');
//        }
//        $this->error("上架失败，请稍候再试！");
//    }

}