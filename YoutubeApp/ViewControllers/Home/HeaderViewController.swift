//
//  HeaderTabViewController.swift
//  YoutubeApp
//
//  Created by user on 2020/09/09.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
import FirebaseUI

class HeaderViewController: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var iconImageView: UIImageView!
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
        iconImageView.layer.cornerRadius = 20
        // strageからアイコン画像の表示
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let imageRef = Storage.storage().reference().child(Const.IconImagePath).child(uid + ".jpg")
        iconImageView.sd_setImage(with: imageRef)

    }

    //タブを管理するためのViewControllerの設定(XLPagerTabStripを利用)
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //管理されるViewControllerを返す処理
        let first = UIStoryboard(name: "VideoList", bundle: nil)
        let firstVC = first.instantiateViewController(withIdentifier: "VideoList") as! VideoListViewController

        let second = UIStoryboard(name: "Page2", bundle: nil)
        let secondVC = second.instantiateViewController(withIdentifier: "Page2") as! Page2ViewController

        let third = UIStoryboard(name: "Page3", bundle: nil)
        let thirdVC = third.instantiateViewController(withIdentifier: "Page3") as! Page3ViewController

        let fourth = UIStoryboard(name: "Page4", bundle: nil)
        let fourthVC = fourth.instantiateViewController(withIdentifier: "Page4") as! Page4ViewController

        let fifth = UIStoryboard(name: "Page5", bundle: nil)
        let fifthVC = fifth.instantiateViewController(withIdentifier: "Page5") as! Page5ViewController

        let sixth = UIStoryboard(name: "Page6", bundle: nil)
        let sixthVC = sixth.instantiateViewController(withIdentifier: "Page6") as! Page6ViewController

        let childViewControllers:[UIViewController] =  [firstVC, secondVC, thirdVC, fourthVC, fifthVC, sixthVC]
        return childViewControllers

    }

    @IBAction func toSetting(_ sender: Any) {
        print("設定ボタンがタップされました")
        let storyBoard = UIStoryboard(name: "Setting", bundle: nil)
        let SettingVC = storyBoard.instantiateViewController(identifier: "Setting") as! SettingViewController
//        SettingVC.modalPresentationStyle = .fullScreen
        self.present(SettingVC, animated: true, completion: nil)
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
