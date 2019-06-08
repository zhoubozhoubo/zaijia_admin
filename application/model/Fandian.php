<?php

namespace app\model;

//use app\index\model\Template;
use think\Db;

class Fandian
{

    public $id;
    public $money;

    public function index()
    {
        //读取提成配置
        $extract=Db::name('ExtractConfig')->select();
        foreach ($extract as $k=>$v){
            $extract_config[$v['name']]=$v['value'];
        }

        //寻找爷级
        $sid = Db::name('User')->where('id', $this->id)->value('sid');
        if ($sid != 0) {
            //存在爷级
            //判断爷级等级
            $suser_exp = Db::name('User')->where('id', $sid)->value('exp');
//            if ($suser_exp == 3 || $suser_exp == 4) {//爷级等级为连创人时返点
            if ($suser_exp == 3) {
                //爷级等级为大管家时返点
                $sfandian = array(
                    'uid' => $this->id,
                    'username' => Db::name('User')->where('id', $this->id)->value('username'),
                    'tid' => $sid,
                    'tusername' => Db::name('User')->where('id', $sid)->value('username'),
                    'status'=>2,
                    'type'=>8,//间接返点
                    'money' => $this->money * ($extract_config['dgj_jj_fd']*0.01),
                    'time' => date('Y-m-d H:i:s'),
                    'total_money'=>$this->money,
                    'out_trade_no'=>$this->out_trade_no()
                );
                //添加佣金返点记录数据
                Db::name('Sale')->insert($sfandian);

                /*//发送微信消息
                $uname=Db::name('User')->where('id',$sid)->value('username');
                $name=Db::name('User')->where('id',$this->id)->value('username');
                $openid=Db::name('User')->where('id',$sid)->value('openid');
                $title="亲爱的'{$uname}',您的团队中'{$name}'支付货款{$this->money}元，您得到提成{$sfandian['money']}元!";
                $code=$sfandian['out_trade_no'];
                $money=$this->money;
                $money2=$sfandian['money'];
                $time=date('Y-m-d H:i:s');
                $temp=new Template();
                $temp->Extract($openid,$title,$code,$money,$money2,$time);*/

                //爷级加钱
                $smoney = Db::name('User')->where('id', $sid)->value('money');
                Db::name('User')->where('id', $sid)->update(['money' => $smoney + $this->money * ($extract_config['dgj_jj_fd']*0.01)]);
            }
        }

        //寻找父级
        $fid = Db::name('User')->where('id', $this->id)->value('fid');
        if ($fid != 0) {
            //存在父级
            //判断父级等级
            $fuser_exp = Db::name('User')->where('id', $fid)->value('exp');
            $fmoney = Db::name('User')->where('id', $fid)->value('money');
            //父级等级为管家或大管家或连创人时返点
            $ffandian = array(
                'uid' => $this->id,
                'username' => Db::name('User')->where('id', $this->id)->value('username'),
                'tid' => $fid,
                'tusername' => Db::name('User')->where('id', $fid)->value('username'),
                'status'=>2,
                'type'=>7,//直接返点
                'time' => date('Y-m-d H:i:s'),
                'total_money'=>$this->money,
                'out_trade_no'=>$this->out_trade_no()
            );
            if($fuser_exp == 2){
                $ffandian['money']=$this->money*($extract_config['gj_zj_fd']*0.01);
                Db::name('User')->where('id', $fid)->update(['money' => $fmoney + $ffandian['money']]);
            }else if($fuser_exp == 3){
                $ffandian['money']=$this->money*($extract_config['dgj_zj_fd']*0.01);
                Db::name('User')->where('id', $fid)->update(['money' => $fmoney + $ffandian['money']]);
            }else if($fuser_exp == 4){
                $ffandian['money']=$this->money*($extract_config['lcr_zj_fd']*0.01);
                Db::name('User')->where('id', $fid)->update(['money' => $fmoney + $ffandian['money']]);
            }
            //添加佣金返点记录数据
            Db::name('Sale')->insert($ffandian);
            
            /*//发送微信消息
            $uname=Db::name('User')->where('id',$fid)->value('username');
            $name=Db::name('User')->where('id',$this->id)->value('username');
            $openid=Db::name('User')->where('id',$fid)->value('openid');
            $title="亲爱的'{$uname}',您的团队中'{$name}'支付货款{$this->money}元，您得到提成{$ffandian['money']}元!";
            $code=$ffandian['out_trade_no'];
            $money=$this->money;
            $money2=$ffandian['money'];
            $time=date('Y-m-d H:i:s');
            $temp=new Template();
            $temp->Extract($openid,$title,$code,$money,$money2,$time);*/
        }

        //寻找团队
        $vid = Db::name('User')->where('id', $this->id)->value('vid');
        if ($vid != 0) {
            //寻找团队连创人是否团队
            $this->ouser($vid);
        }
    }

