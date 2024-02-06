//
//  SearchResultViewController.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/22/24.
//

import UIKit
import Then
import Toast

class SearchResultViewController: UIViewController {
  
  //MARK: Outlets
  @IBOutlet weak var totalCountLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var notiImageView: UIImageView!
  @IBOutlet weak var notiLabel: UILabel!
  @IBOutlet weak var sortOptionCollectionView: UICollectionView!
  
  //MARK: Internal Properties
  weak var loadingIndicator: UIActivityIndicatorView?
  
  var searchFilterOptionCellId: String {
    SearchFilterOptionCell.identifier
  }
  
  var searchResultCellId: String { SearchResultCollectionViewCell.identifier
  }
  
  var activeViews: [UIView] {
    [totalCountLabel, collectionView, sortOptionCollectionView]
  }
  
  var inactiveViews: [UIView] {
    [notiImageView, notiLabel]
  }
  
  /// 선택된 정렬 타입
  var selectedSortType: NaverShopSearchEntity.Request.SortType = .sim {
    willSet {
      if self.selectedSortType != newValue {
        self.selectedSortType = newValue
        scrollToTopAndRefresh()
      }
    }
  }
  
  var sortTypeDataSource = [Sort]()
  var searchResultDataSource = [Section]()
  var searchText: String?
  var itemList: [NaverShopSearchEntity.ShopItem] = []
  
  // MARK:
  var request: NaverShopSearchEntity.Request {
    get {
      .init(query: searchText ?? "", display: itemsPerPage, start: (currentPage) * itemsPerPage + 1, sort: selectedSortType)
    }
  }
  
  /// 페이지 정보
  var currentPage = -1
  let itemsPerPage = 30 // 한 페이지당 아이템 개수
  var isLoadingData: Bool = true {
    willSet(newValue) {
      DispatchQueue.main.async {
        if newValue {
          self.loadingIndicator?.startAnimating()
        } else {
          DispatchQueue.main.async {
            self.loadingIndicator?.stopAnimating()
          }
        }
      }
    }
  }
  
  // 데이터 로딩 중인지 여부
  var totalItems: Int? // 총 아이탬 갯수
  
  //MARK: View Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    configureConfigurableMethods()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    refresh()
  }
  
  //MARK: Internal Methods
  /// 페이지당 데이터 불러오기
  func loadDataForPage() {
    
    /// 이미 모든 아이템을 로드한 경우에는 더 이상 요청하지 않고 종료
    if let totalItems, itemList.count >= totalItems {
      return
    }
    
    isLoadingData = true
    self.currentPage += 1
    
    /// 활성화된 로딩 인디케이터를 보이도록 설정
    let request = self.request
    print(request)
    APIService.searchService.callRequest(request: request) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        /// 검색 결과를 products 배열에 추가
        self.totalItems = response.total
        self.itemList.append(contentsOf: response.items)
        self.isLoadingData = false
        refresh()
        
      case .failure(let error):
        view.makeToast("\(error.localizedDescription)", duration: .init(2))
        self.isLoadingData = false
      }
    }
  }
  
  /// 스크롤 뷰를 최상단으로
  func scrollToTopAndRefresh(){
    /// item 전달인자로 주는 값은 음수로 아무거나 줘도 되는것 같은데,, 내부적으로 처리를 해주는 것인지...
    let indexPath = IndexPath(item: -1, section: 0)
    collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
    refreshSortOption()
    resetPagination()
    loadDataForPage()
  }
  
  func refreshSortOption() {
    var sortTypeModels: [SortTypeModel] {
      NaverShopSearchEntity.Request.SortType.allCases.map {
        .init(sortType: $0, isSelected: selectedSortType == $0)
      }
    }
    let sortTypeSection = Sort.sortType(sortTypeModels)
    self.sortTypeDataSource = [sortTypeSection]
    self.sortOptionCollectionView.reloadData()
  }
  
  func refresh() {
    var productModels: [ProductModel] {
      itemList.map{ProductModel(shopItem: $0, isLiked: UserDefaultManager.favoriteProductDict[$0.productId]?.isLiked ?? false)}
    }
    let productSection = Section.product(productModels)
    self.searchResultDataSource = [productSection]
    updateView()
    self.collectionView.reloadData()
  }
  
  func linkToDetail(product: Product){
    let identifier = WebViewController.identifier
    let sb = UIStoryboard(name: identifier, bundle: nil)
    let vc = sb.instantiateViewController(withIdentifier: identifier) as! WebViewController
    vc.product = product
    navigationController?.pushViewController(vc, animated: true)
  }
  
  /// 페이지네이션
  func resetPagination() {
    currentPage = -1
    totalItems = nil
    itemList.removeAll()
  }
}

//MARK: Configure Methods (UI, Layout 등...)
extension SearchResultViewController: UIViewControllerConfigurable {
  
  func updateView(){
    /// 검색 내역이 없다면
    if (itemList.isEmpty) {
      activeViews.forEach{$0.isHidden = true}
      inactiveViews.forEach{$0.isHidden = false}
    } else {
      activeViews.forEach{$0.isHidden = false}
      inactiveViews.forEach{$0.isHidden = true}
    }
    
    totalCountLabel.text = "\(totalItems?.formatterStyle(.decimal) ?? "0") 개의 검색 결과"
  }
  
  func configureView() {
    self.loadingIndicator = UIActivityIndicatorView(style: .large).then {
      $0.center = view.center
      $0.hidesWhenStopped = true
      view.addSubview($0)
    }
  }
  
