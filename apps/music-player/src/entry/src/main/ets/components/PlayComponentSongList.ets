import { currentList } from "../constant/MusicConstants"
import { SongItemType } from "../models/myMusicModel"
import { SongListUtil } from "../utils/SongListUtil"

@Component
export struct PlayComponentSongList{
  @State playlist: SongItemType[] = [...currentList]
  close: (() => void) = (() => {})

  build() {
    Column() {

      Column(){
      }.width('100%')
      .height('40%')
      .backgroundColor('rgba(0,0,0,0.5)')
      .onClick(() => { this.close() })

      Column(){
        Row(){
          Text('当前播放列表')
          Text('('+this.playlist.length+')')
        }.width('100%')

        Divider()
          .width('100%')
          .height(1)
          .color($r('app.color.diy_some_gray'))

        List() {
          ListItem() {
            Column({space:10}){
              ForEach(this.playlist,(item:SongItemType)=>{
                Row({space:8}){
                  Row(){

                    Column({space:4}){
                      Text(item.name)
                        .fontSize(18)
                        .fontWeight(FontWeight.Bold)

                      Text(item.author)
                        .fontColor($r('app.color.diy_little_gray'))
                        .fontSize(14)
                    }.alignItems(HorizontalAlign.Start)
                  }.layoutWeight(1)

                  Image($r('app.media.xmark'))
                    .width(16)
                    .onClick(()=>{
                      SongListUtil.removeList(item)
                      this.playlist = [...currentList]
                    })

                }.width('100%')
              })
            }.alignItems(HorizontalAlign.Start)
          }
        }
        .layoutWeight(1)

      }.borderRadius({topLeft:12,topRight:12})
      .width('100%')
      .layoutWeight(1)
      .backgroundColor(Color.White)
    }
    .height('100%')
    .width('100%')
  }
}