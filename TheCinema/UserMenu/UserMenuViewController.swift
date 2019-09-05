//
//  UserMenuViewController.swift
//  TheCinema
//
//  Created by ChLee on 04/09/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class UserMenuViewController: UIViewController { //유저 탭 즐겨 찾기 & 조회수 높은 장르 탑 3, 유저 프로필 편집.
  lazy var userMenuView: UserMenuView = UserMenuView().then {
    $0.backgroundColor = MainManager.SI.bgColor//UIColor(hexString: "#F8D1D1")
    $0.layer.borderWidth = 3
    $0.layer.borderColor = UIColor(hexString: "#F8D1D1").cgColor
  }
  
  lazy var userMenuContentTable: UITableView = UITableView().then {
    $0.separatorStyle = .none
    $0.rowHeight = 120
    $0.register(MovieSearchDetailTableViewCell.self, forCellReuseIdentifier: MovieSearchDetailTableViewCell.cellIdentifier)
    $0.backgroundColor = MainManager.SI.tableColor
  }
  lazy var menuBtn: UIButton = UIButton().then {
    $0.setImage(UIImage(named: "ic_list"), for: .normal)
  }
  
  private let viewModel: UserMenuViewModelType = UserMenuViewModel()
  private let disposeBag: DisposeBag = DisposeBag()
  
  var leftConstraint: NSLayoutConstraint = NSLayoutConstraint() //메뉴 넓이 제약
  var currentMenu: BehaviorRelay<UserMenuType?> = BehaviorRelay<UserMenuType?>(value: nil) //기본값은 프로필 닐
  var favoriteList: BehaviorRelay<[MovieFavoriteData]> = BehaviorRelay<[MovieFavoriteData]>(value: [])
  
  override func viewWillAppear(_ animated: Bool) {
    userMenuView.userProfile.URLString(urlString: MainManager.SI.userInfo.userProfileImage)
    userMenuView.userName.text = MainManager.SI.userInfo.userName
  }
  override func viewDidLoad() { //버튼 누를 때 마다 값들 가져오기.
    super.viewDidLoad()
    view.backgroundColor = MainManager.SI.bgColor
    layoutSetUp()
    navigationSetUp()
    MainManager.SI.navigationAppearance(navi: navigationController)
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
          self.clearContext(type: UserMenuType.arrays[0])
        case 1:
          self.viewModel.input.inquiryTopList()
          self.clearContext(type: UserMenuType.arrays[1])
        case 2:
          self.clearContext(type: UserMenuType.arrays[2])
          let vc = UserProfileEditViewController()
          self.navigationController?.pushViewController(vc, animated: true)
        case 3://logout
          do  {
            try Auth.auth().signOut()
            MainManager.SI.userInfo = UserInformation(JSON: [:])!
            self.navigationController?.popToRootViewController(animated: true)
          } catch(let err) {
            iPrint(err.localizedDescription)
          }
        default: break
        }
      }).disposed(by: disposeBag)
    
    viewModel.output.favoriteMovies
      .map { list -> [MovieFavoriteData] in
        guard !list.isEmpty else {
          //경고창
          let banner = FloatingNotificationBanner(title: "데이터", subtitle: "즐겨찾기 데이터가 없습니다. 등록 후 이용 바랍니다.", style: .warning)
          banner.show()
          return []
        }
        return list
      }
      .subscribe(onNext: { [weak self] list in
        self?.favoriteList.accept(list)
      }).disposed(by: disposeBag)
    
    favoriteList.filter{!$0.isEmpty}.asDriver(onErrorJustReturn: [])
      .drive(userMenuContentTable.rx.items(cellIdentifier: MovieSearchDetailTableViewCell.cellIdentifier, cellType: MovieSearchDetailTableViewCell.self)) {
        (row, movie, cell) in
        cell.config(info: movie)
      }.disposed(by: disposeBag)
    
    userMenuContentTable.rx.itemSelected.asDriver(onErrorJustReturn: IndexPath())
      .drive(onNext: { [weak self] indexPath in
        guard let self = self else { return }
        guard self.currentMenu.value != UserMenuType.favorite else { //즐겨찾기의 셀을 선택
          let vc = MovieDetailInformationVC()
          vc.movieInformation.movieSeq = self.favoriteList.value[indexPath.row].movieSeq
          self.navigationController?.pushViewController(vc, animated: true)
          self.userMenuContentTable.deselectRow(at: indexPath, animated: false)
          self.clearContext(type: UserMenuType.favorite)
          return
        }
        
        
      }).disposed(by: disposeBag)
  }
  private func clearContext(type: UserMenuType) {
    title = type.rawValue
    userMenuView.frame.origin.x = -4000
    menuBtn.isSelected = false
    self.currentMenu.accept(type)
  }
}
