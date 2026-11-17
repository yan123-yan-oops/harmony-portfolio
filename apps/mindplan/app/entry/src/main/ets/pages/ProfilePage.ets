@Component
export default struct ProfilePage {
  build() {
    Column() {
      Column() {
        Text('👤 我的')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 32 })
      }
      .alignItems(HorizontalAlign.Center)
      .width('100%')

      Column() {
        Column() {
          Text('🔑')
            .fontSize(48)
          Text('未登录')
            .fontSize(16)
            .fontColor('#888888')
            .margin({ top: 12 })
          Text('使用华为账号一键登录，同步你的日程数据')
            .fontSize(13)
            .fontColor('#AAAAAA')
            .margin({ top: 8 })
            .textAlign(TextAlign.Center)
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .layoutWeight(1)

        Column() {
          Divider()
            .margin({ bottom: 12 })
          Text('v1.0.0 · AI Organise Calendar')
            .fontSize(12)
            .fontColor('#CCCCCC')
            .textAlign(TextAlign.Center)
            .width('100%')
        }
        .padding({ left: 24, right: 24, bottom: 32 })
      }
      .padding({ left: 24, right: 24 })
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
