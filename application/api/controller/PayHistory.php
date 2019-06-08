<?php

namespace app\api\controller;


use think\Db;

class PayHistory extends Base
{

    public function index()
    {
        //获取参数
        $post = $this->request->post();
        $id=Db::name('user')->where('openid',$post['openid'])->value('id');
        $list = Db::name('sale')->where(['uid'=>$id,'type'=>2]);
        //查询类型
        switch ($post['type']) {
            case 0:
                //总数
                $count = Db::name('sale')->where(['uid'=>$id,'type'=>2])->count();
                break;
            case 1:
                $list->whereTime('time','-1 week');
                //总数
                $count = Db::name('sale')->where(['uid'=>$id,'type'=>2])->whereTime('time','-1 week')->count();
                break;
            case 2:
                $list->whereTime('time','-1 month');
                //总数
                $count = Db::name('sale')->where(['uid'=>$id,'type'=>2])->whereTime('time','-1 month')->count();
                break;
            case 3:
                $list->whereTime('time','-1 year');
                //总数
                $count = Db::name('sale')->where(['uid'=>$id,'type'=>2])->whereTime('time','-1 year')->count();
                break;
            default:
                break;
        }
        $list=$list->page($post['page'], $post['limit'])->order('time desc')->select();
        if(!isset($count)){
            $count=0;
        }
        //记录总页数
        $total_page = ceil($count / $post['limit']);
        //组装数据
        $data = [
            'list' => $list,
            'count' => $count,
            'total_page' => $total_page
        ];
        return $this->buildSuccess($data);
    }
}
