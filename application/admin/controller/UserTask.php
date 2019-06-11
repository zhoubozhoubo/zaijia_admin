<?php
namespace app\admin\controller;

use app\admin\model\ZjUserTask;
use app\util\BaseController;
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
            if($postData['status'] === 2 || $postData['status'] === 3){
                $postData['check_time'] = date('Y-m-d H:i:s');
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
}