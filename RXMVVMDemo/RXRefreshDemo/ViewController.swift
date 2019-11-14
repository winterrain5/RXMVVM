//
//  ViewController.swift
//  RXRefreshDemo
//
//  Created by Derrick on 2019/9/30.
//  Copyright © 2019 winter. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    //表格
    var tableView:UITableView!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //创建表格视图
        self.tableView = UITableView(frame: self.view.frame, style:.plain)
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self,
                                 forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView!)
        
        //设置头部刷新控件
        self.tableView.mj_header = MJRefreshNormalHeader()
        self.tableView.mj_footer = MJRefreshBackNormalFooter()
        
        let vm = ViewModel(
            input:(
                headeRefresh: self.tableView.mj_header.rx.refreshing.asDriver(),
                footerRefresh: self.tableView.mj_footer.rx.refreshing.asDriver()),
            dependency: (
                disposeBag: disposeBag,
                networkservice: NetworkService())
            )
        
        vm.tableData.asDriver().drive(tableView.rx.items){
            tableView,row,element in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            cell?.textLabel?.text = "\(row + 1) \(element)"
            return cell!
        }.disposed(by: disposeBag)
        
        vm.endHeaderRefreshing.drive(tableView.mj_header.rx.endRefreshing).disposed(by: disposeBag)
        vm.endFooterRefreshing.drive(tableView.mj_footer.rx.endRefreshing).disposed(by: disposeBag)
        
    }

    // 当订阅者订阅PublishSubject 时，只会收到订阅后Subject发出的新Event，而不会收到订阅之前发出的旧Event
    func publishSubject() {
        let subject = PublishSubject<String>()
        subject.onNext("A") // 不会收到
        subject.subscribe(onNext: { (element) in
            print("第一次订阅：",element)
        },  onCompleted: {
            print("第一次订阅: complete")
        }).disposed(by: disposeBag)
        
        subject.onNext("B") // 第一次收到
        
        subject.subscribe(onNext: { (element) in
            print("第二次订阅：",element)
        },  onCompleted: {
            print("第二次订阅: complete")
        }).disposed(by: disposeBag)
        
        // 一二都会收到
        subject.onNext("C")
        subject.onNext("D")
        
        subject.onCompleted() // 所有订阅都会收到
    }
    
    //  BehaviorSubject 通过一个默认初始值来创建，当订阅者订阅BehaviorSubject 时，会收到订阅后Subject上一个发出的Event，如果还没有收到任何数据，会发出一个默认值。之后就和PublishSubject 一样，正常接收新的事件。
    func behaviorSubject() {
        let subject = BehaviorSubject(value: "A")
        
        // 会收到默认值A
        subject.subscribe(onNext: { (element) in
            print("第一次订阅：",element)
        }, onCompleted: {
            print("第一次订阅： complete")
        }).disposed(by: disposeBag)
        
    }
    
    /// ReplaySubject 创建的时候需要设置一个 buffSize，用来表示发出过的Event的缓存个数。当一个订阅者订阅了一个 ReplaySubject 之后，他将会收到当前缓存在 buffer 中的数据和这之后产生的新数据。如果订阅者订阅了一个已经结束的ReplaySubject，除了会收到缓存中的 next 的Event，还会收到那个终结的 error或 completed 的Event
    func replaySubject() {
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        
        subject.subscribe(onNext: { (element) in
            print("第一次订阅：",element)
        },  onCompleted: {
            print("第一次订阅：complete")
        }).disposed(by: disposeBag)
        
        subject.onNext("A")
        subject.onNext("B")
        subject.onNext("C")
        subject.onNext("D")
        
        // 第二次订阅的时候只会收到上次发出的最后两个 和之后发出的E
        subject.subscribe(onNext: { (element) in
            print("第二次订阅：",element)
        },  onCompleted: {
            print("第二次订阅：complete")
        }).disposed(by: disposeBag)
        
        
        // 第三次订阅的时候只会收到上次发出的最后两个 和之后发出的E
        subject.subscribe(onNext: { (element) in
            print("第三次订阅：",element)
        },  onCompleted: {
            print("第三次订阅：complete")
        }).disposed(by: disposeBag)
        
        subject.onNext("E")
        
    }
    
    // BehaviorRelay 作为Variable 的替代者出现，本质上也是对BehaviorSubject的封装。不同的是Variable他不是观察者也不是序列，没有任何继承。 BehaviorRelay 只遵守 ObservableType协议，所以它其实是一个序列，但它有一个value 属性，通过这属性能拿到最新的值。而通过它的 accept() 方法可以对值进行修改，通过它里面的subject将修改的值发送出去。

    func behaviorRelay() {
        let subject = BehaviorRelay(value: "A")
        
        subject.asObservable().subscribe{
            print("第一次订阅：",$0)
        }.disposed(by: disposeBag)
        
        
        subject.accept("B")
        subject.accept("C")
        
        subject.asObservable().subscribe{
            print("第二次订阅：",$0)
        }.disposed(by: disposeBag)
        
    }
}

