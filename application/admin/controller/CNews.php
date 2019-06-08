<?php
/**
 * Created by PhpStorm.
 * User: yajunyu
 * Date: 2018/11/20
 * Time: 09:32
 */

namespace app\admin\controller;


use app\util\ReturnCode;
use think\Db;
use app\model\News;

class CNews extends Base
{
    public $table = 'News';

    public function index()
    {
        $this->title = '新闻管理';
        list($get, $db) = [$this->request->get(), Db::name($this->table)];
        foreach (['title'] as $key) {
            (isset($get[$key]) && $get[$key] !== '') && $db->whereLike($key, "%{$get[$key]}%");
        }
        return parent::_list($db->order('id desc')->order('sort desc'));
    }



    /** 新闻添加
     * @return array|string
     */
    public function add()
    {
        $post = $this->request->post();
        $post['time']=date('Y-m-d H:i:s');
        $result = News::create($post);
        if ($result) {
            return $this->buildSuccess($result);
        } else {
            return $this->buildFailed(ReturnCode::EMPTY_PARAMS, '失败');
        }
    }


    /** 新闻修改
     * @return array|string
     */
    public function edit()
    {
        $post = $this->request->post();
        $result = News::update($post);
        if ($result) {
            return $this->buildSuccess($result);
        } else {
            return $this->buildFailed(ReturnCode::EMPTY_PARAMS, '失败');
        }
    }


    /**
     * 删除新闻
     * @return array
     */
    public function del()
    {
        $get = $this->request->get();
        $result = News::destroy($get['id']);
        if ($result > 0) {
            return $this->buildSuccess($result);
        }
        return $this->buildFailed(ReturnCode::EMPTY_PARAMS, '失败');

    }
//
//
//    /** 新闻详情
//     * @return array|string
//     */
//    public function check()
//    {
//        $this->assign('url', cookie('url'));
//        return $this->_form($this->table, 'check');
//    }
//
//
//    /**
//     * 新闻删除
//     */
//    public function del()
//    {
//        if (DataService::update($this->table)) {
//            $this->success("删除成功！", '');
//        }
//        $this->error("删除失败，请稍候再试！");
//    }

}