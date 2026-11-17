import { dailyRecommend, recommendList, swiperList } from "../constant/MusicConstants";
import { RecommendDailyType, RecommendListType } from "../models/myMusicModel";
import { RecommendComponent } from "../components/RecommendComponent";

@Entry
@Component
export struct Recommend {
  @Builder
  DaliyRT(item: RecommendDailyType) {
    RecommendComponent.DaliyRT(item)
  }

  @Builder
  DaliyRL(item: RecommendListType) {
    RecommendComponent.DaliyRL(item)
  }

  build() {
    Column({ space: 0 }) {

      Row(){
        Image($r('app.media.ic_search'))
          .width(18)

        TextInput({placeholder:'请输入歌曲名称'})
      }.width('100%')

      Swiper() {
        ForEach(swiperList, (item: string) => {
          Image(item+'')
            .width('92%')
            .borderRadius(12)
        })
      }
      .loop(true)
      .autoPlay(true)
      .indicator(true)
      .height(180)
      .padding({ top: 12 })

      Row() {
        Text('每日推荐')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)

        Text('更多')
          .fontSize(14)
          .fontColor('#999999')
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 20, bottom: 12 })

      List() {
        ListItem() {
          Row({ space: 12 }) {
            ForEach(dailyRecommend, (item: RecommendDailyType) => {
              this.DaliyRT(item)
            })
          }
          .padding({ left: 16, right: 16 })
        }
      }
      .listDirection(Axis.Horizontal)
      .width('100%')
      .height(190)

      Row() {
        Text('推荐歌单')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)

        Text('更多')
          .fontSize(14)
          .fontColor('#999999')
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 20, bottom: 12 })

      List() {
        ListItem() {
          Row({ space: 16 }) {
            ForEach(recommendList, (item: RecommendListType) => {
              this.DaliyRL(item)
            })
          }
          .padding({ left: 16, right: 16 })
        }
      }
      .listDirection(Axis.Horizontal)
      .width('100%')
      .height(170)
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F5F5F5')
  }
}