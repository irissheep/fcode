import HttpUtils from '../utils/HttpUtils';
import {
  booleanDataRes,
  rechargeResType,
  responseType,
  loginResType,
  registerResType,
  consumeResType,
  myResType,
  myBalanceResType,
  messageListResType
} from '../typeDeclare/responseType'

class HomeAPI {
  // 登录
  doLoginApi(data: any): Promise<any>{
    return new HttpUtils().post('/blade-system/user/login', data);
  }

  // 用户注册
  registerApi(data: object): Promise<registerResType> {
    return new HttpUtils().post('/blade-system/user/register', data);
  }

  // 退出登录
  loginOutApi(params: object): Promise<object> {
    return new HttpUtils().get('/blade-system/user/logout', params);
  }

  // 用户详情
  getUserInfoApi(params: object): Promise<myResType> {
    return new HttpUtils().get('/blade-system/user/userInfo', params);
  }

  // 账户余额
  getBalanceApi(params: object): Promise<myBalanceResType> {
    return new HttpUtils().get('/account/getBalance', params);
  }

  // 账户充值
  rechargeApi(data: object): Promise<responseType> {
    return new HttpUtils().post('/account/add', data);
  }

  // 充值记录
  rechargeRecordApi(params): Promise<rechargeResType> {
    return new HttpUtils().get(`/account/log`, params);
  }

  // 修改密码
  editPwdApi(data: object): Promise<responseType> {
    return new HttpUtils().post('/blade-system/user/editPwd', data);
  }

  // 消费/账单记录 分页
  consumeRecordApi(params: object): Promise<consumeResType> {
    return new HttpUtils().get('/bill/page', params);
  }

  // 消息列表
  messageListApi(params: object): Promise<messageListResType> {
    return new HttpUtils().get('/bill/messageList', params);
  }

  // 一键已读
  clearAllMsgApi(userId:string): Promise<booleanDataRes> {
    return new HttpUtils().post(`/bill/editAllStatus?userId=${userId}&status=1`,{});
  }
 // 清空消息
  clearMsgApi(userId:string): Promise<booleanDataRes> {
    return new HttpUtils().get(`/bill/clear`,{userId});
  }
  // 编辑单个消息状态
  msgStatusApi(data: object): Promise<booleanDataRes> {
    return new HttpUtils().post('/bill/editStatus', data);
  }

  // 编辑头像
  editAvatarApi(data: object): Promise<responseType> {
    return new HttpUtils().post('/blade-system/user/edit', data);
  }
  downloadAvatarApi(fileName): Promise<responseType> {
    return new HttpUtils().get(`/images/download`,{fileName,type:1});
  }
  uploadApi(data): Promise<responseType> {
    return new HttpUtils().post(`/images/uploadBase64`,data);
  }
  //人脸识别
  uploadFacialApi(data): Promise<responseType> {
    return new HttpUtils().post(`/images/recognizeImageBase64`,data);
  }

}

export let homeApi = new HomeAPI();

