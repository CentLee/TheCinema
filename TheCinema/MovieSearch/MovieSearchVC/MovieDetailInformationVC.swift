//
//  MovieDetailInformationVC.swift
//  TheCinema
//
//  Created by ChLee on 27/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import UIKit

enum MovieDetailType: String {
  case summary = "요약정보"
  case plot = "줄거리"
  case comment = "최근 리뷰"
  
  static var arrays: [MovieDetailType] {
    return [.summary, .plot, .comment]
  }
}
class MovieDetailInformationVC: UIViewController { //영화 상세정보 ( 리뷰 즐겨찾기
  //데이터 들어오면 리뷰랑 즐겨찾기 가져온다. 영화 이름에 해당하는 코멘트만.
  //테이블 뷰 섹션 멀티플로 구성.
  lazy var movieInfoTable: UITableView = UITableView(frame: .zero, style: .grouped).then {
    $0.estimatedRowHeight = 50 // 기본은 이정도.. 셀마다 각자 지정예정이고 한줄평과 줄거리 감독출연등은 다이나믹
    $0.rowHeight = UITableView.automaticDimension
    $0.separatorStyle = .none
    $0.delegate = self
    $0.dataSource = self
    $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    $0.register(MovieSummaryTableViewCell.self, forCellReuseIdentifier: MovieSummaryTableViewCell.cellIdentifier)
    $0.register(MoviePlotTableViewCell.self, forCellReuseIdentifier: MoviePlotTableViewCell.cellIdentifier)
    $0.register(MovieCommentTableViewCell.self, forCellReuseIdentifier: MovieCommentTableViewCell.cellIdentifier)
  }
  
  var movieInformation: MovieGenreData = MovieGenreData(JSON: [:])! {
    didSet {
      //영화 코멘트들 가져오면서 데이터 바인드 및 리로드.
     
    }
  }
  var comments: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = .white
      layoutSetUp()
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "리뷰", style: .plain, target: self, action: #selector(commentWrite))
        // Do any additional setup after loading the view.
    }
}
extension MovieDetailInformationVC {
  @objc private func commentWrite() {
    let vc = MovieCommentVC()
    vc.movieId = movieInformation.movieSeq
    present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
  }
  private func layoutSetUp() {
    view.addSubview(movieInfoTable)
    
    constrain(movieInfoTable) {
      $0.edges == $0.superview!.edges
    }
    
    movieInfoTable.reloadData()
  }
}

extension MovieDetailInformationVC: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 2 ? comments.count : 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0: //요약정보
      guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieSummaryTableViewCell.cellIdentifier, for: indexPath) as? MovieSummaryTableViewCell else { return UITableViewCell()}
      cell.config(info: movieInformation)
      return cell
    case 1:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: MoviePlotTableViewCell.cellIdentifier, for: indexPath) as? MoviePlotTableViewCell else { return UITableViewCell()}
      iPrint(movieInformation.plot)
      cell.plot.text = movieInformation.plot
      return cell
    case 2: break
    default:break
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let v = MovieDetailHeaderV(text: MovieDetailType.arrays[section].rawValue)
    v.btn.isHidden = section != 2
    return v
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let v: UIView = UIView()
    v.backgroundColor = .clear//UIColor.lightGray.withAlphaComponent(0.5)
    return v
  }
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return section == 2 ? 0 : 10
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}
