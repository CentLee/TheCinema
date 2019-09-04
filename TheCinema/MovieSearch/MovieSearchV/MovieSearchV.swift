//
//  MovieSearchV.swift
//  TheCinema
//
//  Created by SatGatLee on 21/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import Foundation

class MovieSerachV: UIView {
  
  lazy var searchPanel: MovieSearchPanelV = MovieSearchPanelV().then {
    $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    $0.layer.cornerRadius = 10
  }
  
  lazy var searchTitle: UILabel = UILabel().then {
    $0.text = "찾고 싶은 영화의 장르를 선택해보세요"
  }
  
  lazy var genreCollection: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    layout.itemSize = CGSize(width: screenWidth / 2 - 20, height: 130)
    layout.scrollDirection = .vertical
    $0.collectionViewLayout = layout
    $0.register(MovieGenreCollectionViewCell.self, forCellWithReuseIdentifier: MovieGenreCollectionViewCell.cellIdentifier)
    $0.backgroundColor = .white
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    layoutSetUp()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init() error")
  }
}
extension MovieSerachV {
  private func layoutSetUp() {
    [searchPanel, searchTitle, genreCollection].forEach { self.addSubview($0) }
    //[searchIcn, searchField].forEach { self.searchPanel.addSubview($0) }
    
    constrain(searchPanel) {
      $0.height == 30
      $0.left   == $0.superview!.left + 10
      $0.right  == $0.superview!.right - 10
      $0.top    == $0.superview!.top + 20
    }
    
    constrain(searchTitle, searchPanel) {
      $0.top  == $1.bottom + 30
      $0.left == $1.left
    }
    
    constrain(genreCollection, searchTitle) {
      $0.top    == $1.bottom + 20
      $0.bottom == $0.superview!.bottom
      $0.left   == $0.superview!.left
      $0.right  == $0.superview!.right
    }
  }
}
