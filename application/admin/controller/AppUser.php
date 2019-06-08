<?php
/**
 * Created by PhpStorm.
 * User: yajunyu
 * Date: 2018/11/19
 * Time: 16:05
 */

namespace app\admin\controller;


use app\model\AdminUserUpgrade;
use app\model\User;
use app\util\ReturnCode;
use think\Db;

class AppUser extends Base
{

    public $table = 'User';

    /**
     * 获取用户列表
     */
    public function index()
    {

        $this->title = '用户管理';
        list($get, $db) = [$this->request->get(), Db::name($this->table)];
        if (isset($get['fid']) && !empty($get['fid']) && $get['fid'] != 0) {
            $db->where('fid', $get['fid']);
            $sid = Db::name('User')->field('fid,username')->find($get['fid']);
            //$this->assign('sid', $sid['fid']);
            $this->title .= ' >' . $sid['username'] . '> 下级用户';
        }

        foreach (['username', 'exp', 'code', 'phone'] as $key) {
            (isset($get[$key]) && $get[$key] !== '') && $db->whereLike($key, "%{$get[$key]}%");
        }
        return parent::_list($db);
    }

    public function _index_data_filter(&$data)
    {
        foreach ($data as &$v) {
            if ($v['vid'] != 0) {
                $v['vname'] = Db::name('User')->where('id', $v['vid'])->value('username');
            }
            if ($v['fid'] != 0) {
                $v['fname'] = Db::name('User')->where('id', $v['fid'])->value('username');
            }
            //寻找下级
            $str = rtrim(getDiguiId($v['id']), ',');
            $str_arr = explode(',', $str);
            if (count($str_arr) == 1) {
                //没有下级
                $v['next'] = 0;
            } else {
                //存在下级
                $v['next'] = 1;
            }
            //下级人数
            $v['next_num'] = Db::name('User')->where('fid', $v['id'])->count();

            //所属财务
            if ($v['cw_id'] != 0) {
                $v['cw_name'] = db('admin_user')->where('id', $v['cw_id'])->value('username');
            }
        }
    }


    /**
     * 删除用户
     * @return array
     */
    public function del()
    {
        $get = $this->request->get();
        $id_str = rtrim(getDiguiId($get['id']), ',');
        $id_arr = explode(',', $id_str);
        if (count($id_arr) > 1) {
            return $this->buildFailed(ReturnCode::EMPTY_PARAMS, '该用户存在下级用户,无法删除！');
        }
        $exp = db('User')->where('id', $get['id'])->value('exp');
        if ($exp != 1) {
            return $this->buildFailed(ReturnCode::EMPTY_PARAMS, '该用户不是普通用户,无法删除！');
        }
        $result = User::destroy($get['id']);
        if ($result > 0) {
            return $this->buildSuccess($result);
        }
        return $this->buildFailed(ReturnCode::EMPTY_PARAMS, '失败');

    }

    /**
     * 编辑用户
     * @return array
     */
    public function edit()
    {
        $post = $this->request->post();
        //判断等级操作
        $exp = db($this->table)->where('id', $post['id'])->value('exp');
        if ($post['exp'] - $exp == 0) {
            //无等级操作
        } else if ($post['exp'] - $exp < 0) {
            //降级操作
            return $this->buildFailed(ReturnCode::EMPTY_PARAMS, '不能降低等级操作');
        } else if ($post['exp'] - $exp == 1) {
            //升一级操作
            $upgrade = new AdminUserUpgrade();
            $upgrade->id = $post['id'];
            if ($exp == 1) {
                //普通->管家
                $upgrade->uptoHousekeeper();
            } else if ($exp == 2) {
                //管家->大管家
                $upgrade->uptoBigHousekeeper();
            } else if ($exp == 3) {
                //大管家->连创人
                $upgrade->uptoCampaner();
            }
        } else if ($post['exp'] - $exp > 1) {
            //升多级操作
            return $this->buildFailed(ReturnCode::EMPTY_PARAMS, '不能跳等级操作');
        }
        //忽略等级改变
        unset($post['exp']);
        $result = User::update($post);
        if ($result) {
            return $this->buildSuccess($result);
        } else {
            return $this->buildFailed(ReturnCode::EMPTY_PARAMS, '失败');
        }
    }

    /**
     * 重置用户上下级和基本信息（只有普通用户和新管家才能重置）
     */
    public function reset()
    {
        $get = $this->request->get();
        //用户数据
        $user = db($this->table)->where('id', $get['id'])->field('fid,exp')->find();
        //判断用户等级能否重置
        if($user['exp'] == 3){
            return $this->buildFailed(ReturnCode::EMPTY_PARAMS, '大管家不能重置');
        }
        if($user['exp'] == 4){
            return $this->buildFailed(ReturnCode::EMPTY_PARAMS, '连创人不能重置');
        }
        //存在上级
        if ($user['fid'] != 0) {
            //用户等级为管家
            if ($user['exp'] == 2) {
                //上级推荐人数-1
                db($this->table)->where('id', $user['fid'])->setDec('rem_num');
                //上级用户
                $fuser = db($this->table)->where('id', $user['fid'])->field('exp,rem_num')->find();
                //上级等级为大管家
                if ($fuser['exp'] == 3) {
                    //上级推荐人数低于标准
                    if ($fuser['rem_num'] < 30) {
                        //上级大管家降级
                        db($this->table)->where('id', $user['fid'])->setDec('exp');
                    }
                }
            }
        }
        //重置数据
        $result = User::update([
            'id' => $get['id'],
            'fid' => 0,
            'sid' => 0,
            'vid' => 0,
            'exp' => 1,
            'code' => null,
            'card' => null,
            'card_name' => null,
            'uname' => null,
            'phone' => null,
            'address' => null
        ]);
        if ($result) {
            return $this->buildSuccess($result);
        } else {
            return $this->buildFailed(ReturnCode::EMPTY_PARAMS, '失败');
        }
    }

    /**
     * 获取财务
     */
    public function cw(){
        $get = $this->request->get();
        //判断是否有所属财务
        if($get['cw_id']==0){
            $cw_name='暂无所属财务';
        }else{
            $cw_name=db('admin_user')->where('id', $get['cw_id'])->value('username');
        }
        //查询财务人员列表
        $cw_id_list=db('admin_auth_group_access')->where('groupId', 1)->column('uid');
        $cw_list=db('admin_user')->whereIn('id',$cw_id_list)->field('id,username')->select();
        $data=[
            'cw_name'=>$cw_name,
            'cw_list'=>$cw_list
        ];
        return json($data);
    }

    /**
     * 分配财务
     */
    public function cw_change(){
        $post = $this->request->post();
        $result = User::update($post);
        if ($result) {
            return $this->buildSuccess($result);
        } else {
            return $this->buildFailed(ReturnCode::EMPTY_PARAMS, '失败');
        }
    }










}