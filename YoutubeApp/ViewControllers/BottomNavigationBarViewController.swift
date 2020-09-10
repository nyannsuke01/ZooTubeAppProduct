//
//  BottomNavigationBarController.swift
//  YoutubeApp
//
//  Created by user on 2020/09/10.
//  Copyright © 2020 Uske. All rights reserved.
//

import UIKit
import Firebase

class BottomNavigationBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
//        // タブアイコンの色
//        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
//        // タブバーの背景色
//        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        // UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理する。
        self.delegate = self
    }

    // タブバーのアイコンがタップされた時に呼ばれるdelegateメソッドを処理する。
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is MyPageViewController {
            // MyPageViewControllerをタップした時、ログインしていなければ
            if Auth.auth().currentUser == nil {
                // loginViewControllerに遷移
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                self.present(loginViewController!, animated: true, completion: nil)
            }
            return false

        } else {
            // その他のViewControllerは通常のタブ切り替えを実施
            return true
        }
    }
}
