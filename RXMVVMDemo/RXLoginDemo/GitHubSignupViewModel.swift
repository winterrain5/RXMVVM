//
//  GitHubSignupViewModel.swift
//  RXLoginDemo
//
//  Created by Derrick on 2019/9/29.
//  Copyright © 2019 winter. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class GitHubSignupViewModel {
    
    // 用户名验证结果
    let validateUsername:Driver<ValidationResult>
    
    // 密码验证结果
    let validatePassword:Driver<ValidationResult>
    
    // 再次输入密码验证结果
    let validatePasswordRepated:Driver<ValidationResult>
    
    // 注册按钮是否可用
    let signupEnable:Driver<Bool>
    
    // 正在注册
    let signingIn:Driver<Bool>
    
    // 注册结果
    let signupResult:Driver<Bool>
    
    init(
        input:(
        username: Driver<String>,
        password: Driver<String>,
        repeatedPassword: Driver<String>,
        loginTaps: Signal<Void> // single 操作符将限制 Observable 只产生一个元素
        ),
        dependency:(
        networkService:GitHubNetworkService,
        signupService: GitHubSignupService
        )) {
        
        // 用户名验证 转换到另一个 Observable：flatMap
        // 只接收最新的元素转换的 Observable 所产生的元素：flatMapLatest
        validateUsername = input.username.flatMapLatest{
            username in
            return dependency.signupService.validateUsername(username).asDriver(onErrorJustReturn: .failed(message: "服务器发生错误！"))
        }
        
        // 密码校验 对每个元素直接转换：map
        validatePassword = input.password.map{
            password in
            return dependency.signupService.validatePassword(password)
        }
        
        // 重复输入密码校验  当任意一个 Observable 发出一个新的元素：combineLatest
        validatePasswordRepated = Driver.combineLatest(input.password,input.repeatedPassword, resultSelector: dependency.signupService.validateRepeatePassword)
        
        
        // 注册按钮是否可用
        signupEnable = Driver.combineLatest(validateUsername,validatePassword,validatePasswordRepated, resultSelector: { username,password,repeatePassword in
            return username.isValid && password.isValid && repeatePassword.isValid
        })
        
        
        // 获取最新的用户名和密码
        let usernameAnPassword = Driver.combineLatest(input.username,input.password) {
            (username:$0,password:$1)
        }
        
        let activityIndicator = ActivityIndicator()
        self.signingIn = activityIndicator.asDriver()
        
        //注册按钮点击结果
        signupResult = input.loginTaps.withLatestFrom(usernameAnPassword).flatMapLatest{
            pair in
            return dependency.networkService.regist(pair.username, pair.password).trackActivity(activityIndicator).asDriver(onErrorJustReturn: false)
        }
    }
}
