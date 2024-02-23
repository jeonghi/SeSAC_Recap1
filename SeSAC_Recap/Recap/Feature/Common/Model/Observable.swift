//
//  Observable.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 2/22/24.
//

import Foundation

// ⭐️ class로 할때랑 struct로 할때의 차이

class Observable<T> {
  
  var wrappedValue: T {
    didSet {
      _closure?(wrappedValue)
    }
  }
  
  private var _closure: ((T) -> Void)?
  
  init(_ wrappedValue: T) {
    self.wrappedValue = wrappedValue
  }
  
  func bind(_ closure: ((T) -> Void)?) {
    closure?(wrappedValue)
    _closure = closure
  }
}
