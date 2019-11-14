//
//  ValidationResult.swift
//  RXLoginDemo
//
//  Created by Derrick on 2019/9/29.
//  Copyright © 2019 winter. All rights reserved.
//

import Foundation
import UIKit


// 验证结果和信息的枚举
enum ValidationResult {
    case validating // 验证中
    case empty // 输入为空
    case ok(message:String) // 验证通过
    case failed(message:String) // 验证失败
}

// 拓展ValidationResult，对应不同的验证结果返回验证是成功还是失败
extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

// 拓展ValidationResult 对应不同的验证结果返回不同的文字描述
extension ValidationResult: CustomStringConvertible {
    var description: String {
        switch self {
        case .validating:
            return "验证中..."
        case .empty:
            return ""
        case .ok(let message):
            return message
        case .failed(let message):
            return message
        }
    }
}

//扩展ValidationResult，对应不同的验证结果返回不同的文字颜色
extension ValidationResult {
    var textColor: UIColor {
        switch self {
        case .validating:
            return UIColor.gray
        case .empty:
            return UIColor.black
        case .ok:
            return UIColor(red: 0/255, green: 130/255, blue: 0/255, alpha: 1)
        case .failed:
            return UIColor.red
        }
    }
}



