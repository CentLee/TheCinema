//
//  MovieGenrePagerCell.swift
//  TheCinema
//
//  Created by SatGatLee on 24/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import UIKit
import FSPagerView

class MovieGenrePagerCell: FSPagerViewCell {
  static let cellIdentifier: String = String(describing: MovieGenrePagerCell.self)
  lazy var backV: UIView = UIView().then {
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
    $0.backgroundColor = .white
  }
  
  lazy var moviePoster: UIImageView = UIImageView().then {
    _ in
  }
  
  lazy var movieInformationV: UIView = UIView().then {
    $0.backgroundColor = .white
  }
  
  lazy var movieTitle: UILabel = UILabel().then {
    _ in
  }
  
  lazy var movieUserRating: UILabel = UILabel().then {
    _ in
  }
  
  lazy var movieUserRatingStack: UIStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
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
    
//    constrain(movieInformationV, moviePoster) {
//      $0.top    == $1.bottom
//      $0.left   == $0.superview!.left
//      $0.right  == $0.superview!.right
//      $0.bottom == $0.superview!.bottom
//    }
    
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
  
  func configPage() {
    
  }
}
