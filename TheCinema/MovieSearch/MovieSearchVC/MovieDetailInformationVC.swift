//
//  MovieDetailInformationVC.swift
//  TheCinema
//
//  Created by ChLee on 27/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import UIKit

class MovieDetailInformationVC: UIViewController { //영화 상세정보 ( 리뷰 즐겨찾기
  //데이터 들어오면 리뷰랑 즐겨찾기 가져온다. 영화 이름에 해당하는 코멘트만.
  //테이블 뷰 섹션 멀티플로 구성.
  lazy var movieInfoTable: UITableView = UITableView().then {
    $0.estimatedRowHeight = 50 // 기본은 이정도.. 셀마다 각자 지정예정이고 한줄평과 줄거리 감독출연등은 다이나믹
    $0.rowHeight = UITableView.automaticDimension
    $0.separatorStyle = .none
    $0.delegate = self
    $0.register(MovieSummaryTableViewCell.self, forCellReuseIdentifier: MovieSummaryTableViewCell.cellIdentifier)
  }
  
  var movieInformation: MovieGenreData = MovieGenreData(JSON: [:])! {
    didSet {
      //영화 코멘트들 가져오면서 데이터 바인드 및 리로드.
    }
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
}
extension MovieDetailInformationVC {
  private func layoutSetUp() {
    
  }
}

extension MovieDetailInformationVC: UITableViewDelegate {
  
}
