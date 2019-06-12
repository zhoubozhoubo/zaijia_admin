<?php

namespace app\api\controller;

use app\api\model\ZjUserNotice;
use app\util\ReturnCode;

/**
 * 用户消息Controller
 * Class UserNotice
 * @package app\api\controller
 */
class UserNotice extends Base
{
    /**
     * 消息列表
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function noticeList(){
        $this->requestType('GET');
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $where = [
            'user_id'=>$this->userInfo['user_id'],
            'is_delete'=>0
        ];
        $res = ZjUserNotice::where($where)->field('gmt_create,gmt_modified,is_delete',true)->select();
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND,'记录未找到','');
        }
        return $this->buildSuccess($res);
    }



}
