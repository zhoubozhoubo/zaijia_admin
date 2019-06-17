<?php
/**
 * 工程基类
 * @since   2017/02/28 创建
 * @author  zhaoxiang <zhaoxiang051405@gmail.com>
 */

namespace app\api\controller;

// 跨域请求配置
header('Access-Control-Allow-Origin:*');
// 响应类型
header('Access-Control-Allow-Methods:*');
//// 响应头设置
header('Access-Control-Allow-Headers:Content-Type, Content-Length, Authorization, Accept, X-Requested-With , yourHeaderFeild , token');


use app\util\ReturnCode;
use think\Controller;

class Base extends Controller {

    private $debug = [];

    /**
     * 逻辑对象
     * @var
     */
    public $logic;

    /**
     * token
     * @var string
     */
    public $token='';

    /**
     * 用户信息
     * @var array
     */
    protected $userInfo = [];

    public function _initialize()
    {
        $this->token = $this->request->header('token');
        if ($this->token) {
            $userInfo = cache($this->token);
            print_r($userInfo);exit;
            if ($userInfo) {
                //更新时间
                cache($this->token, $userInfo, config('CACHE_TIME'));
                $this->userInfo = json_decode($userInfo, true);
                $this->userInfo['token'] = $this->token;
            }
        }
        $this->initLogic();

    }

    /**
     * 初始化逻辑
     */
    private function initLogic()
    {
        $name = str_replace('controller', 'logic', get_class($this)) . 'Logic';
        if (class_exists($name)) {
            $this->logic = new $name;
        }
    }

    public function buildSuccess($data, $msg = '操作成功', $code = ReturnCode::SUCCESS) {
        $return = [
            'code' => $code,
            'msg'  => $msg,
            'data' => $data
        ];
        if ($this->debug) {
            $return['debug'] = $this->debug;
        }

        return json($return);
    }

    public function buildFailed($code, $msg, $data = []) {
        $return = [
            'code' => $code,
            'msg'  => $msg,
            'data' => $data
        ];
        if ($this->debug) {
            $return['debug'] = $this->debug;
        }

        return json($return);
    }

    protected function debug($data) {
        if ($data) {
            $this->debug[] = $data;
        }
    }

    /**
     * 列表集成处理方法
     * @param Query $dbQuery 数据库查询对象
     * @return array|string
     * @throws \think\exception\DbException
     * @throws \think\Exception
     */
    protected function _list($dbQuery = null)
    {
        $db = is_null($dbQuery) ? Db::name($this->table) : (is_string($dbQuery) ? Db::name($dbQuery) : $dbQuery);
        $limit = $this->request->get('size', config('apiAdmin.ADMIN_LIST_DEFAULT'));
        $start = $this->request->get('page', 1);
        $listObj = $db->paginate($limit, false, ['page' => $start])->toArray();
        $listInfo = $listObj['data'];
        $this->_callback('_data_filter', $listInfo, []);
        return $this->buildSuccess(['list' => $listInfo, 'count' => $listObj['total']]);
    }


    /**
     * 当前对象回调成员方法
     * @param string $method
     * @param array|bool $data1
     * @param array|bool $data2
     * @return bool
     */
    protected function _callback($method, &$data1, $data2)
    {
        foreach ([$method, "_" . $this->request->action() . "{$method}"] as $_method) {
            if (method_exists($this, $_method) && false === $this->$_method($data1, $data2)) {
                return false;
            }
        }
        return true;
    }

    /**
     * 请求方式
     * @param string $type
     * @return \think\response\Json
     */
    protected function requestType($type = 'GET')
    {
        if ($this->request->isOptions()) {
            $result['code'] = ReturnCode::ACCESS_TOKEN_TIMEOUT;
            $result['msg'] = '请求不合法';
            $header = config('apiAdmin.CROSS_DOMAIN');
            return json($result, 200, $header);
        }

        if ($this->request->isGet() && $type != 'GET') {
            exit('请求方式错误');
        }

        if ($this->request->isPost() && $type != 'POST') {
            exit('请求方式错误');
        }

        if ($this->request->isPut() && $type != 'PUT') {
            exit('请求方式错误');
        }

        if ($this->request->isDelete() && $type != 'DELETE') {
            exit('请求方式错误');
        }

    }

}