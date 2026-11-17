import { router } from '@kit.ArkUI';
import { PlayStateType, SongItemType } from '../models/myMusicModel';
import { MusicPlayer } from '../utils/MusicPlayUtil';
import emitter from '@ohos.events.emitter';
import { PlayStateEvent } from '../constant/EventConstants';
import { PlayComponentSongList } from '../components/PlayComponentSongList';
import { PlayComponentShare } from '../components/PlayComponentShare';
import animator, { AnimatorOptions, AnimatorResult } from '@ohos.animator';


@Entry
@Component
struct Play {
  @State playMods: string = ''
  @State isPlaying: boolean = false
  @State song: SongItemType = {
    id: '',
    url: '',
    name: '',
    author: '',
    img: ''
  }
  //黑胶角度
  @State vinylAngleVal: number = 0;
  //唱针角度
  @State stylusAngleVal: number = 65;
  @State currentSec: number = 0
  @State totalSec: number = 0
  @State showSongList: boolean = false
  @State showShare: boolean = false

  private vinylAnimator: AnimatorResult | null = null

  aboutToAppear(): void {

    this.isPlaying = MusicPlayer.isPlaying

    let options: AnimatorOptions = {
      duration: 14000,// 一圈时长
      easing: "linear", // 匀速
      delay: 0,
      fill: "forwards",
      direction: "normal",
      iterations: -1, // 无限循环
      begin: 0,      // 起始角度
      end: 360      // 结束角度
    }
    this.vinylAnimator = animator.create(options)
    this.vinylAnimator.onframe = (value: number) => {
      this.vinylAngleVal = value
    }

    emitter.on(PlayStateEvent, (eventData) => {
      let state = eventData.data as PlayStateType
      this.playMods = state.playMode
      this.isPlaying = state.isPlaying
      this.song.name = state.name
      this.song.author = state.author
      this.song.url = state.url
      this.currentSec = state.time
      this.totalSec = state.duration

      if (state.isPlaying) {
        this.vinylAnimator?.play()
      } else {
        this.vinylAnimator?.pause()
      }
    })
  }

  aboutToDisappear(): void {//释放资源
    emitter.off(PlayStateEvent.eventId);
    this.vinylAnimator?.cancel();
  }

  onPageShow(): void {
    if (this.isPlaying) {
      this.vinylAnimator?.play()
    }

    this.getUIContext().animateTo({ delay: 2000, curve: Curve.EaseIn }, () => {
      this.stylusAngleVal = 36
    })
  }

