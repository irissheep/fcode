import HttpUtils from '../utils/HttpUtils'
import {
  deviceResType,
  responseType,
  goodsNameResType,
  saleNumberResType,
  behaviorResType,
  sellTrendResType,
  SaleRankResType,
  SalesResType,
  warnResType,
  deviceListResType,
  deviceDetailResType,
  userListResType,
  billDetailResType,
  data4ResType
} from '../typeDeclare/responseType'

class MerchantAPI {
  // 设备分页
  deviceManageApi(params: object): Promise<deviceResType> {
    return new HttpUtils().get('/device/page', params);
  }

  // 商品列表名称
  getGoodsNameApi(): Promise<goodsNameResType> {
    return new HttpUtils().get('/product/listName',{});
  }

  // 商品补货-开始
  supplyGoodsStartApi(params: object): Promise<responseType> {
    return new HttpUtils().get('/product/replenishment', params);
  }

  // 商品补货-提交
  supplyGoodsFinishApi(data: object): Promise<responseType> {
    return new HttpUtils().post('/product/replenishment', data);
  }

  // 商品详情
  goodsDetailApi(params: object): Promise<deviceDetailResType> {
    return new HttpUtils().get('/product/detail', params);
  }

  //设备列表 包含货架和格子两级
  shelfListLApi(params?: object): Promise<deviceListResType> {
    return new HttpUtils().get('/device/list', params);
  }

  // 新增或者修改商品
  submitGoodsApi(data: object): Promise<responseType> {
    return new HttpUtils().post('/product/submit', data);
  }

  // 商品销售数量统计
  saleNumberApi(params: object): Promise<saleNumberResType> {
    return new HttpUtils().get('/statistics/numberCount', params);
  }

  //用户选购行为统计
  behaviorApi(params: object): Promise<behaviorResType> {
    return new HttpUtils().get('/statistics/purchaseBehavior', params);
  }

  //商品销售趋势
  sellTrendApi(params: object): Promise<sellTrendResType> {
    return new HttpUtils().get('/statistics/saleTrend', params);
  }

  //商品库存统计
  inventoryApi(): Promise<data4ResType> {
    return new HttpUtils().get('/statistics/inventory',{});
  }

  // 销售统计
  salesApi(): Promise<SalesResType> {
    return new HttpUtils().get('/statistics/saleCount',{});
  }

  // 销量排行
  SaleRankApi(params: object): Promise<SaleRankResType> {
    return new HttpUtils().get('/statistics/SaleRank', params);
  }

  // 补货预警
  replenishWarnApi(): Promise<warnResType> {
    return new HttpUtils().get('/product/replenishWarn');
  }

  //设备异常
  deviceWarnApi(): Promise<warnResType> {
    return new HttpUtils().get('/device/deviceWarn',{});
  }

  // 账户列表
  getUserListApi(): Promise<userListResType> {
    return new HttpUtils().get('/blade-system/user/getUserList');
  }

  // 处置账单
  handleBillApi(data: object): Promise<responseType> {
    return new HttpUtils().post('/bill/handleBill',data);
  }

  // 账单详情
  billDetailApi(id: string): Promise<billDetailResType> {
    return new HttpUtils().get(`/bill/detail?id=${id}`);
  }
}


export let merchantAPI = new MerchantAPI();