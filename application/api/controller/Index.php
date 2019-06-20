<?php

namespace app\api\controller;

use app\api\model\Area;
use app\api\model\ZjBanner;
use app\api\model\ZjBasicConf;
use app\api\model\ZjLink;
use app\util\ReturnCode;
use WeChat\Script;

/**
 * 首页Controller
 * Class Index
 * @package app\api\controller
 */
class Index extends Base
{
    //初始化配置
    public $config = [
        'token' => 'xtcyivubohibxrctyvubn6rty',
        'appid' => 'wxc5b8b08c2e2b506f',
        'appsecret' => '3e0301d69ff031f7c7024e2c01ce05ea'
    ];

    public function getWechatJsSign(){
        $Script = new Script($this->config);
//        $res=$Script->getJsSign('http://jianzhi.hmdog.com');
        $res=$Script->getJsSign('jianzhi.hmdog.com','wxc5b8b08c2e2b506f','HoagFKDcsGMVCIY2vOjf9hfq8V4-tVFUJ-IWv4mte83cWGw3hOoRiiuPlFFUZmUt2t7x1fAmpitHf25vojcOXw');
        return $this->buildSuccess($res);
    }

    /**
     * 城市列表
     * @return array|\think\response\Json
     */
    public function wechatQrCode()
    {
        $this->requestType('GET');
        $wechatQrCode =ZjBasicConf::where(['name' => 'wechat_qr_code'])->value('value');
        if(!$wechatQrCode){
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND, '记录未找到', '');
        }
        return $this->buildSuccess($wechatQrCode);
    }

    /**
     * 城市列表
     * @return array|\think\response\Json
     */
    public function areaList()
    {
        $this->requestType('GET');
        $provinceList =Area::where(['level' => 1])->field('code,name')->select();
        $newProvinceList[0] = '全国';
        $newCityList[0] = '全国';
        foreach ($provinceList as $item){
            $newProvinceList[$item['code']] = $item['name'];
        }
        $cityList =Area::where(['level' => 2])->field('code,name')->select();
        foreach ($cityList as $item){
            $newCityList[$item['code']] = $item['name'];
        }
        $res=[
            'province_list'=>$newProvinceList,
            'city_list'=>$newCityList
        ];
        return $this->buildSuccess($res);

    }

    /**
     * 轮播图列表
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function bannerList()
    {
        $this->requestType('GET');
        $where = [
            'status' => 1,
            'is_delete' => 0
        ];
        $res = ZjBanner::where($where)->order('sort ASC')->field('img,url')->select();
        if (!$res) {
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND, '记录未找到', '');
        }
        return $this->buildSuccess($res);
    }

    /**
     * 链接列表
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function linkList()
    {
        $this->requestType('GET');
        $where = [
            'status' => 1,
            'is_delete' => 0
        ];
        $res = ZjLink::where($where)->order('sort ASC')->field('img,url')->select();
        if (!$res) {
            return $this->buildFailed(ReturnCode::RECORD_NOT_FOUND, '记录未找到', '');
        }
        return $this->buildSuccess($res);
    }

    public function upload() {
        $path = '/upload/' . date('Ymd', time()) . '/';
        $name = $_FILES['file']['name'];
        $tmp_name = $_FILES['file']['tmp_name'];
        $error = $_FILES['file']['error'];
        //过滤错误
        if ($error) {
            switch ($error) {
                case 1 :
                    $error_message = '您上传的文件超过了PHP.INI配置文件中UPLOAD_MAX-FILESIZE的大小';
                    break;
                case 2 :
                    $error_message = '您上传的文件超过了PHP.INI配置文件中的post_max_size的大小';
                    break;
                case 3 :
                    $error_message = '文件只被部分上传';
                    break;
                case 4 :
                    $error_message = '文件不能为空';
                    break;
                default :
                    $error_message = '未知错误';
            }
            die($error_message);
        }
        $arr_name = explode('.', $name);
        $hz = array_pop($arr_name);
        $new_name = md5(time() . uniqid()) . '.' . $hz;
        if (!file_exists($_SERVER['DOCUMENT_ROOT'] . $path)) {
            mkdir($_SERVER['DOCUMENT_ROOT'] . $path, 0755, true);
        }
        if (move_uploaded_file($tmp_name, $_SERVER['DOCUMENT_ROOT'] . $path . $new_name)) {
            return $this->buildSuccess([
                'fileName' => $new_name,
                'fileUrl'  => $this->request->domain() . $path . $new_name
            ],'上传成功');
        } else {
            return $this->buildFailed(ReturnCode::FILE_SAVE_ERROR, '文件上传失败');
        }
    }
}
