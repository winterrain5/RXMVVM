//
//  GitHubSignupService.swift
//  RXLoginDemo
//
//  Created by Derrick on 2019/9/29.
//  Copyright © 2019 winter. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
// 用户注册服务
class GitHubSignupService {
    
    /// 密码最少位数
    let  minPasswordCount = 6
    lazy var networkService = { return GitHubNetworkService() }()
    
    /// 验证用户名
    func validateUsername(_ username:String) -> Observable<ValidationResult> {
        // 用户名是否为空
        if username.isEmpty {
            return .just(.empty)
        }
        
        // 判断用户名是否只有数字和字母
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(.failed(message: "用户名只能包含数字和字母"))
        }
        
        /// 发起网络监察用户名是否已经存在
        return networkService.usernameAvailabel(username).map{
            avaliable in
            if avaliable {
                return .ok(message: "用户名可用")
            }else {
                return .failed(message: "用户不可用")
            }
        }.startWith(.validating) // 发起请求前，先返回一个“正在检查”的验证结果
    }
    
    func validatePassword(_ password:String) -> ValidationResult {
        let numberOfCharacter = password.count
        // 密码是否为空
        if numberOfCharacter == 0 {
            return .empty
        }
        
        // 检查密码位数
        if numberOfCharacter < minPasswordCount {
            return .failed(message: "密码至少需要\(minPasswordCount)个字符")
        }
        
        return .ok(message: "有效的密码")
    }
    
    func validateRepeatePassword(_ passwod:String,_ repeatePassword:String) ->ValidationResult {
        // 判断是否为空
        if repeatePassword.isEmpty {
            return .empty
        }
        
        // 判断是否一致
        if passwod == repeatePassword {
            return .ok(message: "校验通过")
        }else{
            return .failed(message: "校验失败")
        }
    }
}
