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
        $provinceList =Area::where(['level' => 1])->field('code,name')->select();
        foreach ($provinceList as $item){
            $newProvinceList[$item['code']] = $item['name'];
        }
        $cityList =Area::where(['level' => 2])->field('code,name')->select();
        foreach ($cityList as $item){
            $newCityList[$item['code']] = $item['name'];
        }
        $res=[
            'province_list'=>$newProvinceList,
            'city_list'=>$newCityList
        ];
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
