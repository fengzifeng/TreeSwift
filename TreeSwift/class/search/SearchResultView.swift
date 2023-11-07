//
//  SearchResultView.swift
//  TreeSwift
//
//  Created by 冯子丰 on 2023/11/7.
//

import UIKit
import KakaJSON
import SwiftyJSON
import Alamofire
import MJRefresh

class SearchResultView: UIView {
    var titleStr: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
//        self.view.backgroundColor = UIColor.red;
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: requestData)
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: requestMoreData)
        addSubview(tableView)
//        tableView.did
//        requestData()
        
    }
    
    func updateHistoryArray() {
        var array: [Any]? = UserDefaults.standard.object(forKey: UserDefaultKey_HistorySearch) as? [Any]
        if(array == nil){
            array =  Array<Any>()
        }
        array?.removeAll(where: { $0 as? String == titleStr})
        array?.insert(titleStr as Any, at: 0)
//        array?.append(titleStr as Any)
        UserDefaults.standard.set(array, forKey: UserDefaultKey_HistorySearch)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableView = UITableView.init(frame: self.bounds, style: UITableView.Style.plain)
    lazy var arrayData: [Convertible] = Array()
    var page = 0
    
    func requestData() {
        Alamofire.request("https://www.wanandroid.com/article/query/0/json",method: .post, parameters: ["k":titleStr!]) .responseJSON {response in
            guard let dict =  response.result.value else {return}
            guard let jsons =  JSON(dict)["data"]["datas"].arrayObject else {return}
            let array  = modelArray(from: jsons, type: Article.self)
            self.arrayData.removeAll()
            self.arrayData.append(contentsOf: array)
            self.tableView.reloadData()
            self.page = 0
            self.tableView.mj_header?.endRefreshing()
            
            if(array.count == 0){
                self.tableView.mj_footer = nil
                self.tableView.mj_header = nil

                let noRes = UILabel.init(frame: CGRect(x: 0, y: 200, width: ScreenWidth, height: 30))
                noRes.text = "无搜索数据"
                noRes.textColor = UIColor.black
                noRes.textAlignment = NSTextAlignment.center
                self.addSubview(noRes)
            }
            
            print(jsons)

        }
    }
    
    func requestMoreData() {
        Alamofire.request("https://www.wanandroid.com/article/query/\(page + 1)/json",method: .post,parameters: ["k":titleStr!]) .responseJSON {response in
            guard let dict =  response.result.value else {return}
            guard let jsons =  JSON(dict)["data"]["datas"].arrayObject else {return}
            let array = modelArray(from: jsons, type: Article.self)
            self.arrayData.append(contentsOf: array)
            self.tableView.reloadData()
            self.page+=1
            self.tableView.mj_footer?.endRefreshing()
        }
    }
    
    
}

extension SearchResultView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: Article = arrayData[indexPath.row] as! Article
        ArticleWebViewController.loadWebView(url: item.link)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchResultView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ArticleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        cell.updateModel(model: self.arrayData[indexPath.row] as! Article)
        return cell
    }
    
}
