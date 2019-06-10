<?php
namespace app\admin\controller;

use app\admin\model\ZjTask;
use app\util\BaseController;
use think\Db;
use think\Exception;
use think\exception\DbException;

/**
*
* @package app\admin\controller
*/
class Task extends BaseController
{

    public $table = 'ZjTask';

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
        $db = Db::view(['zj_task'=>'a'])->view(['zj_task_type'=>'b'],'name as task_type_name','a.task_type_id=b.id','LEFT');
        $where = [];
        if($searchConf){
            foreach ($searchConf as $key=>$val){
                if($val !== '' && $val !== []) {
                    if ($key === 'gmt_create') {
                        if ($val[0] && $val[1]) {
                            $db->whereBetween('a.gmt_create', ["{$val[0]} 00:00:00", "{$val[1]} 23:59:59"]);
                        }
                        continue;
                    }
                    if ($key === 'task_type_id') {
                        $where["b.id"] = $val;
                        continue;
                    }
                    if ($key === 'title') {
                        $where["a.{$key}"] = ['like', '%' . $val . '%'];
                        continue;
                    }
                    if ($key === 'is_repeat') {
                        $where["a.{$key}"] = $val;
                        continue;
                    }
                    if ($key === 'area') {
                        if ($val[0] && $val[1]) {
                            $where["a.{$key}"] = $val[1];
                        }
                        continue;
                    }
                    if ($key === 'device') {
                        $where["a.{$key}"] = $val;
                        continue;
                    }
                    if ($key === 'submit_way') {
                        $where["a.{$key}"] = $val;
                        continue;
                    }
                    if ($key === 'status') {
                        $where["a.{$key}"] = $val;
                        continue;
                    }
                }
            }
        }
        $db = $db->where($where)->order('status DESC,gmt_create DESC');
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
        print_r($postData);exit;
        if ($postData['task_id'] != 0) {
            ZjTask::update($postData);
            return $this->buildSuccess([]);
        } else if (ZjTask::create($postData)) {
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
        $res = ZjTask::update($postData);
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
        if (ZjTask::destroy($id)) {
            return $this->buildSuccess([]);
        }
        return $this->buildFailed();
    }
}