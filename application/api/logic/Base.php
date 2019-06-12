<?php

namespace app\api\logic;


class Base
{
    public function resultSuccess($data = '',$code=1,$msg='操作成功')
    {
        return ['code' => $code, 'msg' => $msg, 'data' => $data];
    }
    public function resultFailed($code=-1, $msg='操作失败', $data = '')
    {
        return ['code' => $code, 'msg' => $msg, 'data' => $data];
    }

}