//
//  SearchViewController.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/21/24.
//

import UIKit
import Then

class SearchViewController: UIViewController {
  
  var navigationTitle: String {
    "\(UserDefaultManager.profileInfo.nickName ?? "")님의 새싹쇼핑"
  }
  
  var searchHistoryLog: [SearchHistory] {
    get {
      UserDefaultManager.searchHistoryLog.sorted(by: {$0.searchDate > $1.searchDate})
    }
    set {
      UserDefaultManager.searchHistoryLog = newValue
    }
  }
  
  var dataSource = [Section]()
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  @IBOutlet weak var headerView: UIStackView!
  @IBOutlet weak var headerLabel: UILabel!
  @IBOutlet weak var headerButton: UIButton!
  
  @IBOutlet weak var notiView: UIStackView!
  @IBOutlet weak var notiLabel: UILabel!
  
  @IBOutlet weak var searchHistoryTableView: UITableView!
  
  var recog: UIGestureRecognizer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureConfigurableMethods()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    updateView()
    refresh()
  }
  
  @objc func tappedClearButton(_ sender: UIButton){
    searchHistoryLog = []
    refresh()
  }
  
  func navToSearchResult(_ searchText: String){
    let identifier = SearchResultViewController.identifier
    let sb = UIStoryboard(name: identifier, bundle: nil)
    let vc = sb.instantiateViewController(withIdentifier: identifier) as! SearchResultViewController
    vc.searchText = searchText
    navigationController?.pushViewController(vc, animated: true)
    /// 검색 버튼이 눌렸을 때 검색 내역에 비동기로 추가
    DispatchQueue.global().async {
      let newSearchHistory = SearchHistory(searchTerm: searchText)
      
      /// 중복된 항목 검사 및 제거
      if let index = self.searchHistoryLog.firstIndex(where: { $0.searchTerm == newSearchHistory.searchTerm }) {
        self.searchHistoryLog.remove(at: index)
      }
      self.searchHistoryLog.append(newSearchHistory)
    }
  }
  
  private func refresh() {
    let searchHistoryModels: [SearchHistoryModel] = searchHistoryLog.map {
      .init(searchHistory: $0)
    }
    let searchHistorySection = Section.searchHistory(searchHistoryModels)
    
    self.dataSource = [searchHistorySection]
    
    updateView()
    
    self.searchHistoryTableView.reloadData()
  }
}

extension SearchViewController: UIViewControllerConfigurable {
  
  func updateView(){
    
    self.navigationItem.title = navigationTitle
    
    let notiBound = [notiView]
    let searchHistoryBound = [headerView, searchHistoryTableView]
    
    /// 검색 내역이 없다면
    if searchHistoryLog.isEmpty {
      
      /// 노티 부분을 나타냄
      notiBound.forEach { $0?.isHidden = false }
      searchHistoryBound.forEach{ $0?.isHidden = true }
    } else {
      notiBound.forEach { $0?.isHidden = true }
      searchHistoryBound.forEach { $0?.isHidden = false }
    }
  }
  
  @objc func tappedAroundView(){
    view.endEditing(true)
  }
  
  func configureView(){
    self.recog = UITapGestureRecognizer().then {
      $0.addTarget(self, action: #selector(tappedAroundView))
      $0.isEnabled = false
      self.view.addGestureRecognizer($0)
    }
  }
  
  func configureTableView() {
    
    let identifier = SearchHistoryCell.identifier
    
    searchHistoryTableView.do {
      $0.dataSource = self
      $0.delegate = self
      $0.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    refresh()
  }
  
  func configureNavigationBar() {
    self.navigationItem.title = navigationTitle
  }
  
  func configureSeachBar() {
    searchBar.do {
      $0.delegate = self
      $0.placeholder = "브랜드, 상품, 프로필, 태그 등"
    }
  }
  
  func configureLabel() {
    headerLabel.do {
      $0.font = FontStyle.systemFont15
      $0.textColor = ColorStyle.tintColor
      $0.text = "최근 검색"
    }
    
    notiLabel.do {
      $0.font = FontStyle.systemFont17
      $0.textColor = ColorStyle.tintColor
      $0.text = "최근 검색어가 없어요"
    }
  }
  
  func configureButton() {
    headerButton.setTitle("모두 지우기", for: .normal)
    headerButton.setTitleColor(ColorStyle.pointColor, for: .normal)
    headerButton.addTarget(self, action: #selector(tappedClearButton), for: .touchUpInside)
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    /// white space 처리
    if let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty {
      
      /// 내비게이션으로 이동
      navToSearchResult(searchText)
    }
    
    searchBar.resignFirstResponder() /// 키보드를 숨김.
  }
  
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    recog?.isEnabled = true
    return true
  }
  
  func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
    recog?.isEnabled = false
    return true
  }
}

extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    switch dataSource[indexPath.section] {
    case let .searchHistory(
      searchHistoryModels):
      let searchHistoryModel = searchHistoryModels[indexPath.row]
      navToSearchResult(searchHistoryModel.searchHistory.searchTerm)
    }
    return
  }
}

extension SearchViewController: UITableViewDataSource{
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch self.dataSource[indexPath.section] {
    case let .searchHistory(searchHistoryModels):
      let identifier = SearchHistoryCell.identifier
      let cell = searchHistoryTableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SearchHistoryCell
      let searchHistoryModel = searchHistoryModels[indexPath.row]
      cell.prepare(
        content: searchHistoryModel.searchHistory.searchTerm,
        action: {
          self.searchHistoryLog.remove(at: indexPath.row)
          self.refresh()
        })
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch self.dataSource[indexPath.section] {
    case .searchHistory:
      return 50
    }
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch self.dataSource[section] {
    case let .searchHistory( searchHistoryModels):
      searchHistoryModels.count
    }
  }
}

extension SearchViewController {
  
  enum Section {
    case searchHistory([SearchHistoryModel])
  }
  
  struct SearchHistoryModel {
    let searchHistory: SearchHistory
  }
}
