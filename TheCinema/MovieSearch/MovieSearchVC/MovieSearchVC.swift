//
//  MovieSearchVC.swift
//  TheCinema
//
//  Created by SatGatLee on 21/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import UIKit

class MovieSearchVC: UIViewController { //장르별 검색 및 단일 검색
//  let genre: [[String : UIImage]] = [["공포":UIImage(named: "Fear")!], ["로맨스":UIImage(named: "Romance")!],
//                                     ["뮤지컬":UIImage(named: "Musical")!], ["애니메이션":UIImage(named: "Animation")!],
//                                     ["액션":UIImage(named: "Action")!], ["코미디":UIImage(named: "Comedy")!],
//                                     ["판타지":UIImage(named: "Fantasy")!], ["SF":UIImage(named: "SF")!]]
  
  lazy var movieSearchV: MovieSerachV = MovieSerachV().then {
    $0.backgroundColor = .white
  }
  
  private let viewModel: MovieGenreSearchType = MovieGenreSearchVM()
  private let disposeBag: DisposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    layoutSetUp()
    bind()
  }
}
extension MovieSearchVC {
  private func layoutSetUp() {
    view.addSubview(movieSearchV)
    
    constrain(movieSearchV) {
      $0.edges == $0.superview!.safeAreaLayoutGuide.edges
    }
  }
  
  private func bind() {
    movieSearchV.genreCollection.dataSource = nil
    
    Observable.just(MovieGenreType.arrays).asDriver(onErrorJustReturn: [])
      .drive(movieSearchV.genreCollection.rx.items(cellIdentifier: MovieGenreCollectionViewCell.cellIdentifier, cellType: MovieGenreCollectionViewCell.self)) { (row, viewModel, userCell) in
        //MovieGenreType.
        userCell.config(type: MovieGenreType.arrays[row])
        //userCell.config(dic: self.genre[row])
    }.disposed(by: disposeBag)
  
    movieSearchV.genreCollection.rx.itemSelected
    .asDriver(onErrorJustReturn: IndexPath(row: 0, section: 0))
      .drive(onNext: { (indexPath) in
        //guard let genre: String = self.genre[indexPath.row].keys.first else { return }
        let vc = MovieGenreVC()
        self.navigationController?.pushViewController(vc, animated: true)
        self.viewModel.inputs.genre.accept(MovieGenreType.arrays[indexPath.row].rawValue)
      }).disposed(by: disposeBag)
  }
}

