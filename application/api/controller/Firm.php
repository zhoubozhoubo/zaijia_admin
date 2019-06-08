<?php
/**
 * Created by PhpStorm.
 * User: wj
 * Date: 2018/11/27
 * Time: 17:57
 */
namespace app\api\controller;
use think\Db;

/** 公司简介控制器
 * Class Firm
 * @package app\api\controller
 */
class Firm extends Base{

    /** 公司简介
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function index(){
        $db=Db::name('gs')->find();
        return $this->buildSuccess($db);
    }
}