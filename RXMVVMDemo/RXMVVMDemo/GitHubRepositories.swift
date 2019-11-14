
//
//  GitHubRepositiries.swift
//  RXMVVMDemo
//
//  Created by Derrick on 2019/9/27.
//  Copyright © 2019 winter. All rights reserved.
//

import Foundation
import ObjectMapper
/// 单个仓库模型
struct GitHubRepository: Codable{
    
    var id:Int = 0
    var name:String = ""
    var full_name:String = ""
    var html_url:String = ""
    var description:String = ""
   
    
}

struct GitHubRepositories: Codable{
    var total_count: Int = 0
    var incomplete_results: Bool = false
    var items: [GitHubRepository] = [] //本次查询返回的所有仓库集合
    
   
}
