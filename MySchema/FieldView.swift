//
//  FieldView.swift
//  MySchema
//
//  Created by Kieran Brown on 6/1/20.
//  Copyright © 2020 Kieran Brown. All rights reserved.
//

import SwiftUI

struct FieldView: View {
    @Binding var field: Field
    var argumentOptions: [String]
    var returnOptions: [String]
    @State var tempArgumentName: String = ""
    var isEnum: Bool
    
    
    var body: some View {
        HStack(spacing: 0) {
            TextField("field name", text: self.$field.name)
                .foregroundColor(.orange)
                .fixedSize()
            if !isEnum {
                if self.field.arguments.count != 0 {
                    Text("(")
                }
                ForEach(self.field.arguments.indices, id: \.self) { i in
                    HStack(spacing: 0) {
                        ArgumentView(argument: self.$field.arguments[i], options: self.argumentOptions)
                        Text(",")
                    }
                }
                TextField(self.field.arguments.count == 0 ? "(argument)" : "argument", text: self.$tempArgumentName, onCommit: {
                    if !self.tempArgumentName.isEmpty {
                        self.field.arguments.append(.init(name: self.tempArgumentName, scalar: "", defaultValue: ""))
                        self.tempArgumentName = ""
                    }
                    
                })
                    .foregroundColor(Color("Color-2"))
                    .fixedSize()
                if self.field.arguments.count != 0 {
                    Text(")")
                }
                Text(":")
                PickerField(options: self.returnOptions,
                                  text: self.$field.type,
                                  textColor: Color(red: 0.4, green: 0.6, blue: 0.9))
            }
            
        }.textFieldStyle(PlainTextFieldStyle())
        
        
    }
}

struct FieldViewTest: View {
    @State var field: Field = .init(name: "", arguments: [], type: "")
    var body: some View {
        FieldView(field: $field, argumentOptions: [], returnOptions: [], isEnum: false)
    }
}

struct FieldView_Previews: PreviewProvider {
    static var previews: some View {
        FieldViewTest()
    }
}
