//
//  ArgumentView.swift
//  MySchema
//
//  Created by Kieran Brown on 6/1/20.
//  Copyright © 2020 Kieran Brown. All rights reserved.
//

import SwiftUI

struct ArgumentView: View {
    @Binding var argument: Field.Argument
    var options: [String]
    
    var body: some View {
        HStack {
            TextField("name", text: self.$argument.name)
                .foregroundColor(Color("Color-2"))
                .fixedSize()
            Text(":")
            PickerField(
                options: options,
                text: $argument.scalar,
                textColor: Color(red: 0.4, green: 0.6, blue: 0.9))
            Text("=")
            TextField("default?", text: self.$argument.defaultValue)
                .foregroundColor(Color("Color"))
                .fixedSize()
        }.textFieldStyle(PlainTextFieldStyle())
    }
}

struct ArgumentViewTest: View {
    @State var arg: Field.Argument = .init(name: "", scalar: "", defaultValue: "")
    var body: some View {
        ArgumentView(argument: $arg, options: [])
    }
}

struct ArgumentView_Previews: PreviewProvider {
    static var previews: some View {
        ArgumentViewTest()
    }
}