    /**
     * 递归寻找团队连创人是否团队返点
     * @param $id
     */
    public function ouser($oid){
        //育成团队返点
        $lcr_td_fd=Db::name('ExtractConfig')->where('name','lcr_td_fd')->value('value');

        $other = Db::name('User')->where('id', $oid)->find();
        if($other){
            $ofandian = array(
                'uid' => $this->id,
                'username' => Db::name('User')->where('id', $this->id)->value('username'),
                'tid' => $other['id'],
                'tusername' => Db::name('User')->where('id', $other['id'])->value('username'),
                'status'=>2,
                'type'=>10,//育成团队返点
                'money' => $this->money * ($lcr_td_fd*0.01),
                'time' => date('Y-m-d H:i:s'),
                'total_money'=>$this->money,
                'out_trade_no'=>$this->out_trade_no()
            );
//            print_r($ofandian);exit;
            //添加佣金返点记录数据
            Db::name('Sale')->insert($ofandian);

            /*//发送微信消息
            $uname=Db::name('User')->where('id',$other['id'])->value('username');
            $name=Db::name('User')->where('id',$this->id)->value('username');
            $openid=Db::name('User')->where('id',$other['id'])->value('openid');
            $title="亲爱的'{$uname}',您的团队中'{$name}'支付货款{$this->money}元，您得到提成{$ofandian['money']}元!";
            $code=$ofandian['out_trade_no'];
            $money=$this->money;
            $money2=$ofandian['money'];
            $time=date('Y-m-d H:i:s');
            $temp=new Template();
            $temp->Extract($openid,$title,$code,$money,$money2,$time);*/

            //加钱
            Db::name('User')->where('id', $oid)->update(['money'=>$other['money']+($ofandian['money'])]);
            if($other['vid']!=0){
                $this->ouser($other['vid']);
            }
        }
    }

    /**
     * 递归寻找团队连创人是否团队推荐返现
     * @param $id
     */
    public function vuser($oid){
        //团队生成管家返现
        $lcr_td_fx=Db::name('ExtractConfig')->where('name','lcr_td_fx')->value('value');

        $other = Db::name('User')->where('id', $oid)->find();
        if($other){
            $vfanxian = array(
                'uid' => $this->id,
                'username'=>Db::name('User')->where('id',$this->id)->value('username'),
                'tid' => $other['id'],
                'tusername'=>Db::name('User')->where('id',$other['id'])->value('username'),
                'status'=>2,
                'type' => 9,//团队新生成管家
                'money' => $lcr_td_fx,
                'time' => date('Y-m-d H:i:s'),
                'out_trade_no'=>$this->out_trade_no()
            );
            //添加佣金返点记录数据
            Db::name('Sale')->insert($vfanxian);

            /*//发送微信消息
            $uname=Db::name('User')->where('id',$other['id'])->value('username');
            $name=Db::name('User')->where('id',$this->id)->value('username');
            $openid=Db::name('User')->where('id',$other['id'])->value('openid');
            $title="亲爱的'{$uname}',您的团队中'{$name}'开码成功，您得到返现{$vfanxian['money']}元!";
            $code=$vfanxian['out_trade_no'];
            $money='299';
            $money2=$vfanxian['money'];
            $time=date('Y-m-d H:i:s');
            $temp=new Template();
            $temp->Fanxian($openid,$title,$code,$money,$money2,$time);*/

            Db::name('User')->where('id', $oid)->update(['money'=>$other['money']+$lcr_td_fx]);
            //判断团队联创人上面是否还有团队
            if($other['vid']!=0){
                $this->vuser($other['vid']);
            }
        }
    }

    /**
     * 订单号
     */
    public function out_trade_no()
    {
        $str = '订单号';
        $str = md5($str) . time();
        $str = str_shuffle($str);
        $str = substr($str, 10, 25);
        $str=$str.rand(1000,999).session('id');
        return $str;
    }
}













