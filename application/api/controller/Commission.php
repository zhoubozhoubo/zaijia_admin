<?php

namespace app\api\controller;


use think\Db;

class Commission extends Base
{

    public function index()
    {
        //获取参数
        $post = $this->request->post();
        //党员
        $id=Db::name('user')->where('openid',$post['openid'])->value('id');
        if($post['type']>=4){
            $post['type']++;
        }
        //查询类型
        switch ($post['type']) {
            case 0:
                $list = Db::name('sale')->where(['uid'=>$id,'tid'=>0])->whereOr(['tid'=>149])->page($post['page'], $post['limit'])->order('time desc')->select();
                //总数
                $count = Db::name('sale')->where(['uid'=>$id,'tid'=>0])->whereOr(['tid'=>149])->count();
                break;
            case 1:
            case 2:
            case 3:
                $list = Db::name('sale')->where(['uid' =>$id, 'type' => $post['type'], 'tid' => 0])->page($post['page'], $post['limit'])->order('time desc')->select();
                //总数
                $count = Db::name('sale')->where(['uid' =>$id, 'type' => $post['type'], 'tid' => 0])->count();
                break;
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
                $list = Db::name('sale')->where(['tid' =>$id, 'type' => $post['type']])->page($post['page'], $post['limit'])->order('time desc')->select();
                //总数
                $count = Db::name('sale')->where(['tid' =>$id, 'type' => $post['type']])->count();
                break;
            default:
                break;
        }
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
