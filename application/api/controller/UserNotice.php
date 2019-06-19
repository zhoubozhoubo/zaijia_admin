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
        $this->requestType('POST');
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $where = [
            'user_id'=>$this->userInfo['user_id'],
            'is_delete'=>0
        ];
        $res = ZjUserNotice::where($where)->field('gmt_modified,is_delete',true)->order('gmt_create DESC')->paginate();
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND,'记录未找到','');
        }
        return $this->buildSuccess($res);
    }

    /**
     * 标记消息已读
     * @return \think\response\Json
     */
    public function readNotice(){
        $this->requestType('POST');
        $postData = $this->request->post();
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $where = [
            'id'=>$postData['id'],
            'user_id'=>$this->userInfo['user_id'],
            'is_delete'=>0
        ];
        $res = ZjUserNotice::where($where)->update(['is_read'=>1]);
        if(!$res){
            return $this->buildFailed(ReturnCode::UPDATE_FAILED,'标记已读失败','');
        }
        return $this->buildSuccess($res);
    }


}
