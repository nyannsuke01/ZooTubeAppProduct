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
//        // ボトムナビゲーションのアイコンの色
//        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
//        // ボトムナビゲーションの背景色
//        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        // UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理する。
        self.delegate = self
    }

    // タブバーのアイコンがタップされた時に呼ばれるdelegateメソッドを処理する。
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        //先に認証しているか判断して、認証していなければ、Login
        if viewController is MyPageViewController {
            // デフォルトMyPageViewControllerに遷移。ログインしていなければloginViewControllerに遷移。
            if Auth.auth().currentUser == nil {
                let storyBoard = UIStoryboard(name: "Login", bundle: nil)
                let loginVC = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true, completion: nil)
                return false
            }
            return true
        } else {
            // その他のViewControllerは通常のタブ切り替えを実施
            return true
        }
    }
}
