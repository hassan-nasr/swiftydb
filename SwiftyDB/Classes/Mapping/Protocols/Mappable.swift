//
//  Mapable.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 19/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Defines mappable objects */
public protocol Mappable {
    
    // FIXME: Returns `Mappable`, but there is a bug in the compiler
    
    /** Used to map objects with data from the database */
    static func mappableObject() -> Any //Mappable
    
    /** 
    Used to map properties when reading from and writing to the object
     
    - parameters:
        - map: a map to be read or written
    */
    mutating func map<M: Mapper>(using mapper: inout M)
}
