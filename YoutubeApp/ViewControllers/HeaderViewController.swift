//
//  HeaderTabViewController.swift
//  YoutubeApp
//
//  Created by user on 2020/09/09.
//  Copyright © 2020 Uske. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HeaderViewController: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!

    private var prevContentOffset: CGPoint = .init(x: 0, y: 0)
    private let headerMoveHeight: CGFloat = 5

    override func viewDidLoad() {
        //バーの色
        settings.style.buttonBarBackgroundColor = UIColor(red: 73/255, green: 72/255, blue: 62/255, alpha: 1)
        //ボタンの色
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 73/255, green: 72/255, blue: 62/255, alpha: 1)
        //セルの文字色
        settings.style.buttonBarItemTitleColor = UIColor.white
        //セレクトバーの色
        settings.style.selectedBarBackgroundColor = UIColor(red: 254/255, green: 0, blue: 124/255, alpha: 1)

        super.viewDidLoad()
        //プロフィール写真を円に設定
        profileImageView.layer.cornerRadius = 20

    }

    //タブを管理するためのViewControllerの設定(XLPagerTabStripを利用)
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        //管理されるViewControllerを返す処理　 //ViewControllerインスタンスを生成
         let first = UIStoryboard(name: "VideoList", bundle: nil)
        let firstVC = first.instantiateViewController(withIdentifier: "VideoList") as! VideoListViewController
         let second = UIStoryboard(name: "Page2", bundle: nil)
        let secondVC = second.instantiateViewController(withIdentifier: "Page2") as! Page2ViewController

//        let firstVC = Page1ViewController(keyword: Tab.cat.rawValue)
//        let secondVC = Page2ViewController(keyword: Tab.dog.rawValue)
//        let thirdVC = Page3ViewController(keyword: Tab.rabbit.rawValue)
//        let fourthVC = Page4ViewController(keyword: Tab.hedgehog.rawValue)
//        let fifthVC = Page5ViewController(keyword: Tab.zoo.rawValue)
//        let sixthVC = Page6ViewController(keyword: Tab.polarBear.rawValue)

        let childViewControllers:[UIViewController] = [firstVC, secondVC]
        return childViewControllers

    }

    //タブの文字列の管理
    enum Tab: String {
        case cat = "ねこ"
        case dog = "いぬ"
        case rabbit = "うさぎ"
        case hedgehog = "ハリネズミ"
        case zoo = "動物園"
        case polarBear = "しろくま"

    }
}
