import { FindComponent } from "../components/FindComponent";
import { songs } from "../constant/MusicConstants";
import { SongItemType } from "../models/myMusicModel";

@Entry
@Component
export struct Find {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Text('猜你喜欢(歌曲列表)')

      List() {
        ListItem() {
          Column({space:10}){
            ForEach(songs,(item:SongItemType)=>{
              FindComponent({item})
            })
          }.alignItems(HorizontalAlign.Start)
        }
      }

    }
    .height('100%')
    .width('100%')
  }
}