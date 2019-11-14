//
//  ViewController.swift
//  RXMVVMDemo
//
//  Created by Derrick on 2019/9/27.
//  Copyright © 2019 winter. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    
    //显示资源列表的tableView
    var tableView:UITableView!
    
    //搜索栏
    var searchBar:UISearchBar!
    
    let disposeBag = DisposeBag()
    
    var viewModel:ViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        //创建表视图
        self.tableView = UITableView(frame:self.view.frame, style:.plain)
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView!)
        
        //创建表头的搜索栏
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0,
                                                   width: self.view.bounds.size.width, height: 56))
        self.tableView.tableHeaderView =  self.searchBar
        
        /// 查询条件输入
        let searchAction = searchBar.rx.text.orEmpty.asDriver().throttle(0.5) // 只有间隔超过0.5秒才发送
            .distinctUntilChanged()
        
        //
        viewModel = ViewModel(searchAction: searchAction)
        
        // 绑定导航栏标题数据
        viewModel.navigationTitle.drive(self.navigationItem.rx.title).disposed(by: disposeBag)
        
        // 数据绑定到表格
        viewModel.repositories.drive(tableView.rx.items){
            (tableView,row,element) in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = element.name
            cell.detailTextLabel?.text = element.html_url
            return cell
            
        }.disposed(by: disposeBag)
        
    }


}

