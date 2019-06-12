<?php

namespace app\api\controller;

use app\api\model\Area;
use app\api\model\ZjBanner;
use app\api\model\ZjLink;
use app\util\ReturnCode;

/**
 * 首页Controller
 * Class Index
 * @package app\api\controller
 */
class Index extends Base
{
    /**
     * 城市列表
     * @return array|\think\response\Json
     */
    public function areaList()
    {
        $this->requestType('GET');
        $res = Area::where(['level' => 1])->field('id,code as value,name as label')->select();
        if (!$res) {
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND, '记录未找到', '');
        }
        foreach ($res as &$item) {
            $item['children'] = $item->City;
        }
        return $this->buildSuccess($res);
    }

    /**
     * 轮播图列表
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function bannerList()
    {
        $this->requestType('GET');
        $where = [
            'status' => 1,
            'is_delete' => 0
        ];
        $res = ZjBanner::where($where)->order('sort ASC')->field('img,url')->select();
        if (!$res) {
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND, '记录未找到', '');
        }
        return $this->buildSuccess($res);
    }

    /**
     * 链接列表
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function linkList()
    {
        $this->requestType('GET');
        $where = [
            'status' => 1,
            'is_delete' => 0
        ];
        $res = ZjLink::where($where)->order('sort ASC')->field('img,url')->select();
        if (!$res) {
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND, '记录未找到', '');
        }
        return $this->buildSuccess($res);
    }
}
