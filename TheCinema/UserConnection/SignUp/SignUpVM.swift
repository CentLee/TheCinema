//
//  SignUpVM.swift
//  TheCinema
//
//  Created by SatGatLee on 06/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import Foundation
import ObjectMapper

protocol SignUpInterface {
  //input
  var nameText: BehaviorRelay<String?> {get set}
  var emailText: BehaviorRelay<String?> {get set}
  var passwordText: BehaviorRelay<String?> {get set}
  var profileImg: BehaviorRelay<String?> {get set}
  var onSignUpTapped: BehaviorRelay<Void> {get set}
  
  //output
  var onSignUp: PublishSubject<Void> {get}
}
class SignUpVM: SignUpInterface{
  var nameText: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
  var emailText: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
  var passwordText: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
  var profileImg: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
  var onSignUpTapped: BehaviorRelay<Void> = BehaviorRelay<Void>(value: ())
  
  //output
  var onSignUp: PublishSubject<Void> = PublishSubject<Void>()
  
  private let ref: DatabaseReference = Database.database().reference()
  private let disposeBag: DisposeBag = DisposeBag()
  
  init() {
    bindSetUp()
  }
}

extension SignUpVM {
  private func bindSetUp() {
    onSignUpTapped.subscribe(onNext: {[weak self] in
      self?.distinctName { [weak self] in
        self?.singUpUser()
      }
    }).disposed(by: disposeBag)
  }
  
  private func distinctName(onCompleted: @escaping (() -> Void)) { //이름 중복 검사
    ref.child("User").observeSingleEvent(of: .value) { [weak self] (snapshot) in
      guard let self = self else { return }
      guard snapshot.hasChildren() else {
        onCompleted()
        return
      } //데이터가 없다 그냥 사인업 가능
      
      guard let item = snapshot.value as? [String : AnyObject] else { return }
      for (_, value) in item {
        if let name = value["user_name"] as? String {
          iPrint(name)
          if name == self.nameText.value {
            return
          }
        }
      } //포문이 끝났다 그럼 데이터 파싱 끝
      onCompleted()
    }
  }
  private func singUpUser() {
    guard let password: String = passwordText.value, let email: String = emailText.value, let name: String = nameText.value else { return }
    Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] (result, error) in
      guard error == nil , let user = result?.user , let self = self else { return }
      self.ref.child("User").child(user.uid).setValue(["UserInformation": ["user_id": user.uid, "user_name": name, "user_profile_img": self.profileImg.value ?? ""]])
      self.onSignUp.onNext(())
      self.ref.removeAllObservers()
    })
  }
}
