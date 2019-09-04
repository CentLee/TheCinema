//
//  UserMenuViewController.swift
//  TheCinema
//
//  Created by ChLee on 04/09/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import UIKit

class UserMenuViewController: UIViewController { //유저 탭 즐겨 찾기 & 조회수 높은 장르 탑 3, 유저 프로필 편집.
  lazy var userMenuView: UserMenuView = UserMenuView()
  
  lazy var userMenuContentTable: UITableView = UITableView().then {
    $0.separatorStyle = .none
  }
  lazy var menuBtn: UIButton = UIButton().then {
    $0.setImage(UIImage(named: "ic_list"), for: .normal)
  }
  
  private let viewModel: UserMenuViewModelType = UserMenuViewModel()
  private let disposeBag: DisposeBag = DisposeBag()
  
  var leftConstraint: NSLayoutConstraint = NSLayoutConstraint() //메뉴 넓이 제약
  var currentMenu: BehaviorRelay<UserMenuType?> = BehaviorRelay<UserMenuType?>(value: nil) //기본값은 프로필 닐
  
  override func viewWillAppear(_ animated: Bool) {
    userMenuView.userProfile.URLString(urlString: MainManager.SI.userInfo.userProfileImage)
    userMenuView.userName.text = MainManager.SI.userInfo.userName
  }
  override func viewDidLoad() { //버튼 누를 때 마다 값들 가져오기.
    super.viewDidLoad()
    view.backgroundColor = .white
    layoutSetUp()
    navigationSetUp()
    bind()
  }
}
extension UserMenuViewController {
  private func layoutSetUp() {
    [userMenuContentTable, userMenuView].forEach { self.view.addSubview($0) }
    
    constrain(userMenuView) {
      leftConstraint = ($0.left == $0.superview!.left - 4000)
      $0.top    == $0.superview!.safeAreaLayoutGuide.top
      $0.bottom == $0.superview!.safeAreaLayoutGuide.bottom
      $0.width  == screenWidth / 1.5
    }
    
    constrain(userMenuContentTable) {
      $0.edges == $0.superview!.safeAreaLayoutGuide.edges
    }
  }
  
  private func navigationSetUp() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuBtn)
  }
  
  private func bind() {
    menuBtn.rx.tap
      .map{ [weak self] () -> Bool in
        guard let self = self else { return false}
        self.menuBtn.isSelected = !self.menuBtn.isSelected
        return self.menuBtn.isSelected
      }
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] (selected) in
        guard let self = self else { return }
        guard !selected else {
          self.userMenuView.frame.origin.x = -4000
          UIView.animate(withDuration: 0.5, animations: {
            self.leftConstraint.constant = 0
            self.userMenuView.frame.origin.x = 0
          })
          return
        }
        self.userMenuView.frame.origin.x = -4000
      }).disposed(by: disposeBag)
    
//    view.rx.tapGesture().when(.recognized).asDriver(onErrorJustReturn: UITapGestureRecognizer())
//      .drive(onNext: { [weak self] _ in
//        guard let self = self else { return }
//        self.leftConstraint.constant = -4000
//        self.menuBtn.isSelected = !self.menuBtn.isSelected
//      }).disposed(by: disposeBag)
    
    //Todo 1.즐겨찾기 , 2. 조회율순 보여주기
    
    userMenuView.menuTable.rx.itemSelected.asDriver(onErrorJustReturn: IndexPath())
      .drive(onNext: { [weak self] indexPath in
        guard let self = self else { return }
        switch indexPath.row {
        case 0: //즐겨찾기
          self.viewModel.input.favoriteList()
        case 1:
          self.viewModel.input.inquiryTopList()
        case 2:
          self.userMenuView.frame.origin.x = -4000
          self.menuBtn.isSelected = !self.menuBtn.isSelected
          let vc = UserProfileEditViewController()
          self.navigationController?.pushViewController(vc, animated: true)
        case 3://logout
          do  {
            try Auth.auth().signOut()
            MainManager.SI.userInfo = UserInformation(JSON: [:])!
          } catch(let err) {
            iPrint(err.localizedDescription)
          }
        default:
          break
        }
      }).disposed(by: disposeBag)
  }
}
