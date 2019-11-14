//
//  ViewModel.swift
//  RXMVVMDemo
//
//  Created by Derrick on 2019/9/27.
//  Copyright © 2019 winter. All rights reserved.
//

import Foundation
import RxSwift
import Result
import RxCocoa
import Moya
import Moya_ObjectMapper


/*
 （1）首先我们使用 asDriver 方法将 ControlProperty 转换为 Driver。
 （2）接着我们可以用 .asDriver(onErrorJustReturn: []) 方法将任何 Observable 序列都转成 Driver，因为我们知道序列转换为 Driver 要他满足 3 个条件：
 不会产生 error 事件
 一定在主线程监听（MainScheduler）
 共享状态变化（shareReplayLatestWhileConnected）
 而 asDriver(onErrorJustReturn: []) 相当于以下代码：
 let safeSequence = xs
 .observeOn(MainScheduler.instance) // 主线程监听
 .catchErrorJustReturn(onErrorJustReturn) // 无法产生错误
 .share(replay: 1, scope: .whileConnected)// 共享状态变化
 return Driver(raw: safeSequence) // 封装
 （3）同时在 Driver 中，框架已经默认帮我们加上了 shareReplayLatestWhileConnected，所以我们也没必要再加上"replay"相关的语句了。
 （4）最后记得使用 drive 而不是 bindTo
 
 */

class ViewModel {
    // 输入
    fileprivate let searchAction:Driver<String>
    
    // 输出
    // 所有查询结果
    let searchResult:Driver<GitHubRepositories>
    // 资源列表
    let repositories:Driver<[GitHubRepository]>
    // 清空动作
    let cleanResult:Driver<Void>
    let navigationTitle:Driver<String>
    
    init(searchAction:Driver<String>) {
        self.searchAction = searchAction
        
        self.searchResult = searchAction.filter{ !$0.isEmpty } // 输入为空不发送请求
            .flatMapLatest{
                GitHubProvider.rx.request(.repositories($0))
                .filterSuccessfulStatusCodes()
                .map(GitHubRepositories.self)
                .asDriver(onErrorDriveWith: Driver.empty())
        }
        
        self.cleanResult = searchAction.filter{ $0.isEmpty }.map{ _ in Void() }
        
        self.repositories = Driver.merge(searchResult.map{$0.items},cleanResult.map{[]})
        
        self.navigationTitle = Driver.merge(searchResult.map{ "共有\($0.total_count)个结果" },cleanResult.map{ "GitHub" })
        
    }
}


/*
class ViewModel {
    
    /// 输入
    // 查询行为
    fileprivate let searchAction:Observable<String>
    
    /// 所有查询结果
    let searchResult:Observable<GitHubRepositories>
    
    // 查询结果里的资源列表
    let repositories:Observable<[GitHubRepository]>
    
    // 清空动作
    let clearResult:Observable<Void>
    
    // 导航栏标题
    let navigationTitle:Observable<String>
    
    
    
    // 查询
    init(searchAction:Observable<String>) {
        self.searchAction = searchAction
        
        // 生成查询结果序列
        self.searchResult = searchAction.filter{ !$0.isEmpty } // 输入为空不发送请求
            .flatMapLatest{ // 只接受最新的数据
                
                    GitHubProvider.rx.request(.repositories($0))
                .filterSuccessfulStatusCodes()
                .map(GitHubRepositories.self)
                .asObservable()
                .catchError({ (e)  in
                    print("发生错误:",e.localizedDescription)
                    return Observable<GitHubRepositories>.empty()
                })
        }.share(replay: 1) // 让http请求是被共享的
        
        self.clearResult = searchAction.filter{ $0.isEmpty }.map{ _ in Void() }
        
        /// 生成查询结果里的资源列表序列 （如果查询到结果则返回数据，如果是清空数据则返回空数组）
        self.repositories = Observable.of(searchResult.map{ $0.items },clearResult.map{[]}).merge()
        
        //
        self.navigationTitle = Observable.of(searchResult.map{ "共有\($0.total_count)个结果"},clearResult.map{ "github" }).merge()
        
    }
}
*/
