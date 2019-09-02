//
//  MovieSearchVC.swift
//  TheCinema
//
//  Created by SatGatLee on 21/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import UIKit

class MovieSearchVC: UIViewController { //장르별 검색 및 단일 검색
  
  lazy var movieSearchV: MovieSerachV = MovieSerachV().then {
    $0.backgroundColor = .white
  }
  
  private let viewModel: MovieGenreSearchType = MovieGenreSearchVM()
  private let disposeBag: DisposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    title = "검색"
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
        userCell.config(type: MovieGenreType.arrays[row])
        //userCell.config(dic: self.genre[row])
      }.disposed(by: disposeBag)
    
    movieSearchV.genreCollection.rx.itemSelected
      .asDriver(onErrorJustReturn: IndexPath(row: 0, section: 0))
      .drive(onNext: { [weak self] (indexPath) in
        guard let self = self else { return }
        let vc = MovieGenreVC()
        vc.genre = MovieGenreType.arrays[indexPath.row].rawValue
        self.navigationController?.pushViewController(vc, animated: true)
      }).disposed(by: disposeBag)
    
    movieSearchV.searchPanel.searchField.rx.controlEvent(.editingDidBegin).asDriver(onErrorJustReturn: ())
      .drive(onNext: { [weak self] _ in
        let vc = MovieDetailSearchVC()
        self?.navigationController?.pushViewController(vc, animated: true)
        self?.movieSearchV.searchPanel.searchField.resignFirstResponder()
        vc.searchPanel.searchField.becomeFirstResponder()
        //      self?.present(UINavigationController(rootViewController: vc), animated: true, completion: {
        //        self?.movieSearchV.searchPanel.searchField.resignFirstResponder()
        //      })
      }).disposed(by: disposeBag)
    //    movieSearchV.searchPanel.searchField.rx..asDriver(onErrorJustReturn: nil)
    //      .drive(onNext: { [weak self] _ in
    //        let vc = MovieDetailSearchVC()
    //        self?.present(UINavigationController(rootViewController: vc), animated: true, completion: {
    //          self?.movieSearchV.searchPanel.searchField.resignFirstResponder()
    //        })
    //      }).disposed(by: disposeBag)
  }
}

