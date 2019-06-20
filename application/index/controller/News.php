<?php

namespace app\index\controller;

use app\index\model\ZjNews;
use think\Controller;

class News extends Controller
{
    public function index(){
        //新闻列表
        $where = [
            'is_delete'=>0
        ];
        $news =ZjNews::where($where)->field('news_id,news_type_id,title,img,comment,number,gmt_create')->order('gmt_create DESC')->select();
        $this->assign('news',$news);
        return $this->fetch();
    }
}