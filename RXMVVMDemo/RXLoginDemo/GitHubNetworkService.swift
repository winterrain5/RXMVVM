//
//  LoginService.swift
//  RXLoginDemo
//
//  Created by Derrick on 2019/9/29.
//  Copyright © 2019 winter. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class GitHubNetworkService {
    func usernameAvailabel(_ username:String) -> Observable<Bool> {
        //通过检查这个用户的GitHub主页是否存在来判断用户是否存在
        let url = URL(string: "http://github.com/\(username.URLEscaped)")
        let request = URLRequest(url: url!)
        return URLSession.shared.rx.response(request: request).map{
            pair in
            //如果不存在该用户的主页 则这个用户不存在
            return pair.response.statusCode == 404
        }.catchErrorJustReturn(false)
        
    }
    
    func regist(_ username:String,_ password:String) -> Observable<Bool> {
        // 模拟请求  每三次有一次失败
        let result = arc4random() % 3 == 0 ? false : true
        return Observable.just(result).delay(1.5, scheduler: MainScheduler.instance) // 结果延迟1.5秒返回
        
    }
}

//扩展String
extension String {
    //字符串的url地址转义
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
