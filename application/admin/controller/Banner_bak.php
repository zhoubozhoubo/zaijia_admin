<?php

namespace app\admin\controller;

use app\admin\model\ZjBanner;
use app\util\BaseController;

class Banner extends BaseController
{
    public function index()
    {
        $where=[
            'status'=>1,
            'is_delete'=>0
        ];
        $res = ZjBanner::where($where)->order('sort ASC')->select();
        return $this->buildSuccess($res);
    }

    public function save()
    {
        $this->requestType('POST');
        $postData = $this->request->post();
        if ($postData['id'] != 0) {
            ZjBanner::update($postData);
            return $this->buildSuccess([]);
        } else if (ZjBanner::create($postData)) {
            return $this->buildSuccess([]);
        }
        return $this->buildFailed();
    }

}
