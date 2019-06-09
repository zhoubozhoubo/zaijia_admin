<?php

namespace app\admin\controller;

use app\admin\model\ZjUserIncome;
use app\util\BaseController;
use think\Db;
use think\Exception;
use think\exception\DbException;

/**
 * 用户收入控制器
 * @package app\admin\controller
 */
class UserIncome extends BaseController
{

    public $table = 'ZjUserIncome';

    /**
     * 获取列表
     * @return array|string
     * @throws DbException
     * @throws Exception
     */
    public function getList()
    {
        $this->requestType('GET');
        $searchConf = json_decode($this->request->param('searchConf', ''), true);
        $db = Db::view(['zj_user_income'=>'a'])->view(['zj_user'=>'b'],'nickname','a.user_id=b.user_id','LEFT')->view(['zj_task'=>'c'],'title','a.task_id=c.task_id','LEFT');
        $where = [];
        if ($searchConf) {
            foreach ($searchConf as $key => $val) {
                if($val !== ''){
                    if($key === 'nickname'){
                        $where["b.{$key}"] = ['like', '%' . $val . '%'];
                        continue;
                    }
                    if($key === 'title'){
                        $where["c.{$key}"] = ['like', '%' . $val . '%'];
                        continue;
                    }
                }
            }
        }
        $db = $db->where($where)->order('gmt_create desc');
        return $this->_list($db);
    }
}