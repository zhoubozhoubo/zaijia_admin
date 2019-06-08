<?php
namespace app\api\controller;
use Aliyun\Core\Config;
use Aliyun\Core\Profile\DefaultProfile;
use Aliyun\Core\DefaultAcsClient;
use Aliyun\Api\Sms\Request\V20170525\SendSmsRequest;

//验证码通知模板id 验证码为：${code}，您正在开码，若非本人操作，请勿泄露。
const SmsCode="SMS_149422067";

//货款通知模板id 亲爱的${user}，您的货款已收到！我们会尽快给您安排发货，请耐心等候！ 这个过了
const SmsPayemnt='SMS_149422651';

//升级为管家 SMS_149418872  亲爱的${user}，恭喜您升级为管家级别！更多信息请关注“一起购520”公众号。
const SmsNewVip="SMS_149418872";

//升级为大管家 SMS_149423671 亲爱的${user}，恭喜您升级为大管家级别！更多信息请关注“一起购520”公众号
const SmsBigVip="SMS_149423671";

//升级为公司联创人 SMS_149423674 亲爱的${user}，恭喜您升级为公司联创人级别！更多信息请关注“一起购520”公众号
const SmsSuperVip="SMS_149423674";


/** 阿里云短信类
 * Class Sms
 * @package app\index\controller
 */
class  Sms {
    //阿里短信函数，$mobile为手机号码，$code为自定义随机数
    /** 阿里云短信函数
     * @param $mobile 手机号
     * @param $data     模板变量替换 数组
     * @param $sms_code 短信模板ID
     * @return mixed
     */
    static function sendMsg($mobile,$data,$sms_code){

        //这里的路径EXTEND_PATH就是指tp5根目录下的extend目录，系统自带常量。alisms为我们复制api_sdk过来后更改的目录名称
        require_once EXTEND_PATH.'alisms/vendor/autoload.php';
        Config::load();             //加载区域结点配置

        $accessKeyId = 'LTAIFDA271J3d97P';  //阿里云短信获取的accessKeyId

        $accessKeySecret = 'p4etESsuWCtueS7ginER7g6EfVnoWY';    //阿里云短信获取的accessKeySecret

        //这个个是审核过的模板内容中的变量赋值，记住数组中字符串code要和模板内容中的保持一致
        //比如我们模板中的内容为：你的验证码为：${code}，该验证码5分钟内有效，请勿泄漏！
        $templateParam =$data;           //模板变量替换.

        $signName = '一起购'; //这个是短信签名，要审核通过

        $templateCode = $sms_code;   //短信模板ID，记得要审核通过的


        //短信API产品名（短信产品名固定，无需修改）
        $product = "Dysmsapi";

        //短信API产品域名（接口地址固定，无需修改）
        $domain = "dysmsapi.aliyuncs.com";
        //暂时不支持多Region（目前仅支持cn-hangzhou请勿修改）
        $region = "cn-hangzhou";

        // 初始化用户Profile实例
        $profile = DefaultProfile::getProfile($region, $accessKeyId, $accessKeySecret);
        // 增加服务结点
        DefaultProfile::addEndpoint("cn-hangzhou", "cn-hangzhou", $product, $domain);
        // 初始化AcsClient用于发起请求
        $acsClient= new DefaultAcsClient($profile);

        // 初始化SendSmsRequest实例用于设置发送短信的参数
        $request = new SendSmsRequest();
        // 必填，设置雉短信接收号码
        $request->setPhoneNumbers($mobile);

        // 必填，设置签名名称
        $request->setSignName($signName);

        // 必填，设置模板CODE
        $request->setTemplateCode($templateCode);

        // 可选，设置模板参数
        if($templateParam) {
            $request->setTemplateParam(json_encode($templateParam));
        }

        //发起访问请求
        $acsResponse = $acsClient->getAcsResponse($request);

        //返回请求结果
        $result = json_decode(json_encode($acsResponse),true);
        return $result;
    }
}