import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { homeApi } from '../../api/HomeAPI';
import { registerResType, loginResType } from '../../typeDeclare/responseType.d'

@Entry
@Component
struct Register {
  @State account: string = ''
  @State password: string = ''
  @State confirmPwd: string = ''
  @State logoScale: number = 1

  onPageShow() {
    if (AppStorage.Get('token')) {
      router.replaceUrl({ url: 'pages/common/index' })
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
      // 渐变背景
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
        .width(250)
        .height(250)
        .borderRadius(125)
        .backgroundColor('rgba(255, 255, 255, 0.1)')
        .position({ x: -80, y: -30 })

      Column()
        .width(180)
        .height(180)
        .borderRadius(90)
        .backgroundColor('rgba(255, 255, 255, 0.08)')
        .position({ x: 260, y: 450 })

      // 主内容
      Column() {
        // 返回按钮
        Row() {
          Image($r('app.media.back'))
            .width(24)
            .height(24)
            .fillColor(Color.White)
            .onClick(() => router.back())

          Text('用户注册')
            .fontSize(20)
            .fontWeight(600)
            .fontColor(Color.White)
            .margin({ left: 12 })
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 20 })
        .margin({ bottom: 20 })

        // Logo
        Image($r("app.media.logo"))
          .width(90)
          .height(90)
          .borderRadius(45)
          .margin({ bottom: 40 })
          .scale({ x: this.logoScale, y: this.logoScale })
          .shadow({
            radius: 15,
            color: 'rgba(0, 0, 0, 0.3)',
            offsetX: 0,
            offsetY: 8
          })

        // 注册表单
        Column({ space: 16 }) {
          TextInput({ placeholder: '请输入账户' })
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

          TextInput({ placeholder: '请输入确认密码' })
            .placeholderColor('rgba(255, 255, 255, 0.6)')
            .type(InputType.Password)
            .width('100%')
            .height(50)
            .backgroundColor('rgba(255, 255, 255, 0.15)')
            .borderRadius(25)
            .padding({ left: 20, right: 20 })
            .fontColor(Color.White)
            .onChange((value) => this.confirmPwd = value)

          // 注册按钮
          Button('注 册')
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
            .onClick(() => this.register())
        }
        .width('80%')

        // 返回登录
        Text('已有账号？返回登录')
          .fontColor('rgba(255, 255, 255, 0.8)')
          .fontSize(14)
          .margin({ top: 40 })
          .decoration({ type: TextDecorationType.Underline, color: 'rgba(255, 255, 255, 0.8)' })
          .onClick(() => router.back())
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
  }

  register() {
    if (!this.account || !this.password || !this.confirmPwd) {
      promptAction.showToast({ message: '请完整填写表单', duration: 2000 })
      return
    }
    if (this.password !== this.confirmPwd) {
      promptAction.showToast({ message: '两次密码输入不一致', duration: 2000 })
      return
    }

    const data = {
      account: this.account,
      password: this.password,
      confirmPwd: this.confirmPwd,
      category: '1'
    }

    homeApi.registerApi(data).then((res: registerResType) => {
      if (res.success) {
        promptAction.showToast({ message: '注册成功', duration: 2000 })
        // 自动登录
        homeApi.doLoginApi(data).then((loginRes: loginResType) => {
          if (loginRes.success) {
            AppStorage.SetOrCreate('token', loginRes.data.token)
            AppStorage.SetOrCreate('account', loginRes.data.account)
            AppStorage.SetOrCreate('userType', loginRes.data.category)
            AppStorage.SetOrCreate('userId', loginRes.data.id)
            AppStorage.SetOrCreate('pwd', this.password)
            router.replaceUrl({ url: 'pages/common/index' })
          }
        })
      } else {
        promptAction.showToast({ message: res.msg, duration: 3000 })
      }
    }).catch(() => {
      promptAction.showToast({ message: '网络错误，请重试', duration: 2000 })
    })
  }
}
