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
    let url = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
    guard let img_url = URL(string: url) else { return }
    
    let resource = ImageResource(downloadURL: img_url, cacheKey: url)
    kf.setBackgroundImage(with: resource, for: state)
  }
}
