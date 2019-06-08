<template>
    <div>
        <Row>
            <Col span="24">
            <Card style="margin-bottom: 10px">
                <Form inline>
                                        <FormItem style="margin-bottom: 0">
                    <Select v-model="searchConf.status" clearable placeholder='请选择状态' style="width:100px">
                        <Option :value="1">select1</Option>
                        <Option :value="2">select2</Option>
                        <Option :value="3">select3</Option>
                    </Select>
                    </FormItem>
                                        <FormItem style="margin-bottom: 0">
                        <Button type="primary" shape="circle" icon="ios-search" @click="search">查询/刷新</Button>
                    </FormItem>
                </Form>
            </Card>
            </Col>
        </Row>
        <Row>
            <Col span="24">
            <Card>
                                <p slot="title" style="height: 40px">
                    <Button type="primary" @click="alertAdd" icon="md-add">新增</Button>
                </p>
                                <div>
                    <Table :loading="loading" :columns="columnsList" :data="tableData" border disabled-hover></Table>
                </div>
                <div style="text-align: center;margin-top: 15px">
                    <Page :total="tableShow.listCount" :current="tableShow.currentPage"
                          :page-size="tableShow.pageSize" @on-change="changePage"
                          @on-page-size-change="changeSize" show-elevator show-sizer show-total></Page>
                </div>
            </Card>
            </Col>
        </Row>
        <Modal v-model="modalSetting.show" width="700" :styles="{top: '30px'}" @on-visible-change="doCancel">
            <p slot="header" style="color:#2d8cf0;">
                <Icon type="md-information-circle"></Icon>
                <span>{{formItem.id ? '编辑' : '新增'}}</span>
            </p>
            <Form ref="myForm" :rules="ruleValidate" :model="formItem" :label-width="100">
                                <FormItem label="链接名称" prop="name">
                                        <Input v-model="formItem.name" placeholder="链接名称"></Input>
                                    </FormItem>
                                <FormItem label="链接图片" prop="img">
                                        <div class="demo-upload-list" v-if="formItem.img">
                        <img :src="formItem.img">
                        <div class="demo-upload-list-cover">
                            <Icon type="ios-eye-outline" @click.native="handleView()"></Icon>
                            <Icon type="ios-trash-outline" @click.native="handleImgRemove()"></Icon>
                        </div>
                    </div>
                    <input v-if="formItem.img" v-model="formItem.img" type="hidden" name="image">
                    <Upload type="drag"
                            :action="uploadUrl"
                            :headers="uploadHeader"
                            v-if="!formItem.img"
                            :format="['jpg','jpeg','png']"
                            :max-size="5120"
                            :on-success="handleImgSuccess"
                            :on-format-error="handleImgFormatError"
                            :on-exceeded-size="handleImgMaxSize"
                            style="display: inline-block;width:58px;">
                        <div style="width: 58px;height:58px;line-height: 58px;">
                            <Icon type="ios-camera" size="20"></Icon>
                        </div>
                    </Upload>
                    <Modal title="View Image" v-model="visible">
                        <img :src="formItem.img" v-if="visible" style="width: 100%">
                    </Modal>
                                    </FormItem>
                                <FormItem label="链接跳转地址" prop="url">
                                        <Input v-model="formItem.url" placeholder="链接跳转地址"></Input>
                                    </FormItem>
                                <FormItem label="排序" prop="sort">
                                        <Input v-model="formItem.sort" placeholder="排序"></Input>
                                    </FormItem>
                            </Form>
            <div slot="footer">
                <Button type="text" @click="cancel" style="margin-right: 8px">取消</Button>
                <Button type="primary" @click="submit" :loading="modalSetting.loading">确定</Button>
            </div>
        </Modal>
        <!--查看大图-->
        <Modal v-model="modalSeeingImg.show"
               class-name="fl-image-modal"
               @on-visible-change="doCancel">
            <img :src="modalSeeingImg.img" v-if="modalSeeingImg.show" style="width: 100%">
        </Modal>
    </div>
</template>

