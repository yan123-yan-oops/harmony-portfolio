import { MomentListType } from "../models/myMusicModel"
import { router } from "@kit.ArkUI"

@Component
export struct MomentComponent {
  item: MomentListType = {
    author: '',//用户名
    avatar: '',//头像
    content: '',
    comment: 0,
    like: 0,
    song:{
      id:'',
      url:'',
      name:'',
      author:'',
      img:''
    }
  }; // 接收SongList页面的歌曲数据

  build() {
    Row({ space: 8 }) {
      Image(this.item.avatar)
        .width(60)
        .height(60)
        .borderRadius(12)

      //评论信息
      Column({space:16}) {
        Text(this.item.author)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)

        Text(this.item.content)
          .fontSize(12)

        //音乐行
        Row({space:8}){
          Image(this.item.song.img)
            .width(42)
            .borderRadius(12)
          Column(){
            Text(this.item.song.name)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
            Text(this.item.song.author)
              .fontSize(10)
          }
        }.width('92%')
        .borderRadius(12)
        .backgroundColor($r('app.color.diy_little_gray'))

        //操作行
        Row(){
          Row(){
            Image($r('app.media.ic_share'))
              .width(22)
            Text('分享')
          }

          Row(){
            Image($r('app.media.ic_comment_o'))
              .width(22)
            Text(this.item.comment+'')
          }

          Row(){
            Image($r('app.media.heart'))
              .width(22)
            Text(this.item.like+'')
          }
        }.width('90%')
        .margin({right:10})
        .justifyContent(FlexAlign.SpaceBetween)



      }.height(60)
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

    }.width('100%')
    .height(180)
    .alignItems(VerticalAlign.Top)//头像图片顶上面
  }
}

