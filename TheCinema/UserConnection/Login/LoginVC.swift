//
//  LoginVC.swift
//  TheCinema
//
//  Created by SatGatLee on 11/07/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginVC: UIViewController {
  //MARK:- 로그인 화면 
  lazy var loginV: LoginV = LoginV()
  private let loginVM: LoginVM = LoginVM()
  private let disposeBag: DisposeBag = DisposeBag()
  
  override func viewWillAppear(_ animated: Bool) {
    btnIsEnabled(flag: true)
    guard Auth.auth().currentUser == nil else {
      //로그인 성공.
      return
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(loginV)
    view.backgroundColor = .white
    constrain(loginV, view) {
      $0.edges == $1.safeAreaLayoutGuide.edges
    }
    
    for font in UIFont.familyNames {
      print(font)
    }
    
    GIDSignIn.sharedInstance().uiDelegate = self
    GIDSignIn.sharedInstance().delegate = self
    setupBind()
  }
}
extension LoginVC {
  private func btnIsEnabled(flag: Bool) {
    loginV.googleLoginBtn.isEnabled = flag
  }
  
  private func setupBind() {
    loginV.googleLoginBtn.rx.tap
      .asDriver()
      .drive(onNext: {
        GIDSignIn.sharedInstance()?.signIn()
      })
      .disposed(by: disposeBag)
    
    loginVM.onLogined.asDriver(onErrorJustReturn: ())
      .drive(onNext: { [weak self] in
        self?.btnIsEnabled(flag: true)
      }).disposed(by: disposeBag)
    
    loginV.signUpBtn.rx.tap
    .asDriver()
      .drive(onNext: { [weak self] in
        let vc: SignUpVC = SignUpVC()
        self?.present(vc, animated: true, completion: nil)
      }).disposed(by: disposeBag)
  }
}

extension LoginVC: GIDSignInDelegate, GIDSignInUIDelegate {
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) { //로그인 되면 정보 가지고 파이어베이스 저장ㄴ
    guard let _ = user, let authentication = user.authentication else { return }
    let creadential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
    
    if user.profile.hasImage {
      loginVM.onGoogleLogined.onNext((user.profile.name, user.profile.imageURL(withDimension: 100)!.absoluteString, creadential))
    } else {
      loginVM.onGoogleLogined.onNext((user.profile.name, "", creadential))
    }
  }
}
