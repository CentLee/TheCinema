//
//  UiExtension.swift
//  TheCinema
//
//  Created by SatGatLee on 08/08/2019.
//  Copyright © 2019 com.example. All rights reserved.
//

import Foundation

extension UIButton {
  func URLString(urlString: String, state: UIControl.State) {
    guard urlString != "" else {
      setImage(UIImage(named: "profileEdit"), for: .normal)
      return
    }
    let url = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
    guard let img_url = URL(string: url) else { return }
    
    let resource = ImageResource(downloadURL: img_url, cacheKey: url)
    kf.setImage(with: resource, for: state)
  }
}
extension UIImageView {
  func URLString(urlString: String) {
    guard urlString != "" else {
      self.image = UIImage(named: "movieEmpty")
      return
    }
    let url = String(urlString.split(separator: "|")[0]).trimmingCharacters(in: .whitespacesAndNewlines)
    guard let img_url = URL(string: url) else { return }
    
    let resource = ImageResource(downloadURL: img_url, cacheKey: url)
    
    kf.setImage(with: resource)
  }
}
