//
//  MoviePlotTableViewCell.swift
//  TheCinema
//
//  Created by ChLee on 28/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import UIKit

class MoviePlotTableViewCell: UITableViewCell {
  static let cellIdentifier: String = String(describing: MoviePlotTableViewCell.self)
  
  lazy var plot: UILabel = UILabel().then {
    $0.numberOfLines = 0
    $0.lineBreakMode = .byWordWrapping
    $0.textColor = .black
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layoutSetUp()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init() Error")
  }
}
extension MoviePlotTableViewCell {
  private func layoutSetUp() {
    contentView.addSubview(plot)
    
    constrain(plot) {
      $0.left   == $0.superview!.left + 10
      $0.top    == $0.superview!.top
      $0.right  == $0.superview!.right - 10
      $0.bottom <= $0.superview!.bottom - 10
    }
  }
}