//
//  MovieGenreData.swift
//  TheCinema
//
//  Created by SatGatLee on 25/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieGenreList: Mappable {
  var start: Int = 0
  var items: [MovieGenreData] = []
  
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    start  <- map["start"]
    items  <- map["items"]
  }
}

class MovieGenreData: Mappable {
  var title: String = ""
  var link: String = ""
  var image: String = ""
  var userRating: String = ""
  
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    title      <- map["title"]
    link       <- map["link"]
    image      <- map["image"]
    userRating <- map["userRating"]
  }
}

//"title": "주마등<b>주식</b>회사",
//"link": "https://movie.naver.com/movie/bi/mi/basic.nhn?code=96811",
//"image": "https://ssl.pstatic.net/imgmovie/mdi/mit110/0968/96811_P01_142155.jpg",
//"subtitle": "走馬&amp;#28783;株式&amp;#20250;社",
//"pubDate": "2012",
//"director": "미키 코이치로|",
//"actor": "카시이 유우|쿠보타 마사타카|카지와라 히카리|치요 쇼타|요코야마 메구미|카시와바라 슈지|",
//"userRating": "4.50"
