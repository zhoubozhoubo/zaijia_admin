<?php

namespace app\api\model;

use think\Db;

/** 管家
 * Class Guan
 * @package app\index\model
 */
class Guan
{

    public $id;
    public $old_fid;
    public $fid;
    public $table='User';

    public function index(){
        //判断改变
        if($this->old_fid!=$this->fid){
            if($this->old_fid==0&&$this->fid!=0){
                //无上级->有上级
                //绑定上级
                $fuser=Db::name($this->table)->where('id',$this->fid)->field('id,fid,sid,vid,exp,rem_num')->find();
                //判断上级等级
                if($fuser['exp']==2){
                    //上级为管家
                    $this->no_to_guan();
                }else if($fuser['exp']==3){
                    //上级为大管家
                    $this->no_to_da();
                }else if($fuser['exp']==4){
                    //上级为连创人
                    $this->no_to_lian();
                }
            }else if($this->old_fid!=0&&$this->fid==0){
                //有上级->无上级
                //取消绑定原上级
                $fuser=Db::name($this->table)->where('id',$this->old_fid)->field('id,fid,sid,vid,exp,rem_num')->find();
                //判断原上级等级
                if($fuser['exp']==2){
                    //原上级为管家
                    $this->guan_to_no();
                }else if($fuser['exp']==3){
                    //原上级为大管家
                    $this->da_to_no();
                }else if($fuser['exp']==4){
                    //原上级为连创人
                    $this->lian_to_no();
                }
            }else if($this->old_fid!=0&&$this->fid!=0){
                //有上级->有上级
                //原上级
                $old_fuser=Db::name($this->table)->where('id',$this->old_fid)->field('id,fid,sid,vid,exp,rem_num')->find();
                //绑定上级
                $fuser=Db::name($this->table)->where('id',$this->fid)->field('id,fid,sid,vid,exp,rem_num')->find();
                //判断改变情况
                if($old_fuser['exp']==2&&$fuser['exp']==2){
                    $this->guan_to_guan();
                }else if($old_fuser['exp']==2&&$fuser['exp']==3){
                    $this->guan_to_da();
                }else if($old_fuser['exp']==2&&$fuser['exp']==4){
                    $this->guan_to_lian();
                }else if($old_fuser['exp']==3&&$fuser['exp']==2){
                    $this->da_to_guan();
                }else if($old_fuser['exp']==3&&$fuser['exp']==3){
                    $this->da_to_da();
                }else if($old_fuser['exp']==3&&$fuser['exp']==4){
                    $this->da_to_lian();
                }else if($old_fuser['exp']==4&&$fuser['exp']==2){
                    $this->lian_to_guan();
                }else if($old_fuser['exp']==4&&$fuser['exp']==3){
                    $this->lian_to_da();
                }else if($old_fuser['exp']==4&&$fuser['exp']==4){
                    $this->lian_to_lian();
                }
            }
        }
    }

    //无上级->无上级
    public function no_to_no(){

    }

    //无上级->上级管家
    public function no_to_guan(){
        //上级用户
        $fuser=Db::name($this->table)->where('id',$this->fid)->field('id,fid,sid,vid,exp,rem_num')->find();
        //上级推荐人数+1
        Db::name($this->table)->where('id',$this->fid)->setInc('rem_num',1);
        $data=[
            'fid'=>$fuser['id'],
            'sid'=>$fuser['fid'],
            'vid'=>$fuser['vid']
        ];
        //更新
        Db::name($this->table)->where('id',$this->id)->update($data);
        //上级联动改变
        $this->prev_change();
    }

    //无上级->上级大管家
    public function no_to_da(){
        //上级用户
        $fuser=Db::name($this->table)->where('id',$this->fid)->field('id,fid,sid,vid,exp,rem_num')->find();
        //上级推荐人数+1
        Db::name($this->table)->where('id',$this->fid)->setInc('rem_num',1);
        $data=[
            'fid'=>$fuser['id'],
            'sid'=>$fuser['fid'],
            'vid'=>$fuser['vid']
        ];
        //更新
        Db::name($this->table)->where('id',$this->id)->update($data);
    }

