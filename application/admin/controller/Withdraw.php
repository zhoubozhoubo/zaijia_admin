<?php
namespace app\admin\controller;

use app\admin\model\ZjWithdraw;
use app\util\BaseController;
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
        $db = Db::view(['zj_withdraw'=>'a'])->view(['zj_user'=>'b'],'nickname','a.user_id=b.user_id','LEFT');
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
        $db = $db->where($where)->order('id desc');
        return $this->_list($db);
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
            ZjWithdraw::update($postData);
            return $this->buildSuccess([]);
        } else if (ZjWithdraw::create($postData)) {
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
        if (ZjWithdraw::destroy($id)) {
            return $this->buildSuccess([]);
        }
        return $this->buildFailed();
    }
}