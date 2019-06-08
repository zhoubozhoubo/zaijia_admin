<?php

namespace app\util;

// 跨域请求配置
header('Access-Control-Allow-Origin:*');
// 响应类型
header('Access-Control-Allow-Methods:*');
// 响应头设置
header('Access-Control-Allow-Headers:Content-Type, Content-Length, Authorization, Accept, X-Requested-With , yourHeaderFeild , token');


use think\Controller;
use think\Db;

class BaseController extends Controller
{
    private $debug = [];

    /**
     * 默认操作数据表
     * @var string
     */
    public $table;

    /**
     * 用户信息
     * @var array
     */
    public $userInfo = [];

    /**
     * Token
     * @var string
     */
    public $token = '';


    /**
     * 逻辑对象
     * @var
     */
    public $logic;


    /**
     * @throws \Exception
     */
    public function _initialize()
    {
        $this->token = $this->request->header('token');
        if ($this->token) {
            $userInfo = cache($this->token);
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

    /**
     * 成功返回
     * @param $data
     * @param string $msg
     * @param int $code
     * @return array
     */
    public function buildSuccess($data, $msg = '操作成功', $code = ReturnCode::SUCCESS)
    {
        $return = [
            'code' => $code,
            'msg' => $msg,
            'data' => $data
        ];
        if ($this->debug) {
            $return['debug'] = $this->debug;
        }

        return $return;
    }

    /**
     * 失败返回
     * @param $code
     * @param $msg
     * @param array $data
     * @return array
     */
    public function buildFailed($code = 0, $msg = '操作失败', $data = [])
    {
        $return = [
            'code' => $code,
            'msg' => $msg,
            'data' => $data
        ];
        if ($this->debug) {
            $return['debug'] = $this->debug;
        }

        return $return;
    }


    /**
     * 调试
     * @param $data
     */
    protected function debug($data)
    {
        if ($data) {
            $this->debug[] = $data;
        }
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
            $header = config('basic.CROSS_DOMAIN');
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
        $limit = $this->request->get('size', 10);
        $start = $this->request->get('page', 0);
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

    /** 成功返回
     * @param $data
     * @return array
     */
    public function returnSuccess($data)
    {
        $return = [
            'code' => 1,
            'msg' => $data['msg'],
            'data' => $data['data']
        ];
        if ($this->debug) {
            $return['debug'] = $this->debug;
        }

        return $return;
    }


    /** 失败返回
     * @param $data
     * @return array
     */
    public function returnError($data)
    {
        $return = [
            'code' => 0,
            'msg' => $data['msg'],
            'data' => $data['data']
        ];
        if ($this->debug) {
            $return['debug'] = $this->debug;
        }

        return $return;
    }


}