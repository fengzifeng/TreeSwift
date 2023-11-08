//
//  CollectViewController.swift
//  TreeSwift
//
//  Created by 冯子丰 on 2023/11/8.
//

import UIKit
import Alamofire
import SwiftyJSON
import KakaJSON
import MJRefresh

class CollectViewController: BaseViewController {
    
    lazy var tableView = UITableView.init(frame: CGRect(x: 0, y: NavH, width: ScreenWidth, height: ScreenHeigth - NavH - BarH - TabDiff), style: UITableView.Style.plain)
    lazy var arrayData: [Convertible] = Array()
    var page = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTitle = "我的收藏"
        view.backgroundColor = RGB(r: 242, g: 242, b: 242)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
        tableView.backgroundColor = RGB(r: 242, g: 242, b: 242)
        view.addSubview(tableView)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: requestData)
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: requestMoreData)
        view.addSubview(tableView)
//        tableView.did
        requestData()
    }
    
    func requestData() {
        Alamofire.request("https://www.wanandroid.com/lg/collect/list/0/json") .responseJSON {response in
            guard let dict =  response.result.value else {return}
            guard let jsons =  JSON(dict)["data"]["datas"].arrayObject else {return}
            let array  = modelArray(from: jsons, type: Article.self)
            self.arrayData.removeAll()
            self.arrayData.append(contentsOf: array)
            self.tableView.reloadData()
            self.page = 0
            self.tableView.mj_header?.endRefreshing()
            
            print(jsons)

        }
    }
    
    func requestMoreData() {
        Alamofire.request("https://www.wanandroid.com/lg/collect/list/\(page + 1)/json") .responseJSON {response in
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

extension CollectViewController: UITableViewDelegate {
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

extension CollectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ArticleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        cell.updateModel(model: self.arrayData[indexPath.row] as! Article)
        return cell
    }
    
}
