//
//  MovieGenreNetwork.swift
//  TheCinema
//
//  Created by SatGatLee on 25/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieGenreNetwork {
  static let SI: MovieGenreNetwork = MovieGenreNetwork()
  var headers:[String:String] = [:]
  var baseUrl: String = ""
  
  init() {
    baseHeaders()
  }
  
  private func baseHeaders() {
    if let infoDic : [String : Any] = Bundle.main.infoDictionary {
      if let id: String = infoDic["X-Naver-Client-Id"] as? String,
         let secret: String = infoDic["X-Naver-Client-Secret"] as? String,
         let url: String = infoDic["baseUrl"] as? String {
        headers["X-Naver-Client-Id"] = id
        headers["X-Naver-Client-Secret"] = secret
        baseUrl = url
      }
    }
  }
  
  func movieGenreList(start: String, genre: String) -> Observable<MovieGenreList> {
    return Observable<MovieGenreList>.create { observer in
      guard let url: URL = URL(string: self.baseUrl + "start=\(start)&genre=\(genre)") else { return Disposables.create()}
      Alamofire.request(url, method: .get, headers: self.headers).responseJSON { (response) in
        switch response.result {
        case .success(_):
          guard let json = response.result.value as? [String : Any] else { return }
          guard let data: MovieGenreList = Mapper<MovieGenreList>().map(JSON: json) else { return }
          observer.onNext(data)
          observer.onCompleted()
        case .failure(_):
          break
        }
      }
      return Disposables.create()
    }
  }
}
