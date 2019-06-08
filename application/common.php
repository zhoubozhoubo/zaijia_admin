<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006-2016 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: 流年 <liu21st@gmail.com>
// +----------------------------------------------------------------------

// 应用公共文件
use service\FileService;
use think\Db;

/**
 * 把返回的数据集转换成Tree
 * @param $list
 * @param string $pk
 * @param string $pid
 * @param string $child
 * @param string $root
 * @return array
 */
function listToTree($list, $pk = 'id', $pid = 'fid', $child = '_child', $root = '0')
{
    $tree = array();
    if (is_array($list)) {
        $refer = array();
        foreach ($list as $key => $data) {
            $refer[$data[$pk]] = &$list[$key];
        }
        foreach ($list as $key => $data) {
            $parentId = $data[$pid];
            if ($root == $parentId) {
                $tree[] = &$list[$key];
            } else {
                if (isset($refer[$parentId])) {
                    $parent = &$refer[$parentId];
                    $parent[$child][] = &$list[$key];
                }
            }
        }
    }
    return $tree;
}

function formatTree($list, $lv = 0, $title = 'name')
{
    $formatTree = array();
    foreach ($list as $key => $val) {
        $title_prefix = '';
        for ($i = 0; $i < $lv; $i++) {
            $title_prefix .= "|---";
        }
        $val['lv'] = $lv;
        $val['namePrefix'] = $lv == 0 ? '' : $title_prefix;
        $val['showName'] = $lv == 0 ? $val[$title] : $title_prefix . $val[$title];
        if (!array_key_exists('_child', $val)) {
            array_push($formatTree, $val);
        } else {
            $child = $val['_child'];
            unset($val['_child']);
            array_push($formatTree, $val);
            $middle = formatTree($child, $lv + 1, $title); //进行下一层递归
            $formatTree = array_merge($formatTree, $middle);
        }
    }
    return $formatTree;
}

/**
 * 获得用户所有下级
 * @param $id_str
 * @param $table
 * @return string
 */
function getDiguiId($id_str)
{
    $finaly_str = '';
    $id_arr = explode(',', $id_str);
    foreach ($id_arr as $k => $v) {
        $new_arr = Db::name('User')->where(['fid' => $v])->column('id');
        if ($new_arr) {
            $new_str = implode(',', $new_arr);
            $finaly_str .= $v . ',' . getDiguiId($new_str);
        } else {
            $finaly_str .= $v . ',';
        }
    }
    return $finaly_str;
}

/**
 * 读取，设置提成参数
 */
function extconf($name, $value = null)
{
    static $config = [];
    if ($value !== null) {
        list($config, $data) = [[], ['name' => $name, 'value' => $value]];
        return DataService::save('ExtractConfig', $data, 'name');
    }
    if (empty($config)) {
        $config = Db::name('ExtractConfig')->column('name,value');
    }
    return isset($config[$name]) ? $config[$name] : '';
}

/**
 * 下载远程文件到本地
 * @param string $url 远程图片地址
 * @return string
 */
function local_image($url)
{
    return FileService::download($url)['url'];
}

/** 邀请码
 * @return mixed|string
 */
function code(){
    //查询最新记录
    $xh = Db::name('User')->order('code desc')->limit(0, 1)->value('code');

    if (!empty($xh)) {
        return ++$xh;
    } else {
        return '1001';
    }
}

/** 开码返现开关
 * @return mixed
 */
function re(){
    $db=Db::name('re')->find();
    return $db['status'];
}

/** 前端地址
 * @return string
 */
function IndexUrl(){
    return 'http://dbdb00913b65fd62.natapp.cc';
}

/** 后端地址
 * @return string
 */
function AdminUrl(){
    return 'http://1b06d7955f45ea92.natapp.cc';
}

/**
 * 截取日期
 * @param string $datetime 输入日期
 * @param string $format 输出格式
 * @return false|string
 */
function ymd($datetime, $format = 'Y年m月d日')
{
    $time= date($format, strtotime($datetime));
    return $time;
}