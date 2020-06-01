//
//  GraphQLObjects.swift
//  MySchema
//
//  Created by Kieran Brown on 6/1/20.
//  Copyright © 2020 Kieran Brown. All rights reserved.
//

import Foundation

let graphQlBuiltInScalars = ["Int",
"Float",
"String",
"Bool",
"ID"]

enum GraphQLTypeDefs: String, CaseIterable {
    case scalar
    case type
    case interface
    case union
    case _enum = "enum"
    case input
    
    var info: String {
        switch self {
            
        case .scalar:
            return "A type of value that is always treated as a leaf node"
        case .type:
            return "Represents a kind of object you can fetch from your service, and what fields it has"
        case .interface:
            return "Similar to a Swift protocol, any type implementing the interface must contain the exact fields of the interface"
        case .union:
            return "Union types allow multiple object types to possibly be returned regardless of if they share an interface or not"
        case ._enum:
            return "A special kind of scalar that is retricted to a particular set of values"
        case .input:
            return "Objects that can be used as arguments into a field. Input object types can't have arguments on their fields"
        }
    }
}

struct Field {
    var name: String
    var arguments: [Argument]
    var type: String
    
    struct Argument {
        var name: String
        var scalar: String
        var defaultValue: String
    }
}

struct GraphQLObject {
    var typeName: String
    var typeDef: GraphQLTypeDefs
    var fields: [Field]
}


class GraphQLSchema: ObservableObject {
    var scalars: [String] {
        var currentScalars = objects
            .filter{$0.typeDef == .scalar}
            .map {$0.typeDef.rawValue}
        currentScalars.append(contentsOf: graphQlBuiltInScalars)
        return currentScalars
    }
    var types: [String] { objects.filter({$0.typeDef == .type}).map(\.typeName) }
    var interfaces: [String] { objects.filter({$0.typeDef == .interface}).map(\.typeName) }
    var unions: [String] { objects.filter({$0.typeDef == .union}).map(\.typeName) }
    var enums: [String] { objects.filter({$0.typeDef == ._enum}).map(\.typeName) }
    var inputs: [String] { objects.filter({$0.typeDef == .input}).map(\.typeName) }
    
    var notInputArguments: [String] {  scalars + enums + inputs}
    var inputArguments: [String] { scalars + enums }
    var returnOptions: [String] { scalars + types + interfaces + unions + enums }

    
    @Published var objects: [GraphQLObject] = []
}
