import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { goodsItemType } from '../../typeDeclare/responseType.d'

interface paramsType {
  goods: string
}

@Entry
@Component
struct goodsDetail {
  @State goodsInfo: goodsItemType = {} as goodsItemType

  aboutToAppear() {
    const params = router.getParams() as paramsType
    if (params?.goods) {
      this.goodsInfo = JSON.parse(params.goods)
    }
  }

  @Builder customNav() {
    Row() {
      Image($r('app.media.back')).width(20).margin({ right: 14 }).onClick(() => {
        router.back()
      })
      Text('商品详情').fontSize(20).fontWeight(600)
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 12, bottom: 12 })
    .backgroundColor('#f9fafc')
  }

  build() {
    Column() {
      Navigation() {
        Column() {
          Scroll() {
            Column() {
              Stack({ alignContent: Alignment.BottomEnd }) {
                Image(this.goodsInfo.pictureUrl)
                  .width('100%')
                  .height(300)
                  .objectFit(ImageFit.Cover)
                if (this.goodsInfo.number <= 5) {
                  Text('库存紧张')
                    .backgroundColor('#FF6B00')
                    .borderRadius(8)
                    .fontColor('#fff')
                    .padding({ top: 4, bottom: 4, left: 8, right: 8 })
                    .fontSize(12)
                    .margin(12)
                }
              }

              Column() {
                Row() {
                  Text('￥')
                    .fontSize(16)
                    .fontColor('#FA2A2D')
                  Text(this.goodsInfo.price)
                    .fontSize(28)
                    .fontWeight(700)
                    .fontColor('#FA2A2D')
                }
                .margin({ bottom: 12 })

                Text(this.goodsInfo.name)
                  .fontSize(18)
                  .fontWeight(600)
                  .fontColor('#333333')
                  .margin({ bottom: 16 })

                Row() {
                  Text('货架位置')
                    .fontSize(14)
                    .fontColor('#666666')
                  Text(this.goodsInfo.shelf || '-')
                    .fontSize(14)
                    .fontColor('#333333')
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)
                .margin({ bottom: 12 })

                Row() {
                  Text('库存数量')
                    .fontSize(14)
                    .fontColor('#666666')
                  Text(this.goodsInfo.number.toString())
                    .fontSize(14)
                    .fontColor(this.goodsInfo.number > 0 ? '#52C41A' : '#FA2A2D')
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)
                .margin({ bottom: 12 })

                if (this.goodsInfo.cell) {
                  Row() {
                    Text('货格编号')
                      .fontSize(14)
                      .fontColor('#666666')
                    Text(this.goodsInfo.cell)
                      .fontSize(14)
                      .fontColor('#333333')
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.SpaceBetween)
                  .margin({ bottom: 12 })
                }
              }
              .width('100%')
              .padding(16)
              .backgroundColor(Color.White)
              .borderRadius({ topLeft: 16, topRight: 16 })
              .margin({ top: -16 })
            }
          }
          .layoutWeight(1)

          Column() {
            Button(this.goodsInfo.number > 0 ? '立即购买' : '暂时缺货')
              .width('92%')
              .height(48)
              .fontSize(16)
              .fontWeight(600)
              .fontColor('#fff')
              .backgroundColor(this.goodsInfo.number > 0 ? '#2484f4' : '#CCCCCC')
              .borderRadius(24)
              .enabled(this.goodsInfo.number > 0)
              .onClick(() => {
                this.buyNow()
              })
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .shadow({
            color: '#1A000000',
            radius: 8,
            offsetX: 0,
            offsetY: -2
          })
        }
        .width('100%')
        .height('100%')
      }
      .mode(NavigationMode.Stack)
      .title({ builder: this.customNav, height: 50 })
      .hideBackButton(true)
      .width('100%')
      .height('100%')
      .backgroundColor('#f4f9fd')
    }
  }

  buyNow() {
    promptAction.showToast({
      message: '请前往设备进行人脸识别购买',
      duration: 2000
    })
  }
}
