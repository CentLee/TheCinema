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
    loginV.emailText.rx.text.filter{$0 != ""}.asDriver(onErrorJustReturn: "").drive(loginVM.emailText).disposed(by: disposeBag)
    loginV.passwordText.rx.text.filter{$0 != ""}.asDriver(onErrorJustReturn: "").drive(loginVM.passwordText).disposed(by: disposeBag)
    
    loginV.googleLoginBtn.rx.tap.asDriver()
      .drive(onNext: {
        GIDSignIn.sharedInstance()?.signIn()
      })
      .disposed(by: disposeBag)
    
    Driver.combineLatest(loginV.emailText.rx.text.map{$0 != ""}.asDriver(onErrorJustReturn: false), loginV.passwordText.rx.text.map{$0 != ""}.asDriver(onErrorJustReturn: false)) { (isEmailValid, isPasswordValid) in
      return isEmailValid && isPasswordValid
      }
      .drive(onNext: { [weak self] (isValid) in
        self?.loginV.loginBtn.isEnabled = isValid
      }).disposed(by: disposeBag)
    
    loginV.loginBtn.rx.tap.asDriver()
    .drive(loginVM.onLoginTapped).disposed(by: disposeBag)
    
    loginVM.onLogined.asDriver(onErrorJustReturn: ())
      .drive(onNext: { [weak self] in
        self?.btnIsEnabled(flag: true)
        //main flow move
        self?.tabBarSetUp()
      }).disposed(by: disposeBag)
    
    loginV.signUpBtn.rx.tap
    .asDriver()
      .drive(onNext: { [weak self] in
        let vc: SignUpVC = SignUpVC()
        self?.present(vc, animated: true, completion: nil)
      }).disposed(by: disposeBag)
  }
  
  private func tabBarSetUp() { //탭바 이니셜
    let firstVC = BoxOfficeVC()
    firstVC.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 0)
    let secondVC = MovieSearchVC()
    secondVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
    let tabbar: UITabBarController = UITabBarController()
    tabbar.viewControllers = [UINavigationController(rootViewController: firstVC), secondVC]
    present(tabbar, animated: true, completion: nil)
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
