<?php

namespace app\api\controller;

use app\api\model\ZjUserWithdraw;
use app\util\ReturnCode;

/**
 * 用户提现Controller
 * Class UserWithDraw
 * @package app\api\controller
 */
class UserWithDraw extends Base
{

    /**
     * 提现列表
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function withdrawList(){
        $this->requestType('GET');
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $where = [
            'user_id'=>$this->userInfo['user_id'],
            'is_delete'=>0
        ];
        $res = ZjUserWithdraw::where($where)->field('gmt_create,gmt_modified,is_delete',true)->select();
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND,'记录未找到','');
        }
        return $this->buildSuccess($res);
    }




}
