//
//  RxUIApplicationDelegateProxy.swift
//  UIImagePickerControllerDelegateProxy
//
//  Created by Derrick on 2019/10/18.
//  Copyright © 2019 winter. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import UIKit

public class RxUIApplicationDelegateProxy: DelegateProxy<UIApplication,UIApplicationDelegate>,UIApplicationDelegate,DelegateProxyType {
    
   public weak private(set) var application: UIApplication?
     
    init(application: ParentObject) {
        self.application = application
        super.init(parentObject: application, delegateProxy: RxUIApplicationDelegateProxy.self)
    }
     
    public static func registerKnownImplementations() {
        self.register { RxUIApplicationDelegateProxy(application: $0) }
    }
     
    public static func currentDelegate(for object: UIApplication) -> UIApplicationDelegate? {
        return object.delegate
    }
     
    public static func setCurrentDelegate(_ delegate: UIApplicationDelegate?,
                                          to object: UIApplication) {
        object.delegate = delegate
    }
     
    override open func setForwardToDelegate(_ forwardToDelegate: UIApplicationDelegate?,
                                            retainDelegate: Bool) {
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: true)
    }
    
}
