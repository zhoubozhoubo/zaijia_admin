<?php

namespace app\api\model;

use think\Db;

/** 普通用户
 * Class Pu
 * @package app\index\model
 */
class Pu
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
        $data=[
            'fid'=>$fuser['id'],
            'sid'=>$fuser['fid'],
            'vid'=>$fuser['vid']
        ];
        //更新
        Db::name($this->table)->where('id',$this->id)->update($data);
    }

    //无上级->上级大管家
    public function no_to_da(){
        //上级用户
        $fuser=Db::name($this->table)->where('id',$this->fid)->field('id,fid,sid,vid,exp,rem_num')->find();
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
        $data=[
            'fid'=>0,
            'sid'=>0,
            'vid'=>0
        ];
        //更新
        Db::name($this->table)->where('id',$this->id)->update($data);
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
        $data=[
            'fid'=>0,
            'sid'=>0,
            'vid'=>0
        ];
        //更新
        Db::name($this->table)->where('id',$this->id)->update($data);
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
}













