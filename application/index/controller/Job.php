<?php

namespace app\index\controller;

use app\index\model\Area;
use app\index\model\ZjBasicConf;
use app\index\model\ZjTask;
use app\index\model\ZjTaskType;
use think\Controller;
use think\Db;

class Job extends Controller
{
    public function index(){
        $taskType = $this->request->get('taskType','');
        $province = $this->request->get('province','');
        $city = $this->request->get('city','');
        $order = $this->request->get('order','');
        $p = $this->request->get('p',0);
        $limit = $this->request->get('limit',10);
        //任务类型
        $where = [
            'status' => 1,
            'is_delete' => 0
        ];
        $taskTypeList = ZjTaskType::where($where)->order('sort ASC')->field('id,name')->select();
        //area
        $provinceList =Area::where(['level' => 1])->field('code,name')->select();
        if($province){
            $id = Area::where(['code'=>$province])->value('id');
            $cityList =Area::where(['level' => 2,'pid'=>$id])->field('code,name')->select();
        }else{
            $cityList =[];
        }
        //task
        $where=[];
        if($taskType){
            $where['a.task_type_id']=$taskType;
        }
        if($province){
            $where['a.province']=$province;
        }
        if($city){
            $where['a.city']=$city;
        }
        if($order){
            switch ($order){
                case 0: //默认排序
                    $whereOrder='a.gmt_create DESC';
                    break;
                case 1: //最新发布
                    $whereOrder='a.gmt_create DESC';
                    break;
                case 2: //价格高->低
                    $whereOrder='a.money DESC';
                    break;
                default:
                    $whereOrder = '';
            }
        }else{
            $whereOrder = '';
        }
        $task = Db::view(['zj_task'=>'a'],'task_id,title,money,end_date')->view(['zj_task_type'=>'b'],'img as type_img','a.task_type_id=b.id','LEFT')->view(['area'=>'c'],'name as city_name','a.city=c.code','LEFT')->where('a.is_delete',0)->where('a.end_date','>=',date('Y-m-d'))->where('a.number - a.have_number','>',0)->where($where)->order($whereOrder)->page($p,$limit)->select();
        $count = Db::view(['zj_task'=>'a'],'task_id,title,money,end_date')->view(['zj_task_type'=>'b'],'img as type_img','a.task_type_id=b.id','LEFT')->view(['area'=>'c'],'name as city_name','a.city=c.code','LEFT')->where('a.is_delete',0)->where('a.end_date','>=',date('Y-m-d'))->where('a.number - a.have_number','>',0)->where($where)->order($whereOrder)->count();
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

        $this->assign('taskTypeList',$taskTypeList);
        $this->assign('taskType',$taskType);
        $this->assign('provinceList',$provinceList);
        $this->assign('province',$province);
        $this->assign('cityList',$cityList);
        $this->assign('city',$city);
        $this->assign('order',$order);
        $this->assign('task',$task);
        $this->assign('count',$count);
        $this->assign('limit',$limit);
        $this->assign('p',$p);
        $this->assign('customer',$customer);
        return $this->fetch();
    }
    public function details(){
        $taskId = $this->request->get('task_id');
        $where = [
            'status' => 1,
            'is_delete' => 0
        ];
        $task = ZjTask::where($where)->field('status,gmt_create,gmt_modified,is_delete', true)->find($taskId);
        //联系客服
        $customerOld = ZjBasicConf::where(['name'=>'customer'])->value('value');
        $customerOld = explode('%,%',$customerOld);
        foreach ($customerOld as $key=>&$item){
            $value = explode('：',$item);
            $customer[$key]['name'] = $value[0];
            $customer[$key]['value'] = $value[1];
        }

        $this->assign('task',$task);
        $this->assign('customer',$customer);
        return $this->fetch();
    }
}