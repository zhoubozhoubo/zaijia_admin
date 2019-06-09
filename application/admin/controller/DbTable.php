<?php

namespace app\admin\controller;

use app\util\BaseController;
use think\Db;
use think\exception\DbException;

class DbTable extends BaseController
{
    //是否强制写入vue文件
    public $forceWriteVue = false;
    //是否强制写入js文件
    public $forceWriteJs = false;
    //是否强制写入controller文件
    public $forceWriteController = false;
    //是否强制写入model文件
    public $forceWriteModel = false;

    /**
     * 一键生成
     * @return array
     */
    public function index()
    {
        $this->requestType('POST');
        $paramData = $this->request->param()['data'];

        //是否强制重写
        if (isset($paramData['fileList']) && $paramData['fileList'] !== []) {
            $fileList = $paramData['fileList'];
            foreach ($fileList as $key => &$val) {
                if ($val['forceWrite']) {
                    $val['forceWrite'] = 1;
                } else {
                    $val['forceWrite'] = 0;
                }
            }
            if ($fileList[0]['forceWrite'] === 0 && $fileList[1]['forceWrite'] === 0 && $fileList[2]['forceWrite'] === 0 && $fileList[3]['forceWrite'] === 0) {
                return $this->buildFailed(-2, '请勾选要重写生成的文件');
            }
            //强制写入vue文件
            if ($fileList[0]['forceWrite'] === 1) {
                $this->forceWriteVue = true;
            }
            //强制写入js文件
            if ($fileList[1]['forceWrite'] === 1) {
                $this->forceWriteJs = true;
            }
            //强制写入controller文件
            if ($fileList[2]['forceWrite'] === 1) {
                $this->forceWriteController = true;
            }
            //强制写入model文件
            if ($fileList[3]['forceWrite'] === 1) {
                $this->forceWriteModel = true;
            }
        }

        //表名称
        $tableName = $paramData['tableName'];
        //表所有字段及属性
        $fullFields = Db::query("SHOW FULL FIELDS FROM {$tableName}");

        //基本配置
        $baseConfig = $paramData['baseConfig'];

        //可搜索列数据
        $searchData = $paramData['searchData'];
        foreach ($searchData as $key => &$val) {
            if ($val['key'] === '' || $val['name'] === '') {
                unset($searchData[$key]);
            }
        }
        $searchData = array_values($searchData);

        //搜索组件数据
        $searchComponentsData = $paramData['searchComponentsData'];
        $datePickerKey = '';
        $dateRangePickerKey = '';
        foreach ($searchComponentsData as $key => &$val) {
            if ($val['key'] === '' || $val['name'] === '') {
                unset($searchComponentsData[$key]);
            } else {
                if ($val['name'] === 'DatePicker') {
                    $datePickerKey = $val['key'];
                } else if ($val['name'] === 'DateRangePicker') {
                    $dateRangePickerKey = $val['key'];
                }
            }
        }
        $searchComponentsData = array_values($searchComponentsData);

        //表格列数据
        $columnsData = $paramData['columnsData'];
        foreach ($columnsData as $key => &$val) {
            if ($val['key'] === '' || $val['name'] === '') {
                unset($columnsData[$key]);
            }
        }
        $columnsData = array_values($columnsData);

        //表格组件数据
        $tableComponentsData = $paramData['tableComponentsData'];
        $switchKey = '';
        $SwitchComment = [];
        foreach ($tableComponentsData as $key => &$val) {
            if ($val['key'] === '' || $val['name'] === '') {
                unset($tableComponentsData[$key]);
            } else {
                if ($val['name'] === 'Switch') {
                    $switchKey = $val['key'];
                    foreach ($fullFields as $item) {
                        if ($item['Field'] === $switchKey) {
                            $SwitchComment = json_decode($item['Comment'],true);
                            $SwitchComment['name'] = $switchKey;
                        }
                    }
                }
            }
        }
        $tableComponentsData = array_values($tableComponentsData);

        //表单元素数据
        $formData = $paramData['formData'];
        foreach ($formData as $key => &$val) {
            if ($val['key'] === '' || $val['name'] === '') {
                unset($formData[$key]);
            }
        }
        $formData = array_values($formData);

        //表单显示数据
        $showData = $paramData['showData'];
        foreach ($showData as $key => &$val) {
            if ($val['key'] === '') {
                unset($showData[$key]);
            } else {
                if (!$val['show']) {
                    $val['show'] = 0;
                }
            }
        }
        $showData = array_values($showData);

        //表单组件数据
        $componentsData = $paramData['componentsData'];
        foreach ($componentsData as $key => &$val) {
            if ($val['key'] === '' || $val['name'] === '') {
                unset($componentsData[$key]);
            }
        }
        $componentsData = array_values($componentsData);

        //必填数据
        $requiredRuleData = $paramData['requiredRuleData'];
        foreach ($requiredRuleData as $key => &$val) {
            if ($val['key'] === '') {
                unset($requiredRuleData[$key]);
            } else {
                if (!$val['required']) {
                    $val['required'] = 0;
                }
            }
        }
        $requiredRuleData = array_values($requiredRuleData);


        if (isset($paramData['fileList']) && $paramData['fileList'] !== []) {
            //生成vue文件
            if ($this->forceWriteVue === true) {
                $vueRes = $this->createVue($baseConfig, $searchData, $searchComponentsData, $columnsData, $tableComponentsData, $formData, $showData, $componentsData, $requiredRuleData, $SwitchComment);
            } else {
                $vueRes = 1;
            }

            //生成js文件
            if ($this->forceWriteJs === true) {
                $jsRes = $this->createJs($baseConfig['backControllerName'],$baseConfig['frontFileName']);
            } else {
                $jsRes = 1;
            }

            //生成Controller文件
            if ($this->forceWriteController === true) {
                $controllerRes = $this->createController($baseConfig, $datePickerKey, $dateRangePickerKey, $switchKey);
            } else {
                $controllerRes = 1;
            }

            //生成Model文件
            if ($this->forceWriteModel === true) {
                $modelRes = $this->createModel($baseConfig['backModelName']);
            } else {
                $modelRes = 1;
            }
        } else {
            //生成vue文件
            $vueRes = $this->createVue($baseConfig, $searchData, $searchComponentsData, $columnsData, $tableComponentsData, $formData, $showData, $componentsData, $requiredRuleData, $SwitchComment);

            //生成js文件
            $jsRes = $this->createJs($baseConfig['backControllerName'],$baseConfig['frontFileName']);

            //生成Controller文件
            $controllerRes = $this->createController($baseConfig, $datePickerKey, $dateRangePickerKey, $switchKey);

            //生成Model文件
            $modelRes = $this->createModel($baseConfig['backModelName']);
        }

        if ($vueRes === 1 && $jsRes === 1 && $controllerRes === 1 && $modelRes === 1) {
            //生成成功
            return $this->buildSuccess([]);
        } else {
            //存在文件生成失败或文件存在
            $data = [
                ['name' => 'vueFile', 'create' => $vueRes, 'forceWrite' => $this->forceWriteVue],
                ['name' => 'jsFile', 'create' => $jsRes, 'forceWrite' => $this->forceWriteJs],
                ['name' => 'controllerFile', 'create' => $controllerRes, 'forceWrite' => $this->forceWriteController],
                ['name' => 'modelFile', 'create' => $modelRes, 'forceWrite' => $this->forceWriteModel]
            ];
            return $this->buildFailed(0, '存在部分文件生成失败或部分文件已经存在，是否重新生成！', $data);
        }
    }

