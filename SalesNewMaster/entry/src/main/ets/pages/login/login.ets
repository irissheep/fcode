import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { homeApi } from '../../api/HomeAPI';
import { loginResType } from '../../typeDeclare/responseType.d'
// import { InputType } from '@ohos.input'
// import { Color, Alignment, Visibility, animateTo, Curve } from '@ohos/arkui'

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
  @State isLoading: boolean = false
  @State logoScale: number = 1

  onPageShow() {
    if (AppStorage.Get('token')) {
      router.replaceUrl({url:'pages/common/index'})
    }
    // 启动logo动画
    this.animateLogo()
  }

  // animateLogo() {
  //   animateTo({
  //     duration: 1000,
  //     curve: Curve.EaseInOut,
  //     iterations: 1
  //   }, () => {
  //     this.logoScale = 1.1
  //   }, () => {
  //     animateTo({
  //       duration: 800,
  //       curve: Curve.EaseInOut
  //     }, () => {
  //       this.logoScale = 1
  //     })
  //   })
  // }
  animateLogo() {
    animateTo({
      duration: 1000,
      curve: Curve.EaseInOut,
      iterations: 1
    }, () => {
      this.logoScale = 1.1;

      // 在第一个动画完成后，启动第二个动画
      animateTo({
        duration: 80000,
        curve: Curve.EaseInOut
      }, () => {
        this.logoScale = 1;
      });
    });
  }

  build() {
    Column() {
      // 内容容器
      Column() {
        // logo图标
        Image($r("app.media.logo"))
          .width(100)
          .height(100)
          .borderRadius(50)
          .margin({ bottom: 30 })
          .scale({ x: this.logoScale, y: this.logoScale })
          .shadow({
            radius: 10,
            color: 'rgba(0, 0, 0, 0.2)',
            offsetX: 0,
            offsetY: 5
          })

        // 标题
        Text('欢迎登录')
          .fontSize(32)
          .fontWeight(700)
          .fontColor(Color.White)
          .margin({ bottom: 40 })

        // 客户商户切换
        Row() {
          Text('客户')
            .fontSize(20)
            .fontWeight(500)
            .fontColor(this.userType == '1' ? Color.White : 'rgba(255, 255, 255, 0.7)')
            .padding({ bottom: 8 })
            .borderWidth({ bottom: this.userType == '1' ? 3 : 0 })
            .borderColor(Color.White)
            .margin({ right: 60 })
            .onClick(() => {
              this.userType = '1'
            })
          Text('商户')
            .fontSize(20)
            .fontWeight(500)
            .fontColor(this.userType == '2' ? Color.White : 'rgba(255, 255, 255, 0.7)')
            .padding({ bottom: 8 })
            .borderWidth({ bottom: this.userType == '2' ? 3 : 0 })
            .borderColor(Color.White)
            .onClick(() => {
              this.userType = '2'
            })
        }
        .margin({ bottom: 40 })
        .align(Alignment.Center)

        // 登录表单
        Column() {
          // 账户输入框
          // Row() {
          //   TextInput({ placeholder: '请输入账户', placeholderColor: 'rgba(255, 255, 255, 0.7)' })
          //     .maxLength(20)
          //     .inputTextStyle()
          //     .onChange((value) => {
          //       this.account = value;
          //     })
          // }
          Row() {
            TextInput({ placeholder: '请输入账号' })
              .placeholderColor('rgba(255, 255, 255, 0.7)')
              .maxLength(20)
              .inputTextStyle()
              .onChange((value) => {
                this.account = value;
              })
          }

          // 密码输入框
          // Row() {
          //   TextInput({ placeholder: '请输入密码', placeholderColor: 'rgba(255, 255, 255, 0.7)' })
          //     .type(InputType.Password)
          //     .maxLength(20)
          //     .inputTextStyle()
          //     .onChange((value) => {
          //       this.password = value;
          //     })
          //     .onSubmit((enterKey) => {
          //       this.login()
          //     })
          // }
          Row() {
            TextInput({ placeholder: '请输入密码' })
              .placeholderColor('rgba(255, 255, 255, 0.7)')
              .type(InputType.Password)
              .maxLength(20)
              .inputTextStyle()
              .onChange((value) => {
                this.password = value;
              })
          }

          // 登录按钮
          Button(this.isLoading ? '登录中...' : '登录')
            .width('100%')
            .height(52)
            .fontSize(18)
            .fontWeight(600)
            .backgroundColor(Color.White)
            .fontColor('#4CAF50')
            .borderRadius(26)
            .margin({ top: 20 })
            .shadow({
              radius: 8,
              color: 'rgba(0, 0, 0, 0.15)',
              offsetX: 0,
              offsetY: 4
            })
            .onClick(() => {
              this.login()
            })
        }
        .width('80%')

        // 注册链接
        Text('新用户注册')
          .fontColor(Color.White)
          .fontSize(16)
          .margin({ top: 30 })
          .visibility(this.userType == '1' ? Visibility.Visible : Visibility.None)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/login/register',
            })
          })
      }
      .padding({ top: 80 })
      .width('100%')
      .height('100%')
      // .alignItems(Alignment.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#4CAF50')
  }

  // 方法定义
  login() {
    if (this.account.length == 0 || this.password.length == 0) {
      promptAction.showToast({ message: '用户名或者密码不可为空！', duration: 2000 })
      return
    }

    this.isLoading = true

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
      this.isLoading = false
      console.info('loginResult' + JSON.stringify(loginResult))
      //登陆成功
      if (loginResult.success) {
        AppStorage.SetOrCreate('userType', loginResult.data.category); //存储用户类别
        AppStorage.SetOrCreate('account', loginResult.data.account); //存储用户信息
        AppStorage.SetOrCreate('pwd',this.password);
        AppStorage.SetOrCreate('userId', loginResult.data.id); //存储用户id
        AppStorage.SetOrCreate('token', loginResult.data.token); //存储登陆token
        //  跳转到主页
        router.replaceUrl({
          url: 'pages/common/index',
        })
      } else {
        promptAction.showToast({ message: loginResult.msg, duration: 2000 })
      }
    })
      .catch((err: Error) => {
        this.isLoading = false
        console.info('login error' + JSON.stringify(err))
        promptAction.showToast({ message: `系统错误，登陆失败(error:${err.message})`, duration: 2000 })
      })
  }
}

// @Extend仅支持定义在全局，不支持在组件内部定义。
@Extend(TextInput)
function inputTextStyle() {
  .backgroundColor('rgba(255, 255, 255, 0.2)')
  .height(52)
  .margin({ bottom: 20 })
  .borderRadius(26)
  .fontSize(16)
  .fontColor(Color.White)
  .padding({ left: 20, right: 20 })
  .border({ width: 1, color: 'rgba(255, 255, 255, 0.3)' })
}
