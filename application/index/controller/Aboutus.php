<?php

namespace app\index\controller;

use app\index\model\ZjBasicConf;
use think\Controller;

class Aboutus extends Controller
{
    public function index(){
        //公司简介
        $company = ZjBasicConf::where(['name'=>'company'])->value('value');
        //联系客服
        $customerOld = ZjBasicConf::where(['name'=>'customer'])->value('value');
        $customerOld = explode('%,%',$customerOld);
        foreach ($customerOld as $key=>&$item){
            $value = explode('：',$item);
            $customer[$key]['name'] = $value[0];
            $customer[$key]['value'] = $value[1];
        }

        $this->assign('company',$company);
        $this->assign('customer',$customer);
        return $this->fetch();
    }
}