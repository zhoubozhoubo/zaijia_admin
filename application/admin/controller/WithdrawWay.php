<?php
namespace app\admin\controller;

use app\admin\model\ZjWithdrawWay;
use app\util\BaseController;
use think\Db;
use think\Exception;
use think\exception\DbException;

/**
*
* @package app\admin\controller
*/
class WithdrawWay extends BaseController
{

    public $table = 'ZjWithdrawWay';

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
        $db = $db->order('withdraw_way_id ASC');
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
        if ($postData['withdraw_way_id'] != 0) {
            ZjWithdrawWay::update($postData);
            return $this->buildSuccess([]);
        } else if (ZjWithdrawWay::create($postData)) {
            return $this->buildSuccess([]);
        }

        return $this->buildFailed();
    }


    /**
    * 改变
    * @return array
    */
    public function change()
    {
        $this->requestType('POST');
        $postData = $this->request->post();
        $res = ZjWithdrawWay::update($postData);
        if(!$res){
            return $this->buildFailed();
        }
        return $this->buildSuccess([]);
    }


    /**
    * 删除
    * @return array
    */
    public function delete()
    {
        $this->requestType('POST');
        $id = $this->request->post();
        if (ZjWithdrawWay::destroy($id)) {
            return $this->buildSuccess([]);
        }
        return $this->buildFailed();
    }
}