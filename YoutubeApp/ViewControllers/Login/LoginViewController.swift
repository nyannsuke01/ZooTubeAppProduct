//
//  LoginViewController.swift
//  ZooTube
//
//  Created by user on 2020/09/01.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupNotificationObserver()

        displayNameTextField.delegate = self
        mailAddressTextField.delegate = self
        passwordTextField.delegate = self
    }

    // ログインボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text {

            // アドレスとパスワード名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                return
            }

            // HUDで処理中を表示
            SVProgressHUD.show()

            Auth.auth().signIn(withEmail: address, password: password) { authResult, error in
                if let error = error {
                    print("DEBUG_PRINT1: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました。")
                    return
                }
                print("DEBUG_PRINT2: ログインに成功しました。")
                // HUDを消す
                SVProgressHUD.dismiss()

                // 画面を閉じてタブ画面に戻る
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    // アカウント作成ボタンをタップしたときに呼ばれる アカウント作成画面へ遷移
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "CreateAccount", bundle: nil)
        let CreateAccountVC = storyBoard.instantiateViewController(identifier: "CreateAccount") as! CreateAccountViewController
        CreateAccountVC.modalPresentationStyle = .fullScreen
        self.present(CreateAccountVC, animated: true, completion: nil)
        
    }

    @IBAction func handleCancelButton(_ sender: Any) {
        // 画面を閉じてタブ画面に戻る
        self.dismiss(animated: true, completion: nil)
    }

    //　画面の初期状態
    private func setupViews() {
        //ログインボタンの状態　非活性 初期化
        loginButton.layer.cornerRadius = 6.0
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.rgb(red: 255, green: 230, blue: 244)

    }

    //キーボードの通知の設定
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func showKeyboard(notification: Notification) {
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue

        guard let keyboardMinY = keyboardFrame?.minY else { return }
        let registerButtonMaxY = loginButton.frame.maxY
        let distance = registerButtonMaxY - keyboardMinY + 20

        let transform = CGAffineTransform(translationX: 0, y: -distance)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = transform
        })
    }

    @objc func hideKeyboard() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = .identity
        })
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // エンターを押したとき、キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emaillIsEmpty = mailAddressTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true

        if emaillIsEmpty || passwordIsEmpty {
            loginButton.isEnabled = false
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 255, green: 128, blue: 177)
        }
    }

}
