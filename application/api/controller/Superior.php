<?php

namespace app\api\controller;


use Endroid\QrCode\QrCode;
use think\Db;

class Superior extends Base
{

    /** 我的上级
     * @return \think\response\Json
     * @throws \Endroid\QrCode\Exceptions\DataDoesntExistsException
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function index()
    {
        $openid=$_POST['openid'];
        //查询我的上级id
        $fid=Db::name('user')->where('openid',$openid)->value('fid');

        if($fid == 0){
            return $this->buildFailed(500,'没有上级');
        }else{
            $user=Db::name('user')->field('id,userimg,username,code')->where('id',$fid)->find();

            $id = base64_encode($user['id']);
            $img = explode('/', $user['userimg']);
            $ImgUrl = $img[3] . '/' . $img[4] . '/' . $img[5] . '/' . $img[6] . '/' . $img[7];

            //实例化Qrcode类
            $qrCode = new QrCode();
            $url = IndexUrl()."/#/?coder=$id";
            $qrCode->setText($url)
                ->setSize(300)
                ->setPadding(10)
                ->setErrorCorrection('high')
                ->setForegroundColor(array('r' => 0, 'g' => 0, 'b' => 0, 'a' => 0))
                ->setBackgroundColor(array('r' => 255, 'g' => 255, 'b' => 255, 'a' => 0))
                ->setLogo($ImgUrl)
                ->setLogoSize(80)
                ->setLabelFontSize(16);
            //返回图片
            $name=ROOT_PATH.'public/upload/20181119/'.$user['id'].'.png';
            //判断二维码是否存在
            if(!file_exists($name)){
                $qrCode->save($name);
            }
            $user['src']= AdminUrl().'/upload/20181119/'.$user['id'].'.png';
            return $this->buildSuccess($user);
        }
    }
}
