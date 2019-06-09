<?php

namespace app\admin\controller;

use app\admin\model\Area;
use app\util\BaseController;
use think\Db;
use think\Exception;
use think\exception\DbException;

/**
 *
 * @package app\admin\controller
 */
class AreaCon extends BaseController
{

    public $table = 'Area';

    /**
     * 获取列表
     * @return array|string
     * @throws DbException
     * @throws Exception
     */
    public function getList()
    {
        $this->requestType('GET');
        $res = Area::where(['level'=>1])->field('id,code as value,name as label')->select();
        foreach ($res as &$item){
            $item['children'] = $item->City;
        }
        return $this->buildSuccess($res);
    }
}