    public function createVue($baseConfig, $searchData, $searchComponentsData, $columnsData, $tableComponentsData, $formData, $showData, $componentsData, $requiredRuleData, $SwitchComment)
    {
        //模块名
        $modelName = $baseConfig['frontModelName'];
        //组名称
        $groupName = $baseConfig['frontGroupName'];
        //文件名称
        $fileName = $baseConfig['frontFileName'];

        //表主键
        $pk = $baseConfig['pk'];

        //新增操作
        $add = $baseConfig['add'];

        //编辑操作
        $edit = $baseConfig['edit'];

        //删除操作
        $delete = $baseConfig['delete'];

        //搜索表单
        $searchConf = $searchData;
        $searchConfJson = [];
        if ($searchConf) {
            foreach ($searchConf as $key => $val) {
                foreach ($searchComponentsData as $k => $v) {
                    if ($val['key'] === $v['key']) {
                        //搜索组件类型
                        $searchConf[$key]['components'] = $v['name'];
                    }
                }
                //搜索字段json
                $searchConfJson["-" . $val['key'] . "-"] = '';
            }
        }


        //显示表格列json
        $columnsListJson = [];
        if ($columnsData) {
            foreach ($columnsData as $key => $val) {
                $columnsListJson[$key]["-title-"] = $val['name'];
                $columnsListJson[$key]["-key-"] = $val['key'];
                $columnsListJson[$key]["-align-"] = 'center';
            }
        }
        //操作列
        if ($edit && $delete) {
            $key = count($columnsListJson);
            $columnsListJson[$key]['-title-'] = '操作';
            $columnsListJson[$key]['-key-'] = 'handle';
            $columnsListJson[$key]['-align-'] = 'center';
            if (!$edit && $delete) {
                $handle = ['delete'];
            } else if ($edit && !$delete) {
                $handle = ['edit'];
            } else {
                $handle = ['edit', 'delete'];
            }
            $columnsListJson[$key]['-handle-'] = $handle;
        }

        //新增表单元素
        $formItem = $formData;
        $formItemJson = [];
        $imgComponentsKey = '';
        $imgComponents = 0;
        $textAreaComponentsKey = '';
        $textAreaComponents = 0;
        if ($formItem) {
            foreach ($formItem as $key => $val) {
                //表单元素显示
                $formItem[$key]['show'] = $showData[$key]['show'];
                //表单元素组件
                if ($showData[$key]['show']) {
                    foreach ($componentsData as $k => $v) {
                        if ($v['name'] === 'UploadImg') {
                            $imgComponentsKey = $v['key'];
                            $imgComponents = 1;
                        }
                        if ($v['name'] === 'TextArea') {
                            $textAreaComponentsKey = $v['key'];
                            $textAreaComponents = 1;
                        }
                        if ($val['key'] === $v['key']) {
                            //表单元素组件类型
                            $formItem[$key]['components'] = $v['name'];
                        }
                    }
                }
                //表单字段json
                $formItemJson["-" . $val['key'] . "-"] = '';
            }
        }

        //表单字段过滤规则
        $ruleValidate = [];
        if ($requiredRuleData) {
            foreach ($requiredRuleData as $val) {
                $ruleValidate['-' . $val['key'] . '-'] = [["-required-" => $val['required'], "-message-" => $val['msg'], "-trigger-" => 'blur']];
            }
        }

        //主键
        $this->assign('pk', $pk);
        //模块名
        $this->assign('modelName', $modelName);
        $this->assign('fileName', $fileName);
        //搜索参数
        $this->assign('searchConf', $searchConf);
        $this->assign('searchConfJson', $this->jsonReplace($searchConfJson));
        //表格数据
        $this->assign('columnsListJson', $this->jsonReplace($columnsListJson));
        $this->assign('tableComponentsData', $tableComponentsData);
        $this->assign('add', $add);
        $this->assign('edit', $edit);
        $this->assign('delete', $delete);
        //表单参数
        $this->assign('formItem', $formItem);
        if($formItemJson){
            $this->assign('formItemJson', $this->jsonReplace($formItemJson));
        }else{
            $this->assign('formItemJson', '');
        }
        $this->assign('imgComponentsKey', $imgComponentsKey);
        $this->assign('imgComponents', $imgComponents);
        $this->assign('textAreaComponentsKey', $textAreaComponentsKey);
        $this->assign('textAreaComponents', $textAreaComponents);
        //表单验证
        if($ruleValidate){
            $this->assign('ruleValidate', $this->jsonReplace($ruleValidate));
        }else{
            $this->assign('ruleValidate', '');
        }
        $this->assign('SwitchComment', $SwitchComment);

        //原始vue文件内容
        $txt = $this->fetch('vue');

        $path = '/view-true/src/views/' . $modelName . '/' . $groupName . '/';

        if (!file_exists($_SERVER['DOCUMENT_ROOT'] . $path)) {
            mkdir($_SERVER['DOCUMENT_ROOT'] . $path, 0777, true);
        }
        $pathFile = $_SERVER['DOCUMENT_ROOT'] . $path . $fileName . ".vue";
        if (file_exists($pathFile) && !$this->forceWriteVue) {
//            return $this->buildSuccess('文件已经存在，是否重新生成！', ReturnCode::DB_SAVE_ERROR);
            return -1;
        }
        if (file_exists($pathFile)) {
            copy($pathFile, $_SERVER['DOCUMENT_ROOT'] . '/generateBack/' . $fileName . date('Ymdhms', time()) . ".vue");
        }

        //打开文件
        $myFile = fopen($pathFile, "w");

        // 写入文件
        if (fwrite($myFile, $txt)) {
            fclose($myFile);
//            return $this->buildSuccess('生成成功');
            return 1;
        } else {
//            return $this->buildFailed();
            return 0;
        }
    }

