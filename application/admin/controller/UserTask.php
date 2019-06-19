<?php
namespace app\admin\controller;

use app\admin\model\ZjCommission;
use app\admin\model\ZjCommissionConf;
use app\admin\model\ZjTask;
use app\admin\model\ZjUser;
use app\admin\model\ZjUserIncome;
use app\admin\model\ZjUserNotice;
use app\admin\model\ZjUserTask;
use app\util\BaseController;
use app\util\ReturnCode;
use think\Db;
use think\Exception;
use think\exception\DbException;

/**
*
* @package app\admin\controller
*/
class UserTask extends BaseController
{

    public $table = 'ZjUserTask';

    /**
    * 获取列表
    * @return array|string
    * @throws DbException
    * @throws Exception
    */
    public function getList()
    {
        $this->requestType('GET');
        $searchConf = json_decode($this->request->param('searchConf', ''),true);
        $db = Db::view(['zj_user_task'=>'a'])->view(['zj_user'=>'b'],'nickname,avatarurl,phone','a.user_id=b.user_id','LEFT')->view(['zj_task'=>'c'],'title','a.task_id=c.task_id','LEFT');
        $where = [];
        if($searchConf){
            foreach ($searchConf as $key=>$val){
                if($val !== ''){
                    if($key === 'gmt_create'){
                        if($val[0] && $val[1]){
                            $db->whereBetween('a.gmt_create', ["{$val[0]} 00:00:00", "{$val[1]} 23:59:59"]);
                        }
                        continue;
                    }
                    if($key === 'nickname'){
                        $where["b.{$key}"] = ['like', '%' . $val . '%'];
                        continue;
                    }
                    if($key === 'task_id'){
                        $where["c.{$key}"] = $val;
                        continue;
                    }
                    if($key === 'title'){
                        $where["c.{$key}"] = ['like', '%' . $val . '%'];
                        continue;
                    }
                    if($key === 'status'){
                        $where["a.{$key}"] = $val;
                        continue;
                    }
                    if($key === 'submit_time'){
                        if($val[0] && $val[1]){
                            $db->whereBetween('a.submit_time', ["{$val[0]} 00:00:00", "{$val[1]} 23:59:59"]);
                        }
                        continue;
                    }
                    if($key === 'check_time'){
                        if($val[0] && $val[1]){
                            $db->whereBetween('a.check_time', ["{$val[0]} 00:00:00", "{$val[1]} 23:59:59"]);
                        }
                        continue;
                    }
                }
            }
        }
        $db = $db->where($where)->order('gmt_create desc');
        return $this->_list($db);
    }

    public function _getList_data_filter(&$data){
        foreach ($data as &$item){
            $item['submit_img'] = explode('%,%',$item['submit_img']);
        }
    }


    /**
    * 保存
    * @return array
    */
    public function save()
    {
        $this->requestType('POST');
        $postData = $this->request->post();
        if ($postData['id'] != 0) {
            $userTask = ZjUserTask::where(['id'=>$postData['id']])->field('task_id,user_id,gmt_create')->find();
            if($postData['status'] === 2 || $postData['status'] === 3){
                $postData['check_time'] = date('Y-m-d H:i:s');
            }
            //如果任务通过 TODO 分销佣金
            if($postData['status'] === 2){
                $this->commissionShare($postData['id']);
                //发送消息给用户
                $this->sendNotice($userTask['user_id'],'任务通过',"您于'{$userTask['gmt_create']}'领取的任务已通过审核");
            }

            //如果未通过 任务已领取数量自减
            if($postData['status'] === 3){
                ZjTask::where(['task_id'=>$userTask['task_id']])->setDec('have_number');
                //发送消息给用户
                $this->sendNotice($userTask['user_id'],'任务未通过',"您于'{$userTask['gmt_create']}'领取的任务未通过审核,有疑问请联系管理员");
            }
            ZjUserTask::update($postData);
            return $this->buildSuccess([]);
        } else if (ZjUserTask::create($postData)) {
            return $this->buildSuccess([]);
        }

        return $this->buildFailed();
    }


    /**
    * 删除
    * @return array
    */
    public function delete()
    {
        $this->requestType('POST');
        $id = $this->request->post();
        if (ZjUserTask::destroy($id)) {
            return $this->buildSuccess([]);
        }
        return $this->buildFailed();
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
            $userTask = ZjUserTask::where(['id'=>$user_task_id])->field('user_id,task_id,gmt_create')->find();
            //任务数据
            $task = ZjTask::where(['task_id'=>$userTask['task_id']])->field('money,task_id')->find();
            //用户数据
            $user = ZjUser::where(['user_id'=>$userTask['user_id'],'is_delete'=>0])->field('superior_user_id,superior_superior_user_id,user_id,nickname')->find();
            //任务金额
            $money = $task['money'];
            if($user['superior_user_id'] !== 0){
                //存在上级 TODO 上级分享一级佣金
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
                //添加佣金数据
                ZjCommission::create($oneCommission);
                //上级增加金额
                ZjUser::where(['user_id'=>$user['superior_user_id']])->setInc('money',$oneCommission['money']*100);
                //发送消息给用户
                $this->sendNotice($user['superior_user_id'],'佣金到账',"您的一级成员'{$user['nickname']}'任务通过了审核,收到佣金'{$oneCommission['money']}'");
                //剩余任务金额
                $money -=$oneCommission['money'];
            }
            if($user['superior_superior_user_id'] !== 0){
                //存在上上级 TODO 上上级分享二级佣金
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
                //添加佣金数据
                ZjCommission::create($twoCommission);
                //上上级增加金额
                ZjUser::where(['user_id'=>$user['superior_superior_user_id']])->setInc('money',$twoCommission['money']*100);
                //发送消息给用户
                $this->sendNotice($user['superior_user_id'],'佣金到账',"您的二级成员'{$user['nickname']}'任务通过了审核,收到佣金'{$twoCommission['money']}'");
                //剩余任务金额
                $money-=$twoCommission['money'];
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
            $this->sendNotice($user['user_id'],'任务收入',"您于'{$userTask['gmt_create']}'领取的任务通过了审核,收入任务金额'{$userIncome['money']}'");
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