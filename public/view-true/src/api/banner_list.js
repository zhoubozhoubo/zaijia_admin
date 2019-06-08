import axios from 'axios';

/**
 * 获取列表
 * @returns {*}
 */
export const getDataList = (pageData, searchConf) => {
    return axios.get('Banner/getList',{
        params: {
            'page':
            pageData.currentPage,
            'size':
            pageData.pageSize,
            'searchConf':
            searchConf,
        }
    })
}

export const saveData = (data) => {
    return axios.post('Banner/save',{
        data: data,
    })
}

export const change = (data) => {
    return axios.post('Banner/change',{
        data: data,
    })
}

export const deleteData = (data) => {
    return axios.post('Banner/delete',{
        data: data,
    })
}