    public function createJs($backControllerName,$frontModelName)
    {

        $this->assign('name', $backControllerName);
        $txt = $this->fetch('js');
        //return $txt;
        $path = '/view-true/src/api/';
        if (!file_exists($_SERVER['DOCUMENT_ROOT'] . $path)) {
            mkdir($_SERVER['DOCUMENT_ROOT'] . $path, 0777, true);
        }
        $pathFile = $_SERVER['DOCUMENT_ROOT'] . $path . $frontModelName . ".js";
        if (file_exists($pathFile) && !$this->forceWriteJs) {
//            return $this->buildSuccess('文件已经存在，是否重新生成！', ReturnCode::DB_SAVE_ERROR);
            return -1;
        }
        if (file_exists($pathFile)) {
            copy($pathFile, $_SERVER['DOCUMENT_ROOT'] . '/generateBack/' . $frontModelName . date('Ymdhms', time()) . ".js");
        }
        $myFile = fopen($pathFile, "w");

        if (fwrite($myFile, $txt)) {
            fclose($myFile);
//            return $this->buildSuccess('生成成功');
            return 1;
        } else {
//            return $this->buildFailed();
            return 0;
        }
    }

    public function createController($baseConfig, $datePickerKey, $dateRangePickerKey, $switchKey)
    {
        //下划线转驼峰命名
        //文件名称及类名称
        $backControllerName = $this->convertUnderline($baseConfig['backControllerName']);
        //Model名称
        $backModelName = $this->convertUnderline($baseConfig['backModelName']);
        //表主键
        $pk = $baseConfig['pk'];

        //返回原始文件内容
        $txtOne = "<?php\nnamespace app\admin\controller;\n\nuse app\admin\model\\{$backModelName};\nuse app\util\BaseController;\nuse think\Db;\nuse think\Exception;\nuse think\\exception\DbException;

/**
*
* @package app\admin\controller
*/
class {$backControllerName} extends BaseController
{

    public $-table = '{$backModelName}';

    /**
    * 获取列表
    * @return array|string
    * @throws DbException
    * @throws Exception
    */
    public function getList()
    {
        $-this->requestType('GET');
        $-searchConf = json_decode($-this->request->param('searchConf', ''),true);
        $-db = Db::name($-this->table);
        if($-searchConf){
            foreach ($-searchConf as $-key=>$-val){
                if($-val === ''){
                    unset($-searchConf[$-key]);
                }
                else if($-key === 'status'){
                    $-searchConf[$-key] = $-val;
                }";
        $txtTwo = "
                else{";
        $txtThree = "
                    if($-key === '{$datePickerKey}'){
                        $-db->whereTime('{$datePickerKey}','between', [" . '"{$-val} 00:00:00"' . ", " . '"{$-val} 23:59:59"' . "]);
                        unset($-searchConf[$-key]);
                        continue;
                    }";
        $txtFour = "
                    if($-key === '{$dateRangePickerKey}'){
                        $-db->whereBetween('{$dateRangePickerKey}', [" . '"{$-val[0]} 00:00:00"' . ", " . '"{$-val[1]} 23:59:59"' . "]);
                        unset($-searchConf[$-key]);
                        continue;
                    }";
        $txtFive = "
                    if ($-key === 'status') {
                        $-searchConf[$-key] = $-val;
                    }
                    else{
                        $-searchConf[$-key] = ['like', '%'.$-val.'%'];
                    }
                }";
        $txtSix = "
            }
        }
        $-where = $-searchConf;
        $-db = $-db->where($-where)->order('{$pk} desc');
        return $-this->_list($-db);
    }


    /**
    * 保存
    * @return array
    */
    public function save()
    {
        $-this->requestType('POST');
        $-postData = $-this->request->post();
        if ($-postData['{$pk}'] !== 0) {
            {$backModelName}::update($-postData);
            return $-this->buildSuccess([]);
        } else if ({$backModelName}::create($-postData)) {
            return $-this->buildSuccess([]);
        }
        return $-this->buildFailed();
    }";
        $txtSeven = "


    /**
    * 改变
    * @return array
    */
    public function change()
    {
        $-this->requestType('POST');
        $-postData = $-this->request->post();
        $-res = {$backModelName}::update($-postData);
        if(!$-res){
            return $-this->buildFailed();
        }
        return $-this->buildSuccess([]);
    }";
        $txtEight = "


    /**
    * 删除
    * @return array
    */
    public function delete()
    {
        $-this->requestType('POST');
        $-id = $-this->request->post();
        if ({$backModelName}::destroy($-id)) {
            return $-this->buildSuccess([]);
        }
        return $-this->buildFailed();
    }
}";
        if (!$datePickerKey && !$dateRangePickerKey) {
            $txt = $txtOne . $txtTwo . $txtFive . $txtSix;
        } else if ($datePickerKey && !$dateRangePickerKey) {
            $txt = $txtOne . $txtTwo . $txtThree . $txtFive . $txtSix;
        } else if (!$datePickerKey && $dateRangePickerKey) {
            $txt = $txtOne . $txtTwo . $txtFour . $txtFive . $txtSix;
        } else {
            $txt = $txtOne . $txtTwo . $txtThree . $txtFour . $txtFive . $txtSix;
        }

        if (!$switchKey) {
            $txt .= $txtEight;
        } else {
            $txt .= $txtSeven . $txtEight;
        }

        $path = '/admin/controller/';
        if (!file_exists(APP_PATH . $path)) {
            mkdir(APP_PATH . $path, 0777, true);
        }
        $pathFile = APP_PATH . $path . $backControllerName . ".php";

        if (file_exists($pathFile) && !$this->forceWriteController) {
//            return $this->buildSuccess('文件已经存在，是否重新生成！', ReturnCode::DB_SAVE_ERROR);
            return -1;
        }
        if (file_exists($pathFile)) {
            copy($pathFile, $_SERVER['DOCUMENT_ROOT'] . '/generateBack/' . $backControllerName . date('Ymdhms', time()) . ".php");
        }
        $txt = str_replace('$-', '$', $txt);
        $myFile = fopen($pathFile, "w");

        if (fwrite($myFile, $txt)) {
            fclose($myFile);
//            return $this->buildSuccess('生成成功');
            return 1;
        } else {
//            return $this->buildFailed();
            return 0;
        }
    }

