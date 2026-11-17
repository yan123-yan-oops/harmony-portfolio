@Component
export  struct MineComponent{
  build() {
    Column(){
      Image($r('app.media.logo'))
        .width(22)

      Row(){
        Text('我的云音乐')
          .fontSize(22)
        Image($r('app.media.ic_vip'))
          .width(44)
      }
    }
    .width('100%')
    .padding({ left: 16, top: 16, bottom: 12 })

  }
}