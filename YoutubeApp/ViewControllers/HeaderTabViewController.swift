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

    }

    //タブを管理するためのViewControllerの設定(XLPagerTabStripを利用)
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //管理されるViewControllerを返す処理
        let firstVC = Page1ViewController(keyword: Tab.cat.rawValue)
        let secondVC = Page2ViewController(keyword: Tab.dog.rawValue)
        let thirdVC = Page3ViewController(keyword: Tab.rabbit.rawValue)
        let fourthVC = Page4ViewController(keyword: Tab.hedgehog.rawValue)
        let fifthVC = Page5ViewController(keyword: Tab.zoo.rawValue)
        let sixthVC = Page6ViewController(keyword: Tab.polarBear.rawValue)

        let childViewControllers:[UIViewController] = [firstVC, secondVC, thirdVC, fourthVC, fifthVC, sixthVC]
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
