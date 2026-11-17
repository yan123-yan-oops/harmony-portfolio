import { RecommendDailyType, RecommendListType } from "../models/myMusicModel";

@Component
export struct RecommendComponent {
  @Builder
  static DaliyRT(item: RecommendDailyType) {
    Column() {
      Text(item.type)
        .backgroundColor(item.top)
        .width(110)
        .height(30)
        .textAlign(TextAlign.Center)

      Image(item.img)
        .width(110)
        .height(110)

      Text(item.title)
        .backgroundColor(item.bottom)
        .fontSize(12)
        .width(110)
        .height(30)
        .textAlign(TextAlign.Center)
    }
    .width(110)
    .borderRadius(12)
    .clip(new Rect({ width: 110, height: 170, radius: 12 }))
  }

  @Builder
  static DaliyRL(item: RecommendListType) {
    Column() {
      Stack() {
        Image(item.img)
          .width(120)
          .height(120)
          .borderRadius(12)

        Row() {
          Image($r('app.media.ic_recommend'))
            .width(10)
            .height(10)
            .fillColor(Color.White)
          Text(item.count)
            .fontSize(10)
            .fontColor(Color.White)
        }
        .alignItems(VerticalAlign.Center)
        .position({ bottom: 6, right: 8 })
      }
      .width(120)
      .height(120)
      .clip(new Rect({ width: 120, height: 120, radius: 12 }))
      .shadow({ radius: 6, color: '#22000000', offsetY: 3 })

      Text(item.title)
        .fontSize(12)
        .fontColor('#333333')
        .margin({ top: 6 })
        .lineHeight(16)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width(120)
    }
    .width(132)
    .alignItems(HorizontalAlign.Start)
  }

  build() {
  }
}