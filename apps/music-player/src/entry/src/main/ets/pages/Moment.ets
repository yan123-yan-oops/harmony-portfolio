import { MomentComponent } from '../components/MomentComponent';
import {  momentList } from '../constant/MusicConstants';
import { MomentListType } from '../models/myMusicModel';

@Entry
@Component
export struct Moment {
  @State message: string = 'Hello World';

  build() {
    Column() {


        List() {
          ListItem() {
            Column({space:10}){
              ForEach(momentList,(item:MomentListType)=>{
                MomentComponent({ item })

                Divider()
                  .width('90%')
                  .height(2)
                  .color($r('app.color.diy_some_gray'))

              })
            }.alignItems(HorizontalAlign.Center)
          }
        }.layoutWeight(1)




    }
    .height('100%')
    .width('100%')
  }
}

