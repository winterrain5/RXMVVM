//
//  ViewModel.swift
//  RXRefreshDemo
//
//  Created by Derrick on 2019/9/30.
//  Copyright © 2019 winter. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
class ViewModel {
    // 表格数据序列
    let tableData = BehaviorRelay<[String]>(value: [])
    // 停止刷新状态序列
    let endHeaderRefreshing:Driver<Bool>
    let endFooterRefreshing:Driver<Bool>
    
    init(input:(
        headeRefresh:Driver<Void>,
        footerRefresh:Driver<Void>
        ),
         dependency:(
        disposeBag:DisposeBag,
        networkservice:NetworkService
        )) {
        
        // 下拉结果序列
        let headerRefreshData = input.headeRefresh.startWith(())
            .flatMapLatest{
                return dependency.networkservice.getRandomResult()
        }
        
        // 上拉结果序列
        let footerRefreshData = input.footerRefresh.flatMapLatest{
            return dependency.networkservice.getRandomResult()
        }
        
        /// 当请求结束获取到data时 即结束刷新
        self.endHeaderRefreshing = headerRefreshData.map{ _ in true }
        self.endFooterRefreshing = footerRefreshData.map{ _ in true }
        
        // 下拉刷新时 将查询结果替换原数据
        headerRefreshData.drive(onNext: { (items) in
            self.tableData.accept(items)
        }).disposed(by: dependency.disposeBag)
        
        // 上拉加载时 将查询结果拼接搭到原数据尾部
        footerRefreshData.drive(onNext: { (items) in
            self.tableData.accept(self.tableData.value + items)
        }).disposed(by: dependency.disposeBag)
    }
}