    //无上级->上级连创人
    public function no_to_lian(){
        //上级用户
        $fuser=Db::name($this->table)->where('id',$this->fid)->field('id,fid,sid,vid,exp,rem_num')->find();
        //上级推荐人数+1
        Db::name($this->table)->where('id',$this->fid)->setInc('rem_num',1);
        $data=[
            'fid'=>$fuser['id'],
            'sid'=>$fuser['fid'],
            'vid'=>$fuser['id']
        ];
        //更新
        Db::name($this->table)->where('id',$this->id)->update($data);
    }

    //上级管家->无上级
    public function guan_to_no(){
        //原上级用户
        $old_fuser=Db::name($this->table)->where('id',$this->old_fid)->field('id,fid,sid,vid,exp,rem_num')->find();
        //原上级推荐人数-1
        Db::name($this->table)->where('id',$this->old_fid)->setDec('rem_num',1);
        $data=[
            'fid'=>0,
            'sid'=>0,
            'vid'=>0
        ];
        //更新
        Db::name($this->table)->where('id',$this->id)->update($data);
        //原上级联动改变
        $this->old_prev_change();
    }

    //上级管家->上级管家
    public function guan_to_guan(){
        $this->guan_to_no();
        $this->no_to_guan();
    }

    //上级管家->上级大管家
    public function guan_to_da(){
        $this->guan_to_no();
        $this->no_to_da();
    }

    //上级管家->上级连创人
    public function guan_to_lian(){
        $this->guan_to_no();
        $this->no_to_lian();
    }

    //上级大管家->无上级
    public function da_to_no(){
        //原上级用户
        $old_fuser=Db::name($this->table)->where('id',$this->old_fid)->field('id,fid,sid,vid,exp,rem_num')->find();
        //原上级推荐人数-1
        Db::name($this->table)->where('id',$this->old_fid)->setDec('rem_num',1);
        $data=[
            'fid'=>0,
            'sid'=>0,
            'vid'=>0
        ];
        //更新
        Db::name($this->table)->where('id',$this->id)->update($data);
        //原上级联动改变
        $this->old_prev_change();
    }

    //上级大管家->上级管家
    public function da_to_guan(){
        $this->da_to_no();
        $this->no_to_guan();
    }

    //上级大管家->上级大管家
    public function da_to_da(){
        $this->da_to_no();
        $this->no_to_da();
    }

    //上级大管家->上级连创人
    public function da_to_lian(){
        $this->da_to_no();
        $this->no_to_lian();
    }

    //上级连创人->无上级
    public function lian_to_no(){
        //原上级用户
        $old_fuser=Db::name($this->table)->where('id',$this->old_fid)->field('id,fid,sid,vid,exp,rem_num')->find();
        //原上级推荐人数-1
        Db::name($this->table)->where('id',$this->old_fid)->setDec('rem_num',1);
        $data=[
            'fid'=>0,
            'sid'=>0,
            'vid'=>0
        ];
        //更新
        Db::name($this->table)->where('id',$this->id)->update($data);
    }

    //上级连创人->上级管家
    public function lian_to_guan(){
        $this->lian_to_no();
        $this->no_to_guan();
    }

    //上级连创人->上级大管家
    public function lian_to_da(){
        $this->lian_to_no();
        $this->no_to_da();
    }

    //上级连创人->上级连创人
    public function lian_to_lian(){
        $this->lian_to_no();
        $this->no_to_lian();
    }

    //原上级联动改变
    public function old_prev_change(){
        //原上级用户
        $old_fuser=Db::name($this->table)->where('id',$this->old_fid)->field('id,fid,sid,vid,exp,rem_num')->find();
        //判断原上级等级
        if($old_fuser['exp']==2){
            //管家
        }else if($old_fuser['exp']==3){
            //大管家
            if($old_fuser['rem_num']<30){
                //降级为管家
                $this->da_down($old_fuser['id']);
                //查询大管家是否有父级
                if($old_fuser['fid']!=0){
                    $suser = Db::name($this->table)->where('id', $old_fuser['fid'])->field('id,fid,sid,vid,exp,rem_num')->find();
                    //大管家父级等级
                    if ($suser['exp'] == 4) {
                        //大管家父级为连创人
                        //判断大管家父级下面的大管家是否满足15名
                        $num = Db::name($this->table)->where(['fid' => $suser['id'], 'exp' => 3])->count();
                        if ($num < 15) {
                            //低于15名，大管家父级连创人降级为大管家
                            $this->lian_down($suser['id']);

                            //有联创人降级时，解散团队
                            //TODO 解散原来的团队
//                            $this->dropteam($suser['id']);
                        }
                    }
                }
            }
        }else if($old_fuser['exp']==4){
            //连创人
        }
    }

