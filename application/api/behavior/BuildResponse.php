<?php
/**
 * 输出结果规整
 * @since   2017-07-25
 * @author  zhaoxiang <zhaoxiang051405@gmail.com>
 */

namespace app\api\behavior;


use app\model\AdminFields;
use app\util\ApiLog;
use app\util\DataType;
use think\Cache;
use think\Request;

class BuildResponse {

    /** 允许携带cookie跨域访问的路由
     * @var array
     */
    public $cookie_url=[
        '5bfdf690745eb',
        '5bfdf92392578'
    ];
    /**
     * 返回参数过滤（主要是将返回参数的数据类型给规范）
     * @param $response \think\Response
     * @author zhaoxiang <zhaoxiang051405@gmail.com>
     * @throws \think\exception\DbException
     */
    public function run($response) {
        //读取跨域配置
        $header = config('apiAdmin.CROSS_DOMAIN');

        //获取当前请求详情
        $request = Request::instance();
        $hash = $request->routeInfo();

        //判断当前请求的路由是否存在于数组中,存在则允许跨域
        if(in_array($hash['rule'][1],$this->cookie_url) && $hash['rule'][0] == 'api'){
            $header['Access-Control-Allow-Origin'] = 'http://dbdb00913b65fd62.natapp.cc';
        }
        $response->header($header);
        $data = $response->getData();

        if (isset($hash['rule'][1])) {
            $hash = $hash['rule'][1];

            $has = Cache::has('ResponseFieldsRule:' . $hash);
            if ($has) {
                $rule = cache('ResponseFieldsRule:' . $hash);
            } else {
                $rule = AdminFields::all(['hash' => $hash, 'type' => 1]);
                cache('ResponseFieldsRule:' . $hash, $rule);
            }

            if ($rule) {
                $rule = json_decode(json_encode($rule), true);
                $newRule = array_column($rule, 'dataType', 'showName');
                if (is_array($data)) {
                    $this->handle($data['data'], $newRule);
                } elseif (empty($data)) {
                    if ($newRule['data'] == DataType::TYPE_OBJECT) {
                        $data = (object)[];
                    } elseif ($newRule['data'] == DataType::TYPE_ARRAY) {
                        $data = [];
                    }
                }
                $response->data($data);
            }
        }
        ApiLog::setResponse($data);
        ApiLog::save();
    }

    private function handle(&$data, $rule, $prefix = 'data') {
        if (empty($data)) {
            if ($rule[$prefix] == DataType::TYPE_OBJECT) {
                $data = (object)[];
            }
        } else {
            if ($rule[$prefix] == DataType::TYPE_OBJECT) {
                $prefix .= '{}';
                foreach ($data as $index => &$datum) {
                    $myPre = $prefix . $index;
                    if (isset($rule[$myPre])) {
                        switch ($rule[$myPre]) {
                            case DataType::TYPE_INTEGER:
                                $datum = intval($datum);
                                break;
                            case DataType::TYPE_FLOAT:
                                $datum = floatval($datum);
                                break;
                            case DataType::TYPE_STRING:
                                $datum = strval($datum);
                                break;
                            default:
                                $this->handle($datum, $rule, $myPre);
                                break;
                        }
                    }
                }
            } else {
                $prefix .= '[]';
                if (is_array($data[0])) {
                    foreach ($data as &$datum) {
                        $this->handle($datum, $rule, $prefix);
                    }
                }
            }
        }
    }

}
