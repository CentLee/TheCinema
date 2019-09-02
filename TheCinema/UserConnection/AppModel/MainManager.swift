//
//  MainManager.swift
//  TheCinema
//
//  Created by SatGatLee on 06/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import Foundation

class MainManager {
  static let SI = MainManager()
  
  var userInfo: UserInformation = UserInformation(JSON: [:])! //로그인시 받는 유저 정보
}
extension MainManager {
  func ratingCalculate(rating: Int, stackV: UIStackView) {
    var previoudIndex: Double = 0.0
    var currentIndex: Double = 0.0
    let rating: Double = Double(rating) / 2
    stackV.arrangedSubviews.enumerated().forEach {
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
