//
//  LoginVM.swift
//  TheCinema
//
//  Created by SatGatLee on 11/07/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import Foundation
import FirebaseDatabase
import GoogleSignIn
import ObjectMapper

enum LoginType {
  case google
  case email
}
protocol LoginViewModelInterface {
  var emailText: BehaviorRelay<String?> {get set}
  var passwordText: BehaviorRelay<String?> {get set}
  var onLoginTapped: BehaviorRelay<Void> {get set}
  var onGoogleLogined: PublishSubject<(String, String, AuthCredential)> {get set}
  
  var onLogined: PublishSubject<Void> {get}
  func userInfo(uid: String)
}
class LoginVM: NSObject, LoginViewModelInterface { //이메일 로그인과 구글 로그인 연동.
  //Input
  var emailText: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
  var passwordText: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
  var onLoginTapped: BehaviorRelay<Void> = BehaviorRelay<Void>(value: ())
  var onGoogleLogined: PublishSubject<(String, String, AuthCredential)> = PublishSubject<(String, String, AuthCredential)>()
  
  //output
  var onLogined: PublishSubject<Void> = PublishSubject<Void>()

  private var userName: String! //구글 로그인용
  private var userProfileImage: String! //구글 로그인용
  private var ref: DatabaseReference!
  private let disposeBag: DisposeBag = DisposeBag()
  
  override init() {
    super.init()
    self.setupBind()
  }
}
extension LoginVM {
  private func setupBind() {
    ref = Database.database().reference()
    
    onLoginTapped
      .subscribe(onNext: { [weak self] in
        self?.loginFirebase()
      }).disposed(by: disposeBag)
    
    onGoogleLogined.subscribe(onNext: {[weak self] (name, image, credential) in
      self?.userName = name
      self?.userProfileImage = image
      self?.firebaseAuthentication(credential: credential)
    }).disposed(by: disposeBag)
    
  }
  
  private func loginFirebase() {
    guard let email: String = emailText.value , let password: String = passwordText.value else { return }
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
      guard error == nil else { return }
      self.onLogined.onNext(())
    }
  }
  
  private func firebaseAuthentication(credential: AuthCredential) {
    Auth.auth().signIn(with: credential) { [weak self] (result, error) in
      guard let self = self , let user = result?.user else { return }
      MainManager.SI.userInfo.userId = user.uid
      MainManager.SI.userInfo.userName = self.userName
      MainManager.SI.userInfo.userProfileImage = self.userProfileImage
      self.ref.child("User").observeSingleEvent(of: .value, with: { (snapshot) in
        guard snapshot.hasChild("\(user.uid)") else  {
          self.ref.child("User").child("\(user.uid)").setValue(["UserInformation" : ["user_id": user.uid, "user_name": self.userName, "user_profile_img": self.userProfileImage]])
          self.onLogined.onNext(())
          //데이터 저장 후 푸쉬
          return
        }
        self.onLogined.onNext(())
      })
      
    }
  }
  func userInfo(uid: String) {
    ref.child("User").child("\(uid)").child("UserInformation").observeSingleEvent(of: .value) { (snapshot) in
      guard !(snapshot.value is NSNull) else { return }
      guard let item = snapshot.value as? [String:Any] , let data = Mapper<UserInformation>().map(JSON: item) else { return }
      //let data = Mapper<UserInformation>().map(JSON: item)
      MainManager.SI.userInfo = data
    }
  }
}
