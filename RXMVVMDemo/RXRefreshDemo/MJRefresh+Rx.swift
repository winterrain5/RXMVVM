//
//  MJRefresh+Rx.swift
//  RXRefreshDemo
//
//  Created by Derrick on 2019/9/30.
//  Copyright © 2019 winter. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa


extension Reactive where Base:MJRefreshComponent {
    
    /// 正在刷新事件
    var refreshing:ControlEvent<Void> {
        let source:Observable<Void> = Observable.create{
            [weak control = self.base] observer in
            if let control = control {
                control.refreshingBlock = {
                    observer.on(.next(()))
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
    
    var endRefreshing:Binder<Bool> {
        return Binder(base) {
            refresh,isEnd  in
            if isEnd {
                refresh.endRefreshing()
            }
        }
    }
}
