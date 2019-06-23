<?php

namespace app\index\controller;

use app\index\model\ZjNews;
use think\Controller;
use think\Db;

class News extends Controller
{
    public function index(){
        //新闻列表
        $where = [
            'is_delete'=>0
        ];
        $news =ZjNews::where($where)->field('news_id,news_type_id,title,img,comment,number,gmt_create')->order('gmt_create DESC')->select();
        //task
        $task = Db::view(['zj_task'=>'a'],'title,money,end_date')->view(['zj_task_type'=>'b'],'img as type_img','a.task_type_id=b.id','LEFT')->view(['area'=>'c'],'name as city_name','a.city=c.code','LEFT')->where('a.is_delete',0)->where('a.end_date','>=',date('Y-m-d'))->where('a.number - a.have_number','>',0)->order('a.gmt_create DESC')->limit(10)->select();
        foreach ($task as &$item){
            $item['money'] = number_format($item['money'] / 100, 2, '.', '');
            if($item['city_name']==''){
                $item['city_name']='全国';
            }
        }
//        print_r($news);exit;
        $this->assign('news',$news);
        $this->assign('task',$task);
        return $this->fetch();
    }
}