  build() {
    Stack() {
      Column() {

        //顶行
        Row() {
          Image($r('app.media.chevron_down'))
            .width(28)
            .onClick(() => {
              router.back()
            })

          Row() {
            Text('私人漫游 . 熟悉模式')
              .fontColor(Color.White)

            Image($r('app.media.chevron_down'))
              .width(12)
          }

          Image($r('app.media.ic_share'))
            .width(24)
            .onClick(() => {
              this.showShare = true
            })
        }.width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Stack({ alignContent: Alignment.Center }) {
          //黑胶唱片
          Image($r('app.media.ic_cd'))
            .width(340)
            .offset({ y: 55 })
            .rotate({
              angle: this.vinylAngleVal
            , centerX: '50%'
            , centerY: '50%'
            })

          //唱针
          Image($r('app.media.ic_stylus'))
            .width(125)
            .align(Alignment.TopStart)
            .offset({ y: -110 })
            .rotate({
              angle: this.stylusAngleVal
            , centerX: '50%'
            , centerY: 0
            })
        }.margin({ top: 12 })
        .width('100%')
        .height(400)


        //歌曲信息行
        Row({ space: 8 }) {
          Column({ space: 8 }) {

            Text(this.song.name)
              .fontSize(22)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)

            Text(this.song.author)
              .fontColor(Color.White)
              .fontSize(16)

          }.width(180)
          .alignItems(HorizontalAlign.Start)

          Badge({
            //角标
            value: '999+',
            position: BadgePosition.RightTop,
            style: {
              badgeSize: 12
            }
          })

          Image($r('app.media.heart'))
            .width(26)

          Image($r('app.media.ic_comment_o'))
            .width(26)

        }.width('98%')
        .margin({ top: 68 })
        .alignItems(VerticalAlign.Top)
        .justifyContent(FlexAlign.SpaceBetween)

        //音乐播放条
        Slider({
          value: this.currentSec,
          min: 0,
          max: this.totalSec,
          step: 1000,
          direction: Axis.Horizontal
        }).onChange((value) => {
          MusicPlayer.seekMusic(value)
          this.currentSec = value
        }).margin({ top: 12 })

        Row() { //转换为合适的时间显示
          Text('0' + Math.floor(this.currentSec / 1000 / 60) + ':' + Math.floor(this.currentSec / 1000 % 60))
            .fontColor($r('app.color.diy_little_gray'))
          //padStart(总共几位，‘不足用什么补齐’)

          Text('无敌音质')
            .fontColor($r('app.color.diy_little_gray'))

          Text('0' + Math.floor(this.totalSec / 1000 / 60) + ':' + Math.floor(this.totalSec / 1000 % 60))
            .fontColor($r('app.color.diy_little_gray'))
        }.width('96%')
        .justifyContent(FlexAlign.SpaceBetween)


        //控制歌曲变量行
        Row() {
          if (this.playMods == 'auto') {
            Image($r('app.media.repeat'))
              .width(42)
              .onClick(() => {
                MusicPlayer.changePlayModeImg('repeat')
                console.log('yan', '播放模式改变为：' + MusicPlayer.playMode);
              })
          }

          if (this.playMods == 'repeat') {
            Image($r('app.media.ic_repeat'))
              .width(42)
              .onClick(() => {
                MusicPlayer.changePlayModeImg('random')
                console.log('yan', '播放模式改变为：' + MusicPlayer.playMode);
              })
          }

          if (this.playMods == 'random') {
            Image($r('app.media.shuffle'))
              .width(42)
              .onClick(() => {
                MusicPlayer.changePlayModeImg('auto')
                console.log('yan', '播放模式改变为：' + MusicPlayer.playMode);
              })
          }


          Image($r('app.media.backward_end_fill'))//上一首
            .width(42)
            .onClick(() => {
              MusicPlayer.prevMusic()
            })

          Image(this.isPlaying ? $r('app.media.ic_paused') : $r('app.media.play_fill'))
            .width(42)
            .onClick(() => {
              if (this.isPlaying) {
                MusicPlayer.pauseMusic()
              } else {
                MusicPlayer.resumeMusic()
              }
            })

          Image($r('app.media.forward_end_fill'))//下一首
            .width(42)
            .onClick(() => {
              MusicPlayer.nextMusic()
            })


          Image($r('app.media.ic_song_list'))//当前播放歌单
            .width(42)
            .onClick(() => {
              this.showSongList = true
            })


        }.width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ right: 8, left: 8, top: 22 })

      }
      .height('100%')
      .width('100%')
      .linearGradient({
        direction: GradientDirection.Top,
        repeating: true,
        colors: [['#A83E18', 0.0],
          ['#E89A3E', 1.0]]
      })

      if (this.showSongList) {
        PlayComponentSongList({
          close: () => {
            this.showSongList = false
          }
        })
      }

      if (this.showShare) {
        PlayComponentShare({
          close: () => {
            this.showShare = false
          },
          shareName: this.song.name,
          shareAuthor: this.song.author
        })
      }
    }
  }
  //
  // startVinylAnimation() {
  //   this.getUIContext().animateTo({ duration: 14000, curve: Curve.Linear, iterations: -1 }, () => {
  //     this.vinylAngleVal = -360
  //   })
  // }
  //
  // stopVinylAnimation() {
  //   this.getUIContext().animateTo({ duration: 0 }, () => {
  //     this.vinylAngleVal = this.vinylAngleVal // 保持当前角度不变
  //   })
  // }
}

