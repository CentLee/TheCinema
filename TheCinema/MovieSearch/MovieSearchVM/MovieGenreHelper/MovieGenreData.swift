//
//  MovieGenreData.swift
//  TheCinema
//
//  Created by SatGatLee on 25/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieGenreList: Mappable { //장르별 영화 리스트
  var totalCount: Int = 0
  var items: [MovieGenreResult] = []
  
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    totalCount  <- map["TotalCount"]
    items       <- map["Data"]
  }
}

class MovieGenreResult: Mappable {
  var movies: [MovieGenreData] = []
  var collName: String = ""
  var count: Int = 0
  var totalCount: Int = 0
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    totalCount  <- map["TotalCount"]
    count       <- map["Count"]
    movies      <- map["Result"]
    collName    <- map["CollName"]
  }
}

class MovieGenreData: Mappable { //장르별 영화 데이터.
  var movieSeq: String = ""
  var title: String = ""
  var prodYear: String = ""
  var directors: [MovieGenreDirector] = []
  var actors: [MovieGenreActor] = []
  var plot: String = ""
  var runtime: String = ""
  var rating: MovieGenreRating = MovieGenreRating(JSON: [:])!
  var kmdbUrl: String = ""
  var genre: String = ""
  var poster: String = ""
  var stills: String = ""
  
  var full: String {
    return "\(genre) / \(runtime)분 \(rating.rating)"
  }
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    movieSeq      <- map["movieSeq"]
    title         <- map["title"]
    prodYear      <- map["prodYear"]
    directors     <- map["director"]
    actors        <- map["actor"]
    plot          <- map["plot"]
    runtime       <- map["runtime"]
    rating        <- map["rating"]
    genre         <- map["genre"]
    kmdbUrl       <- map["kmdbUrl"]
    poster        <- map["posters"]
    stills        <- map["stills"]
  }
}

class MovieGenreDirector: Mappable {//감독진
  var name: String = ""
  var id: String = ""
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    name      <- map["directorNm"]
    id        <- map["directorId"]
  }
}

class MovieGenreActor: Mappable { //배우진
  var name: String = ""
  var id: String = ""
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    name      <- map["actorNm"]
    id        <- map["actorId"]
  }
}

class MovieGenreRating: Mappable { //러닝타임 및 개봉일
  var runtime: String = ""
  var openingDate: String = ""
  var rating: String = ""
  
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    rating      <- map["rating"]
    runtime     <- map["runtime"]
    openingDate <- map["releaseDate"]
  }
}
