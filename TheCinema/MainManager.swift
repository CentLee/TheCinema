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
