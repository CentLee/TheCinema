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
    $0.font = UIFont(name: "NanumSquareOTFEB", size:40)
  }
  lazy var loginVSubTitle: UILabel = UILabel().then {
    $0.text = "상영작부터 간단하게 사용 가능한 영화 정보 앱"
  }
  lazy var loginSeparateLine: UIView = UIView().then {
    $0.backgroundColor = UIColor.lightGray
  }
  lazy var googleLoginBtn: UIButton = UIButton().then {
    $0.setImage(UIImage(named: "buttonsLoginGoogle"), for: .normal)
    $0.contentHorizontalAlignment = .fill
    $0.contentVerticalAlignment = .fill
  }
  lazy var appIcon: UIImageView = UIImageView().then {
    $0.image = UIImage(named:"AppIcon")
    $0.contentMode = .scaleAspectFit
  }
  lazy var snsTitle: UILabel = UILabel().then {
    $0.text = "SNS 계정으로 로그인"
    $0.textAlignment = .center
  }
  lazy var emailText: UITextField = UITextField().then {
    $0.borderStyle = .roundedRect
    $0.placeholder = "Email"
    $0.autocorrectionType = .no
    $0.autocapitalizationType = .none
  }
  lazy var passwordText: UITextField = UITextField().then {
    $0.borderStyle = .roundedRect
    $0.placeholder = "Password"
    $0.isSecureTextEntry = true
    $0.autocorrectionType = .no
    $0.autocapitalizationType = .none
  }
  lazy var loginBtn: UIButton = UIButton().then {
    $0.setTitle("로그인", for: .normal)
    $0.setTitleColor(.black, for: .normal)
  }
  lazy var signUpBtn: UIButton = UIButton().then {
    $0.setTitle("회원가입", for: .normal)
    $0.setTitleColor(.black, for: .normal)
  }
  lazy var loginStack: UIStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
  }
  ///
  
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    addSubview(backV)
    [loginVTitle, appIcon, loginVSubTitle, emailText, passwordText, loginStack, loginSeparateLine, snsTitle, googleLoginBtn].forEach {
      self.backV.addSubview($0)
    }
    loginStack.addArrangedSubview(loginBtn)
    loginStack.addArrangedSubview(signUpBtn)
    
    constrain(backV, self) {
      $0.edges == $1.safeAreaLayoutGuide.edges
    }
    
    constrain(appIcon, backV) {
      $0.top     == $1.top + 100
      $0.width   == 70
      $0.height  == $0.width
      $0.centerX == $1.centerX
    }
    
    constrain(loginVTitle, appIcon) {
      $0.centerX == $1.centerX
      $0.top     == $1.bottom + 20
    }
    
    constrain(loginVSubTitle, loginVTitle) {
      $0.top     == $1.bottom + 10
      $0.centerX == $1.centerX
    }
    
    constrain(emailText, loginVSubTitle) {
      $0.width  == $0.superview!.width / 2
      $0.top    == $1.bottom + 20
      $0.centerX == $0.superview!.centerX
    }
    
    constrain(passwordText, emailText) {
      $0.width   == $1.width
      $0.centerX == $1.centerX
      $0.top     == $1.bottom + 20
    }
    
    constrain(loginStack, passwordText) {
      $0.top     == $1.bottom + 10
      $0.width   == $1.width
      $0.centerX == $1.centerX
    }
    
    constrain(loginSeparateLine, backV, googleLoginBtn) {
      $0.centerX == $1.centerX
      $0.bottom  == $1.bottom - 200
      $0.height  == 1
      $0.left    == $2.left
      $0.right   == $2.right
    }
    
    constrain(snsTitle, loginSeparateLine) {
      $0.left   == $1.left
      $0.right  == $1.right
      $0.bottom == $1.top - 10
    }
    
    constrain(googleLoginBtn, loginSeparateLine) {
      $0.top    == $1.bottom + 10
      $0.width  == $0.superview!.width / 2
      $0.height == 30
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
