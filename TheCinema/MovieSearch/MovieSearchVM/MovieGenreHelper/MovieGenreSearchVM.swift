//
//  MovieGenreSearchVM.swift
//  TheCinema
//
//  Created by SatGatLee on 22/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import Foundation

enum MovieGenreType: String {
  case fantasy = "판타지"
  case fear = "공포"
  case animation = "애니메이션"
  case action = "액션"
  case comedy = "코미디"
  case romance = "로맨스"
  case musical = "뮤지컬"
  case sf = "SF"
  
  static var arrays: [MovieGenreType] {
    return [.fear, .romance, .musical, .animation, .action, .comedy, .fantasy, .sf]
  }
  
  var image: UIImage {
    return UIImage(named: "\(self)")!
  }
}
protocol MovieGenreSearchInput { //장르별 검색 kmdb 사용.
//  var genre: PublishRelay<(String, Int)> {get set}
  func genreMovieParsing(start: String, genre: String)
}

protocol MovieGenreSearchOutput {
  var genreList: PublishSubject<MovieGenreResult> {get set}
}

protocol MovieGenreSearchType {
  var inputs: MovieGenreSearchInput {get}
  var outputs: MovieGenreSearchOutput {get}
}
class MovieGenreSearchVM: MovieGenreSearchType, MovieGenreSearchOutput, MovieGenreSearchInput {
  
  var genreList: PublishSubject<MovieGenreResult> = PublishSubject<MovieGenreResult>()
  
  //장르별 검색 및 단일 검색할 것들.
  //인풋으로 장르 및 단일 영화이름 오면 그걸로 파싱.
  
  var inputs: MovieGenreSearchInput {return self}
  var outputs: MovieGenreSearchOutput {return self}
  
  private let disposeBag: DisposeBag = DisposeBag()
  init() { }
}
extension MovieGenreSearchVM {
  func genreMovieParsing(start: String, genre: String) {
    //글로벌에서 돌고
    MovieGenreNetwork.SI.movieGenreList(start: start, genre: genre)
      .subscribe(onNext: { [weak self] (movieResult) in
        self?.genreList.onNext(movieResult)
      }).disposed(by: disposeBag)
//    genre.subscribe(onNext: { [weak self] (genre, start) in
//      //여기서 장르별 검색을 진행한다. offset도 활용을 해야함.
//      self?.genreList = MovieGenreNetwork.SI.movieGenreList(start: "\(start)", genre: genre).asDriver(onErrorJustReturn: MovieGenreList(JSON: [:])!)
//    }).disposed(by: disposeBag)
  }
}
