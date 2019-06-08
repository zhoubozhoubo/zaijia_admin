<?php

namespace app\model;

use think\Db;

/**
 * 用户升级
 * Class AdminUserUpgrade
 * @package app\model
 */
class AdminUserUpgrade extends Base
{

    public $id;
    public $table = 'User';

    /**
     * 普通用户升级为管家
     */
    public function uptoHousekeeper()
    {
        Db::transaction(function () {
            //升级为管家
            db($this->table)->where('id', $this->id)->setInc('exp');
            //判断父级是否存在
            $fid = db($this->table)->where('id', $this->id)->value('fid');
            if ($fid != 0) {
                //推荐人数+1
                db($this->table)->where('id', $fid)->setInc('rem_num');
                //判断父级等级
                $exp = db($this->table)->where('id', $fid)->value('exp');
                //父级为管家
                if ($exp == 2) {
                    //判断父级推荐人数
                    $rem_num = db($this->table)->where('id', $fid)->value('rem_num');
                    if ($rem_num >= 30) {
                        //管家升级为大管家
                        $this->id=$fid;
                        $this->uptoBigHousekeeper();
                    }
                }
            }
        });
    }

    /**
     * 管家升级为大管家
     */
    public function uptoBigHousekeeper()
    {
        Db::transaction(function () {
            //升级为大管家
            db($this->table)->where('id', $this->id)->setInc('exp');
            //判断父级是否存在
            $fid = db($this->table)->where('id', $this->id)->value('fid');
            if ($fid != 0) {
                //判断父级等级
                $exp = db($this->table)->where('id', $fid)->value('exp');
                //父级为大管家
                if ($exp == 3) {
                    //判断父级下大管家
                    $rem_num = db($this->table)->where(['fid' => $fid, 'exp' => 3])->count();
                    if ($rem_num >= 15) {
                        //大管家升级为连创人
                        $this->id=$fid;
                        $this->uptoCampaner();
                    }
                }
            }
            //判断下级大管家人数
            $rem_num = db($this->table)->where(['fid' => $this->id, 'exp' => 3])->count();
            if ($rem_num >= 15) {
                //大管家升级为连创人
                $this->uptoCampaner();
            }
        });
    }

    /**
     * 大管家升级为连创人
     */
    public function uptoCampaner()
    {
        Db::transaction(function () {
            //升级为连创人
            db($this->table)->where('id', $this->id)->setInc('exp');
            //判断是否有所属团队
            $vid = db($this->table)->where('id', $this->id)->value('vid');
            //下面所有用户
            $id_str = rtrim(GetDiguiId($this->id), ',');
            $id_arr = explode(',', $id_str);
            unset($id_arr[0]);
            //无所属团队
            if ($vid == 0) {
                //下面所有没有团队的用户归为连创人
                foreach ($id_arr as $k => $v) {
                    db($this->table)->where(['id' => $v, 'vid' => 0])->update(['vid' => $this->id]);
                }
            }
            //有所属团队
            if ($vid != 0) {
                //下面所有属于自己所属团队的用户归为连创人
                foreach ($id_arr as $k => $v) {
                    db($this->table)->where(['id' => $v, 'vid' => $vid])->update(['vid' => $this->id]);
                }
            }
        });
    }
}
