//
//  NetworkService.swift
//  RXRefreshDemo
//
//  Created by Derrick on 2019/9/30.
//  Copyright © 2019 winter. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class NetworkService {
    func  getRandomResult() ->Driver<[String]> {
        let items = (0..<15).map{ _ in
            "随机数据\(Int(arc4random()))"
        }
        let observable = Observable.just(items)
        return observable.delay(1, scheduler: MainScheduler.instance).asDriver(onErrorDriveWith: Driver.empty())
    }
}
