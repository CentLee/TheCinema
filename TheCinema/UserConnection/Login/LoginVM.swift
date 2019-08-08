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

enum LoginType {
  case google
  case email
}
protocol LoginViewModelInterface {
  
  var onLoginTapped: BehaviorRelay<LoginType?> {get set}
  var onGoogleLogined: PublishSubject<(String, String, AuthCredential)> {get set}
  
  var onLogined: PublishSubject<Void> {get}
  
}
class LoginVM: NSObject, LoginViewModelInterface { //이메일 로그인과 구글 로그인 연동.
  //Input
  var onLoginTapped: BehaviorRelay<LoginType?> = BehaviorRelay<LoginType?>(value: nil)
  var onGoogleLogined: PublishSubject<(String, String, AuthCredential)> = PublishSubject<(String, String, AuthCredential)>()
  
  //output
  var onLogined: PublishSubject<Void> = PublishSubject<Void>()

  private var userName: String! //구글 로그인용
  private var userProfileImage: String! //구글 로그인용
  private var ref: DatabaseReference!
  private let disposeBag: DisposeBag = DisposeBag()
  
  override init() {
    super.init()
    GIDSignIn.sharedInstance().uiDelegate = self
    GIDSignIn.sharedInstance().delegate = self
    self.setupBind()
  }
}
extension LoginVM {
  private func setupBind() {
    ref = Database.database().reference()
    onLoginTapped
      .subscribe(onNext: { [weak self] type in
        guard let type = type , let self = self else { return }
        self.loginGroupByType(type: type)
      }).disposed(by: disposeBag)
    
    onGoogleLogined.subscribe(onNext: {[weak self] (name, image, credential) in
      self?.userName = name
      self?.userProfileImage = image
      self?.firebaseAuthentication(credential: credential)
    }).disposed(by: disposeBag)
    
  }
  private func loginGroupByType(type: LoginType) {
    if type == .google {
      GIDSignIn.sharedInstance()?.signIn()
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
          //데이터 저장 후 푸쉬
          return
        }
      })
      
    }
  }
}

extension LoginVM: GIDSignInDelegate, GIDSignInUIDelegate {
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) { //로그인 되면 정보 가지고 파이어베이스 저장ㄴ
    guard let authentication = user.authentication else { return }
    let creadential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
    userName = user.profile.name
    if user.profile.hasImage {
      userProfileImage = user.profile.imageURL(withDimension: 100)?.absoluteString
    }
    firebaseAuthentication(credential: creadential)
  }
}
