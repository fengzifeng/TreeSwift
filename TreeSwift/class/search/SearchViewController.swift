//
//  SearchViewController.swift
//  TreeSwift
//
//  Created by 冯子丰 on 2023/11/6.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchViewController: BaseViewController {
    
    var searchResultView: SearchResultView?
    
    lazy var searchView: SearchView = SearchView.init(frame: CGRect(x: 0, y: searchBarView.bottom, width: ScreenWidth, height: ScreenHeigth - searchBarView.bottom))

                                                        
    lazy var searchBarView = {
        let searchBarView = SearchBarView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 55+StateBarH))
        
        searchBarView.reloadResultView = {
            [weak self] text in
            self?.addSearchResultView(text: text)
        }
        
        return searchBarView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarView.textField.deleteAll = {
            [weak self] in
            self?.searchResultView?.removeFromSuperview()
            self?.updateHistory()
        }
        view.addSubview(searchBarView)
        view.addSubview(searchView)
    }
    
    func addSearchResultView(text:String) {
        searchResultView?.removeFromSuperview()
        let searchResultView: SearchResultView = SearchResultView.init(frame: searchView.frame)
        searchResultView.titleStr = text
        view.addSubview(searchResultView)
        self.searchResultView = searchResultView
        searchResultView.requestData()
        searchBarView.textField.text = text
        searchResultView.updateHistoryArray()
    }
    
    func updateHistory()  {
        var array = UserDefaults.standard.object(forKey: UserDefaultKey_HistorySearch)
        if(array == nil){
            array =  Array<Any>()
        }
        
        searchView.historyArray = array as! [Any]
        searchView.tableView.reloadData()
    }
    
}

