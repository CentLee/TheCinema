//
//  MovieSearchVC.swift
//  TheCinema
//
//  Created by SatGatLee on 21/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import UIKit

class MovieSearchVC: UIViewController { //장르별 검색 및 단일 검색
  let genre: [[String : UIImage]] = [["공포":UIImage(named: "Fear")!], ["로맨스":UIImage(named: "Romance")!],
                                     ["뮤지컬":UIImage(named: "Musical")!], ["애니메이션":UIImage(named: "Animation")!],
                                     ["액션":UIImage(named: "Action")!], ["코미디":UIImage(named: "Comedy")!],
                                     ["판타지":UIImage(named: "Fantasy")!], ["SF":UIImage(named: "SF")!]]
  
  lazy var movieSearchV: MovieSerachV = MovieSerachV().then {
    $0.backgroundColor = .white
  }
  
  private let viewModel: MovieGenreSearchType = MovieGenreSearchVM()
  private let disposeBag: DisposeBag = DisposeBag()
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    layoutSetUp()
    // Do any additional setup after loading the view.
    bind()
  }
}
extension MovieSearchVC {
  private func layoutSetUp() {
    view.addSubview(movieSearchV)
    
    constrain(movieSearchV) {
      $0.edges == $0.superview!.safeAreaLayoutGuide.edges
    }
    
//    movieSearchV.genreCollection.dataSource = self
//    movieSearchV.genreCollection.delegate = self
//    movieSearchV.genreCollection.reloadData()
  }
  
  private func bind() {
    movieSearchV.genreCollection.dataSource = nil
    
    Observable.just(genre).asDriver(onErrorJustReturn: [])
      .drive(movieSearchV.genreCollection.rx.items(cellIdentifier: MovieGenreCollectionViewCell.cellIdentifier, cellType: MovieGenreCollectionViewCell.self)) { (row, viewModel, userCell) in
        userCell.config(dic: self.genre[row])
    }.disposed(by: disposeBag)
  
    movieSearchV.genreCollection.rx.itemSelected
    .asDriver(onErrorJustReturn: IndexPath(row: 0, section: 0))
      .drive(onNext: { [weak self] (indexPath) in
        guard let genre: String = genre[indexPath.row].keys.first else { return }
        self?.viewModel.inputs.genre.accept(genre)
      }).disposed(by: disposeBag)
  }
}

//extension MovieSearchVC: UICollectionViewDataSource, UICollectionViewDelegate {
//  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    return 8
//  }
//
//  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieGenreCollectionViewCell.cellIdentifier, for: indexPath) as! MovieGenreCollectionViewCell
//    cell.config(index: indexPath.row)
//    return cell
//  }
//}
