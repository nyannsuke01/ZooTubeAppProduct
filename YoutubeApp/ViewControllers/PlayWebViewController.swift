//
//  PlayWebViewController.swift
//  YoutubeApp
//
//  Created by user on 2020/09/09.
//  Copyright © 2020 Uske. All rights reserved.
//

import UIKit
import WebKit

class PlayWebViewController: UIViewController {

    var webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 50)
        view.addSubview(webView)

        //渡されたurlをwebViewに読み込む
        if UserDefaults.standard.object(forKey: "url") != nil{
            let urlString = UserDefaults.standard.object(forKey: "url")
            let url = URL(string: urlString as! String)
            let reqest = URLRequest(url: url!)
            webView.load(reqest)

        }
    }

}
