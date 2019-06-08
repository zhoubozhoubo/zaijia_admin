<?php

namespace app\api\controller;


use think\Db;

class Direct extends Base
{
    /** 直属管家
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function index()
    {
        //获取参数
        $post = $this->request->post();
        //当前用户id
        $id=Db::name('user')->where('openid',$post['openid'])->value('id');
        //记录列表
        $list = Db::name('User')->where(['fid' => $id])->where('exp','neq',1)->page($post['page'], $post['limit'])->order('time desc')->select();
        foreach ($list as $k=>$v) {
            //总货款
            $all_money= Db::name('Sale')->where(['uid'=>$v['id'],'type'=>2])->sum('money');
            $list[$k]['all_money']=number_format($all_money,2);
            //总提成
            $ti_money= Db::name('Sale')->where(['uid'=>$v['id'],'tid'=>$id])->where('type','7|8|9')->sum('money');
            $list[$k]['ti_money']=number_format($ti_money,2);
        }
        $count=Db::name('User')->where(['fid' => $id])->where('exp','neq',1)->count();
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
