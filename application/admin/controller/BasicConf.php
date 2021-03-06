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
    public function website(){
        $res = ZjBasicConf::where(['name'=>'website'])->value('value');
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND,'记录未找到','');
        }
        return $this->buildSuccess($res);
    }
    public function saveWebsite(){
        $postData = $this->request->post();
        $res = ZjBasicConf::where(['name'=>'website'])->update(['value'=>$postData['website']]);
        if(!$res){
            return $this->buildFailed(ReturnCode::UPDATE_FAILED,'更新数据失败','');
        }
        return $this->buildSuccess($res);
    }
    public function wechatQrCode(){
        $res = ZjBasicConf::where(['name'=>'wechat_qr_code'])->value('value');
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND,'记录未找到','');
        }
        return $this->buildSuccess($res);
    }
    public function saveWechatQrCode(){
        $postData = $this->request->post();
        $res = ZjBasicConf::where(['name'=>'wechat_qr_code'])->update(['value'=>$postData['wechat_qr_code']]);
        if(!$res){
            return $this->buildFailed(ReturnCode::UPDATE_FAILED,'更新数据失败','');
        }
        return $this->buildSuccess($res);
    }
    public function company(){
        $res = ZjBasicConf::where(['name'=>'company'])->value('value');
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND,'记录未找到','');
        }
        return $this->buildSuccess($res);
    }
    public function saveCompany(){
        $postData = $this->request->post();
        $res = ZjBasicConf::where(['name'=>'company'])->update(['value'=>$postData['company']]);
        if(!$res){
            return $this->buildFailed(ReturnCode::UPDATE_FAILED,'更新数据失败','');
        }
        return $this->buildSuccess($res);
    }
    public function reward(){
        $res = ZjBasicConf::where('id','in','6,7')->select();
        foreach ($res as &$item){
            $item['value'] = number_format($item['value'] / 100, 2, '.', '');
        }
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND,'记录未找到','');
        }
        return $this->buildSuccess($res);
    }
    public function saveReward(){
        $postData = $this->request->post();
        foreach ($postData as $key=>$val){
            $res = ZjBasicConf::where(['name'=>$key])->update(['value'=>$val*100]);
        }
        return $this->buildSuccess([]);
    }
    public function taskmoney(){
        $res = ZjBasicConf::where(['name'=>'taskmoney_status'])->value('value');
        return $this->buildSuccess($res);
    }
    public function saveTaskmoney(){
        $postData = $this->request->post();
        $res = ZjBasicConf::where(['name'=>'taskmoney_status'])->update(['value'=>$postData['taskmoney_status']]);
//        if(!$res){
//            return $this->buildFailed(ReturnCode::UPDATE_FAILED,'更新数据失败','');
//        }
        return $this->buildSuccess($res);
    }

}
