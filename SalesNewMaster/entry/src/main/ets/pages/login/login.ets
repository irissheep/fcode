import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { homeApi } from '../../api/HomeAPI';
import { loginResType } from '../../typeDeclare/responseType.d'

PersistentStorage.PersistProp('token', '');
PersistentStorage.PersistProp('userType','');
PersistentStorage.PersistProp('account', '');
PersistentStorage.PersistProp('pwd', '');
PersistentStorage.PersistProp('userId','');
PersistentStorage.PersistProp('isConnect',false);

@Entry
@Component
struct Login {
  @State userType: string = '1'
  @State account: string = ''
  @State password: string = ''
  @State isLoading: boolean = false
  @State logoScale: number = 1

  onPageShow() {
    if (AppStorage.Get('token')) {
      router.replaceUrl({url:'pages/common/index'})
    }
    this.animateLogo()
  }

  animateLogo() {
    animateTo({
      duration: 1000,
      curve: Curve.EaseInOut,
      iterations: 1
    }, () => {
      this.logoScale = 1.1;
    });
    setTimeout(() => {
      animateTo({
        duration: 800,
        curve: Curve.EaseInOut
      }, () => {
        this.logoScale = 1;
      });
    }, 1000);
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 渐变背景 - 使用多层Column模拟渐变
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#667eea')

      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#764ba2')
        .opacity(0.8)

      // 装饰圆形
      Column()
        .width(300)
        .height(300)
        .borderRadius(150)
        .backgroundColor('rgba(255, 255, 255, 0.1)')
        .position({ x: -100, y: -50 })

      Column()
        .width(200)
        .height(200)
        .borderRadius(100)
        .backgroundColor('rgba(255, 255, 255, 0.08)')
        .position({ x: 250, y: 500 })

      // 主内容
      Column() {
        // Logo
        Image($r("app.media.logo"))
          .width(100)
          .height(100)
          .borderRadius(50)
          .margin({ top: 80, bottom: 30 })
          .scale({ x: this.logoScale, y: this.logoScale })
          .shadow({
            radius: 20,
            color: 'rgba(0, 0, 0, 0.3)',
            offsetX: 0,
            offsetY: 10
          })

        // 标题
        Text('欢迎登录')
          .fontSize(32)
          .fontWeight(700)
          .fontColor(Color.White)
          .margin({ bottom: 10 })

        Text('智能零售管理系统')
          .fontSize(14)
          .fontColor('rgba(255, 255, 255, 0.7)')
          .margin({ bottom: 40 })

        // 用户类型切换
        Row() {
          Column() {
            Text('客户')
              .fontSize(18)
              .fontWeight(this.userType == '1' ? 600 : 400)
              .fontColor(this.userType == '1' ? Color.White : 'rgba(255, 255, 255, 0.6)')
              .padding({ bottom: 8 })
            if (this.userType == '1') {
              Column()
                .width(24)
                .height(3)
                .backgroundColor(Color.White)
                .borderRadius(2)
            }
          }
          .onClick(() => this.userType = '1')

          Column() {
            Text('商户')
              .fontSize(18)
              .fontWeight(this.userType == '2' ? 600 : 400)
              .fontColor(this.userType == '2' ? Color.White : 'rgba(255, 255, 255, 0.6)')
              .padding({ bottom: 8 })
            if (this.userType == '2') {
              Column()
                .width(24)
                .height(3)
                .backgroundColor(Color.White)
                .borderRadius(2)
            }
          }
          .margin({ left: 60 })
          .onClick(() => this.userType = '2')
        }
        .margin({ bottom: 40 })

        // 登录表单
        Column({ space: 16 }) {
          TextInput({ placeholder: '请输入账号' })
            .placeholderColor('rgba(255, 255, 255, 0.6)')
            .width('100%')
            .height(50)
            .backgroundColor('rgba(255, 255, 255, 0.15)')
            .borderRadius(25)
            .padding({ left: 20, right: 20 })
            .fontColor(Color.White)
            .onChange((value) => this.account = value)

          TextInput({ placeholder: '请输入密码' })
            .placeholderColor('rgba(255, 255, 255, 0.6)')
            .type(InputType.Password)
            .width('100%')
            .height(50)
            .backgroundColor('rgba(255, 255, 255, 0.15)')
            .borderRadius(25)
            .padding({ left: 20, right: 20 })
            .fontColor(Color.White)
            .onChange((value) => this.password = value)

          // 登录按钮
          Button(this.isLoading ? '登录中...' : '登 录')
            .width('100%')
            .height(50)
            .fontSize(18)
            .fontWeight(600)
            .fontColor('#667eea')
            .backgroundColor(Color.White)
            .borderRadius(25)
            .margin({ top: 24 })
            .shadow({
              radius: 12,
              color: 'rgba(0, 0, 0, 0.2)',
              offsetX: 0,
              offsetY: 6
            })
            .onClick(() => this.login())
        }
        .width('80%')

        // 注册链接
        Text('还没有账号？立即注册')
          .fontColor('rgba(255, 255, 255, 0.8)')
          .fontSize(14)
          .margin({ top: 40 })
          .decoration({ type: TextDecorationType.Underline, color: 'rgba(255, 255, 255, 0.8)' })
          .visibility(this.userType == '1' ? Visibility.Visible : Visibility.Hidden)
          .onClick(() => router.pushUrl({ url: 'pages/login/register' }))
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
  }

  login() {
    if (!this.account || !this.password) {
      promptAction.showToast({ message: '请输入账号和密码', duration: 2000 })
      return
    }
    this.isLoading = true
    homeApi.doLoginApi({
      account: this.account,
      password: this.password,
      category: this.userType
    }).then((res: loginResType) => {
      this.isLoading = false
      if (res.success) {
        AppStorage.SetOrCreate('token', res.data.token)
        AppStorage.SetOrCreate('account', res.data.account)
        AppStorage.SetOrCreate('userType', res.data.category)
        AppStorage.SetOrCreate('userId', res.data.id)
        AppStorage.SetOrCreate('pwd', this.password)
        router.replaceUrl({ url: 'pages/common/index' })
      } else {
        promptAction.showToast({ message: res.msg, duration: 3000 })
      }
    }).catch(() => {
      this.isLoading = false
      promptAction.showToast({ message: '网络错误，请重试', duration: 2000 })
    })
  }
}
