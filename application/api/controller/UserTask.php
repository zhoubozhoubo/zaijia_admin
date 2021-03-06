<?php

namespace app\api\controller;

use app\admin\model\ZjCommissionConf;
use app\api\model\ZjCommission;
use app\api\model\ZjTask;
use app\api\model\ZjUser;
use app\api\model\ZjUserIncome;
use app\api\model\ZjUserNotice;
use app\api\model\ZjUserTask;
use app\util\ReturnCode;
use think\Db;
use WeChat\Media;

/**
 * 用户任务Controller
 * Class UserTask
 * @package app\api\controller
 */
class UserTask extends Base
{
    //初始化配置
    public $config = [
        'token' => 'xtcyivubohibxrctyvubn6rty',
        'appid' => 'wxc5b8b08c2e2b506f',
        'appsecret' => '3e0301d69ff031f7c7024e2c01ce05ea'
    ];
    /**
     * 任务列表
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function taskList(){
        $this->requestType('POST');
        $postData = $this->request->post();
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $where = [
            'user_id'=>$this->userInfo['user_id'],
            'status'=>$postData['status'],
            'is_delete'=>0
        ];
        $res = ZjUserTask::where($where)->field('gmt_modified,is_delete',true)->paginate();
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND,'记录未找到','');
        }
        foreach ($res as $key=>$item){
            $item->task;
            $item['img']=$item['task']['task_type']['img'];
            //通过率
//            $pass_number = ZjUserTask::where(['task_id'=>$item['task_id'],'status'=>2,'is_delete'=>0])->count();
//            $all_number = ZjUserTask::where(['task_id'=>$item['task_id'],'status'=>['in','2,3'],'is_delete'=>0])->count();
//            if($all_number){
//                $item['ratio'] = number_format($pass_number/$all_number*100, 2, '.', '');
//            }else{
//                $item['ratio'] = 0;
//            }

            //倒计时
            $surplusTime = 0;
            if ($item['status'] == 0) {
                //执行中返回执行剩余时间
                $finishDuration = $item['task']['finish_duration'] * 60 * 60;
                $surplusTime = $finishDuration - (time() - strtotime($item['gmt_create']));
                //当时间小于0时，表示执行阶段已结束，进行订单放弃处理
                if ($surplusTime <= 0) {
                    ZjUserTask::update(['id' => $item['id'], 'status' => 4]);
                    //任务已领取数量自减
                    ZjTask::where(['task_id'=>$res['task_id']])->setDec('have_number');
                    unset($res[$key]);
                }
            } else if ($item['status'] == 1) {
                //审核中返回审核剩余时间
                $checkDuration = $item['task']['check_duration'] * 60 * 60;
                $surplusTime = $checkDuration - (time() - strtotime($item['submit_time']));
                //当时间小于0时，表示审核阶段已结束，进行订单自动通过处理
                if ($surplusTime <= 0) {
                    ZjUserTask::update(['id' => $item['id'],'check_time'=>date('Y-m-d H:i:s'), 'status' => 2]);
                    // TODO 用户收入，佣金记录
                    $this->commissionShare($item['id']);
                    unset($res[$key]);
                }
            }
            $item['surplus_time'] = $surplusTime * 1000;
            $item['count_time'] = '--:--:--';
        }
        return $this->buildSuccess($res);
    }

    /**
     * 用户任务详情
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function taskDetails(){
        $this->requestType('POST');
        $id = $this->request->post('id','');
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $where = [
            'user_id'=>$this->userInfo['user_id'],
            'id'=>$id,
            'is_delete'=>0
        ];
        $res = ZjUserTask::where($where)->field('gmt_modified,is_delete',true)->find();
        if(!$res){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND, '记录未找到', '');
        }
        $res->task;
        $surplusTime = 0;
        if ($res['status'] == 0) {
            //执行中返回执行剩余时间
            $finishDuration = $res['task']['finish_duration'] * 60 * 60;
            $surplusTime = $finishDuration - (time() - strtotime($res['gmt_create']));
            //当时间小于0时，表示执行阶段已结束，进行订单放弃处理
            if ($surplusTime <= 0) {
                ZjUserTask::update(['id' => $res['id'], 'status' => 4]);
                $res['status'] = 4;
                //任务已领取数量自减
                ZjTask::where(['task_id'=>$res['task_id']])->setDec('have_number');
            }
        } else if ($res['status'] == 1) {
            //执行中返回审核剩余时间
            $checkDuration = $res['task']['check_duration'] * 60 * 60;
            $surplusTime = $checkDuration - (time() - strtotime($res['submit_time']));
            //当时间小于0时，表示审核阶段已结束，进行订单自动通过处理
            if ($surplusTime <= 0) {
                ZjUserTask::update(['id' => $res['id'],'check_time'=>date('Y-m-d H:i:s'), 'status' => 2]);
                $res['status'] = 2;
                // TODO 用户收入，佣金记录
                $this->commissionShare($id);
            }
        }
        $res['surplus_time'] = $surplusTime * 1000;
        return $this->buildSuccess($res);
    }

    /**
     * 添加任务
     * @return \think\response\Json
     * @throws \think\Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function addTask(){
        $this->requestType('POST');
        $postData = $this->request->post();
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        //判断任务状态，以及任务是否已领完
        $where = [
            'task_id'=>$postData['task_id'],
            'end_date'=>['>=',date('Y-m-d')],
            'status'=>1
        ];
        $task = ZjTask::where($where)->where('number','neq','have_number')->find();
        if(!$task){
            return $this->buildFailed(ReturnCode::ADD_FAILED, '该任务已下架或已结束', '');
        }

        $data = [
            'user_id'=>$this->userInfo['user_id'],
            'task_id'=>$postData['task_id']
        ];
        $res = ZjUserTask::create($data);
        if(!$res){
            return $this->buildFailed(ReturnCode::ADD_FAILED,'领取任务失败','');
        }
        //返回任务完成时间
        $finishDuration = ZjTask::where(['task_id'=>$postData['task_id']])->field('finish_duration')->find();
        $res['finish_duration']=$finishDuration['finish_duration']*60*60*1000;
        //任务已领取数量自增
        ZjTask::where(['task_id'=>$postData['task_id']])->setInc('have_number');
        //发送消息给用户
        $date = date('Y-m-d H:i:s');
        $this->sendNotice($data['user_id'],'领取任务成功',"您于'{$date}'领取了任务,请在规定时间内完成,超时将自动放弃任务");
        return $this->buildSuccess($res,'成功领取任务');
    }

    /**
     * 提交任务
     * @return \think\response\Json
     */
    public function submitTask(){
        $this->requestType('POST');
        $postData = $this->request->post();
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $data = [
            'id'=>$postData['id'],
            'user_id'=>$this->userInfo['user_id'],
            'submit_text'=>$postData['submit_text'],
            'submit_time'=>date('Y-m-d H:i:s'),
            'status'=>1
        ];

        $media = new Media($this->config);
        $submitServerIdImg = [];
        if($postData['submit_server_id']){
            foreach ($postData['submit_server_id'] as $key => $item) {
//                $img = $media->get($item);
//                $resource = fopen($_SERVER['DOCUMENT_ROOT'] . "/upload/imgTemp.jpg", "w");
//                fwrite($resource, $img);
//                fclose($resource);

                $path = '/upload/' . date('Ymd', time()) . '/';
                $new_name = md5(time() . uniqid()) . '.' . 'jpg';
                if (!file_exists($_SERVER['DOCUMENT_ROOT'] . $path)) {
                    mkdir($_SERVER['DOCUMENT_ROOT'] . $path, 0755, true);
                }
//                $img = $media->get($item);
//                $resource = fopen($_SERVER['DOCUMENT_ROOT'] . $path . $new_name, "w");
//                fwrite($resource, $img);
//                fclose($resource);
//                $submitServerIdImg[$key] = $this->request->domain() . $path . $new_name;

                $res = $media->get($item);
                if(is_array($res)){
                    $submitServerIdImg[$key] =$res['access_token'];
                }else{
                    $resource = fopen($_SERVER['DOCUMENT_ROOT'] . $path . $new_name, "w");
                    fwrite($resource, $res);
                    fclose($resource);
                    $submitServerIdImg[$key] = $this->request->domain() . $path . $new_name;
                }
//                $submitServerIdImg[$key] = $res;
//                $submitServerIdImg[$key] = $item;
            }
            $data['submit_img'] = implode('%,%',$submitServerIdImg);
        }


        $res = ZjUserTask::update($data);
        if(!$res){
            return $this->buildFailed(ReturnCode::UPDATE_FAILED,'提交任务失败','');
        }
        //发送消息给用户
        $this->sendNotice($data['user_id'],'提交任务成功',"您于'{$res['submit_time']}'提交了任务,请等待后台审核");
        return $this->buildSuccess($res);
    }

