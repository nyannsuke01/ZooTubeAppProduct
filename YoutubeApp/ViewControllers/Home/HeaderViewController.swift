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
        let settingVC = storyboard?.instantiateViewController(identifier: "SettingViewController") as! SettingViewController
        self.present(settingVC, animated: true, completion: nil)
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

//    //HeaderView消える処理
//    private func headerViewEndAnimation() {
//        if headerTopConstraint.constant < -headerHeightConstraint.constant / 2 {
//            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [], animations: {
//
//                self.headerTopConstraint.constant = -self.headerHeightConstraint.constant
//                self.headerView.alpha = 0
//                self.view.layoutIfNeeded()
//            })
//        } else {
//            //再出現
//            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [], animations: {
//
//                self.headerTopConstraint.constant = 0
//                self.headerView.alpha = 1
//                self.view.layoutIfNeeded()
//            })
//        }
//    }



// MARK: - ScrollViewのDelegateメソッド
//extension HeaderViewController {
//
//    // scrollした時に呼ばれるメソッド
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        headerAnimation(scrollView: scrollView)
//    }
//
//    private func headerAnimation(scrollView: UIScrollView) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.prevContentOffset = scrollView.contentOffset
//        }
//
//        guard let presentIndexPath = videoListCollectionView.indexPathForItem(at: scrollView.contentOffset) else { return }
//        if scrollView.contentOffset.y < 0 { return }
//        if presentIndexPath.row >= videoItems.count - 2 { return }
//
//        let alphaRatio = 1 / headerHeightConstraint.constant
//
//        if self.prevContentOffset.y < scrollView.contentOffset.y {
//            if headerTopConstraint.constant <= -headerHeightConstraint.constant { return }
//            headerTopConstraint.constant -= headerMoveHeight
//            headerView.alpha -= alphaRatio * headerMoveHeight
//        } else if self.prevContentOffset.y > scrollView.contentOffset.y {
//            if headerTopConstraint.constant >= 0 { return }
//            headerTopConstraint.constant += headerMoveHeight
//            headerView.alpha += alphaRatio * headerMoveHeight
//        }
//
//    }
//
//    // scrollViewのscrollがピタッと止まった時に呼ばれる
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if !decelerate {
//            headerViewEndAnimation()
//        }
//    }
//
//    // scrollViewが止まった時に呼ばれる
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        headerViewEndAnimation()
//    }
//
//}
