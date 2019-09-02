//
//  BoxOfficeNetwork.swift
//  TheCinema
//
//  Created by ChLee on 02/09/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import Foundation
import ObjectMapper

class BoxOfficeNetwork { // 박스 오피스 검색 및 그 영화에 대한 kmdb 검색 api
  static let SI: BoxOfficeNetwork = BoxOfficeNetwork()
  var boxOfficeBaseUrl: String = ""
  var kmdbUrl: String = ""
  init() {
    baseHeaders()
  }
  
  private func baseHeaders() {
    if let infoDic : [String : Any] = Bundle.main.infoDictionary {
      if let url: String = infoDic["BoxOfficeApiBaseUrl"] as? String,
        let key: String = infoDic["BoxOfficeServiceKey"] as? String,
        let key2: String = infoDic["GenreSearchServiceKey"] as? String,
        let url2: String = infoDic["GenreSearchApiBaseUrl"] as? String{
        boxOfficeBaseUrl = url + "key=\(key)"
        kmdbUrl = url2 + "&ServiceKey=\(key2)"
      }
    }
  }
  
  func boxOfficeList(date: String) -> Observable<[BoxOfficeData]>{ //일일 박스오피스 리스트 가져오는 것.
    return Observable<[BoxOfficeData]>.create { observer in
      guard let url: URL = URL(string: self.boxOfficeBaseUrl + "&targetDt=\(date)") else { return Disposables.create() }
      iPrint(url)
      Alamofire.request(url, method: .get).responseJSON { (response) in
        switch response.result {
        case .success(_):
          guard let json = response.result.value as? [String : Any] else { return }
          iPrint(json)
          guard let data: BoxOfficeResult = Mapper<BoxOfficeResult>().map(JSON: json) else { return }
          observer.onNext(data.result.list)
          observer.onCompleted()
        case .failure(let msg):
          iPrint(msg.localizedDescription)
        }
      }
      return Disposables.create()
    }
    
  }
  
  func boxOfficeSearch(list: [BoxOfficeData]) -> Observable<[MovieGenreData]> {
    return Observable<[MovieGenreData]>.create { observer in
      var result: [MovieGenreData] = []
      for i in 0..<10 {
        let str: String = self.kmdbUrl + "&query=\(list[i].movieName)&sort=prodYear&listCount=1&detail=Y"
        iPrint(str)
        guard let encodingStr: String = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else
        {
          return Disposables.create()
        }
        guard let url: URL = URL(string: encodingStr) else
        {
          return Disposables.create()
        }
        
        Alamofire.request(url, method: .get).responseJSON(completionHandler: { (response) in
          switch response.result {
          case .success(_):
            guard let json = response.result.value as? [String : Any] else { return }
            iPrint(json)
            guard let data: MovieGenreResult = Mapper<MovieGenreResult>().map(JSON: json) else { return }
            iPrint(data.movies)
//            let movieData: MovieGenreData = data.movies[0]
//            result.append(movieData) //데이터 하나씩 넣어주라.
          case .failure(let msg): iPrint(msg)
          }
        })
      }
      //포문 끝나면.
      observer.onNext(result)
      observer.onCompleted()
      return Disposables.create()
    }
  }
}
