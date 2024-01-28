//
//  WebViewController.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/22/24.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
  
  @IBOutlet weak var webView: WKWebView!
  var likeButton: UIBarButtonItem!
  var product: Product!
  
  var url: URL? {
    "https://msearch.shopping.naver.com/product/\(product.id)".toURL()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureConfigurableMethods()
  }
  
  @objc func likeButtonTapped() {
    /// 좋아요 버튼이 눌렸을 때, Product 모델의 좋아요 상태를 토글
    product.toggleLike()
    
    /// 좋아요 버튼 이미지 업데이트
    if let likeButton = navigationItem.rightBarButtonItem {
      likeButton.image = product.isLiked ? ImageStyle.heartFill : ImageStyle.heartEmpty
    }
  }
}

extension WebViewController: UIViewControllerConfigurable {
  
  func configureView() {
    setDefaultBackground()
  }
  
  func updateLikeButtonState() {
    likeButton.image = product.isLiked ? ImageStyle.heartFill : ImageStyle.heartEmpty
  }
  
  func configureWebView() {
    /// URL이 유효한 경우에만 로드
    if let validURL = url {
      let request = URLRequest(url: validURL)
      webView.load(request)
    }
  }
  
  func configureNavigationBar() {
    
    /// 좋아요 버튼 생성
    likeButton = UIBarButtonItem(image: product.isLiked ? ImageStyle.heartFill : ImageStyle.heartEmpty, style: .plain, target: self, action: #selector(likeButtonTapped))
    likeButton.tintColor = ColorStyle.tintColor
    
    /// 좋아요 버튼을 내비게이션 바 우측 상단에 추가
    navigationItem.rightBarButtonItem = likeButton
    
    /// 네비게이션 타이틀
    navigationItem.title = product.name.htmlToAttributedString(font: FontStyle.systemFont15, color: ColorStyle.tintColor, lineHeight: 22)?.string
  }
}
