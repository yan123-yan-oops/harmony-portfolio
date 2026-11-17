import { SongItemType } from "../models/myMusicModel"
import { MusicPlayer } from "../utils/MusicPlayUtil"
import { router } from "@kit.ArkUI"
import { SongListUtil } from "../utils/SongListUtil";

@Component
export struct FindComponent {
  item: SongItemType = {
    id: '',
    url: '',
    name: '',
    author: '',
    img: ''
  }; // 接收SongList页面的歌曲数据

  build() {
    Row({ space: 8 }) { // 歌曲封面
      Image(this.item.img)
        .width(60)
        .height(60)
        .borderRadius(12)


      // 歌曲信息
      Column() {
        Text(this.item.name)
          .fontSize(18)
          .layoutWeight(1)

          Text(this.item.author)
            .fontSize(12)

      }.height(60)
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)


      Image($r('app.media.dot_grid_1x2'))
        .width(28)
        .margin({ right: 6 })
        .bindMenu([{
          value:'收藏',
          action:()=>{}//写添加到收藏歌单的方法
        },{
          value:'添加到歌单',
          action:()=>{
            SongListUtil.addListPush(this.item)//尾插
            console.log('yan','添加  '+this.item.name+'  成功')
          }
        }
          ])

    }.justifyContent(FlexAlign.Start)
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .width('100%')
    .height(60)
    .borderRadius(12)
    .onClick(async () => {
      SongListUtil.addListUnshift(this.item)
      await MusicPlayer.playMusic(this.item)
      router.pushUrl({url:'pages/Play'})
      console.log('yan', '播放歌曲：' + this.item.name)
    })
  }
}