  func configureCollectionView() {
    
    sortOptionCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.register(UINib(nibName: searchFilterOptionCellId, bundle: nil), forCellWithReuseIdentifier: searchFilterOptionCellId)
      
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      layout.minimumInteritemSpacing = 10
      layout.minimumLineSpacing = 10
      layout.itemSize = CGSize(width: 100, height: 35)
      
      $0.showsHorizontalScrollIndicator = false
      $0.collectionViewLayout = layout
    }
    
    collectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.prefetchDataSource = self
      $0.register(UINib(nibName: searchResultCellId, bundle: nil), forCellWithReuseIdentifier: searchResultCellId)
      /// 레이아웃 설정
      let numberOfColumns: CGFloat = 2
      let interitemSpacing: CGFloat = 5
      let lineSpacing: CGFloat = 10
      
      let totalInteritemSpacing = interitemSpacing * (numberOfColumns - 1)
      let itemWidth = (collectionView.frame.width - totalInteritemSpacing) / numberOfColumns - 20
      let itemHeight = itemWidth / 3 * 5
      
      let layout = UICollectionViewFlowLayout()
      layout.minimumInteritemSpacing = interitemSpacing
      layout.minimumLineSpacing = lineSpacing
      layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
      $0.collectionViewLayout = layout
    }
    
    loadDataForPage()
    
    refreshSortOption()
    refresh()
  }
  func configureLabel() {
    totalCountLabel.textColor = ColorStyle.pointColor
    totalCountLabel.font = FontStyle.systemFont17
    totalCountLabel.numberOfLines = 1
  }
  func configureNavigationBar() {
    navigationItem.title = searchText
  }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if collectionView == sortOptionCollectionView {
      switch self.sortTypeDataSource[indexPath.section] {
      case let .sortType(sortTypeModels):
        return CGSize(width: sortTypeModels[indexPath.item].sortType.label.size(withAttributes: [NSAttributedString.Key.font : FontStyle.systemFont15]).width + 10, height: 30)
      }
    } else {
      
      let layout = collectionViewLayout as! UICollectionViewFlowLayout
      let numberOfItemsInRow: Int = 2
      let itemSpacing = layout.minimumInteritemSpacing
      let sectionInset = layout.sectionInset
      let totalSpacing = (itemSpacing * CGFloat(numberOfItemsInRow - 1)) + sectionInset.left + sectionInset.right
      
      let availableWidth = collectionView.frame.width - totalSpacing
      let itemWidth = availableWidth / CGFloat(numberOfItemsInRow)
      
      return CGSize(width: itemWidth, height: itemWidth/3*5)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch self.searchResultDataSource[indexPath.section] {
    case .product(let productModels):
      let productModel = productModels[indexPath.item]
      let shopItem = productModel.shopItem
      
      let product = Product(
        id: shopItem.productId,
        name: shopItem.title,
        isLiked: productModel.isLiked
      )
      
      linkToDetail(product: product)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == sortOptionCollectionView {
      switch self.sortTypeDataSource[section] {
      case let .sortType(sortTypeModels):
        return sortTypeModels.count
      }
    } else {
      switch self.searchResultDataSource[section] {
      case let .product(productModels):
        return productModels.count
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if collectionView == sortOptionCollectionView {
      switch self.sortTypeDataSource[indexPath.section] {
      case let .sortType(sortTypeModels):
        
        let cell = sortOptionCollectionView.dequeueReusableCell(withReuseIdentifier: searchFilterOptionCellId, for: indexPath) as! SearchFilterOptionCell
        
        var sortTypeModel = sortTypeModels[indexPath.item]
        let sortType = sortTypeModel.sortType
        
        cell.prepare(
          content: sortType.label,
          isSelected: sortTypeModel.isSelected,
          action: {
            self.selectedSortType = sortType
          }
        )
        
        return cell
      }
      
    } else {
      switch self.searchResultDataSource[indexPath.section] {
      case let .product(productModels):
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: searchResultCellId, for: indexPath) as! SearchResultCollectionViewCell
        
        
        /// 여기서 터진다...
        let productModel = productModels[indexPath.item]
        let shopItem = productModel.shopItem
        
        cell.prepare(
          image: shopItem.image,
          mallName: shopItem.mallName,
          title: shopItem.title,
          lprice: shopItem.lprice.formattedWithSeparator(),
          isLike: productModel.isLiked,
          action: {
            /// 이렇게 액션으로 넘겨줘도 되는걸까....
            UserDefaultManager.updateFavoriteProducts(product: Product(id: productModel.shopItem.productId, name: productModel.shopItem.title, isLiked: !productModel.isLiked))
            
            /// cost 엄청 큼......
            /// 하나의 item 셀만 refresh 하도록 개선해야함..
            self.refresh()
          }
        )
        return cell
      }
    }
  }
}

extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
  
  /// 미리 데이터를 로딩하기 위한 메서드
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    /// 다음 페이지의 데이터 로드
    if !isLoadingData && indexPaths.contains(where: { $0.item >= itemList.count - 10 }) {
      loadDataForPage()
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.size.height {
      if let totalItems, itemList.count >= totalItems {
        view.makeToast("마지막 상품입니다", duration: .init(2))
        return
      }
    }
  }
}

extension SearchResultViewController {
  enum Section {
    case product([ProductModel])
  }
  
  struct ProductModel {
    let shopItem: NaverShopSearchEntity.ShopItem
    var isLiked: Bool
  }
}

extension SearchResultViewController {
  enum Sort {
    case sortType([SortTypeModel])
  }
  struct SortTypeModel {
    let sortType: NaverShopSearchEntity.Request.SortType
    let isSelected: Bool
  }
}
