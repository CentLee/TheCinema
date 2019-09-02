//
//  MovieCommentTableViewCell.swift
//  TheCinema
//
//  Created by ChLee on 28/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import UIKit

class MovieCommentTableViewCell: UITableViewCell { //영화 리뷰 셀
  static let cellIdentifier: String = String(describing: MovieCommentTableViewCell.self)
  
  lazy var profile: UIImageView = UIImageView().then {
    $0.layer.cornerRadius = 25
    $0.clipsToBounds = true
  }
  
  lazy var nameText: UILabel = UILabel()
  
  lazy var ratingStack: UIStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
  }
  
  lazy var dateText: UILabel = UILabel().then {
    $0.textColor = .lightGray
  }
  
  lazy var commentText: UILabel = UILabel().then {
    $0.numberOfLines = 0
    $0.lineBreakMode = .byWordWrapping
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layoutSetUp()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init() Error")
  }
}

extension MovieCommentTableViewCell {
  private func layoutSetUp() {
    [profile, nameText, ratingStack, dateText, commentText].forEach { self.contentView.addSubview($0) }
    
    constrain(profile) {
      $0.top    == $0.superview!.top + 20
      $0.left   == $0.superview!.left + 20
      $0.width  == 50
      $0.height == $0.width
    }
    
    constrain(nameText, profile) {
      $0.top  == $1.top
      $0.left == $1.right + 10
    }
    
    constrain(ratingStack, nameText) {
      $0.top    == $1.top
      $0.left   == $1.right + 10
      $0.width  == 75
      $0.height == 15
    }
    
    constrain(dateText, nameText) {
      $0.top  == $1.bottom + 10
      $0.left == $1.left
    }
    
    constrain(commentText, dateText) {
      $0.bottom <= $0.superview!.bottom - 10
      $0.top    == $1.bottom + 10
      $0.left   == $1.left
      $0.right  == $0.superview!.right - 10
    }
    
    for _ in 0..<5 {
      let image: UIImageView = UIImageView()
      image.image = UIImage(named: "ic_star_large")
      ratingStack.addArrangedSubview(image)
    }
  }
  
  func config(data: MovieComment) {
    selectionStyle = .none
    OperationQueue.main.addOperation {
      self.profile.URLString(urlString: data.image)
    }
    nameText.text = data.name
    dateText.text = data.createdAt
    commentText.text = data.comment
    ratingCalculate(rating: data.rating)
  }
  
  private func ratingCalculate(rating: Int) {
    var previoudIndex: Double = 0.0
    var currentIndex: Double = 0.0
    let rating: Double = Double(rating) / 2
    ratingStack.arrangedSubviews.enumerated().forEach {
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
}
