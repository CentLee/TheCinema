//
//  SignUpVC.swift
//  TheCinema
//
//  Created by SatGatLee on 06/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import UIKit
import Photos
import NotificationBannerSwift

class SignUpVC: UIViewController {
  private let signUpVM: SignUpVM = SignUpVM()
  private let disposeBag: DisposeBag = DisposeBag()
  
  lazy var signUpV: SignUpV = SignUpV().then {
    $0.backgroundColor = .white
  }
  
  lazy var loadingView: UIActivityIndicatorView = UIActivityIndicatorView().then {
    $0.style = .whiteLarge
    $0.color = .darkGray
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    layoutSetUp()
    bindSetUp()
    // Do any additional setup after loading the view.
  }
}
extension SignUpVC {
  private func layoutSetUp() {
    view.backgroundColor = .white
    view.addSubview(signUpV)
    view.addSubview(loadingView)
    
    constrain(signUpV) {
      $0.edges == $0.superview!.safeAreaLayoutGuide.edges
    }
    
    constrain(loadingView) {
      $0.center == $0.superview!.center
    }
  }
  
  private func imagePicked() {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
      imagePicker.allowsEditing = true
      
      present(imagePicker, animated: true)
    }
  }
  private func bindSetUp() {
    let nameIsEmpty: ControlProperty<String?> = signUpV.nameText.rx.text
    nameIsEmpty.filter{$0 != ""}.asDriver(onErrorJustReturn: "").drive(signUpVM.nameText).disposed(by: disposeBag)
    signUpV.emailText.rx.text.filter{$0 != ""}.asDriver(onErrorJustReturn: "").drive(signUpVM.emailText).disposed(by: disposeBag)
    signUpV.passwordText.rx.text.filter{$0 != ""}.asDriver(onErrorJustReturn: "").drive(signUpVM.passwordText).disposed(by: disposeBag)
    
    signUpV.cancelBtn.rx.tap
      .asDriver()
      .drive(onNext: { [weak self] in
        self?.dismiss(animated: true, completion: nil)
      }).disposed(by: disposeBag)
    
    Driver.combineLatest(nameIsEmpty.map{$0 != ""}.asDriver(onErrorJustReturn: false), signUpV.emailText.rx.text.map{$0 != ""}.asDriver(onErrorJustReturn: false), signUpV.passwordText.rx.text.map{$0 != ""}.asDriver(onErrorJustReturn: false)) {
      $0 && $1 && $2 }
      .drive(onNext: {
        [weak self] (isValid)in
        guard let self = self else { return }
        self.signUpV.signUpBtn.isEnabled = isValid
      }).disposed(by: disposeBag)
    
    signUpV.signUpBtn.rx.tap.map{self.loadingView.startAnimating()}.asDriver(onErrorJustReturn: ())
      .drive(signUpVM.onSignUpTapped).disposed(by: disposeBag)
    
    signUpV.profileImage.rx.tap.asDriver(onErrorJustReturn: ())
      .drive(onNext: { [weak self] in
        self?.imagePicked()
      }).disposed(by: disposeBag)
    
    signUpVM.onSignUp.asDriver(onErrorJustReturn: ())
      .drive(onNext: { [weak self] in
        self?.loadingView.stopAnimating()
        self?.dismiss(animated: true, completion: {
          let banner = FloatingNotificationBanner(title: "축하드립니다.", subtitle: "회원가입이 완료되었습니다.", style: .success)
          banner.show()
        })
      }).disposed(by: disposeBag)
  }
}
extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let chosenImage: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
    signUpV.profileImage.setBackgroundImage(chosenImage, for: .normal)
    signUpVM.profileImg.accept(chosenImage.jpegData(compressionQuality: 0.5))
    
    picker.dismiss(animated: true, completion: nil)
  }
}
