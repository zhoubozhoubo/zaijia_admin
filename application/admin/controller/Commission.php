<?php
namespace app\admin\controller;

use app\admin\model\ZjCommission;
use app\util\BaseController;
use think\Db;
use think\Exception;
use think\exception\DbException;

/**
*
* @package app\admin\controller
*/
class Commission extends BaseController
{

    public $table = 'ZjCommission';

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
        $db = Db::view(['zj_commission'=>'a'])->view(['zj_user'=>'b'],'nickname','a.user_id=b.user_id','LEFT')->view(['zj_user'=>'c'],'nickname as from_user_nickname','a.from_user_id=c.user_id','LEFT')->view(['zj_task'=>'d'],'title','a.task_id=d.task_id','LEFT');
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
                    if ($key === 'type') {
                        $where["a.{$key}"] = $val;
                        continue;
                    }
                    if ($key === 'nickname') {
                        $where["b.{$key}"] = ['like', '%' . $val . '%'];
                        continue;
                    }
                    if ($key === 'from_user_nickname') {
                        $where["c.nickname"] = ['like', '%' . $val . '%'];
                        continue;
                    }
                    if ($key === 'title') {
                        $where["d.{$key}"] = ['like', '%' . $val . '%'];
                        continue;
                    }
                }
            }
        }
        $db = $db->where($where)->order('id desc');
        return $this->_list($db);
    }
}