<?php
/**
 * Created by PhpStorm.
 * User: wj
 * Date: 2018/11/27
 * Time: 16:39
 */
namespace app\api\controller;
use think\Db;

class News extends Base{

    /** 新闻列表
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function index(){
        //分页
        $news=Db::name('news')->page($_GET['page'],10)->order('id desc')->select();
        //总数
        $count=Db::name('news')->count();
        $data=[
            'data'=>$news,
            'count'=>ceil($count/2)
        ];
        return $this->buildSuccess($data);
    }

    /** 新闻详情
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function content(){
        $id=$_GET['id'];
        $news=Db::name('news')->where('id',$id)->find();
        return $this->buildSuccess($news);
    }
}