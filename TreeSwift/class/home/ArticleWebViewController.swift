//
//  ArticleWebViewController.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/10/27.
//  Copyright © 2023 feng. All rights reserved.
//

import WebKit
import UIKit

class ArticleWebViewController: BaseViewController {
    
    lazy var webView: WKWebView = {
        let webview = WKWebView(frame: CGRect(x: 0, y: NavH, width: ScreenWidth, height: ScreenHeigth - NavH))
        return webview
    }()
    
    lazy var activityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activityIndicatorView.center = self.view.center
        
        return activityIndicatorView
    } ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        view.addSubview(webView)
        view.addSubview(activityIndicatorView)
        myNavigationItem.title = "rfkn"

    }
    
   class func loadWebView(url: String) -> ArticleWebViewController {
        let vc: ArticleWebViewController = ArticleWebViewController.init()
        let url = URL(string: url)
        let request = URLRequest(url: url!)

        vc.webView.load(request)
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
       appDelegate.nav?.pushViewController(vc, animated: true)
        
        return vc
    }
}

extension ArticleWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicatorView.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorView.stopAnimating()
        webView.evaluateJavaScript("document.title" ,completionHandler:{[weak self] (value:Any?,error:Error?) in
            if (value != nil) {
            
                self?.myNavigationItem.title = value as? String
            }
        })
    }
}


