@Component
export default struct TimelinePage {
  build() {
    Column() {
      Column() {
        Text('📋 今日时间轴')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 32 })
      }
      .alignItems(HorizontalAlign.Center)
      .width('100%')

      Column() {
        Column() {
          Text('✨')
            .fontSize(48)
          Text('暂无排程')
            .fontSize(16)
            .fontColor('#888888')
            .margin({ top: 12 })
          Text('在首页输入任务，AI 将自动生成今日行程安排')
            .fontSize(13)
            .fontColor('#AAAAAA')
            .margin({ top: 8 })
            .textAlign(TextAlign.Center)
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .layoutWeight(1)
      }
      .padding({ left: 24, right: 24 })
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
