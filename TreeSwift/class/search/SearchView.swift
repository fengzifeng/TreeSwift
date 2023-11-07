//
//  SearchView.swift
//  TreeSwift
//
//  Created by 冯子丰 on 2023/11/7.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchView: UIView {

    lazy var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: self.height), style: UITableView.Style.plain)
    lazy var hotArray: [Any] = Array()
    lazy var historyArray: [Any] = {
        let array = UserDefaults.standard.object(forKey: UserDefaultKey_HistorySearch)
        if(array != nil){
            return array as! [Any]
        }else{
            return Array()
        }
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HotSearchCell.self, forCellReuseIdentifier: "HotSearchCell")
//        view.backgroundColor = UIColor.white;
        addSubview(tableView)
        requestData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func requestData() {
        Alamofire.request("https://www.wanandroid.com/hotkey/json") .responseJSON {response in
            guard let dict =  response.result.value else {return}
            guard let jsons =  JSON(dict)["data"].arrayObject else {return}
            for item in jsons {
                let str: String = (item as! Dictionary<String, Any>)["name"] as! String
                self.hotArray.append(str)
            }

            self.tableView.reloadData()
            print(jsons)

        }
    }
}

extension SearchView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(hotArray.count>0 && historyArray.count>0){
            return 2
        } else if(hotArray.count>0 || historyArray.count>0){
            return 1
        } else {
            return 0

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(hotArray.count>0 && historyArray.count>0){
            if(indexPath.row == 0) {
                let height = HotSearchCell.cellHeight(hotArray: historyArray)
                return height

            } else {
                let hotHeight = HotSearchCell.cellHeight(hotArray: hotArray)
                return hotHeight

            }

        } else if(hotArray.count>0){
            let hotHeight = HotSearchCell.cellHeight(hotArray: hotArray)
            return hotHeight

        } else if(historyArray.count>0){
            let historyHeight = HotSearchCell.cellHeight(hotArray: historyArray)
            return historyHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HotSearchCell = tableView.dequeueReusableCell(withIdentifier: "HotSearchCell", for: indexPath) as! HotSearchCell
        if(hotArray.count>0 && historyArray.count>0){
            if(indexPath.row == 0) {
                cell.updatecell(hotArray: historyArray)

            } else {
                cell.isHot = true
                cell.updatecell(hotArray: hotArray)
            }
        } else if(hotArray.count>0){
            cell.isHot = true
            cell.updatecell(hotArray: hotArray)

        } else if(historyArray.count>0){
            cell.updatecell(hotArray: historyArray)

        }
        
        return cell
    }
    
}
