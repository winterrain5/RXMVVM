//
//  GitHubAPI.swift
//  RXMVVMDemo
//
//  Created by Derrick on 2019/9/27.
//  Copyright © 2019 winter. All rights reserved.
//

import Foundation
import Moya


let GitHubProvider = MoyaProvider<GitHubAPI>()

public enum GitHubAPI {
    case repositories(String)
}

extension GitHubAPI:TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    public var path: String {
        switch self {
        case .repositories:
            return "/search/repositories"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    /// 单元测试模拟数据
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    // 请求任务事件
    public var task: Task {
        print("发起请求")
        switch self {
        case .repositories(let query):
            var params:[String:Any] = [:]
            params["q"] = query
            params["sort"] = "stars"
            params["order"] = "desc"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    
}
