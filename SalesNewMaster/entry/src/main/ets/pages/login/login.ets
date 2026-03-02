import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { homeApi } from '../../api/HomeAPI';
import { loginResType } from '../../typeDeclare/responseType.d'
import { InputType, FontWeight, HorizontalAlign, FlexAlign, Visibility, Alignment } from '@ohos.ui'
import { backgroundLinearGradient, shadow, focusEffect } from '@ohos.ace'

PersistentStorage.PersistProp('token', ''); //存储登陆token
PersistentStorage.PersistProp('userType',''); //存储用户类别
PersistentStorage.PersistProp('account', ''); //存储用户名
PersistentStorage.PersistProp('pwd', ''); //存储密码
PersistentStorage.PersistProp('userId',''); //存储用户id
PersistentStorage.PersistProp('isConnect',false); //存储用户id
@Entry
@Component
struct Login {
  // 定义变量
  @State userType: string = '1'
  @State account: string = ''
  @State password: string = ''
  @State opacity: number = 0
  @State scale: number = 0.9

  onPageShow() {
    if (AppStorage.Get('token')) {
      router.replaceUrl({url:'pages/common/index'})
    }
    // 页面加载动画
    animateTo({
      duration: 800,
      curve: Curve.EaseOut
    }, () => {
      this.opacity = 1
      this.scale = 1
    })
  }

  build() {
    Column() {
      // 登录卡片
      Column()
        .opacity(this.opacity)
        .scale({ x: this.scale, y: this.scale }) {
       // logo图标
        Image($r("app.media.logo"))
          .width(100)
          .height(100)
          .borderRadius(50)
          .margin({ bottom: 30 })
        
        // 标题
        Text('欢迎登录')
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 30 })
          
        // 客户商户
        Row() {
          Text('客户')
            .fontSize(20)
            .fontWeight(this.userType == '1' ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.userType == '1' ? '#667eea' : '#666666')
            .borderWidth({ bottom: this.userType == '1' ? 3 : 0, })
            .borderColor('#667eea')
            .margin({ right: 50 })
            .onClick(() => {
              // 添加切换动画
              animateTo({
                duration: 300,
                curve: Curve.EaseInOut
              }, () => {
                this.opacity = 0.7
              }, () => {
                this.userType = '1'
                animateTo({
                  duration: 300,
                  curve: Curve.EaseInOut
                }, () => {
                  this.opacity = 1
                })
              })
            })
          Text('商户')
            .fontSize(20)
            .fontWeight(this.userType == '2' ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.userType == '2' ? '#667eea' : '#666666')
            .borderWidth({ bottom: this.userType == '2' ? 3 : 0, })
            .borderColor('#667eea')
            .onClick(() => {
              // 添加切换动画
              animateTo({
                duration: 300,
                curve: Curve.EaseInOut
              }, () => {
                this.opacity = 0.7
              }, () => {
                this.userType = '2'
                animateTo({
                  duration: 300,
                  curve: Curve.EaseInOut
                }, () => {
                  this.opacity = 1
                })
              })
            })
        }.align(Alignment.Center)

        // 登录账户
        Column() {
          Column() {
            Row() {
              TextInput({ placeholder: '请输入账户' })
                .maxLength(20)
                .inputTextStyle()
                .onChange((value) => { //绑定变量值
                  this.account = value;
                })
            }

            Row() {
              TextInput({ placeholder: '请输入密码' })
                .type(InputType.Password)
                .maxLength(20)
                .inputTextStyle()
                .onChange((value) => { //绑定变量值
                  this.password = value;
                })
                .onSubmit((enterKey) => {
                  this.login() //调用登陆逻辑
                })
            }

          }

          Button('登录')
            .width('100%')
            .height(50)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor('#ffffff')
            .backgroundLinearGradient({
              angle: 135,
              colors: ['#667eea', '#764ba2']
            })
            .margin({ top: 10 })
            .onClick(() => {
              // 按钮点击动画
              animateTo({
                duration: 200,
                curve: Curve.EaseInOut
              }, () => {
                this.scale = 0.95
              }, () => {
                animateTo({
                  duration: 200,
                  curve: Curve.EaseInOut
                }, () => {
                  this.scale = 1
                  this.login() //调用登陆逻辑
                })
              })
            })
        }.width('100%').margin({ top: 40 })

        Text('新用户注册')
          .fontColor('#667eea')
          .margin({ top: 25 })
          .fontSize(16)
          .visibility(this.userType == '1' ? Visibility.Visible : Visibility.None)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/login/register',
            })
          })
      .width('85%')
      .maxWidth(400)
      .padding(30)
      .backgroundColor('#ffffff')
      .borderRadius(20)
      .shadow({
        radius: 20,
        color: '#00000010',
        offsetX: 0,
        offsetY: 10
      })
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .backgroundLinearGradient({
      angle: 135,
      colors: ['#667eea', '#764ba2']
    })
  }

  // 方法定义
  login() {
    if (this.account.length == 0 || this.password.length == 0) {
      promptAction.showToast({ message: '用户名或者密码不可为空！', duration: 2000 })
      return
    }

    interface paramsType {
      account: string
      password: string
      category: string
    }

    let data: paramsType = {
      account: this.account,
      password: this.password,
      category: this.userType
    }

    // api发请求
    homeApi.doLoginApi(data).then((loginResult: loginResType) => {

      console.info('loginResult' + JSON.stringify(loginResult))
      //登陆成功
      if (loginResult.success) {
        AppStorage.SetOrCreate('userType', loginResult.data.category); //存储用户类别
        AppStorage.SetOrCreate('account', loginResult.data.account); //存储用户信息
        AppStorage.SetOrCreate('pwd',this.password);
        AppStorage.SetOrCreate('userId', loginResult.data.id); //存储用户id
        AppStorage.SetOrCreate('token', loginResult.data.token); //存储登陆token
        // console.log('登陆成功', AppStorage.Get('token'))
        //  跳转到主页
        router.replaceUrl({
          url: 'pages/common/index',
        })
      } else {
        promptAction.showToast({ message: loginResult.msg, duration: 2000 })
      }
    })
      .catch((err: Error) => {
        console.info('login error' + JSON.stringify(err))
        promptAction.showToast({ message: `系统错误，登陆失败(error:${err.message})`, duration: 2000 })
      })

  }
}

// @Extend仅支持定义在全局，不支持在组件内部定义。
@Extend(TextInput)
function inputTextStyle() {
  .backgroundColor(Color.White)
  .height(50)
  .margin({ bottom: 20 })
  .borderRadius(10)
  .borderWidth(1)
  .borderColor('#e0e0e0')
  .padding({ left: 15, right: 15 })
  .fontSize(16)
  .focusEffect({
    borderColor: '#667eea',
    borderWidth: 2,
    shadowColor: '#667eea30',
    shadowRadius: 10
  })
}
