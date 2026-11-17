@Component
export default struct PomodoroPage {
  build() {
    Column() {
      Column() {
        Text('⏱️ 专注')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 32 })
      }
      .alignItems(HorizontalAlign.Center)
      .width('100%')

      Column() {
        Column() {
          Text('🍅')
            .fontSize(48)
          Text('暂无进行中的专注')
            .fontSize(16)
            .fontColor('#888888')
            .margin({ top: 12 })
          Text('在时间轴点击任务即可开始番茄钟')
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
