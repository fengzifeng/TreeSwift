//
//  articleListViewController.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/11/5.
//  Copyright © 2023 feng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KakaJSON
import MJRefresh

class ArticleListViewController: BaseViewController {
    var cid: Int = 0
    var titleStr: String = ""
//测试回退1
    lazy var tableView = UITableView.init(frame: CGRect(x: 0, y: NavH, width: ScreenWidth, height: ScreenHeigth - NavH), style: UITableView.Style.plain)
    lazy var arrayData: [Convertible] = Array()
    var page = 0
    
    func requestData() {
        Alamofire.request("https://www.wanandroid.com/article/list/0/json?cid=\(cid)") .responseJSON {response in
            guard let dict =  response.result.value else {return}
            guard let jsons =  JSON(dict)["data"]["datas"].arrayObject else {return}
            let array  = modelArray(from: jsons, type: Article.self)
            self.arrayData.removeAll()
            self.arrayData.append(contentsOf: array)
            self.tableView.reloadData()
            self.page = 0
            self.tableView.mj_header?.endRefreshing()
            let headerFields = response.response?.allHeaderFields as! [String : String]
            let userCookie =  headerFields["Set-Cookie"]
            print(jsons)
//测试1
        }
    }
    
    func requestMoreData() {
        Alamofire.request("https://www.wanandroid.com/article/list/\(page + 1)/json") .responseJSON {response in
            guard let dict =  response.result.value else {return}
            guard let jsons =  JSON(dict)["data"]["datas"].arrayObject else {return}
            let array = modelArray(from: jsons, type: Article.self)
            self.arrayData.append(contentsOf: array)
            self.tableView.reloadData()
            self.page+=1
            
            self.tableView.mj_footer?.endRefreshing()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myTitle = titleStr
        view.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
//        self.view.backgroundColor = UIColor.red;
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: requestData)
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: requestMoreData)
        view.addSubview(tableView)
        requestData()

    }
    
}

extension ArticleListViewController: UITableViewDelegate {
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

extension ArticleListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ArticleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        cell.updateModel(model: self.arrayData[indexPath.row] as! Article)
        return cell
    }
    
}
