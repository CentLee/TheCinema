//
//  BoxOfficeVM.swift
//  TheCinema
//
//  Created by SatGatLee on 20/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import Foundation

protocol BoxOfficeInput {
  func boxOfficeSearch(date: String)
}

protocol BoxOfficeOutput {
  var boxOffice: [BoxOfficeData] {get set}
  var boxOfficeInfo: PublishSubject<[MovieGenreData]> {get set}
}
protocol BoxOfficeType {
  var input: BoxOfficeInput {get}
  var output: BoxOfficeOutput {get}
}

class BoxOfficeVM: BoxOfficeType, BoxOfficeInput, BoxOfficeOutput {
  
  var input: BoxOfficeInput {return self}
  var output: BoxOfficeOutput {return self}
  
  private let disposeBag: DisposeBag = DisposeBag()
  var boxOffice: [BoxOfficeData] = [] {
    didSet {
      boxOfficeList(list: boxOffice)
    }
  }
  var boxOfficeInfo: PublishSubject<[MovieGenreData]> = PublishSubject<[MovieGenreData]>()
}
extension BoxOfficeVM {
  private func boxOfficeList(list: [BoxOfficeData]) {
    BoxOfficeNetwork.SI.boxOfficeSearch(list: list)
      .subscribe(onNext : { [weak self] list in
        self?.boxOfficeInfo.onNext(list)
      }).disposed(by: disposeBag)
  }
  
  func boxOfficeSearch(date: String) {
    BoxOfficeNetwork.SI.boxOfficeList(date: date)
      .subscribe(onNext: { [weak self] data in
        self?.boxOffice = data
      }).disposed(by: disposeBag)
  }
}
