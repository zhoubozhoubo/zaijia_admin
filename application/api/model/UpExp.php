<?php

namespace app\api\model;

use think\Db;

/** 升级
 * Class UpExp
 * @package app\index\model
 */
class UpExp
{

    public $id;
    public $table='User';

    public function index(){
        //判断是否有上级
        $fid=Db::name($this->table)->where('id',$this->id)->value('fid');
        if($fid) {
            //存在上级
            $fuser=Db::name($this->table)->find($fid);
            if($fuser) {
                //之前是普通用户的话，上级推荐人数+1
                if(Db::name($this->table)->where('id',$this->id)->value('exp')==1){
                    Db::name($this->table)->where('id', $fuser['id'])->update(['rem_num' => $fuser['rem_num'] + 1]);
                }
                //判断上级等级
                if($fuser['exp']==2) {
                    //上级为管家
                    //上级邀请人数达到标准上级等级提升
                    $rem_num=Db::name($this->table)->where('id',$fuser['id'])->value('rem_num');
                    if ($rem_num == 30) {
                        //上级升级为大管家
                        $dgj=Db::name($this->table)->where('id', $fuser['id'])->update(['exp' => 3]);
                        if($dgj){
                            //查询大管家是否有上级
                            $fid = Db::name($this->table)->where('id', $fuser['id'])->value('fid');
                            if ($fid) {
                                //查询大管家父级等级
                                $fexp = Db::name($this->table)->where('id', $fid)->value('exp');
                                if ($fexp == 3) {
                                    //大管家父级为大管家
                                    //判断大管家父级下面的大管家是否满足15名
                                    $num = Db::name($this->table)->where(['fid' => $fid, 'exp' => 3])->count();
                                    if ($num == 15) {
                                        //满足15名，大管家父级升级为联创人
                                        Db::name($this->table)->where('id', $fid)->update(['exp' => 4]);
                                        //有联创人产生时，生成团队
                                        $this->createteam($fid);
                                    }
                                }
                            }

                            //如果有大管家产生，则看是否有联创人产生
                            $num = Db::name($this->table)->where(['fid' => $fuser['id'], 'exp' => 3])->count();
                            //判断该大管家下面的大管家是否满足15名
                            if ($num == 15) {
                                //满足15名，大管家升级为联创人
                                Db::name($this->table)->where('id', $fuser['id'])->update(['exp' => 4]);
                                //有联创人产生时，生成团队
                                $this->createteam($fuser['id']);
                            }
                        }
                    }
                }
                if($fuser['exp']==4) {
                    //上级为管家
                }
            }
        }
    }

    /**
     * 生成团队
     */
    public function createteam($id){
        //找出下面所有用户
        $str=rtrim(GetDiguiId($id),',');
        $str_arr=explode(',',$str);
        unset($str_arr[0]);
//        print_r($str_arr);exit;
        $user=Db::name($this->table)->whereIn('id',$str_arr)->field('id,vid')->select();
//        print_r($user);
        foreach ($user as $k=>$v){
            //没有团队时，团队为联创人
            if($v['vid']==0){
                Db::name($this->table)->where('id',$v['id'])->update(['vid'=>$id]);
            }else{
                //存在团队时
                if(!in_array($v['vid'],$str_arr)){
                    Db::name($this->table)->where('id',$v['id'])->update(['vid'=>$id]);
                }
            }
        }
    }
}













