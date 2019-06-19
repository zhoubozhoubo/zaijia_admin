<?php
namespace app\admin\controller;

use app\admin\model\ZjUser;
use app\admin\model\ZjWithdraw;
use app\admin\model\ZjUserNotice;
use app\util\BaseController;
use app\util\ReturnCode;
use think\Db;
use think\Exception;
use think\exception\DbException;

/**
*
* @package app\admin\controller
*/
class Withdraw extends BaseController
{

    public $table = 'ZjWithdraw';

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
        $db = Db::view(['zj_withdraw'=>'a'])->view(['zj_user'=>'b'],'nickname','a.user_id=b.user_id','LEFT')->view(['zj_withdraw_way'=>'c'],'name as withdraw_name','a.withdraw_way_id=c.withdraw_way_id','LEFT');
        $where = [];
        if($searchConf){
            foreach ($searchConf as $key=>$val){
                if($val !== '') {
                    if ($key === 'gmt_create') {
                        if ($val[0] && $val[1]) {
                            $db->whereBetween('a.gmt_create', ["{$val[0]} 00:00:00", "{$val[1]} 23:59:59"]);
                        }
                        continue;
                    }
                    if ($key === 'nickname') {
                        $where["b.{$key}"] = ['like', '%' . $val . '%'];
                        continue;
                    }
                    if ($key === 'withdraw_way_id') {
                        $where["a.{$key}"] = $val;
                        continue;
                    }
                    if ($key === 'account') {
                        $where["a.{$key}"] = ['like', '%' . $val . '%'];
                        continue;
                    }
                    if ($key === 'status') {
                        $where["a.{$key}"] = $val;
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
            $item['money'] =  number_format($item['money'] / 100, 2, '.', '');
        }
    }


    /**
    * 保存
    * @return array
    */
    public function save()
    {
        // 启动事务
        Db::startTrans();
        try {
            $this->requestType('POST');
            $postData = $this->request->post();
            $res = ZjWithdraw::update($postData);
            if(!$res){
                return $this->buildFailed(ReturnCode::UPDATE_FAILED,'操作失败,请稍候再试','');
            }
            $withdraw = ZjWithdraw::where(['id'=>$postData['id']])->field('user_id,money,name,account,gmt_create')->find();
            if($postData['status'] === 2){
                //如果提现未通过 TODO 返回余额给用户
                ZjUser::where(['user_id'=>$withdraw['user_id']])->setInc('money',$withdraw['money']);
                //发送消息给用户
                $this->sendNotice($withdraw['user_id'],'申请提现失败',"您于'{$withdraw['gmt_create']}'发起的申请提现被拒绝,有疑问请联系管理员");
            }
            // 提交事务
            Db::commit();
            //发送消息给用户
            $this->sendNotice($withdraw['user_id'],'申请提现成功',"您于'{$withdraw['gmt_create']}'发起的申请提现已通过,请到账号'{$withdraw['name']}({$withdraw['account']})'查收");
            return $this->buildSuccess($res,'操作成功');
        } catch (\Exception $e) {
            // 回滚事务
            Db::rollback();
            return $this->buildFailed(ReturnCode::UPDATE_FAILED,'操作失败,请稍候再试','');
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