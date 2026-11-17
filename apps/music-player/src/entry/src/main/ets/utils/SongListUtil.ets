import { currentList } from "../constant/MusicConstants";
import { SongItemType } from "../models/myMusicModel";
import { MusicPlayer } from "./MusicPlayUtil";

export class SongListUtil {
  static addListUnshift(song: SongItemType) {
    //尾插法
    // currentList.push(song)
    //头插
    const idx: number = currentList.findIndex((songs) => song.name === songs.name)
    if(idx == MusicPlayer.playIndex){
      return
    }
    currentList.unshift(song)


  }

  static addListPush(song: SongItemType) {
    //尾插法
    const idx: number = currentList.findIndex((songs) => song.name === songs.name)
    if(idx == MusicPlayer.playIndex){
      return
    }
    currentList.push(song)

  }

  static removeList(clickSong: SongItemType) {
    const idx: number = currentList.findIndex((song) => clickSong.name === song.name)
    if (idx !== -1&&idx != MusicPlayer.playIndex) {
      currentList.splice(idx, 1)
    }
  }
}

