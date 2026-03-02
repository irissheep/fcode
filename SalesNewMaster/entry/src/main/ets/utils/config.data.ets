import {loadingStatusType} from '../typeDeclare/responseType.d'

export const loadingStatusKeyMap:loadingStatusType = {
  loading:'加载中',
  loadMore: '加载更多',
  loadFailed :'加载失败，请重试',
  noMore:'没有更多了'
}

// 后端基础地址配置说明：
// - Android模拟器：使用 http://10.0.2.2:9999
// - 本地浏览器调试：使用 http://localhost:9999
// - 真机调试：使用电脑IP地址，例如 http://192.168.1.100:9999
// - 远程服务器：使用 http://42.193.243.96:9999
// 可在运行期通过 AppStorage.SetOrCreate('BASE_URL', 'http://your-host:9999') 覆盖默认值
// 注意：请根据您的实际开发环境选择正确的URL
export const DEFAULT_BASE_URL: string = 'http://localhost:9999'
