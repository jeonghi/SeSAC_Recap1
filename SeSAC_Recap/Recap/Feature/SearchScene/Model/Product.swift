//
//  Product.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/22/24.
//

struct Product: Identifiable, Codable {
  let id: String
  let name: String
  var isLiked: Bool {
    willSet {
      self.isLiked = newValue
      UserDefaultManager.updateFavoriteProducts(product: self)
    }
  }/// 좋아요 여부를 나타내는 Bool 프로퍼티
  
  /// 좋아요 상태를 토글하는 메서드
  mutating func toggleLike() {
    isLiked.toggle()
  }
}
