//
//  MovieGenreVC.swift
//  TheCinema
//
//  Created by SatGatLee on 22/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import UIKit
import FSPagerView

class MovieGenreVC: UIViewController { //장르별 영화를 보여주는 테이블 뷰 근데 콜렉션 셀을 사용할 것 같다
  lazy var movieGenrePageView: FSPagerView = FSPagerView().then {
    $0.register(MovieGenrePagerCell.self, forCellWithReuseIdentifier: MovieGenrePagerCell.cellIdentifier)
    $0.backgroundColor = .clear
    $0.transformer = FSPagerViewTransformer(type: .linear)
    $0.itemSize = CGSize(width: screenWidth / 1.5, height: 300)
  }
  
  lazy var backImageView: UIImageView = UIImageView().then { _ in }
  
  private let viewModel: MovieGenreSearchType = MovieGenreSearchVM()
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    // Do any additional setup after loading the view.
    layoutSetUp()
  }
}
extension MovieGenreVC {
  private func layoutSetUp() {
    view.addSubview(backImageView)
    view.addSubview(movieGenrePageView)
    
    constrain(backImageView) {
      $0.edges == $0.superview!.edges
    }
    
    constrain(movieGenrePageView) {
      $0.left    == $0.superview!.left
      $0.right   == $0.superview!.right
      $0.height  == 300
      $0.centerY == $0.superview!.centerY
    }
  }
}
