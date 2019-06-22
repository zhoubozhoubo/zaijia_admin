<?php
namespace app\admin\controller;

use app\admin\model\ZjNews;
use app\admin\model\ZjNewsType;
use app\util\BaseController;
use app\util\ReturnCode;
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
        $where = [];
        if($searchConf){
            foreach ($searchConf as $key=>$val){
                if($val !== '') {
                    if ($key === 'name') {
                        $where[$key] = ['like', '%' . $val . '%'];
                        continue;
                    }
                    if ($key === 'status') {
                        $where[$key] = $val;
                        continue;
                    }
                }
            }
        }
        $where['is_delete']=0;
        $db = $db->where($where)->order('sort ASC');
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
        //查询当前任务分类下是否有任务数据
        $news = ZjNews::where(['news_type_id'=>$postData['news_type_id'],'is_delete'=>0])->count();
        if($news>0){
            return $this->buildFailed(ReturnCode::DELETE_FAILED,'当前分类下存在任务数据，无法关闭','');
        }
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
        //查询当前新闻分类下是否有新闻数据
        $news = ZjNews::where(['news_type_id'=>$id['news_type_id'],'is_delete'=>0])->count();
        if($news>0){
            return $this->buildFailed(ReturnCode::DELETE_FAILED,'当前分类下存在新闻数据，无法删除','');
        }
        if (ZjNewsType::del($id)) {
            return $this->buildSuccess([]);
        }
        return $this->buildFailed();
    }
}