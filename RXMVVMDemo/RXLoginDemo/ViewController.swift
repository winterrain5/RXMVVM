//
//  ViewController.swift
//  RXLoginDemo
//
//  Created by Derrick on 2019/9/29.
//  Copyright © 2019 winter. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var userNameTf: UITextField!
    @IBOutlet weak var userNamevalidationLabel: UILabel!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var passwordValidationLabel: UILabel!
    @IBOutlet weak var repeatedPasswordtf: UITextField!
    @IBOutlet weak var repeatedValidationLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 输入是textfield的文字 按钮的点击事件
        let viewModel = GitHubSignupViewModel(
            input: (
                username: userNameTf.rx.text.orEmpty.asDriver(),
                password: passwordTf.rx.text.orEmpty.asDriver(),
                repeatedPassword: repeatedPasswordtf.rx.text.orEmpty.asDriver(),
                loginTaps: signupButton.rx.tap.asSignal()
            ),
            dependency: (
                networkService: GitHubNetworkService(),
                signupService: GitHubSignupService()
            )
        )
        
        // 绑定
        viewModel.validateUsername.drive(userNamevalidationLabel.rx.validationResult).disposed(by: disposeBag)
        viewModel.validatePassword.drive(passwordValidationLabel.rx.validationResult).disposed(by: disposeBag)
        viewModel.validatePasswordRepated.drive(repeatedValidationLabel.rx.validationResult).disposed(by: disposeBag)
        
        viewModel.signingIn.drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible).disposed(by: disposeBag)
        
        viewModel.signupEnable.drive( onNext:{
            [weak self] valid in
            self?.signupButton.isUserInteractionEnabled = valid
            self?.signupButton.alpha = valid ? 1 : 0.3
        }).disposed(by: disposeBag)
        
        viewModel.signupResult.drive(onNext:{
            [weak self] result in
            self?.showMessage("注册" + (result ? "成功" : "失败") + "!")
        }).disposed(by: disposeBag)
        
        
    }
    
    //详细提示框
    func showMessage(_ message: String) {
        let alertController = UIAlertController(title: nil,
                                                message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }


}

