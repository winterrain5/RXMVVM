//
//  BindingExtensions.swift
//  RXLoginDemo
//
//  Created by Derrick on 2019/9/29.
//  Copyright © 2019 winter. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base:UILabel {
    var validationResult:Binder<ValidationResult> {
        return Binder(base) { (label,result) in
            label.textColor = result.textColor
            label.text = result.description
        }
    }
}
