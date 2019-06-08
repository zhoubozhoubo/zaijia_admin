<?php

namespace app\api\controller;


use Endroid\QrCode\QrCode;
use think\Db;

class MyCode extends Base
{

    /** 获取用户二维码和邀请码
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function index()
    {
        $openid = $_POST['openid'];
        //我的邀请码
        $db = Db::name('user')->where('openid', $openid)->find();

        $img = $this->code($openid);
        $data = [
            'code' => $db['code'],
            'img' => $img,
        ];
        return $this->buildSuccess($data);
    }

    public function code($openid)
    {
        $db = Db::name('user')->field('userimg,id')->where('openid', $openid)->find();
        //TODO 如果用户头像不存在域名字符则下载微信头像到本地
        if (!strstr($db['userimg'], AdminUrl())) {

            //下载用户头像到本地
            $img = local_image($db['userimg']);

            //更新数据库头像地址
            Db::name('user')->where('id', $db['id'])->update(['userimg' => $img]);

            $img = explode('/', $img);
        } else {
            $img = explode('/', $db['userimg']);
        }
        $ImgUrl = $img[3] . '/' . $img[4] . '/' . $img[5] . '/' . $img[6] . '/' . $img[7];

        $id = base64_encode($db['id']);

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
        $name = ROOT_PATH . 'public/upload/20181119/' . $db['id'] . '.png';
        //判断二维码是否存在
        if (!file_exists($name)) {
            $qrCode->save($name);
        }

        return AdminUrl().'/upload/20181119/' . $db['id'] . '.png';

    }

}
