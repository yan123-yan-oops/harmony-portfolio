import InputPage from './InputPage'
import TimelinePage from './TimelinePage'
import PomodoroPage from './PomodoroPage'
import ProfilePage from './ProfilePage'

@Entry
@Component
struct Index {
  @State currentTabIndex: number = 0

  build() {
    Column() {
      Tabs({
        barPosition: BarPosition.End,
        index: this.currentTabIndex
      }) {
        TabContent() {
          InputPage()
        }
        .tabBar('🏠 首页')

        TabContent() {
          TimelinePage()
        }
        .tabBar('📋 时间轴')

        TabContent() {
          PomodoroPage()
        }
        .tabBar('⏱️ 专注')

        TabContent() {
          ProfilePage()
        }
        .tabBar('👤 我的')
      }
      .backgroundColor('#FFFFFF')
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}
