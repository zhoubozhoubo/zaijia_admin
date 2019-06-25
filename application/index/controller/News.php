<?php

namespace app\index\controller;

use app\index\model\ZjBasicConf;
use app\index\model\ZjNews;
use think\Controller;
use think\Db;

class News extends Controller
{
    public function index(){
        $p = $this->request->get('p',0);
        $limit = $this->request->get('limit',10);
        //新闻列表
        $where = [
            'status'=>['neq', 2],
            'is_delete'=>0
        ];
        $news =ZjNews::where($where)->field('news_id,news_type_id,title,img,comment,number,gmt_create')->order('gmt_create DESC')->page($p,$limit)->select();
        $count =ZjNews::where($where)->field('news_id,news_type_id,title,img,comment,number,gmt_create')->order('gmt_create DESC')->count();
        //task
        $task = Db::view(['zj_task'=>'a'],'task_id,title,money,end_date')->view(['zj_task_type'=>'b'],'img as type_img','a.task_type_id=b.id','LEFT')->view(['area'=>'c'],'name as city_name','a.city=c.code','LEFT')->where('a.is_delete',0)->where('a.end_date','>=',date('Y-m-d'))->where('a.number - a.have_number','>',0)->order('a.gmt_create DESC')->limit(10)->select();
        foreach ($task as &$item){
            $item['money'] = number_format($item['money'] / 100, 2, '.', '');
            if($item['city_name']==''){
                $item['city_name']='全国';
            }
        }
        //联系客服
        $customerOld = ZjBasicConf::where(['name'=>'customer'])->value('value');
        $customerOld = explode('%,%',$customerOld);
        foreach ($customerOld as $key=>&$item){
            $value = explode('：',$item);
            $customer[$key]['name'] = $value[0];
            $customer[$key]['value'] = $value[1];
        }

        $this->assign('news',$news);
        $this->assign('count',$count);
        $this->assign('limit',$limit);
        $this->assign('p',$p);
        $this->assign('task',$task);
        $this->assign('customer',$customer);
        return $this->fetch();
    }
    public function details(){
        //news
        $newsId = $this->request->get('news_id');
        $where = [
            'is_delete' => 0
        ];
        $news = ZjNews::where($where)->field('gmt_modified,is_delete', true)->find($newsId);
        //task
        $task = Db::view(['zj_task'=>'a'],'task_id,title,money,end_date')->view(['zj_task_type'=>'b'],'img as type_img','a.task_type_id=b.id','LEFT')->view(['area'=>'c'],'name as city_name','a.city=c.code','LEFT')->where('a.is_delete',0)->where('a.end_date','>=',date('Y-m-d'))->where('a.number - a.have_number','>',0)->order('a.gmt_create DESC')->limit(10)->select();
        foreach ($task as &$item){
            $item['money'] = number_format($item['money'] / 100, 2, '.', '');
            if($item['city_name']==''){
                $item['city_name']='全国';
            }
        }
        //联系客服
        $customerOld = ZjBasicConf::where(['name'=>'customer'])->value('value');
        $customerOld = explode('%,%',$customerOld);
        foreach ($customerOld as $key=>&$item){
            $value = explode('：',$item);
            $customer[$key]['name'] = $value[0];
            $customer[$key]['value'] = $value[1];
        }

        $this->assign('news',$news);
        $this->assign('task',$task);
        $this->assign('customer',$customer);
        return $this->fetch();
    }
}