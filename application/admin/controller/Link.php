<?php
namespace app\admin\controller;

use app\admin\model\ZjLink;
use app\util\BaseController;
use think\Db;
use think\Exception;
use think\exception\DbException;

/**
*
* @package app\admin\controller
*/
class Link extends BaseController
{

    public $table = 'ZjLink';

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
        $db = Db::name($this->table);
        if($searchConf){
            foreach ($searchConf as $key=>$val){
                if($val === ''){
                    unset($searchConf[$key]);
                }
                else{
                    $searchConf[$key] = ['like', '%'.$val.'%'];
                }
            }
        }
        $where = $searchConf;
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
            ZjLink::update($postData);
            return $this->buildSuccess([]);
        } else if (ZjLink::create($postData)) {
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
        $res = ZjLink::update($postData);
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
        if (ZjLink::destroy($id)) {
            return $this->buildSuccess([]);
        }
        return $this->buildFailed();
    }
}