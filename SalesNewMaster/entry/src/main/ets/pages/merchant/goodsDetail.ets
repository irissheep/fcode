import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { merchantAPI } from '../../api/merchantApi'
import {
  responseType,
  deviceListResType,
  deviceDetailResType,
  deviceListItemType,
  deviceDetailItemType
} from '../../typeDeclare/responseType.d'
import picker from '@ohos.file.picker';
import common from '@ohos.app.ability.common';
import axios, { AxiosError, AxiosProgressEvent, AxiosResponse, FormData } from '@ohos/axios'
import { copyFile,toBase64 } from '../../utils/index'
import image from '@ohos.multimedia.image'
import AlbumModel from '../../model/AlbumModel'
import { homeApi } from '../../api/HomeAPI';


interface pj {
  id?: string
  name?: string
  cell?: string
}

const context = getContext(this) as common.UIAbilityContext;

@Entry
@Component
struct goodsDetail {
  @State mode: string = 'add'
  @State curId: string = ''
  @State selectId: string = '' //选中的货架格子id
  @State shelfList: deviceListItemType[] = []
  @State shelfOption: string[] = []
  @State validateData: string[] = ['name', 'shelf', 'price', 'weight', 'thresholdValue','pictureUrl'] // 'pictureUrl'
  @State detailInfo: deviceDetailItemType = {
    name: '',
    shelf: '',
    price: 0,
    weight: '',
    thresholdValue: '',
    pictureUrl: ''
  }
  private albumModel: AlbumModel = new AlbumModel();

  @Styles
  sameStyle(){
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#ffffff')
    .borderRadius(12)
    .margin({ bottom: 12 })
  }

