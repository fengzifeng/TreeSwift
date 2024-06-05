//
//  TreeViewController.swift
//  swiftTest
//
//  Created by feng on 2019/11/1.
//  Copyright © 2019 feng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KakaJSON
import MJRefresh

class TreeViewController: BaseViewController {
    
    lazy var tableView = UITableView.init(frame: CGRect(x: 0, y: NavH, width: ScreenWidth, height: ScreenHeigth - NavH - BarH - TabDiff), style: UITableView.Style.plain)
    lazy var arrayData: [Convertible] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isHidden = true
                
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TreeCell.self, forCellReuseIdentifier: "TreeCell")
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: requestData)
        tableView.mj_header?.beginRefreshing()
        view.backgroundColor = UIColor.white;
        view.addSubview(tableView)
        //        tableView.did
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let parentVc : BaseViewController = self.parent as! BaseViewController
        parentVc.myTitle = "体系"
        
    }
    
    func requestData() {
        Alamofire.request("https://www.wanandroid.com/tree/json") .responseJSON {response in
            guard let dict =  response.result.value else {return}
            guard let jsons =  JSON(dict)["data"].arrayObject else {return}
            let array  = modelArray(from: jsons, type: TreeModel.self)
            self.arrayData.removeAll()
            self.arrayData.append(contentsOf: array)
            self.tableView.reloadData()
            print(jsons)
            self.tableView.mj_header?.endRefreshing()
        }
        
    }
}
    
extension TreeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = arrayData[indexPath.row]
        
        return TreeCell.cellHeight(model: model as! TreeModel)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TreeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TreeCell = tableView.dequeueReusableCell(withIdentifier: "TreeCell", for: indexPath) as! TreeCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.updateModel(model: self.arrayData[indexPath.row] as! TreeModel)
        return cell
    }
    
}
