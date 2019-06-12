<?php

namespace app\api\controller;

use app\api\model\ZjCommission;
use app\api\model\ZjUserIncome;
use app\util\ReturnCode;

/**
 * 用户收入Controller
 * Class UserIncome
 * @package app\api\controller
 */
class UserIncome extends Base
{
    /**
     * 个人收入列表
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function myIncomeList(){
        $this->requestType('GET');
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $where = [
            'user_id'=>$this->userInfo['user_id'],
            'is_delete'=>0
        ];
        $res = ZjUserIncome::where($where)->field('gmt_create,gmt_modified,is_delete',true)->select();
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND,'记录未找到','');
        }
        return $this->buildSuccess($res);
    }

    /**
     * 团队收入列表
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function teamIncomeList(){
        $this->requestType('GET');
        $getData = $this->request->get();
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $where = [
            'user_id'=>$this->userInfo['user_id'],
            'type'=>$getData['type'],
            'is_delete'=>0
        ];
        $res = ZjCommission::where($where)->field('gmt_create,gmt_modified,is_delete',true)->select();
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND,'记录未找到','');
        }
        return $this->buildSuccess($res);
    }




}
