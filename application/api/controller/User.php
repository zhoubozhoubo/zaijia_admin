<?php

namespace app\api\controller;

use app\admin\model\ZjBasicConf;
use app\api\model\ZjUser;
use app\api\model\ZjUserNotice;
use app\api\model\ZjWithdrawWay;
use app\util\ReturnCode;

/**
 * 用户Controller
 * Class User
 * @package app\api\controller
 */
class User extends Base
{
    /**
     * 用户个人信息
     * @return array|\think\response\Json
     * @throws \think\exception\DbException
     */
    public function info(){
        $this->requestType('POST');
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $where = [
            'user_id'=>$this->userInfo['user_id'],
            'is_delete'=>0
        ];
        $res = ZjUser::where($where)->field('password,gmt_create,gmt_modified,is_delete',true)->find();
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND,'用户不存在','');
        }
        $res->superiorUser;
        $res['my_income'] = $res->my_income;
        $res['team_income'] = $res->team_income;
        $res['total_income'] =number_format(($res['my_income']+$res['team_income']), 2, '.', '') ;
        //提现方式信息
        $withdrawWay = ZjWithdrawWay::where(['withdraw_way_id'=>1,'status'=>1,'is_delete'=>0])->field('gmt_create,gmt_modified,is_delete',true)->find();
        $res['withdraw_notice']=$withdrawWay['notice'];
        //二维码图片内容
        //获取域名配置
        $website = ZjBasicConf::where(['name'=>'website'])->value('value');
        $res['qr_code'] = $website.'?invitationCode='.$res['code'];
        //邀请技巧
        $invite = ZjBasicConf::where(['name'=>'invite'])->value('value');
        $res['invite'] = explode('%,%',$invite);
        //邀请技巧
        $customer = ZjBasicConf::where(['name'=>'customer'])->value('value');
        $res['customer'] = explode('%,%',$customer);
        //最新消息数量
        $noticeNum = ZjUserNotice::where(['user_id'=>$res['user_id'],'is_read'=>0])->count();
        $res['notice_num']=$noticeNum;

        return $this->buildSuccess($res);
    }

    /**
     * 用户登录
     * @return array|\think\response\Json
     */
    public function login(){
        $this->requestType('POST');
        $postData = $this->request->post();
        $res = $this->logic->login($postData);
        if($res['code'] !== 1){
            return $this->buildFailed($res['code'], $res['msg'], $res['data']);
        }
        return $this->buildSuccess($res['data'],'登陆成功');
    }

    /**
     * 用户注册
     * @return array|\think\response\Json
     */
    public function register(){
        $this->requestType('POST');
        $postData = $this->request->post();
        $res = $this->logic->register($postData);
        if($res['code'] !== 1){
            return $this->buildFailed($res['code'], $res['msg'], $res['data']);
        }
        return $this->buildSuccess($res['data'],'注册成功');
    }

    /**
     * 发送验证码
     * @return array|\think\response\Json
     */
    public function sendCode(){
        $this->requestType('POST');
        $postData = $this->request->post();
        $res = $this->logic->sendCode($postData);
        if($res['code'] !== 1){
            return $this->buildFailed($res['code'], $res['msg'], $res['data']);
        }
        return $this->buildSuccess($res['data'],'发送验证码成功');
    }

    /**
     * 用户团队列表
     * @return array|\think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function myTeamList(){
        $this->requestType('POST');
        $postData = $this->request->post();
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $where=[];
        if($postData['type'] === 1){ //一级团队成员
            $where = [
                'superior_user_id'=>$this->userInfo['user_id'],
                'is_delete'=>0
            ];
        }else if($postData['type'] === 2){ //二级团队成员
            $where = [
                'superior_superior_user_id'=>$this->userInfo['user_id'],
                'is_delete'=>0
            ];
        }
        $res = ZjUser::where($where)->field('nickname,avatarurl,gmt_create')->paginate();
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND,'记录未找到','');
        }
        return $this->buildSuccess($res);
    }














}
