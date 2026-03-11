import router from '@ohos.router'
import { customerAPI } from '../../../api/customerApi'
import { PageParamsType, goodsItemType, goodsResType } from '../../../typeDeclare/responseType.d'
import promptAction from '@ohos.promptAction'
import { loadStatusCom } from '../../common/components/loadStatusCom'


@Component
export struct home {
  @State refresh: boolean = false
  @State goodsList: goodsItemType[] = []
  @State loadStatus: string = 'loadMore'
  @State pageParams: PageParamsType = {
    size: 10,
    current: 1,
    total: 0
  };
  scroller: Scroller = new Scroller()

  @Builder
  customNav() {
    Row() {
      Text('首页').fontSize(20).fontWeight(600)
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 12, bottom: 12 })
    .backgroundColor('#E0E0E0')
  }

  aboutToAppear() {
    this.pageParams.current = 1
    this.goodsList = []
    this.getGoodsList()
  }

  @Styles cardStyle() {
    .backgroundColor(Color.White)
    .borderRadius(12)
    .shadow({
      color: '#1A000000',
      radius: 8,
      offsetX: 0,
      offsetY: 2
    })
  }

  goToDetail(item: goodsItemType) {
    router.pushUrl({
      url: 'pages/customer/goodsDetail',
      params: { goods: JSON.stringify(item) }
    })
  }

  build() {
    Navigation() {
      Column() {
        List({ space: 16, initialIndex: 0 }) {
          ForEach(this.goodsList, (item: goodsItemType, index) => {
            ListItem() {
              Column() {
                Stack({ alignContent: Alignment.TopStart }) {
                  Image(item.pictureUrl).width('100%').height(140).borderRadius({ topLeft: 12, topRight: 12 }).objectFit(ImageFit.Cover)
                  if (item.shelf) {
                    Text(item.shelf)
                      .backgroundColor('#FA2A2D')
                      .borderRadius(8)
                      .fontColor('#fff')
                      .padding({ top: 4, bottom: 4, left: 8, right: 8 })
                      .fontSize(11)
                      .margin(8)
                  }
                  if (item.number <= 5) {
                    Text('库存紧张')
                      .backgroundColor('#FF6B00')
                      .borderRadius(8)
                      .fontColor('#fff')
                      .padding({ top: 4, bottom: 4, left: 8, right: 8 })
                      .fontSize(10)
                      .position({ x: 8, y: 8 })
                  }
                }
                .width('100%')
                .height(140)

                Column() {
                  Text(item.name)
                    .textAlign(TextAlign.Start)
                    .width('100%')
                    .fontSize(14)
                    .fontWeight(500)
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .margin({ bottom: 8 })
                  Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                    Row() {
                      Text('￥').fontSize(12).fontColor('#FA2A2D')
                      Text(item.price).fontSize(18).fontColor('#FA2A2D').fontWeight(700)
                    }
                    Row() {
                      Image($r('app.media.ic_radio')).width(12).margin({ right: 4 })
                      Text('库存:' + item.number).fontSize(12).fontColor('#999999')
                    }
                  }
                  .width('100%')
                }
                .padding(12)
              }
              .cardStyle()
              .width('90%')
              .height(220)
            }
            .margin({ left: '5%' })
            .onClick(() => this.goToDetail(item))
          }, (item: goodsItemType, index: number) => index.toString())

          ListItem() {
            if ((this.goodsList.length) % 2 == 0) {
              Column() {
              }
              .width('90%')
              .height(220)
            }
          }

          ListItem() {
            loadStatusCom({ loadStatus: this.loadStatus, refresh: $refresh })
          }
          .width('100%')
          .layoutWeight(2)
          .align(Alignment.Center)
        }
        .width("100%")
        .height('100%')
        .lanes(2)
        .alignListItem(ListItemAlign.Center)
        .onReachEnd(() => {
          if (this.loadStatus != 'loadMore') return
          this.pageParams.current++
          this.getGoodsList()
        })
      }.height('100%')
    }
    .mode(NavigationMode.Auto)
    .title({ builder: this.customNav, height: 50 })
    .titleMode(NavigationTitleMode.Mini)
    .hideBackButton(true)
    .width('100%')
    .height('100%')
    .backgroundColor("#E0E0E0")
  }

  getGoodsList() {
    this.loadStatus = 'loading'
    const params: PageParamsType = {
      size: this.pageParams.size,
      current: this.pageParams.current
    }

    customerAPI.productPageApi(params).then((res: goodsResType) => {
      if (res.success) {
        // this.goodsList =[]
        this.goodsList = this.goodsList.concat(res.data.records)
        if (res.data.total <= this.goodsList.length) {
          this.loadStatus = 'noMore'
        } else {
          this.loadStatus = 'loadMore'
        }
      } else {
        this.loadStatus = 'loadFailed'
        promptAction.showToast({
          duration: 3000,
          message: res.msg
        })
      }
      this.refresh = false
    })
  }
}