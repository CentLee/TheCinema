//
//  MovieCommentVM.swift
//  TheCinema
//
//  Created by ChLee on 28/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import Foundation
import ObjectMapper

protocol MovieCommentInput { //레이팅이랑 코멘트 받을 것.
  var movieSeq: BehaviorRelay<String> {get set} //이게 들어오면 영화 파싱해서 아웃풋.
  func registerComment(data: MovieComment)
  func commentList(seq: String, recent: Bool)
  func favorite(info: MovieGenreData)
  func myFavorite(seq: String)
}

protocol MovieCommentOutPut {
  var comments: PublishSubject<[MovieComment]> {get set} //파싱해서 가져갈 코멘트 데이터
  var onCompleted: PublishSubject<Bool> {get set}
  var favoriteMovie: PublishSubject<Bool> {get set}
  var favoriteEnabled: PublishSubject<Bool> {get set}
}

protocol MovieCommentVMType {
  var inputs: MovieCommentInput {get}
  var outputs: MovieCommentOutPut {get}
}

class MovieCommentVM: MovieCommentVMType, MovieCommentInput, MovieCommentOutPut {
  var inputs: MovieCommentInput {return self}
  var outputs: MovieCommentOutPut {return self}
  
  var movieSeq: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
  var comments: PublishSubject<[MovieComment]> = PublishSubject<[MovieComment]>()
  var favoriteMovie: PublishSubject<Bool> = PublishSubject<Bool>()
  var favoriteEnabled: PublishSubject<Bool> = PublishSubject<Bool>()
  
  var onCompleted: PublishSubject<Bool> = PublishSubject<Bool>()
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let ref: DatabaseReference = Database.database().reference()
  init() { }
}

extension MovieCommentVM {
  func commentList(seq: String, recent: Bool = false) {
    var list: [MovieComment] = []
    let path = recent ? ref.child("Comments").child("\(seq)").queryLimited(toFirst: 10) : ref.child("Comments").child("\(seq)")
    DispatchQueue.global().async {
      path.observeSingleEvent(of: .value) {[weak self] (snapshot) in
        guard !(snapshot.value is NSNull) else {
          self?.comments.onNext([])
          return
        }
        guard let item = snapshot.value as? [String: Any] else { return }
        for(key, value) in item {
          guard let set = value as? [String : Any] , let data = Mapper<MovieComment>().map(JSON: set) else { return }
          data.commentKey = key
          list.append(data)
        }
        //for Finish
        self?.comments.onNext(list)
      }
      self.ref.removeAllObservers()
    }
  }
  
  func registerComment(data: MovieComment) { //코멘트 등록.다 되면 스트림 넘긴다.
    ref.child("Comments").child("\(movieSeq.value)").childByAutoId().setValue(["name": data.name, "created_at": data.createdAt, "image": data.image, "comment": data.comment, "rating": data.rating, "comment_key": data.commentKey, "user_id": data.uid]) { (error, _) in
      guard error == nil else {
        self.onCompleted.onNext(false)
        return
      }
      self.onCompleted.onNext(true)
    }
  }
  
  func favorite(info: MovieGenreData) { //내 아이디 에서 페이보릿에서 있으면 삭제하고 폴스 없으면 등록하고 트루
    ref.child("User").child(MainManager.SI.userInfo.userId).child("FavoriteMovie")
      .observeSingleEvent(of: .value) { (snapshot) in
        guard !(snapshot.value is NSNull) else {
          self.ref.child("User").child(MainManager.SI.userInfo.userId).child("FavoriteMovie").childByAutoId().setValue(["id": info.movieSeq, "posters": info.poster, "title": info.title, "date": info.repRlsDate]) { (_, _) in
            self.favoriteMovie.onNext(true)
          }
          return
        }
        //값이 하나라도 일단 존재해
        guard let list = snapshot.value as? [String : AnyObject] else { return }
        for(key , value) in list {
          guard let item = value as? [String : AnyObject] else { return }
          guard let id = item["id"] as? String, id != info.movieSeq else { //같은게 있다 그럼 지우라
            self.ref.child("User").child(MainManager.SI.userInfo.userId).child("FavoriteMovie").child(key).removeValue() //해당 키 밸류 삭제
            self.favoriteMovie.onNext(false)
            return
          }
        }
        //다 돌았지만 값이 없어서 등록을 해야한다.
        self.ref.child("User").child(MainManager.SI.userInfo.userId).child("FavoriteMovie").setValue(["id": info.movieSeq, "posters": info.poster, "title": info.title, "date": info.repRlsDate]) { (_, _) in
          self.favoriteMovie.onNext(true)
        }
    }
  }
  
  func myFavorite(seq: String) {
    ref.child("User").child(MainManager.SI.userInfo.userId).child("FavoriteMovie").observeSingleEvent(of: .value) { (snapshot) in
      guard !(snapshot.value is NSNull) else {
        self.favoriteEnabled.onNext(false)
        return
      }
      guard let list = snapshot.value as? [String : AnyObject] else { return }
      for(_, value) in list {
        guard let item = value as? [String : AnyObject] else { return }
        guard let id = item["id"] as? String, id != seq else { //같은게 있다 그럼 즐겨찾기 된거니까 가져오자
          self.favoriteMovie.onNext(true)
          return
        }
      }
    }
  }
}
