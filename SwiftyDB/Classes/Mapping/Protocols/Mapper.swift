//
//  Map.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 19/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

infix operator <-


public protocol Mapper {
    subscript(key: String) -> Self { get }
    
    /* Read or write basic datatypes */
    
    static func <- <T: StorableProperty>(left: inout Array<T>, right: Self)
    static func <- <T: StorableProperty>(left: inout Array<T>?, right: Self)
    static func <- <T: StorableProperty>(left: inout Array<T>!, right: Self)
    
    static func <- <T: StorableProperty>(left: inout Set<T>, right: Self) where T.RawValue : Hashable
    static func <- <T: StorableProperty>(left: inout Set<T>?, right: Self) where T.RawValue : Hashable
    static func <- <T: StorableProperty>(left: inout Set<T>!, right: Self) where T.RawValue : Hashable
    
    static func <- <T: StorableProperty>(left: inout T, right: Self)
    static func <- <T: StorableProperty>(left: inout T?, right: Self)
    static func <- <T: StorableProperty>(left: inout T!, right: Self)

    /* Read or write nested objects */
    
    static func <- <T: Storable>(left: inout Array<T>, right: Self)
    static func <- <T: Storable>(left: inout Array<T>?, right: Self)
    static func <- <T: Storable>(left: inout Array<T>!, right: Self)
    
    static func <- <T: Storable>(left: inout Set<T>, right: Self)
    static func <- <T: Storable>(left: inout Set<T>?, right: Self)
    static func <- <T: Storable>(left: inout Set<T>!, right: Self)
    
    static func <- <T: Storable>(left: inout T, right: Self)
    static func <- <T: Storable>(left: inout T?, right: Self)
    static func <- <T: Storable>(left: inout T!, right: Self)
}