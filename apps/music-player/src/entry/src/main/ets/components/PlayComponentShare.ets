@Component
export struct PlayComponentShare {
  close: (() => void) = () => {}
  shareName: string = ''
  shareAuthor: string = ''

  build() {
    Column() {
      Column()
        .width('100%')
        .height('50%')
        .backgroundColor('rgba(0,0,0,0.5)')
        .onClick(() => { this.close() })

      Column() {
        Row() {
          Text('分享')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .padding({ top: 16, bottom: 16 })

        Divider()
          .width('100%')
          .height(1)
          .color($r('app.color.diy_some_gray'))

        Text(this.shareName + ' - ' + this.shareAuthor)
          .fontSize(16)
          .fontColor($r('app.color.diy_little_gray'))
          .padding({ top: 16, bottom: 16 })

        Row({ space: 24 }) {
          Column({ space: 8 }) {
            Image($r('app.media.rectangle_and_arrowshape_turn_up_right'))
              .width(48)
              .height(48)

            Text('分享给好友')
              .fontSize(12)
          }

          Column({ space: 8 }) {
            Image($r('app.media.ic_moment'))
              .width(48)
              .height(48)

            Text('分享到动态')
              .fontSize(12)
          }

          Column({ space: 8 }) {
            Image($r('app.media.ic_code'))
              .width(48)
              .height(48)

            Text('生成二维码')
              .fontSize(12)
          }

          Column({ space: 8 }) {
            Image($r('app.media.ic_download_o'))
              .width(48)
              .height(48)

            Text('保存到本地')
              .fontSize(12)
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceEvenly)
        .padding({ top: 8, bottom: 16 })

        Divider()
          .width('100%')
          .height(1)
          .color($r('app.color.diy_some_gray'))

        Text('取消')
          .fontSize(16)
          .fontColor($r('app.color.diy_little_red'))
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding({ top: 14, bottom: 14 })
          .onClick(() => { this.close() })
      }
      .borderRadius({ topLeft: 16, topRight: 16 })
      .width('100%')
      .layoutWeight(1)
      .backgroundColor(Color.White)
    }
    .height('100%')
    .width('100%')
  }
}