  async onPageShow() {
    interface pt {
      mode?: string
      id?: string
    }

    const param = router.getParams() as pt || {}
    this.mode = param.mode || ''
    if (this.mode == 'edit') {
      this.curId = param.id || ''
      this.getDetail()
    }
    const res: deviceListResType = await merchantAPI.shelfListLApi()
    this.shelfList = res.data
    this.shelfOption = (res.data.map(i => i.name) || []) as string[]
  }
  @Builder
  customNav() {
    Row() {
      Image($r('app.media.back')).width(20).margin({ right: 14 }).onClick(() => {
        // if (AppStorage.Get('userType') == '1') {
          router.replaceUrl({ url: 'pages/common/index', params: { tabIndex: '1' } })
        // } else {
        //   router.back()
        // }
      })
      Text(this.mode=='edit'?'商品详情':'新增').fontSize(19)
    }.position({x:0}).width('100%').padding({ left: 20, right: 20, top: 10, bottom: 10 }).height(50).backgroundColor('#f9fafc')
  }
  build() {
    Column() {
      Navigation() {
        Column() {
          Row() {
            Flex({ alignItems: ItemAlign.Center }) {
              Text('*').fontColor(Color.Red)
              Text('商品名称').width(100).fontSize(16).fontWeight(500)
              TextInput({ text: this.detailInfo.name, placeholder: '请输入商品名称' })
                .backgroundColor('#F5F7FA')
                .borderRadius(8)
                .height(40)
                .padding({ left: 12, right: 12 })
                .onChange((value) => {
                  this.detailInfo.name = value;
                })
            }
          }.sameStyle()

          Row() {
            Flex({ alignItems: ItemAlign.Center }) {
              Text('*').fontColor(Color.Red)
              Text('所在货架').width(100).fontSize(16).fontWeight(500)
              TextInput({ text: this.detailInfo.shelf || '', placeholder: '请选择货架' })
                .backgroundColor('#F5F7FA')
                .borderRadius(8)
                .height(40)
                .padding({ left: 12, right: 12 })
                .onClick(() => {
                  TextPickerDialog.show({
                    range: this.shelfOption,
                    onAccept: (shelf: TextPickerResult) => {
                      const index1 = shelf.index as number
                      const cellList = this.shelfList[index1]['childrenTreeVO'] as pj[]
                      const cellOption = cellList.map(i => i.cell)
                      TextPickerDialog.show({
                        range: (cellOption || []) as string[],
                        onAccept: (cell: TextPickerResult) => {
                          const index2 = cell.index as number
                          this.selectId = Object(cellList[index2])['id']
                          this.detailInfo.shelf = shelf.value + '-' + cell.value;
                        },
                      })
                    },
                  })
                })
              Image($r('app.media.youjiantou')).width(16).height(16)
            }
          }.sameStyle()

          Row() {
            Flex({ alignItems: ItemAlign.Center }) {
              Text('*').fontColor(Color.Red)
              Text('商品单价').width(70).fontSize(16).fontWeight(500)
              TextInput({ text: (Number(this.detailInfo.price || '')).toString(), placeholder: '请输入单价' })
                .backgroundColor('#F5F7FA')
                .borderRadius(8)
                .height(40)
                .padding({ left: 12, right: 12 })
                .type(InputType.Number)
                .onChange((value) => {
                  this.detailInfo.price = Number(value);
                }).width(100)
              Text('元').fontSize(16).fontColor('#666')
            }
          }.sameStyle()

          Row() {
            Flex({ alignItems: ItemAlign.Center }) {
              Text('*').fontColor(Color.Red)
              Text('商品重量').width(70).fontSize(16).fontWeight(500)
              TextInput({ text: this.detailInfo.weight, placeholder: '请输入重量' })
                .backgroundColor('#F5F7FA')
                .borderRadius(8)
                .height(40)
                .padding({ left: 12, right: 12 })
                .type(InputType.Number)
                .onChange((value) => {
                  this.detailInfo.weight = value;
                }).width(100)
              Text('g').fontSize(16).fontColor('#666')
            }
          }.sameStyle()

          Row() {
            Flex({ alignItems: ItemAlign.Center }) {
              Text('*').fontColor(Color.Red)
              Text('补货阈值').width(70).fontSize(16).fontWeight(500)
              TextInput({ text: (this.detailInfo.thresholdValue || '').toString(), placeholder: '请输入阈值' })
                .backgroundColor('#F5F7FA')
                .borderRadius(8)
                .height(40)
                .padding({ left: 12, right: 12 })
                .type(InputType.Number)
                .onChange((value) => {
                  this.detailInfo.thresholdValue = value;
                }).width(100)
              Text('件').fontSize(16).fontColor('#666')
            }
          }.sameStyle()

          Row() {
            Flex({ alignItems: ItemAlign.Center }) {
              Text('*').fontColor(Color.Red)
              Text('商品图片').width(100).fontSize(16).fontWeight(500)
              Row() {
                if (this.detailInfo.pictureUrl) {
                  Image(this.detailInfo.pictureUrl).width(80).height(80).borderRadius(8).objectFit(ImageFit.Cover).onClick(() => {
                    this.openAlbum()
                  })
                } else {
                  Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
                    Image($r('app.media.upload')).width(40).height(40)
                  }
                  .width(80)
                  .height(80)
                  .backgroundColor('#F5F7FA')
                  .borderRadius(8)
                  .border({ width: 2, color: '#E0E0E0', style: BorderStyle.Dashed })
                  .onClick(() => {
                    this.openAlbum()
                  })
                }

              }.height(100).width(100)
            }
          }.sameStyle().margin({ bottom: 24 }).height(100)


          Button('保存')
            .width('100%')
            .height(48)
            .fontSize(16)
            .fontWeight(600)
            .backgroundColor('#007DFF')
            .borderRadius(24)
            .onClick(() => {
              let pass = true
              this.validateData.forEach(i => {
                if (!this.detailInfo[i]) {
                  promptAction.showToast({ message: '请填写完整信息！', duration: 2000 })
                  pass = false
                  return
                }
              })

              if (pass) this.submit()

            })
        }.width('100%').padding(10)
      }

      .title({ builder: this.customNav, height: 50 })
      .hideBackButton(true)
      .mode(NavigationMode.Auto)
      .titleMode(NavigationTitleMode.Mini)
    }.width('100%').height('100%').backgroundColor('#f4f9fd')
  }



  openAlbum() {
    // 调起相机，选照片替换
    this.albumModel.setCallback((str: string) => {
      this.uploadImg(str)
    })
    this.albumModel.selectPicture()
  }

  async uploadImg(fileUri: string) {
    try{
      const base = toBase64(fileUri)
      if(base=='err') return
      homeApi.uploadApi({
        image: base,
        name: Date.now() + '.jpg',
        type: '1'
      }).then((res: any) => {
        const path = res.data.filePath
        this.detailInfo.pictureUrl = path
      })
    } catch (e){
      console.error(e)
    }

    // const fileName = copyFile(fileUri, context, 'goods')
    // let formData = new FormData();
    // formData.append('image', 'internal://cache/' + fileName);
    // formData.append('type', '1');
    // axios.post<string, AxiosResponse<string>, FormData>('http://42.193.243.96:9999/images/upload', formData, {
    //   headers: {
    //     'Content-Type': 'multipart/form-data',
    //     'token': AppStorage.Get('token')
    //   },
    //   context,
    //   onUploadProgress: (progressEvent: AxiosProgressEvent): void => {
    //     console.info(progressEvent && progressEvent.loaded && progressEvent.total ? Math.ceil(progressEvent.loaded / progressEvent.total * 100) + '%' : '0%');
    //   },
    // }).then((res: AxiosResponse) => {
    //   interface pathType { filePath: string }
    //
    //   interface dataType { data: pathType }
    //
    //   // const data: dataType = res.data as dataType
    //   // this.detailInfo.pictureUrl = data.data.filePath
    //   console.info("上传request result",JSON.stringify(res));
    //
    // }).catch((error: AxiosError) => {
    //   console.error("error:" + JSON.stringify(error));
    // })

  }

  // 获取详情
  getDetail() {
    interface pp {
      id: string
    }

    merchantAPI.goodsDetailApi({ id: this.curId } as pp).then((res: deviceDetailResType) => {
      this.detailInfo = res.data
      console.log('detailInfo', JSON.stringify(this.detailInfo))
      const shelf = res.data.shelf
      const deviceId = res.data.deviceId
      this.selectId = deviceId
      // 获取所在货架的子项数组
      setTimeout(() => {
        const childList = ((this.shelfList?.find(i => i?.name == shelf) || {})['childrenTreeVO'] || []) as pj[]
        const cell = ((childList?.find(i => i.id == deviceId) || {}).cell || '') as string
        this.detailInfo.shelf = shelf + '-' + cell
      }, 300)
    })
  }

  submit() {
    interface parType {
      id?: string
      name?: string
      deviceId?: string
      price?: number
      weight?: string
      thresholdValue?: string
      pictureUrl?: string
    }

    const params: parType = {
      id: this.curId.toString() || '',
      name: this.detailInfo.name,
      deviceId: this.selectId,
      price: this.detailInfo.price,
      weight: this.detailInfo.weight,
      thresholdValue: this.detailInfo.thresholdValue,
      pictureUrl: this.detailInfo.pictureUrl,
    }
    console.log('submit params', JSON.stringify(params))
    merchantAPI.submitGoodsApi(params).then((res: responseType) => {
      promptAction.showToast({ message: res.msg })
      if (res.success) {
        console.log('保存商品信息', JSON.stringify(res))
        router.replaceUrl({ url: 'pages/common/index', params: { tabIndex: '1' } })
      }
    })
  }
}