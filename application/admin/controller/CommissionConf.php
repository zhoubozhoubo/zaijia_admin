<?php
namespace app\admin\controller;

use app\admin\model\ZjCommissionConf;
use app\util\BaseController;
use think\Db;
use think\Exception;
use think\exception\DbException;

/**
*
* @package app\admin\controller
*/
class CommissionConf extends BaseController
{

    public $table = 'ZjCommissionConf';

    /**
    * 获取列表
    * @return array|string
    * @throws DbException
    * @throws Exception
    */
    public function getList()
    {
        $this->requestType('GET');
        $db = Db::name($this->table);
        $db = $db->order('id ASC');
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
            ZjCommissionConf::update($postData);
            return $this->buildSuccess([]);
        } else if (ZjCommissionConf::create($postData)) {
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
        if (ZjCommissionConf::destroy($id)) {
            return $this->buildSuccess([]);
        }
        return $this->buildFailed();
    }
}