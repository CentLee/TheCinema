//
//  MovieSearchDetailTableViewCell.swift
//  TheCinema
//
//  Created by ChLee on 30/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import UIKit

class MovieSearchDetailTableViewCell: UITableViewCell { //영화 단일 검색 테이블 셀
  
  static let cellIdentifier: String = String(describing: MovieSearchDetailTableViewCell.self)
  
  lazy var movieBackV: BackContentV = BackContentV().then {
    $0.layer.masksToBounds = false
    $0.backgroundColor = .white
  }
  
  lazy var moviePoster: UIImageView = UIImageView().then {
    $0.layer.cornerRadius = 8
    //$0.clipsToBounds = true
  }
  
  lazy var movieTitle: UILabel = UILabel().then {
    $0.lineBreakMode = .byTruncatingTail
    $0.numberOfLines = 0
  }
  
  lazy var ratingStack: UIStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
  }
  lazy var rating: UILabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layoutSetUp()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
extension MovieSearchDetailTableViewCell {
  private func layoutSetUp() {
    contentView.addSubview(movieBackV)
    [moviePoster, movieTitle, ratingStack, rating].forEach { self.movieBackV.addSubview($0) }
    
    constrain(movieBackV) {
      $0.top    == $0.superview!.top + 10
      $0.left   == $0.superview!.left + 10
      $0.right  == $0.superview!.right - 10
      $0.bottom == $0.superview!.bottom - 10
    }
    
    constrain(moviePoster) {
      $0.top    == $0.superview!.top + 5
      $0.left   == $0.superview!.left + 5
      $0.bottom == $0.superview!.bottom - 5
      $0.width  == 100
    }
    
    constrain(movieTitle, moviePoster) {
      $0.top      == $1.top + 10
      $0.left     == $1.right + 10
      $0.right    == $0.superview!.right - 5
    }
    
    constrain(rating, moviePoster) {
      $0.left   == $1.right + 10
      $0.bottom == $1.bottom - 10
    }
    
    constrain(ratingStack , rating) {
      $0.left    == $1.right + 10
      $0.centerY == $1.centerY
      $0.width   == 75
      $0.height  == 15
    }
    
    for _ in 1...5 {
      let image: UIImageView = UIImageView()
      image.image = UIImage(named: "ic_star_large")
      ratingStack.addArrangedSubview(image)
    }
    
    layoutIfNeeded()
  }
  
  func config(info: MovieData) {
    moviePoster.URLString(urlString: info.image)
    movieTitle.text = info.full
    rating.text = "평점: \(info.userRating)"
    
    MainManager.SI.ratingCalculate(rating: Int(Double(info.userRating)!), stackV: ratingStack)
  }
}
