//
//  BoxOfficeVC.swift
//  TheCinema
//
//  Created by SatGatLee on 10/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import UIKit
import FSPagerView

class BoxOfficeVC: UIViewController { //일일 박스오피스 뷰. 유저 디폴트 값에 현재 런칭 했을 때의 날짜 값을 들고오고 날짜 값이 없거나 다를경우 최신화 해서 갖고 온다 그럼 매일 최신화 되는 거승로.
  //상세 정보는 movieDetailInfoVC 사용.
  lazy var boxOfficePageView: FSPagerView = FSPagerView().then {
    $0.register(MovieGenrePagerCell.self, forCellWithReuseIdentifier: MovieGenrePagerCell.cellIdentifier)
    $0.backgroundColor = .clear
    $0.transformer = FSPagerViewTransformer(type: .linear)
    $0.itemSize = CGSize(width: screenWidth / 1.5, height: 290)
    $0.delegate = self
    $0.dataSource = self
  }
  
  lazy var backImageView: UIImageView = UIImageView()
  lazy var boxOfficeInfoV: UIView = UIView().then { //박스 오피스 영화의 간략 정보 뷰
    $0.backgroundColor = .white
  }
  lazy var rank: UILabel = UILabel()
  lazy var name: UILabel = UILabel()
  lazy var audience: UILabel = UILabel()
  lazy var openDate: UILabel = UILabel()
  lazy var infoStack: UIStackView = UIStackView().then {
    $0.axis = .vertical
    $0.distribution = .equalSpacing
    $0.spacing = 10
    $0.alignment = .center
  }
  
  private let viewModel: BoxOfficeType = BoxOfficeVM()
  private let disposeBag: DisposeBag = DisposeBag()
  private let boxOfficeList: BehaviorRelay<[MovieGenreData]> = BehaviorRelay<[MovieGenreData]>(value: [])
  private let formatter: DateFormatter = DateFormatter().then {
    $0.dateFormat = "YYYYMMdd"
  }
  private var previousIndex: Int = 0
  
  override func viewWillAppear(_ animated: Bool) {
    guard let currentDate = UserDefaults().string(forKey: "currentDate"), currentDate != "" else { //파싱했으나 데이터가 공백이면 바로 파싱
      viewModel.input.boxOfficeSearch(date: formatter.string(from: Date().addingTimeInterval(-86400))) //오늘 데이터로 파싱
      UserDefaults.standard.set(formatter.string(from: Date().addingTimeInterval(-86400)), forKey: "currentDate")
      return
    }
    //값이 있다?
    guard let date = formatter.date(from: currentDate)?.compare(Date()) , date == ComparisonResult.orderedSame ||  date == ComparisonResult.orderedDescending else { return }
    
    viewModel.input.boxOfficeSearch(date: formatter.string(from: Date().addingTimeInterval(-86400))) //오늘 데이터로 파싱
    UserDefaults.standard.set(formatter.string(from: Date().addingTimeInterval(-86400)), forKey: "currentDate")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    // Do any additional setup after loading the view.
  }
}
extension BoxOfficeVC {
  private func layoutSetUp() {
    view.addSubview(backImageView)
    view.addSubview(boxOfficePageView)
    view.addSubview(boxOfficeInfoV)
    boxOfficeInfoV.addSubview(infoStack)
    [rank, name, audience, openDate].forEach { self.infoStack.addArrangedSubview($0) }
    
    constrain(backImageView) {
      $0.edges == $0.superview!.safeAreaLayoutGuide.edges
    }
    
    constrain(boxOfficePageView) {
      $0.left    == $0.superview!.left
      $0.right   == $0.superview!.right
      $0.height  == 300
      $0.centerY == $0.superview!.centerY
    }
    
    constrain(boxOfficeInfoV, boxOfficePageView) {
      $0.width   == 200
      $0.height  == 100
      $0.top     == $1.bottom + 20
      $0.centerX == $0.superview!.centerX
    }
    
    constrain(infoStack) {
      $0.edges == $0.superview!.edges
    }
  }
  
  private func bind() {
    viewModel.output.boxOfficeInfo.asDriver(onErrorJustReturn: [])
      .drive(onNext: { [weak self] list in
        self?.boxOfficePageView.reloadData()
      }).disposed(by: disposeBag)
  }
  
  private func dataBind(index: Int) {
    let numberFormatter: NumberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    guard let audi = numberFormatter.string(from: NSNumber(value: Int(viewModel.output.boxOffice[index].audience)!)) else { return }
    backImageView.URLString(urlString: boxOfficeList.value[index].poster)
    
    rank.text = "순위 : \(viewModel.output.boxOffice[index].rank)"
    name.text = "제목 : \(viewModel.output.boxOffice[index].movieName)"
    audience.text = "관객 : " + audi + "명"
    openDate.text = "개봉 : \(viewModel.output.boxOffice[index].openDate)"
  }
}
extension BoxOfficeVC: FSPagerViewDelegate, FSPagerViewDataSource {
  func numberOfItems(in pagerView: FSPagerView) -> Int {
    return boxOfficeList.value.count
  }
  
  func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
    guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: MovieGenrePagerCell.cellIdentifier, at: index) as? MovieGenrePagerCell else { return FSPagerViewCell() }
    cell.configPage(movie: boxOfficeList.value[index])
    return cell
  }
  
  func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
    if previousIndex != targetIndex && previousIndex != boxOfficeList.value.count - 1 {
      dataBind(index: targetIndex)
    }
    previousIndex = targetIndex
  }
}
