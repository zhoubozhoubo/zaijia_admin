<?php

namespace app\admin\controller;

use app\admin\model\ZjUser;
use app\util\BaseController;
use think\Db;
use think\Exception;
use think\exception\DbException;

/**
 * 用户控制器
 * @package app\admin\controller
 */
class UserCon extends BaseController
{

    public $table = 'ZjUser';

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
        $db = Db::view(['zj_user'=>'a'])->view(['zj_user'=>'b'], 'nickname as superior_user_nickname','a.superior_user_id = b.user_id','LEFT');
        $where = [];
        if ($searchConf) {
            if($searchConf['level'] == 1) {
                $where["a.superior_user_id"] = $searchConf['user_id'];
            }else if($searchConf['level'] == 2) {
                $where["a.superior_superior_user_id"] = $searchConf['user_id'];
            }
            foreach ($searchConf as $key => $val) {
                if($val !== ''){
                    if ($key === 'gmt_create') {
                        if($val[0] && $val[1]){
                            $db->whereBetween('a.gmt_create', ["{$val[0]} 00:00:00", "{$val[1]} 23:59:59"]);
                        }
                        continue;
                    }
                    if($key === 'nickname'){
                        $where["a.{$key}"] = ['like', '%' . $val . '%'];
                        continue;
                    }
                    if($key === 'phone'){
                        $where["a.{$key}"] = ['like', '%' . $val . '%'];
                        continue;
                    }
                }
            }
        }
        $db = $db->where($where)->order('gmt_create desc');
        return $this->_list($db);
    }
}