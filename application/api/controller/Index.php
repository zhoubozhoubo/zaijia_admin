<?php

namespace app\api\controller;
use think\Db;

/** 首页
 * Class Index
 * @package app\api\controller
 */
class Index extends Base {
    /** 首页信息
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function index() {
        $openid=$_POST['openid'];
        //商品
        $shopping=Db::name('shopping')->page(1,5)->order('id desc')->select();
        //新闻
        $news=Db::name('news')->page(1,5)->order('id desc')->select();

        //顶部信息
        //当前用户信息
        $uid=Db::name('user')->where('openid',$openid)->value('id');

        //今日销售额
        $today_money=Db::name('sale')->where(['uid'=>$uid,'type'=>2]) ->whereTime('time', 'today')->sum('money');

        //今日销售单数
        $today_num=Db::name('sale')->where(['uid'=>$uid,'type'=>2]) ->whereTime('time', 'today')->count();

        //昨日销售额
        $yesterday_money=Db::name('sale')->where(['uid'=>$uid,'type'=>2]) ->whereTime('time', 'yesterday')->sum('money');

        //昨日销售单数
        $yesterday_num=Db::name('sale')->where(['uid'=>$uid,'type'=>2]) ->whereTime('time', 'yesterday')->count();
        $data=[
            'shopping'=>$shopping,
            'news'=>$news,
            'today_money'=>$today_money,
            'today_num'=>$today_num,
            'yesterday_money'=>$yesterday_money,
            'yesterday_num'=>$yesterday_num
        ];
        return $this->buildSuccess($data);
    }
}
