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
}

protocol MovieCommentOutPut {
  var comments: PublishSubject<[MovieComment]> {get set} //파싱해서 가져갈 코멘트 데이터
  var onCompleted: PublishSubject<Bool> {get set}
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
  var onCompleted: PublishSubject<Bool> = PublishSubject<Bool>()
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let ref: DatabaseReference = Database.database().reference()
  init() { bindViewModel() }
}

extension MovieCommentVM {
  func bindViewModel() {
    movieSeq.filter{$0 != ""}
      .subscribe(onNext:{ [weak self] (id) in
        self?.commentList(seq: id)
      }).disposed(by: disposeBag)
  }
  
  func commentList(seq: String) {
    var list: [MovieComment] = []
    
    DispatchQueue.global().async {
      self.ref.child("Comments").child("\(seq)").observeSingleEvent(of: .value) {[weak self] (snapshot) in
        guard !(snapshot.value is NSNull) else { return }
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
    ref.child("Comments").child("\(movieSeq.value)").childByAutoId().setValue(["name": data.name, "created_at": data.createdAt, "image": data.image, "comment": data.comment, "rating": data.rating, "comment_key": data.commentKey]) { (error, _) in
      guard error == nil else {
        self.onCompleted.onNext(false)
        return
      }
      self.onCompleted.onNext(true)
    }
  }
}
