<?php
namespace app\admin\controller;

use app\admin\model\ZjNews;
use app\util\BaseController;
use think\Db;
use think\Exception;
use think\exception\DbException;

/**
*
* @package app\admin\controller
*/
class News extends BaseController
{

    public $table = 'ZjNews';

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
        $db = Db::view(['zj_news' => 'a'])->view(['zj_news_type' => 'b'], 'name as news_type_name', 'a.news_type_id=b.news_type_id', 'LEFT');
        $where = [];
        if($searchConf){
            foreach ($searchConf as $key=>$val){
                if ($val !== '') {
                    if ($key === 'news_type_id') {
                        $where["b.news_type_id"] = $val;
                        continue;
                    }
                    if ($key === 'title') {
                        $where["a.{$key}"] = ['like', '%' . $val . '%'];
                        continue;
                    }
                    if ($key === 'status') {
                        $where["a.{$key}"] = $val;
                        continue;
                    }
                }
            }
        }
        $db = $db->where($where)->order('news_id desc');
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
        if ($postData['news_id'] !== 0) {
            ZjNews::update($postData);
            return $this->buildSuccess([]);
        } else if (ZjNews::create($postData)) {
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
        $res = ZjNews::update($postData);
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
        if (ZjNews::destroy($id)) {
            return $this->buildSuccess([]);
        }
        return $this->buildFailed();
    }
}