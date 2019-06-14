<?php

namespace app\index\controller;

use think\Controller;

class Index extends Controller
{
    public function index(){
        $this->assign('title','123');
        return $this->fetch();
    }
}