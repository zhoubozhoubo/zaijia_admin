<?php

namespace app\api\controller;

use app\api\model\ZjNewsType;
use app\util\ReturnCode;

/**
 * 新闻类型Controller
 * Class NewsType
 * @package app\api\controller
 */
class NewsType extends Base
{
    /**
     * 新闻类型列表
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function newsTypeList()
    {
        $this->requestType('GET');
        $where=[
            'is_delete'=>0
        ];
        $res =ZjNewsType::where($where)->field('news_type_id,name')->order('sort ASC')->select();
        if (!$res) {
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND, '记录未找到', '');
        }
        return $this->buildSuccess($res);
    }

}
