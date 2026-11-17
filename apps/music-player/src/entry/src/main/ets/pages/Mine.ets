import { MineComponent } from "../components/MineComponent";
import { momentList } from "../constant/MusicConstants";
import { MomentListType } from "../models/myMusicModel";

@Entry
@Component
export struct Mine {
  @State message: string = 'Hello World';

  build() {
    Column() {

      Grid(){
        ForEach(momentList,(item:MomentListType)=>{
          GridItem(){
            Image(item.song.img)
              .width(82)
              .height(82)
              .borderRadius(8)
          }
        })

      }.width('100%')
      .height('50%')
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .columnsGap(8)
      .rowsGap(8)
      .padding(8)

      MineComponent()
    }
    .height('100%')
    .width('100%')
  }
}