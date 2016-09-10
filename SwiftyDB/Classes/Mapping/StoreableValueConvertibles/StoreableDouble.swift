//
//  Double.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension Double: StoreableValueConvertible {
    
    public typealias StoreableValueType = Double
    
    public var storeableValue: StoreableValueType {
        return self
    }
    
    public static func fromStoreableValue(storeableValue: StoreableValueType) -> Double {
        return storeableValue
    }
}