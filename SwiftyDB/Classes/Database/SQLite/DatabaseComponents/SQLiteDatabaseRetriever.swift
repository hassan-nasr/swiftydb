//
//  SQLiteDatabaseObjectRetriever.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

class SQLiteDatabaseRetriever: DatabaseRetrieverType {
    
    let databaseQueue: DatabaseQueue
    let queryFactory: SQLiteQueryFactory
    
    
    init(databaseQueue: DatabaseQueue, queryFactory: SQLiteQueryFactory) {
        self.databaseQueue = databaseQueue
        self.queryFactory = queryFactory
    }

    func get(query: _QueryType, nested: Bool = true) throws -> [Writer] {
        
        let reader = Mapper.readerForType(query.type)
        
        var writers: [Writer] = []
        
        try databaseQueue.transaction { database in
            writers = try self.getWritersForReader(reader, filter: query.filter as? SQLiteFilterStatement, sorting: query.sorting, limit: query.limit, offset: query.offset, nested: nested, database: database)
        }
                
        return writers
    }
    
    // TODO: Make this prettier
    private func getWritersForReader(reader: Reader, filter: SQLiteFilterStatement?, sorting: Sorting, limit: Int?, offset: Int?, nested: Bool, database: DatabaseConnection) throws -> [Writer] {
        let query = queryFactory.selectQueryForType(reader.storeableType, andFilter: filter, sorting: sorting, limit: limit, offset: offset)
        
        var writers: [Writer] = []
        
        let statement = try database.prepare(query.query)
        
        try! statement.execute(query.parameters)
        
        for row in statement {
            let writer = Writer(type: reader.type)
            
            for (property, value) in row.dictionary {
                writer.storeableValues[property] = value as? StoreableValue
            }
            
            writers.append(writer)
        }
        
        try statement.finalize()
        
        if nested {
            for writer in writers {
                try getStoreableWritersForWriter(writer, database: database)
            }
        }
        
        return writers
    }
    
    
    // MARK: - Storeable properties
    
    private func getStoreableWritersForWriter(writer: Writer, database: DatabaseConnection) throws {
        let reader = Mapper.readerForType(writer.type)
        
        for (property, type) in reader.types {
            if let storeableType = type as? Storeable.Type {
                writer.mappables[property] = try getStoreableWriterForProperty(property, ofType: storeableType, forWriter: writer, database: database)
                
            } else if let storeableArrayType = type as? StoreableArrayType.Type {
                if let storeableType = storeableArrayType.storeableType {
                    let maps: [MapType] = try getStoreableWritersForProperty(property, ofType: storeableType, forWriter: writer, database: database).matchType()
                    
                    writer.mappableArrays[property] = maps
                }
            }
        }
    }
    
    private func getStoreableWriterForProperty(property: String, ofType type: Storeable.Type, forWriter writer: Writer, database: DatabaseConnection) throws -> Writer? {
        return try getStoreableWritersForProperty(property, ofType: type, forWriter: writer, database: database).first
    }
    
    private func getStoreableWritersForProperty(property: String, ofType type: Storeable.Type, forWriter writer: Writer, database: DatabaseConnection) throws -> [Writer] {
        let propertyReader = Mapper.readerForType(type)
        
        let query = "SELECT childID FROM  \(HasStoreable.self) WHERE parentType = ? AND parentID = ? AND parentProperty = ?"
        let parameters: [SQLiteValue?] = [String(writer.type), writer.identifierValue as? SQLiteValue, property]
        
        let statement = try! database.prepare(query)
                                     .execute(parameters)
        
        let ids = statement.map { $0.valueForColumn("childID") as? StoreableValue }
        
        try! statement.finalize()
        
        guard ids.count > 0 else {
            return []
        }
        
        let filter = type.identifier() << ids
        
        return try! getWritersForReader(propertyReader, filter: filter as! SQLiteFilterStatement,  sorting: .None, limit: nil, offset: nil, nested: true, database: database)
    }
}


