<?php

namespace app\api\controller;

use app\api\model\ZjNews;
use app\util\ReturnCode;

/**
 * 新闻Controller
 * Class News
 * @package app\api\controller
 */
class News extends Base
{
    /**
     * 新闻列表
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function newsList()
    {
        $this->requestType('GET');
        $getData = $this->request->get();
        $where = [
            'news_type_id'=>$getData['news_type_id'],
            'status'=>['neq', 1],
            'is_delete'=>0
        ];
        $res =ZjNews::where($where)->field('news_id,news_type_id,title,img,comment,number,gmt_create')->order('gmt_create DESC')->paginate();
        if (!$res) {
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND, '记录未找到', '');
        }
        return $this->buildSuccess($res);
    }

    /**
     * 新闻详情
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function newsDetails()
    {
        $this->requestType('GET');
        $newsId = $this->request->get('news_id', '');
        $where = [
            'news_id' => $newsId,
            'is_delete' => 0
        ];
        $res = ZjNews::where($where)->field('gmt_modified,is_delete', true)->find();
        if (!$res) {
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND, '记录未找到', '');
        }
        //新闻阅读数自加1
        ZjNews::where($where)->setInc('number');
        return $this->buildSuccess($res);
    }
}
