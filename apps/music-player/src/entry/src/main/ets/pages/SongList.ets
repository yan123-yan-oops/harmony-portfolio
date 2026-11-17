import { SongListComponent } from "../components/SongListComponent";
import { songs } from "../constant/MusicConstants";
import { SongItemType } from "../models/myMusicModel";

@Entry
@Component
export struct SongList {
  @State message: string = '动态内容';
  @State operatePic:Resource[] = [$r('app.media.heart'),$r('app.media.arrow_down_circle'),$r('app.media.ellipsis_message'),$r('app.media.rectangle_and_arrowshape_turn_up_right')]
  @State operate:string[] = ['收藏','下载','评论','分享']
  @State Operate:Operate = { operatePic: this.operatePic, operate: this.operate }
  @State isPlaying:boolean = false

  build() {
    Column() {
      Column({space:10}){
        Row(){
          Image($r('app.media.arrow_left'))
            .width(18)
          Text('歌单')
        }.width('100%')
        .justifyContent(FlexAlign.Start)

        Row(){
          Image($r('app.media.img'))
            .width(160)

          Column(){
            Text('独立民谣')
              .fontSize(18)
            Text('歌单选取了一些比较受关注的歌曲')
              .fontSize(12)
              .fontWeight(FontWeight.Lighter)
          }.alignItems(HorizontalAlign.Start)

        }.width('100%')

        //歌单页面功能按钮行
        Row({space:5}){
          ForEach(this.Operate.operatePic, (pic: Resource, index: number) => {
            Column(){
              Image(pic)
                .width(24)
                .height(24)
              Text(this.Operate.operate[index])
                .fontSize(12)
            }
            .alignItems(HorizontalAlign.Center)
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

      }.height('40%')
      .justifyContent(FlexAlign.SpaceEvenly)
      .backgroundColor('#E6EEF7')

      //歌单功能按钮行
      Row({space:8}){
        Row(){
          Image($r('app.media.play_fill'))
            .width(24)
          Text('播放全部('+songs.length+')')
        }

        Row(){
          Image($r('app.media.sort'))
            .width(24)

          Image($r('app.media.list_square'))
            .width(24)

        }
      }.width('100%')
      .margin({bottom:20,top:5})
      .justifyContent(FlexAlign.SpaceBetween)

      List() {
        ListItem() {
          Column({space:10}){
            ForEach(songs,(item:SongItemType)=>{
              SongListComponent({item})
            })
          }.alignItems(HorizontalAlign.Start)
        }
      }.layoutWeight(1)
      .borderRadius({topLeft:12,topRight:12})

    }
    .height('100%')
    .width('100%')
  }

}

interface Operate{
  operatePic :Resource[]
  operate :string[]
}