    //上级联动改变
    public function prev_change(){
        //上级用户
        $fuser=Db::name($this->table)->where('id',$this->fid)->field('id,fid,sid,vid,exp,rem_num')->find();
        //判断上级等级
        if($fuser['exp']==2){
            //管家
            if($fuser['rem_num']>=30){
                //升级为大管家
                $this->guan_up($fuser['id']);
                //查询大管家是否有父级
                if($fuser['fid']!=0){
                    $suser = Db::name($this->table)->where('id', $fuser['fid'])->field('id,fid,sid,vid,exp,rem_num')->find();
                    //大管家父级等级
                    if ($suser['exp'] == 3) {
                        //大管家父级为大管家
                        //判断大管家父级下面的大管家是否满足15名
                        $num = Db::name($this->table)->where(['fid' => $suser['id'], 'exp' => 3])->count();
                        if ($num == 15) {
                            //满足15名，大管家父级大管家升级为联创人
                            $this->da_up($suser['id']);

                            //有联创人产生时，生成团队
                            $this->createteam($suser['id']);
                        }
                    }
                }
                //判断该大管家下面的大管家是否满足15名
                $num = Db::name('User')->where(['fid' => $fuser['id'], 'exp' => 3])->count();
                if ($num == 15) {
                    //满足15名，大管家升级为联创人
                    $this->da_up($fuser['id']);

                    //有联创人产生时，生成团队
                    $this->createteam($fuser['id']);
                }
            }
        }else if($fuser['exp']==3){
            //大管家
        }else if($fuser['exp']==4){
            //连创人
        }
    }

    //管家升级
    public function guan_up($guan_id){
        if(Db::name($this->table)->where('id',$guan_id)->value('exp')==2){
            //升级为大管家
            Db::name($this->table)->where('id', $guan_id)->update(['exp' => 3]);
        }
    }

    //大管家降级
    public function da_down($da_id){
        if(Db::name($this->table)->where('id',$da_id)->value('exp')==3) {
            //降级为管家
            Db::name($this->table)->where('id', $da_id)->update(['exp' => 2]);
        }
    }

    //大管家升级
    public function da_up($da_id){
        if(Db::name($this->table)->where('id',$da_id)->value('exp')==3) {
            //升级为连创人
            Db::name($this->table)->where('id', $da_id)->update(['exp' => 4]);
        }
    }

    //连创人降级
    public function lian_down($lian_id){
        if(Db::name($this->table)->where('id',$lian_id)->value('exp')==4) {
            //降级为大管家
            Db::name($this->table)->where('id', $lian_id)->update(['exp' => 3]);
        }
    }

    //生成团队
    public function createteam($lian_id)
    {
        //找出下面所有用户
        $str = rtrim(GetDiguiId($lian_id), ',');
        $str_arr = explode(',', $str);
        unset($str_arr[0]);
        $user = Db::name($this->table)->whereIn('id', $str_arr)->field('id,vid')->select();
        foreach ($user as $k => $v) {
            //没有团队时，团队为联创人
            if ($v['vid'] == 0) {
                Db::name($this->table)->where('id', $v['id'])->update(['vid' => $lian_id]);
            } else {
                //存在团队时
                if (!in_array($v['vid'], $str_arr)) {
                    Db::name($this->table)->where('id', $v['id'])->update(['vid' => $lian_id]);
                }
            }
        }
    }

    //TODO 解散团队
    //解散团队
    public function dropteam($lian_id)
    {
        //找出下面所有用户
        $str = rtrim(GetDiguiId($lian_id), ',');
        $str_arr = explode(',', $str);
        unset($str_arr[0]);
        $user = Db::name($this->table)->whereIn('id', $str_arr)->field('id,vid')->select();
        foreach ($user as $k => $v) {
            //没有团队时，团队为联创人
            if ($v['vid'] == 0) {
                Db::name($this->table)->where('id', $v['id'])->update(['vid' => $lian_id]);
            } else {
                //存在团队时
                if (!in_array($v['vid'], $str_arr)) {
                    Db::name($this->table)->where('id', $v['id'])->update(['vid' => $lian_id]);
                }
            }
        }
    }
}













