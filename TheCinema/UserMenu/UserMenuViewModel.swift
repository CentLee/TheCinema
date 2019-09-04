//
//  UserMenuViewModel.swift
//  TheCinema
//
//  Created by ChLee on 04/09/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import Foundation


protocol UserMenuInput {
  func favoriteList()
  func inquiryTopList()
}

protocol UserMenuOutput {
  
}

protocol UserMenuViewModelType {
  var input: UserMenuInput {get}
  var output: UserMenuOutput {get}
}

class UserMenuViewModel: UserMenuViewModelType, UserMenuInput, UserMenuOutput {
  var input: UserMenuInput {return self}
  var output: UserMenuOutput {return self}
 
  private let disposeBag: DisposeBag = DisposeBag()
  private let ref: DatabaseReference = Database.database().reference()
  
}

extension UserMenuViewModel {
  func favoriteList() {
    
  }
  
  func inquiryTopList() {
    
  }
}
