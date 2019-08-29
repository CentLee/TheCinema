//
//  MovieDetailHeaderV.swift
//  TheCinema
//
//  Created by ChLee on 28/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import Foundation

class MovieDetailHeaderV: UIView { //헤더 섹션 뷰
  
  lazy var title: UILabel = UILabel()
  
  lazy var btn: UIButton = UIButton().then {
    $0.isHidden = true
    $0.setTitle("전체보기", for: .normal)
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
  }
  
  convenience init(text: String) {
    self.init(frame: .zero)
    title.text = text
    backgroundColor = .white
    layoutSetUp()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
extension MovieDetailHeaderV {
  private func layoutSetUp() {
    addSubview(title)
    
    constrain(title) {
      $0.centerY == $0.superview!.centerY
      $0.left    == $0.superview!.left + 10
    }
  }
}