//
//  LoginVC.swift
//  TheCinema
//
//  Created by SatGatLee on 11/07/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
  //MARK:- 로그인 화면 
  lazy var loginV: LoginV = LoginV()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      view.addSubview(loginV)
      view.backgroundColor = .white
      constrain(loginV, view) {
        $0.width  == 200
        $0.height == 200
        $0.center == $1.center
      }
      
      for font in UIFont.familyNames {
        print(font)
      }
        // Do any additional setup after loading the view.
    }
}
