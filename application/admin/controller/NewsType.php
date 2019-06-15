<?php
namespace app\admin\controller;

use app\admin\model\ZjNewsType;
use app\util\BaseController;
use think\Db;
use think\Exception;
use think\exception\DbException;

/**
*
* @package app\admin\controller
*/
class NewsType extends BaseController
{

    public $table = 'ZjNewsType';

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
                else if($key === 'status'){
                    $searchConf[$key] = $val;
                }
                else{
                    if ($key === 'status') {
                        $searchConf[$key] = $val;
                    }
                    else{
                        $searchConf[$key] = ['like', '%'.$val.'%'];
                    }
                }
            }
        }
        $where = $searchConf;
        $db = $db->where($where)->order('news_type_id desc');
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
        if ($postData['news_type_id'] !== 0) {
            ZjNewsType::update($postData);
            return $this->buildSuccess([]);
        } else if (ZjNewsType::create($postData)) {
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
        $res = ZjNewsType::update($postData);
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
        if (ZjNewsType::destroy($id)) {
            return $this->buildSuccess([]);
        }
        return $this->buildFailed();
    }
}