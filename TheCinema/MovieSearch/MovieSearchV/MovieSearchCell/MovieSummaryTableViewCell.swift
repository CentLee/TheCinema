//
//  MovieSummaryTableViewCell.swift
//  TheCinema
//
//  Created by ChLee on 27/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import UIKit

class MovieSummaryTableViewCell: UITableViewCell { //영화 간략정보 뷰
  static let cellIdentifier: String = String(describing: MovieSummaryTableViewCell.self)
  
  lazy var moviePoster: UIImageView = UIImageView().then {
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
  }
  lazy var movieDate: UILabel = UILabel()
  lazy var movieGenre: UILabel = UILabel()
  lazy var movieTitle: UILabel = UILabel()
  lazy var movieActors: UILabel = UILabel()
  lazy var movieDirectors: UILabel = UILabel().then {
    $0.numberOfLines = 0
    $0.lineBreakMode = .byWordWrapping
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layoutSetUp()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init() error")
  }
}

extension MovieSummaryTableViewCell {
  private func layoutSetUp() {
    [moviePoster, movieDate, movieGenre, movieTitle, movieActors, movieDirectors].forEach { self.contentView.addSubview($0) }
    
    constrain(moviePoster) {
      $0.top    == $0.superview!.top + 10
      $0.left   == $0.superview!.left + 20
      $0.width  == 100
      $0.height == $0.width
    }
    
    constrain(movieTitle, moviePoster) {
      $0.top  == $1.top + 10
      $0.left == $1.right + 10
    }
    
    constrain(movieGenre, moviePoster, movieTitle) {
      $0.left    == $2.left
      $0.centerY == $1.centerY
    }
    
    constrain(movieDate, movieGenre) {
      $0.top  == $1.bottom + 10
      $0.left == $1.left
    }
    
    constrain(movieDirectors, moviePoster) {
      $0.top   == $1.bottom + 10
      $0.left  == $0.superview!.left + 10
      $0.right == $0.superview!.right - 10
    }
    
    constrain(movieActors, movieDirectors) {
      $0.top    == $1.bottom + 5
      $0.left   == $1.left
      $0.right  == $1.right
      $0.bottom >= $0.superview!.bottom - 10
    }
  }
  
  func config(info: MovieGenreData) {
    moviePoster.URLString(urlString: info.poster)
    movieTitle.text = info.title
    movieGenre.text = info.full
    movieDate.text = "\(info.rating.openingDate) 개봉"
    //movieDirectors.text = info.directors.forEach { $0}
  }
  
//  func directors(director: [MovieGenreDirector]) -> String {
//    var name: String = ""
//    director.reduce{}($0.name + $1.name)
//    director.forEach { }
//  }
}
