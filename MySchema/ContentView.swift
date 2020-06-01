//
//  ContentView.swift
//  MySchema
//
//  Created by Kieran Brown on 6/1/20.
//  Copyright © 2020 Kieran Brown. All rights reserved.
//

import SwiftUI

// Removes the border around a textfield while in focus
extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

struct SchemaEditor: View {
    @ObservedObject var schema: GraphQLSchema = .init()
    @State var currentTypeDef: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(self.schema.objects.indices, id: \.self) { i in
                ObjectView(
                    object: self.$schema.objects[i],
                    nonInputOptions: self.schema.notInputArguments,
                    inputOptions: self.schema.inputArguments,
                    returnOptions: self.schema.returnOptions)
                    .padding(25)
                    .background(Color(white: 0.16).cornerRadius(5))
                    .overlay(GeometryReader { proxy in
                        Text("􀃰")
                            .foregroundColor(.red)
                            .position(x: proxy.size.width-15, y: 12)
                            .onTapGesture {
                                _ = self.schema.objects.remove(at: i)
                        }
                    })
                
            }
            PickerField(
                options: GraphQLTypeDefs.allCases.map(\.rawValue),
                text: Binding(
                    get: {
                        self.currentTypeDef
                },
                    set: { new in
                        self.currentTypeDef = new
                        guard let value = GraphQLTypeDefs.allCases.first(where: {$0.rawValue == new}) else { return }
                        self.schema.objects.append(.init(typeName: "", typeDef: value, fields: []))
                        self.currentTypeDef = ""
                }),
                placeHolder: "New Object",
                textColor: Color.purple)
        }.animation(.linear)
    }
}



struct ContentView: View {
    var body: some View {
        SchemaEditor()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(white: 0.1))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
