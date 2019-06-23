<?php

namespace app\index\controller;

use app\index\model\ZjBanner;
use app\index\model\ZjBasicConf;
use app\index\model\ZjLink;
use app\index\model\ZjTask;
use think\Controller;
use think\Db;

class Index extends Controller
{
    public function index(){
        //banner
        $where = [
            'status' => 1,
            'is_delete' => 0
        ];
        $banner = ZjBanner::where($where)->order('sort ASC')->field('img,url')->select();
        //link
        $where = [
            'status' => 1,
            'is_delete' => 0
        ];
        $link = ZjLink::where($where)->order('sort ASC')->field('img,url')->select();
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

        $this->assign('banner',$banner);
        $this->assign('link',$link);
        $this->assign('task',$task);
        $this->assign('customer',$customer);
        return $this->fetch();
    }
}