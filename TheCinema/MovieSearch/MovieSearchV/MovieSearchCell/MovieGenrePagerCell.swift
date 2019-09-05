//
//  MovieGenrePagerCell.swift
//  TheCinema
//
//  Created by SatGatLee on 24/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import UIKit
import FSPagerView

class MovieGenrePagerCell: FSPagerViewCell { //영화 장르 셀
  static let cellIdentifier: String = String(describing: MovieGenrePagerCell.self)
  lazy var backV: UIView = UIView().then {
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
    $0.backgroundColor = MainManager.SI.bgColor
  }
  
  lazy var moviePoster: UIImageView = UIImageView()
  
  lazy var movieTitle: UILabel = UILabel().then {
    $0.textColor = MainManager.SI.bgColor
  }
  
  lazy var movieUserRatingStack: UIStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
    $0.backgroundColor = .clear
    $0.isHidden = true
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    layoutSetUp()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init() error")
  }
}
extension MovieGenrePagerCell {
  private func layoutSetUp() {
    contentView.addSubview(backV)
    [moviePoster, movieTitle, movieUserRatingStack].forEach { self.backV.addSubview($0) }
    
    constrain(backV) {
      $0.edges == $0.superview!.edges
    }
    
    constrain(moviePoster) {
      $0.left   == $0.superview!.left
      $0.right  == $0.superview!.right
      $0.top    == $0.superview!.top
      $0.bottom == $0.superview!.bottom
    }
    
    constrain(movieTitle) {
      $0.centerX == $0.superview!.centerX
      $0.top     == $0.superview!.top + 10
    }
    
    constrain(movieUserRatingStack) {
      $0.bottom  == $0.superview!.bottom - 10
      $0.right   == $0.superview!.right - 10
      $0.width   == 75
      $0.height  == 15
    }
    
    for _ in 0..<5 {
      let image: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "ic_star_large")
      }
      movieUserRatingStack.addArrangedSubview(image)
      
      constrain(image) {
        $0.width  == 15
        $0.height == $0.width
      }
    }
  }
  
  func configPage<T>(movie: T) {
    if let genreData: MovieGenreData = movie as? MovieGenreData {
      movieTitle.text = genreData.poster == "" ? genreData.title : ""
      moviePoster.URLString(urlString: genreData.poster)
    }
      
    else if let movieData: MovieData = movie as? MovieData {
      moviePoster.URLString(urlString: movieData.image)
      movieTitle.text = movieData.title
      movieUserRatingStack.isHidden = false
      ratingCalculate(rating: Int(movieData.userRating)!)
    }
      
    else if let stills: String = movie as? String {
      moviePoster.URLString(urlString: stills)
      backV.layer.cornerRadius = 0
    }
    
    //else if let
  }
  
  private func ratingCalculate(rating: Int) {
    var previoudIndex: Double = 0.0
    var currentIndex: Double = 0.0
    let rating: Double = Double(rating) / 2
    movieUserRatingStack.arrangedSubviews.enumerated().forEach {
      currentIndex = Double($0.offset) + 1.0
      let image: UIImageView = $0.element as! UIImageView
      if currentIndex <= rating {
        image.image = UIImage(named: "ic_star_large_full")
        previoudIndex = currentIndex
      } else if previoudIndex < rating && currentIndex > rating { //3.5 쩜오같은 사이즈
        image.image = UIImage(named: "ic_star_large_half")
        previoudIndex = currentIndex
      } else {
        image.image = UIImage(named: "ic_star_large")
      }
    }
  }
  
  override func prepareForReuse() {
    movieTitle.text = ""
  }
}
