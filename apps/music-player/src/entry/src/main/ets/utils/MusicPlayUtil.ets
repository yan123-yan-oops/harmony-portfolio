import { media } from '@kit.MediaKit';
import { emitter } from '@kit.BasicServicesKit';
import { PlayStateEvent } from '../constant/EventConstants';
import { SongItemType } from '../models/myMusicModel';
import { currentList } from '../constant/MusicConstants';

export class MusicPlayer {
  private static instance: media.AVPlayer = null!;
  //不给外部调用最底层的AVPlayer，只能通过方法来使用
  private static isListenRegistered: boolean = false;

  static currentSong: SongItemType = { id: '', url: '', name: '', author: '', img: '' };
  static isPlaying: boolean = false;
  static duration: number = 0;//歌曲总时长
  static time: number = 0;//歌曲现在时长
  static playIndex: number = 0;
  static playMode: 'auto' | 'repeat' | 'random' = 'auto';//播放模式
  static playList: SongItemType[] = [];

  static async getPlayer(): Promise<media.AVPlayer> {
    if (!MusicPlayer.instance) {
      MusicPlayer.instance = await media.createAVPlayer();
    }//没有实例就创建，有的话就复用现有的
    return MusicPlayer.instance;
  }

  static async registerStateListen() {
    if (MusicPlayer.isListenRegistered) return;//有注册监听就用现有的，没有就创建
    MusicPlayer.isListenRegistered = true;

    MusicPlayer.instance.on('stateChange', async (state) => {
      console.log('yan','Player state:', state);

      if (state === 'initialized') {
        await MusicPlayer.instance.prepare();
      }

      if (state === 'prepared') {
        MusicPlayer.duration = MusicPlayer.instance.duration;
        await MusicPlayer.instance.play();
      }

      if (state === 'playing') {
        MusicPlayer.isPlaying = true;
        MusicPlayer.emitState();
      }

      if (state === 'paused' || state === 'stopped') {
        MusicPlayer.isPlaying = false;
        MusicPlayer.emitState();
      }
    });

    MusicPlayer.instance.on('timeUpdate', () => {//写注册外面，不然会重复
      MusicPlayer.time = MusicPlayer.instance.currentTime;
      MusicPlayer.emitState();
    });
  }


  static async changePlayModeImg(mode:'auto' | 'repeat' | 'random'){
    MusicPlayer.playMode = mode
    MusicPlayer.emitState()
  }

  static async playMusic(song: SongItemType) {
    let player = await MusicPlayer.getPlayer();
    await MusicPlayer.registerStateListen();

    if (player.state === 'playing' || player.state === 'prepared' || player.state === 'paused'){
      await player.reset();
    }

    MusicPlayer.currentSong = song;
    MusicPlayer.playIndex = currentList.findIndex((s) => s.name === song.name)
    MusicPlayer.playList = currentList
    player.url = song.url;
  }

  //下一曲功能
  static nextMusic() {
    if (currentList.length === 0) return;
    let nextIndex = MusicPlayer.playIndex + 1;

    if(MusicPlayer.playMode == 'auto'||MusicPlayer.playMode == 'repeat'){

      if (nextIndex >= currentList.length) {
        nextIndex = 0;
      }
      MusicPlayer.playMusic(currentList[nextIndex]);

    }else {
      if (currentList.length === 1) {
        MusicPlayer.playMusic(currentList[0]);
        return;
      }//先执行判断是否只有一首歌，防止while死循环
      let randomIdx:number
      do {
        randomIdx = Math.floor(Math.random() * currentList.length);
      }while (randomIdx == MusicPlayer.playIndex)

      MusicPlayer.playMusic(currentList[randomIdx]);
    }

  }

  //上一曲功能
  static prevMusic() {

    if (currentList.length === 0) return;//列表没有歌曲
    let prevIndex = MusicPlayer.playIndex - 1;

    if(MusicPlayer.playMode == 'auto'||MusicPlayer.playMode == 'repeat') {//循环模式和单曲循环
      if (prevIndex < 0) {
        prevIndex = currentList.length - 1;
      }
      MusicPlayer.playMusic(currentList[prevIndex]);
    }else {
      if (currentList.length === 1) {
        MusicPlayer.playMusic(currentList[0]);
        return;
      }
      let randomIdx:number
      do {
        randomIdx = Math.floor(Math.random() * currentList.length);
      }while (randomIdx == MusicPlayer.playIndex)

      MusicPlayer.playMusic(currentList[randomIdx]);
    }

  }

  static resumeMusic() {//重新播放**当前**歌曲
    if (MusicPlayer.instance && MusicPlayer.instance.state === 'paused') {
      MusicPlayer.instance.play();
    }
  }

  static pauseMusic() {
    if (MusicPlayer.instance) {
      MusicPlayer.instance.pause();
    }
  }

  static seekMusic(timeMs: number) {
    if (MusicPlayer.instance) {
      MusicPlayer.instance.seek(timeMs);
    }
  }

  static emitState() {
    emitter.emit(PlayStateEvent, {
      data: {
        isPlaying: MusicPlayer.isPlaying,
        duration: MusicPlayer.duration,
        playMode: MusicPlayer.playMode,
        time: MusicPlayer.time,
        playIndex: MusicPlayer.playIndex,
        url: MusicPlayer.currentSong.url,
        author: MusicPlayer.currentSong.author,
        name: MusicPlayer.currentSong.name,
        img: MusicPlayer.currentSong.img,
        playList: MusicPlayer.playList
      }
    });
  }
}