<script>
        import config from '../../../../build/config';
        import {getDataList,saveData,deleteData,change} from '@/api/link_list'
    
    const editButton = (vm, h, currentRow, index) => {
        return h('Button', {
            props: {
                type: 'primary'
            },
            style: {
                margin: '0 5px'
            },
            on: {
                'click': () => {
                                        vm.formItem.id = currentRow.id;
                                        vm.formItem.name = currentRow.name;
                                        vm.formItem.img = currentRow.img;
                                        vm.formItem.url = currentRow.url;
                                        vm.formItem.sort = currentRow.sort;
                                        vm.modalSetting.show = true
                    vm.modalSetting.index = index
                }
            }
        }, '编辑')
    }
    const deleteButton = (vm, h, currentRow, index) => {
        return h('Poptip', {
            props: {
                confirm: true,
                title: '您确定要删除这条数据吗? ',
                transfer: true
            },
            on: {
                'on-ok': () => {
                    deleteData(currentRow.id).then(res => {
                        if (res.data.code === 1) {
                            vm.tableData.splice(index, 1)
                            vm.$Message.success(res.data.msg)
                        } else {
                            vm.$Message.error(res.data.msg)
                        }
                    }, err => {
                        vm.$Message.error(err.data.msg)
                    })
                }
            }
        }, [
            h('Button', {
                style: {
                    margin: '0 5px'
                },
                props: {
                    type: 'error',
                    placement: 'top',
                }
            }, '删除')
        ])
    }

    export default {
        name: 'link_list',
        components: {
        },
        data() {
            return {
                columnsList:[{title:"链接id",key:"id",align:"center"},{title:"链接名称",key:"name",align:"center"},{title:"链接图片",key:"img",align:"center"},{title:"链接跳转地址",key:"url",align:"center"},{title:"排序",key:"sort",align:"center"},{title:"状态",key:"status",align:"center"},{title:"操作",key:"handle",align:"center",handle:["edit","delete"]}],
                tableData: [],
                tableShow: {
                    currentPage: 1,
                    pageSize: 10,
                    listCount: 0
                },
                searchConf:{status:""},
                modalSetting: {
                    show: false,
                    loading: false,
                    index: 0
                },
                // 初始化图片弹出框
                modalSeeingImg: {
                    img: '',
                    show: false
                },
                                visible: false,
                uploadUrl: '',
                uploadHeader: {},
                                formItem:{id:"",name:"",img:"",url:"",sort:""},
                ruleValidate: {id:[{required:0,message:"",trigger:"blur"}],img:[{required:true,message:"请上传图片",trigger:"blur"}],url:[{required:true,message:"请输入跳转地址",trigger:"blur"}],status:[{required:0,message:"",trigger:"blur"}]},
                    loading: true,
            }
        },
        created() {
            this.init()
            this.getList()
                            this.uploadUrl = config.baseUrl + 'Index/upload';
                this.uploadHeader = {'ApiAuth': sessionStorage.getItem('apiAuth')};
                    },
        methods: {
            init() {
                let vm = this
                this.columnsList.forEach(item => {
                    if (item.key === 'handle') {
                        item.render = (h, param) => {
                            let currentRowData = vm.tableData[param.index]
                                                        return h('div', [
                                editButton(vm, h, currentRowData, param.index),
                                deleteButton(vm, h, currentRowData, param.index)
                            ])
                                                    }
                    }
                                            if (item.key === 'status') {
                            item.render = (h, param) => {
                                let currentRowData = vm.tableData[param.index];
                                return h('i-switch', {
                                    attrs: {
                                        size: 'large'
                                    },
                                    props: {
                                        'true-value': 1,
                                        'false-value': 0,
                                        value: currentRowData.status                                    },
                                    on: {
                                        'on-change': function (status) {
                                            change({id:currentRowData.id,status:status}).then(res => {
                                                vm.$Message.success(res.data.msg)
                                                vm.cancel()
                                            }, err => {
                                                vm.$Message.error(res.data.msg)
                                                vm.cancel()
                                            })
                                        }
                                    }
                                }, [
                                    h('span', {
                                        slot: 'open'
                                    }, '开启'),
                                    h('span', {
                                        slot: 'close'
                                    }, '关闭')
                                ]);
                            };
                        }
                                    })
            },
            alertAdd() {
                this.formItem.id = 0
                this.modalSetting.show = true
            },
                        handleView() {
                this.visible = true;
            },
            handleImgRemove() {
                this.formItem.img = '';
            },
            handleImgFormatError(file) {
                this.$Notice.warning({
                    title: '文件类型不合法',
                    desc: file.name + '的文件类型不正确，请上传jpg或者png图片。'
                });
            },
            handleImgMaxSize(file) {
                this.$Notice.warning({
                    title: '文件大小不合法',
                    desc: file.name + '太大啦请上传小于5M的文件。'
                });
            },
            handleImgSuccess(response) {
                if (response.code === 1) {
                    this.$Message.success(response.msg);
                    this.formItem.img = response.data.fileUrl;
                } else {
                    this.$Message.error(response.msg);
                }
            },
                        submit() {
                this.$refs['myForm'].validate((valid) => {
                    if (valid) {
                        this.modalSetting.loading = true
                        saveData(this.formItem).then(res => {
                            if (res.data.code === 1) {
                                this.$Message.success(res.data.msg)
                                this.getList()
                                this.cancel()
                            } else {
                                this.$Message.error(res.data.msg)
                            }
                        })
                    }
                })
            },
            cancel() {
                this.modalSetting.show = false
            },
            doCancel(data) {
                if (!data) {
                    this.formItem.id = 0
                    this.$refs['myForm'].resetFields()
                    this.modalSetting.loading = false
                    this.modalSetting.index = 0
                }
            },
            changePage(page) {
                this.tableShow.currentPage = page
                this.getList()
            },
            changeSize(size) {
                this.tableShow.pageSize = size
                this.getList()
            },
            search() {
                this.tableShow.currentPage = 1
                this.getList()
            },
            getList() {

                this.loading = true;
                getDataList(this.tableShow, this.searchConf).then(res => {
                    this.tableData = res.data.data.list
                    this.tableShow.listCount = res.data.data.count
                    this.loading = false
                })
            }
        }
    }
</script>

<style scoped>
.demo-upload-list{
    display: inline-block;
    width: 60px;
    height: 60px;
    text-align: center;
    line-height: 60px;
    border: 1px solid transparent;
    border-radius: 4px;
    overflow: hidden;
    background: #fff;
    position: relative;
    box-shadow: 0 1px 1px rgba(0,0,0,.2);
    margin-right: 4px;
}
.demo-upload-list img{
    width: 100%;
    height: 100%;
}
.demo-upload-list-cover{
    display: none;
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    background: rgba(0,0,0,.6);
}
.demo-upload-list:hover .demo-upload-list-cover{
    display: block;
}
.demo-upload-list-cover i{
    color: #fff;
    font-size: 20px;
    cursor: pointer;
    margin: 0 2px;
}
</style>
<style>
</style>
