//
//  LoginV.swift
//  TheCinema
//
//  Created by SatGatLee on 11/07/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import Foundation
import UIKit

class LoginV: UIView { //로그인 뷰.
  //MARK:- view Component
  lazy var backV: UIView = UIView().then {
    $0.backgroundColor = .clear
  }
  lazy var loginVTitle: UILabel = UILabel().then {
    $0.text = "The Cinema"
    $0.font = UIFont(name: "NanumSquareEB", size:20)
  }
  lazy var loginVSubTitle: UILabel = UILabel().then {
    $0.text = "상영작부터 간단하게 사용 가능한 영화 정보 앱"
  }
  lazy var kakaoLoginBtn: UIButton = UIButton().then {
    _ in
  }
  //lazy var 
  ///
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    [loginVTitle].forEach {
      self.addSubview($0)
    }
    
    constrain(loginVTitle, self) {
      $0.center == $1.center
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
