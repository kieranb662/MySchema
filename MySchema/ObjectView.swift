//
//  ObjectView.swift
//  MySchema
//
//  Created by Kieran Brown on 6/1/20.
//  Copyright © 2020 Kieran Brown. All rights reserved.
//

import SwiftUI

struct ObjectView: View {
    @Binding var object: GraphQLObject
    @State private var currentTypeDef: String = ""
    let nonInputOptions: [String]
    let inputOptions: [String]
    let returnOptions: [String]
    @State var tempFieldName: String = ""
    @State var isHovering: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .bottom, spacing: 2) {
                PickerField(options: GraphQLTypeDefs.allCases.map(\.rawValue),
                                  text: Binding(get: {self.currentTypeDef}, set: { new in
                                    self.currentTypeDef = new
                                    guard let value = GraphQLTypeDefs.allCases.first(where: {$0.rawValue == new}) else { return }
                                    self.object.typeDef = value
                                  }), textColor: Color.purple).onAppear {
                                    self.currentTypeDef = self.object.typeDef.rawValue
                }
                TextField("Object name", text: self.$object.typeName)
                    .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.9))
                    .font(.system(size: 13, weight: .semibold))
                    .fixedSize()
                    .textFieldStyle(PlainTextFieldStyle())
                if isHovering || self.object.fields.count != 0 {
                    Text("{")
                }
            }
            ForEach(self.object.fields.indices, id: \.self) { (i)  in
                FieldView(field: self.$object.fields[i],
                          argumentOptions: self.object.typeDef != .input ? self.nonInputOptions : self.inputOptions,
                          returnOptions: self.returnOptions,
                          isEnum: self.object.typeDef == ._enum)
                    .offset(x: 20, y: 0)
                
            }
            if isHovering {
                TextField("New Field", text: $tempFieldName, onCommit: {
                    if !self.tempFieldName.isEmpty {
                        self.object.fields.append(.init(name: self.tempFieldName, arguments: [], type: "Int"))
                        self.tempFieldName = ""
                    }
                })
                    .foregroundColor(.orange)
                    .fixedSize()
                    .textFieldStyle(PlainTextFieldStyle())
                    .offset(x: 20, y: 0)
            }
            if isHovering || self.object.fields.count != 0 {
                Text("}")
            }
            
        }.onHover { (isHovering) in
            withAnimation(.linear(duration: 0.2)) {
                self.isHovering = isHovering
            }
        }
        
    }
}

struct ObjectViewTest: View {
    @State var obj: GraphQLObject = .init(typeName: "DatData", typeDef: .type, fields: [])
    var body: some View {
        ObjectView(object: $obj, nonInputOptions: [], inputOptions: [], returnOptions: [])
    }
}

struct ObjectView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectViewTest()
    }
}
