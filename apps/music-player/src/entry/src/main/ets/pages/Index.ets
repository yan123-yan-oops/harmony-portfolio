import { tabsData } from '../constant/MusicConstants';
import { MusicPlayer } from '../utils/MusicPlayUtil';
import { Find } from './Find';
import { Mine } from './Mine';
import { Moment } from './Moment';
import { Recommend } from './Recommend';
import { SongList } from './SongList';
import { emitter } from '@kit.BasicServicesKit';
import { PlayStateEvent } from '../constant/EventConstants';
import { PlayStateType } from '../models/myMusicModel';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State isClick:'recommend'|'find'|'songlist'|'moment'|'mine' = 'recommend'
  @State curImg:string = ''
  @State curName:string = ''
  @State curAut:string = ''

  aboutToAppear(): void {
    emitter.on(PlayStateEvent, (eventData) => {
      let state = eventData.data as PlayStateType
      this.curImg = state.img
      this.curName = state.name
      this.curAut = state.author
    })
  }



  @Builder
  PlayingBar(){
    Row({space:8}){
      Image(this.curImg)
        .width(50).height(50).borderRadius(8)

      Column({space:2}){
        Text(this.curName)
          .fontSize(16)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)
        Text(this.curAut)
          .fontSize(12)
          .fontColor(Color.Black)
      }.alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Image($r('app.media.ic_song_list'))
        .width(24)

    }
    .width('100%')
    .height(60)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.White)
    .shadow({ radius: 6, color: 'rgba(0,0,0,0.1)', offsetY: -2 })
    .translate({ y: -60 })
    .onClick(()=>{
      router.pushUrl({ url: 'pages/Play' })
    })
  }

  // 自定义 tab 样式
  @Builder
  buildTabBar(name: string, img: ResourceStr) {
    Column() {
      Image(img).width(20)
      Text(name)
    }
  }

  build() {
    Stack() {

      Stack({ alignContent: Alignment.Bottom }) {

        Tabs({
          barPosition: BarPosition.End
        }) {

          TabContent() {
            Column() {
              Recommend()
              Text('推荐内容')
            }
          }
          .tabBar(this.isClick == 'recommend'?this.buildTabBar(tabsData[0].title,tabsData[0].icon):this.buildTabBar(tabsData[0].title,$r('app.media.ic_recommend_click')))

          TabContent() {
            Column() {
              Find()
            }
          }
          .tabBar(this.isClick == 'find'?this.buildTabBar(tabsData[1].title,tabsData[1].icon):this.buildTabBar(tabsData[1].title,$r('app.media.ic_find_click')))

          TabContent() {
            Column() {
              SongList()
            }
          }
          .tabBar(this.isClick == 'songlist'?this.buildTabBar(tabsData[2].title,tabsData[2].icon):this.buildTabBar(tabsData[2].title,$r('app.media.ic_logo_click')))

          TabContent() {
            Column() {
              Moment()
            }
          }
          .tabBar(this.isClick == 'moment'?this.buildTabBar(tabsData[3].title,tabsData[3].icon):this.buildTabBar(tabsData[3].title,$r('app.media.ic_moment_click')))

          TabContent() {
            Column() {
            Mine()
            }
          }
          .tabBar(this.isClick == 'mine'?this.buildTabBar(tabsData[4].title,tabsData[4].icon):this.buildTabBar(tabsData[4].title,$r('app.media.ic_mine_click')))
        }
        .onChange((index: number) => {
          const tabs = ['recommend', 'find', 'songlist', 'moment', 'mine']
          this.isClick = tabs[index] as 'recommend'|'find'|'songlist'|'moment'|'mine'
        })

        if (this.isClick !== 'mine' && this.curName !== '') {
          this.PlayingBar()
        }
      }

    }
    .height('100%')
    .width('100%')
  }
}