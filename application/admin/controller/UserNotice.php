<?php
namespace app\admin\controller;

use app\admin\model\ZjUser;
use app\admin\model\ZjUserNotice;
use app\util\BaseController;
use think\Db;
use think\Exception;
use think\exception\DbException;

/**
*
* @package app\admin\controller
*/
class UserNotice extends BaseController
{

    public $table = 'ZjUserNotice';

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
        $db = Db::view(['zj_user_notice'=>'a'])->view(['zj_user'=>'b'],'nickname','a.user_id=b.user_id','LEFT');
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
                    if($key === 'title'){
                        $where["a.{$key}"] = ['like', '%' . $val . '%'];
                        continue;
                    }
                    if($key === 'content'){
                        $where["a.{$key}"] = ['like', '%' . $val . '%'];
                        continue;
                    }
                    if($key === 'is_read'){
                        $where["a.{$key}"] = ['like', '%' . $val . '%'];
                        continue;
                    }
                }
            }
        }
        $db = $db->where($where)->order('gmt_create desc');
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
        if($postData['user_id'] === 0){
            $userId = ZjUser::where('is_delete',0)->column('user_id');
        }else{
            $userId = explode(',',$postData['user_id']);
        }
        $data = [];
        foreach ($userId as $key=>$val){
            $data[$key]['user_id'] = $val;
            $data[$key]['title'] = $postData['title'];
            $data[$key]['content'] = $postData['content'];
        }
        $userNotice = new ZjUserNotice();
        $res = $userNotice->saveAll($data);
        if ($res) {
            return $this->buildSuccess($res);
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
        if (ZjUserNotice::destroy($id)) {
            return $this->buildSuccess([]);
        }
        return $this->buildFailed();
    }
}