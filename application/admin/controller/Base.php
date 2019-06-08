<?php
/**
 * 工程基类
 * @since   2017/02/28 创建
 * @author  zhaoxiang <zhaoxiang051405@gmail.com>
 */

namespace app\admin\controller;

use app\util\ReturnCode;
use think\Controller;
use think\Db;
use think\db\Query;

class Base extends Controller
{

    private $debug = [];
    protected $userInfo;

    /**
     * 页面标题
     * @var string
     */
    public $title;

    /**
     * 默认操作数据表
     * @var string
     */
    public $table;

    public function _initialize()
    {
        $ApiAuth = $this->request->header('ApiAuth');
        if ($ApiAuth) {
            $userInfo = cache('Login:' . $ApiAuth);
            $this->userInfo = json_decode($userInfo, true);
        }
    }

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

    public function buildFailed($code, $msg, $data = [])
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

    protected function debug($data)
    {
        if ($data) {
            $this->debug[] = $data;
        }
    }


    /** 列表集成处理方法
     * @param null $dbQuery 数据库查询对象
     * @param $other    其他数据
     * @return array
     * @throws \think\exception\DbException
     */
    protected function _list($dbQuery = null,$other = null)
    {
        $db = is_null($dbQuery) ? Db::name($this->table) : (is_string($dbQuery) ? Db::name($dbQuery) : $dbQuery);
        $limit = $this->request->get('size', config('apiAdmin.ADMIN_LIST_DEFAULT'));
        $start = $this->request->get('page', 1);
        $listObj = $db->paginate($limit, false, ['page' => $start])->toArray();
        $listInfo = $listObj['data'];
        $this->_callback('_data_filter', $listInfo, []);
        return $this->buildSuccess(['list' => $listInfo, 'count' => $listObj['total'], 'other' => $other]);
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

}
