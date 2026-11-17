
//歌曲信息【id, name, url, author, img】

/**
 * 歌曲信息
 */
export interface SongItemType{

  id:string
  url: string
  name: string
  author: string
  img: string
}


// 每日推荐歌曲

export interface RecommendDailyType{

  img: string
  title:string
  type:string
  top:string
  bottom:string

}

//推荐列表
export interface RecommendListType{

  img: string
  title: string
  count: string
}


//评论列表
export interface MomentListType{

  author: string
  avatar: string
  content: string
  comment:number
  like :number
  song:SongItemType

}


export interface FavoriteListType{
  name: string
  nickName: string
  avatar: ResourceStr
  songs: SongItemType[]
}


export interface PlayStateType{
  isPlaying:boolean
  duration:number
  playMode:'auto'|'repeat'|'random'
  time:number
  playIndex:number
  url:string
  author:string
  name:string
  img:string
  playList:SongItemType[]
}

export  class FavoriteListTypeModel implements  FavoriteListType{
  name: string
  nickName: string
  avatar: ResourceStr
  songs: SongItemType[]

  constructor(name: string, nickName: string, avatar: ResourceStr, songs: SongItemType[]) {
    this.name = name
    this.nickName = nickName
    this.avatar = avatar
    this.songs = songs
  }



}


//搜藏列表
export  class SongItemTypeModel implements  SongItemType{

  id: string
  url: string
  name: string
  author: string
  img: string

  constructor(id: string, url: string, name: string, author: string, img: string) {
    this.id = id
    this.url = url
    this.name = name
    this.author = author
    this.img = img
  }


}


export  class RecommentListTypeModel implements  RecommendListType{
  img: string
  title: string
  count: string

  constructor(img: string, title: string, count: string) {
    this.img = img
    this.title = title
    this.count = count
  }

}


export  class RecommendDailyTypeModel implements  RecommendDailyType{
  img: string
  title: string
  type: string
  top: string
  bottom: string

  constructor(img: string, title: string, type: string, top: string, bottom: string) {
    this.img = img
    this.title = title
    this.type = type
    this.top = top
    this.bottom = bottom
  }



}

export class  MomentListTypeModel implements   MomentListType{
  author: string
  avatar: string
  content: string
  comment: number
  like: number
  song: SongItemType

  constructor(author: string, avatar: string, content: string, comment: number, like: number, song: SongItemType) {
    this.author = author
    this.avatar = avatar
    this.content = content
    this.comment = comment
    this.like = like
    this.song = song
  }
}

export class PlayStateMode implements PlayStateType{
  isPlaying: boolean
  duration: number
  playMode: "auto" | "repeat" | "random"
  time: number
  playIndex: number
  url: string
  author: string
  name: string
  img: string
  playList: SongItemType[]

  constructor(isPlaying: boolean, duration: number, playMode: "auto" | "repeat" | "random", time: number,
    playIndex: number, url: string, author: string, name: string, img: string, playList: SongItemType[]) {
    this.isPlaying = isPlaying
    this.duration = duration
    this.playMode = playMode
    this.time = time
    this.playIndex = playIndex
    this.url = url
    this.author = author
    this.name = name
    this.img = img
    this.playList = playList
  }

}
