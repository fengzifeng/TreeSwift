//
//  HomeController.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/10/27.
//  Copyright © 2023 feng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KakaJSON
import MJRefresh

class HomeController: BaseViewController, CycleViewDelegate  {
    func didSelectIndexCollectionViewCell(index: Int) {
        
    }
    
    lazy var tableView = UITableView.init(frame: CGRect(x: 0, y: NavH, width: ScreenWidth, height: ScreenHeigth - NavH - BarH - TabDiff), style: UITableView.Style.plain)
    lazy var arrayData: [Convertible] = Array()
    var page = 0
    
    func createHeadView() {
        Alamofire.request("https://www.wanandroid.com/banner/json") .responseJSON {response in
            guard let dict =  response.result.value else {return}
            guard let jsons =  JSON(dict)["data"].arrayObject else {return}
//            let array  = modelArray(from: jsons, type: TreeModel.self)
            var strArray: [String] = Array()
            for item in jsons {
                strArray.append((item as! Dictionary<String, Any>)["imagePath"] as! String)
            }
//            var array = jsons as NSArray
//            array = array.value(forKeyPath: "imagePath") as! NSArray
            if(strArray.count > 0) {
                let cycle = CycleScrollView.init(frame: CGRectMake(0, 0, ScreenWidth, ScreenWidth/9.0*5))
                cycle.delegate = self;
                cycle.images = strArray
                self.tableView.tableHeaderView = cycle
            }
//            self.arrayData.removeAll()
//            self.arrayData.append(contentsOf: array)
//            self.tableView.reloadData()
            print(jsons)
        }
        
    }
    
    func requestData() {
        createHeadView()

        Alamofire.request("https://www.wanandroid.com/article/list/0/json") .responseJSON {response in
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
        navigationBar.isHidden = true
        view.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
//        self.view.backgroundColor = UIColor.red;
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: requestData)
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: requestMoreData)
        view.addSubview(tableView)
//        tableView.did
        requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let parentVc : BaseViewController = self.parent as! BaseViewController
//        parentVc.navigationBar.isHidden = true
        parentVc.myTitle = "首页"
    }
    
    
}
extension HomeController: UITableViewDelegate {
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

extension HomeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ArticleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        cell.updateModel(model: self.arrayData[indexPath.row] as! Article)
        return cell
    }
    
}