    public function createModel($backModelName)
    {
        //返回原始文件内容
        $txt = "<?php

namespace app\admin\model;

use think\Model;

class {$backModelName} extends Model
{

}";
        $path = '/admin/model/';
        if (!file_exists(APP_PATH . $path)) {
            mkdir(APP_PATH . $path, 0777, true);
        }
        $pathFile = APP_PATH . $path . $backModelName . ".php";
        if (file_exists($pathFile) && !$this->forceWriteModel) {
//            return $this->buildSuccess('文件已经存在，是否重新生成！', ReturnCode::DB_SAVE_ERROR);
            return -1;
        }
        if (file_exists($pathFile)) {
            copy($pathFile, $_SERVER['DOCUMENT_ROOT'] . '/generateBack/' . $backModelName . date('Ymdhms', time()) . ".php");
        }
        $txt = str_replace('$-', '$', $txt);
        $myFile = fopen($pathFile, "w");

        if (fwrite($myFile, $txt)) {
            fclose($myFile);
//            return $this->buildSuccess('生成成功');
            return 1;
        } else {
//            return $this->buildFailed();
            return 0;
        }

    }

    /**
     * 获取数据表
     * @return array
     */
    public function getTableList()
    {
        try {
            $lists = Db::query("SHOW TABLE STATUS");
            return $this->buildSuccess($lists);
        } catch (DbException $exception) {
            return $this->buildFailed();
        }
    }

    /**
     * 获取表所有列
     * @return array
     */
    public function getTableFullColumns()
    {
        $table = $this->request->get('name');
        try {
            $lists = Db::query("SHOW FULL COLUMNS FROM {$table}");
            return $this->buildSuccess($lists);
        } catch (DbException $exception) {
            return $this->buildFailed();
        }
    }

    /**
     * 获取表所有字段
     * @return array
     */
    public function getTableFullFields()
    {
        $table = $this->request->get('name');
        try {
            $lists = Db::query("SHOW FULL FIELDS FROM {$table}");
            return $this->buildSuccess($lists);
        } catch (DbException $exception) {
            return $this->buildFailed();
        }
    }

    /**
     * json字符串处理
     * @param $str
     * @return mixed
     */
    public function jsonReplace($str)
    {
        return str_replace('-"', '', str_replace('"-', '', json_encode($str, JSON_UNESCAPED_UNICODE)));
    }

    /**
     * 下划线转驼峰命名
     * @param $str
     * @return string
     */
    public function convertUnderline($str)
    {
        $str = ucwords(str_replace('_', ' ', $str));
        $str = str_replace(' ', '', lcfirst($str));
        return ucfirst($str);
    }


}