//
//  ProfileImage.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/22/24.
//

import UIKit

struct ProfileImage: Codable, Identifiable {
  
  static let imageList: [ProfileImage] = {
    var images: [ProfileImage] = []
    for index in 1...14 {
      images.append(ProfileImage(imageName: "profile\(index)"))
    }
    return images
  }()
  
  var id: UUID = UUID()
  let imageName: String
  var image: UIImage? {
    return UIImage(named: imageName)
  }
  
  init(imageName: String) {
    self.imageName = imageName
  }
}
