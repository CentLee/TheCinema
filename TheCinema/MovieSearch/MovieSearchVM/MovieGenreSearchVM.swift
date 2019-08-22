//
//  MovieGenreSearchVM.swift
//  TheCinema
//
//  Created by SatGatLee on 22/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import Foundation

protocol MovieGenreSearchInput {
  var genre: PublishRelay<String> {get set}
}

protocol MovieGenreSearchOutput {
  
}

protocol MovieGenreSearchType {
  var inputs: MovieGenreSearchInput {get}
  var outputs: MovieGenreSearchOutput {get}
}
class MovieGenreSearchVM: MovieGenreSearchType, MovieGenreSearchOutput, MovieGenreSearchInput {
  
  var genre: PublishRelay<String> = PublishRelay<String>()
  
  //장르별 검색 및 단일 검색할 것들.
  //인풋으로 장르 및 단일 영화이름 오면 그걸로 파싱.
  
  var inputs: MovieGenreSearchInput {return self}
  var outputs: MovieGenreSearchOutput {return self}
  
  private let disposeBag: DisposeBag = DisposeBag()
  init() {
    bind()
  }
}
extension MovieGenreSearchVM {
  private func bind() {
    //글로벌에서 돌고
    genre.subscribe(onNext: { [weak self] (genre) in
      //여기서 장르별 검색을 진행한다. offset도 활용을 해야함.
    }).disposed(by: disposeBag)
  }
}