    /**
     * 放弃任务
     * @return \think\response\Json
     * @throws \think\Exception
     */
    public function delTask(){
        $this->requestType('POST');
        $postData = $this->request->post();
        if(!$this->userInfo){
            return $this->buildFailed(ReturnCode::ACCESS_TOKEN_TIMEOUT, '非法请求', '');
        }
        $data = [
            'id'=>$postData['id'],
            'user_id'=>$this->userInfo['user_id'],
            'status'=>4
        ];
        $res = ZjUserTask::update($data);
        if(!$res){
            return $this->buildFailed(ReturnCode::UPDATE_FAILED,'放弃任务失败','');
        }
        //任务已领取数量自减
        $taskId = ZjUserTask::where(['id'=>$postData['id']])->value('task_id');
        ZjTask::where(['task_id'=>$taskId])->setDec('have_number');
        //发送消息给用户
        $this->sendNotice($data['user_id'],'放弃任务',"您放弃了任务,请再接再厉");
        return $this->buildSuccess($res);
    }


    /**
     * 佣金分享
     * @param $user_task_id
     * @return mixed
     */
    public function commissionShare($user_task_id){
        // 启动事务
        Db::startTrans();
        try {
            //用户任务数据
            $userTask = ZjUserTask::where(['id'=>$user_task_id])->field('user_id,task_id')->find();
            //任务数据
            $task = ZjTask::where(['task_id'=>$userTask['task_id']])->field('money,task_id')->find();
            //用户数据
            $user = ZjUser::where(['user_id'=>$userTask['user_id'],'is_delete'=>0])->field('superior_user_id,superior_superior_user_id,user_id,nickname')->find();
            //任务金额
            $money = $task['money'];
            //一级佣金比例
            $commissionConf = ZjCommissionConf::where(['level'=>1])->value('value');
            //一级佣金数据
            $oneCommission = [
                'type'=>1,
                'user_id'=>$user['superior_user_id'],
                'money'=>$task['money'] * $commissionConf/100,
                'from_user_id'=>$user['user_id'],
                'task_id'=>$task['task_id']
            ];
            //剩余任务金额
            $money -=$oneCommission['money'];
            if($user['superior_user_id'] != 0){
                //存在上级 TODO 上级分享一级佣金
                //添加佣金数据
                ZjCommission::create($oneCommission);
                //上级增加金额
                ZjUser::where(['user_id'=>$user['superior_user_id']])->setInc('money',$oneCommission['money']*100);
                //发送消息给用户
                $this->sendNotice($user['superior_user_id'],'佣金到账',"您的一级成员'{$user['nickname']}'任务通过了审核,收到佣金'{$oneCommission['money']}'");
            }
            //二级佣金比例
            $commissionConf = ZjCommissionConf::where(['level'=>2])->value('value');
            //二级佣金数据
            $twoCommission = [
                'type'=>2,
                'user_id'=>$user['superior_superior_user_id'],
                'money'=>$task['money'] * $commissionConf/100,
                'from_user_id'=>$user['user_id'],
                'task_id'=>$task['task_id']
            ];
            //剩余任务金额
            $money-=$twoCommission['money'];
            if($user['superior_superior_user_id'] != 0){
                //存在上上级 TODO 上上级分享二级佣金
                //添加佣金数据
                ZjCommission::create($twoCommission);
                //上上级增加金额
                ZjUser::where(['user_id'=>$user['superior_superior_user_id']])->setInc('money',$twoCommission['money']*100);
                //发送消息给用户
                $this->sendNotice($user['superior_user_id'],'佣金到账',"您的二级成员'{$user['nickname']}'任务通过了审核,收到佣金'{$twoCommission['money']}'");
            }
            //添加用户收入数据
            $userIncome = [
                'user_id'=>$user['user_id'],
                'task_id'=>$task['task_id'],
                'money'=>$money
            ];
            ZjUserIncome::create($userIncome);
            //用户增加金额
            ZjUser::where(['user_id'=>$user['user_id']])->setInc('money',$money*100);
            //发送消息给用户
            $date = date('Y-m-d H:i:s');
            $this->sendNotice($user['user_id'],'任务收入',"您于'{$date}'领取的任务通过了审核,收入任务金额'{$userIncome['money']}'");
            // 提交事务
            Db::commit();
        } catch (\Exception $e) {
            // 回滚事务
            Db::rollback();
            return $this->buildFailed('');
        }


    }



    /**
     * 发送消息给用户
     * @param $user_id
     * @param $title
     * @param $content
     */
    public function sendNotice($user_id,$title,$content){
        $notice = [
            'user_id'=>$user_id,
            'title'=>$title,
            'content'=>$content
        ];
        ZjUserNotice::create($notice);
    }








}
