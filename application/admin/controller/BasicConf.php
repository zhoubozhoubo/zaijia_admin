<?php
/**
 * 工程基类
 * @since   2017/02/28 创建
 * @author  zhaoxiang <zhaoxiang051405@gmail.com>
 */

namespace app\admin\controller;

use app\admin\model\ZjBasicConf;
use app\util\BaseController;
use app\util\ReturnCode;

class BasicConf extends BaseController
{
    public function invite(){
        $invite = ZjBasicConf::where(['name'=>'invite'])->value('value');
        $res = explode('%,%',$invite);
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND,'记录未找到','');
        }
        return $this->buildSuccess($res);
    }
    public function saveInvite(){
        $postData = $this->request->post();
        $invite = implode('%,%',$postData['step']);
        $res = ZjBasicConf::where(['name'=>'invite'])->update(['value'=>$invite]);
        if(!$res){
            return $this->buildFailed(ReturnCode::UPDATE_FAILED,'更新数据失败','');
        }
        return $this->buildSuccess($res);
    }
    public function customer(){
        $customer = ZjBasicConf::where(['name'=>'customer'])->value('value');
        $res = explode('%,%',$customer);
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND,'记录未找到','');
        }
        return $this->buildSuccess($res);
    }
    public function saveCustomer(){
        $postData = $this->request->post();
        $customer = implode('%,%',$postData['step']);
        $res = ZjBasicConf::where(['name'=>'customer'])->update(['value'=>$customer]);
        if(!$res){
            return $this->buildFailed(ReturnCode::UPDATE_FAILED,'更新数据失败','');
        }
        return $this->buildSuccess($res);
    }

}
