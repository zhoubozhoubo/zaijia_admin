<?php

namespace app\admin\controller;

use app\admin\model\ZjTask;
use app\admin\model\ZjUserTask;
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
        $searchConf = json_decode($this->request->param('searchConf', ''), true);
        $db = Db::view(['zj_task' => 'a'])->view(['zj_task_type' => 'b'], 'name as task_type_name', 'a.task_type_id=b.id', 'LEFT')->view(['area' => 'c'], 'name as city_name', 'a.city=c.code', 'LEFT');
        $where = [];
        if ($searchConf) {
            foreach ($searchConf as $key => $val) {
                if ($val !== '' && $val !== []) {
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

    public function _getList_data_filter(&$data){
        foreach ($data as &$item){
            $item['wait_check'] = ZjUserTask::where(['task_id'=>$item['task_id'],'status'=>1,'is_delete'=>0])->count();
            $item['have_pass'] = ZjUserTask::where(['task_id'=>$item['task_id'],'status'=>2,'is_delete'=>0])->count();
            $item['no_pass'] = ZjUserTask::where(['task_id'=>$item['task_id'],'status'=>3,'is_delete'=>0])->count();
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
        $postData['end_date'] = date('Y-m-d', strtotime($postData['end_date']));
        if (isset($postData['area'])) {
            if($postData['area'] !== []){
                $postData['province'] = $postData['area'][0];
                $postData['city'] = $postData['area'][1];
            }
            unset($postData['area']);
        }
        $postData['step'] = implode('%,%',$postData['step']);
        $postData['show_img'] = implode('%,%',$postData['show_img']);
        $postData['submit_img'] = implode('%,%',$postData['submit_img']);

        if ($postData['task_id'] !== 0) {
            $number = ZjTask::where('task_id', $postData['task_id'])->value('number');
            $postData['number'] += $number;
            $res = ZjTask::update($postData);
            return $this->buildSuccess($res);
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
        if (!$res) {
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