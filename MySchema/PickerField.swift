//
//  InlinePickerView.swift
//  MySchema
//
//  Created by Kieran Brown on 6/1/20.
//  Copyright © 2020 Kieran Brown. All rights reserved.
//

import SwiftUI

/// Creates an arrow head like triangle.
public struct OpenTriangle: Shape {
    public init() {}
    public func path(in rect: CGRect) -> Path {
        Path { (path) in
            let w = rect.width
            let h = rect.height
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: w, y: h/2))
            path.addLine(to: CGPoint(x: 0, y: h))
            
        }
    }
}

struct PickerField: View {
    var options: [String]
    @Binding var text: String
    var placeHolder: String = ""
    var textColor: Color = .white
    @State private var isHovering: Bool = false
    @State private var isPresented: Bool = false
    @State private var hasFocus: Bool = false
    
    struct OptionMenu: View {
        let options: [String]
        @Binding var text: String
        @Binding var isPresented: Bool
        var body: some View {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(options, id: \.self) { option in
                        Group {
                            Text(option)
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        self.text = option
                                        self.isPresented = false
                                    }
                                    
                            }.padding(.horizontal, 5)
                            if option != self.options.last {
                                Divider()
                            }
                            
                        }
                    }
                }
                .fixedSize(horizontal: true, vertical: false)
            }
        }
    }
    var menuToggle: some View {
        Button(action: {
            self.isPresented.toggle()
        }) {
            OpenTriangle()
                .stroke(Color.white, style: .init(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .rotationEffect(self.isPresented ? Angle(degrees: 90) : .zero)
                .contentShape(Rectangle())
        }.frame(width: 6, height: 9)
            .buttonStyle(PlainButtonStyle())
    }
    
    var suggestion: String {
        self.options.first(where: {$0.contains(self.text)}) ?? ""
    }
    
    var body: some View {
        HStack(spacing: self.hasFocus ? 4 : 0) {
            ZStack(alignment: .leading) {
                Text(hasFocus ? suggestion : "")
                    .foregroundColor(.purple)
                    .opacity(0.7)
                TextField(self.placeHolder,
                          text: $text,
                          onEditingChanged: { currentlyEditing in
                    self.hasFocus = currentlyEditing
                }, onCommit:  {
                    self.text = self.suggestion
                })
                    .foregroundColor(self.textColor)
                    .font(.system(size: 12, weight: .bold))
            }.textFieldStyle(PlainTextFieldStyle())
            .fixedSize()
            if self.isHovering {
                self.menuToggle
            }
            
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 2)
        .border(self.hasFocus ? Color.yellow : .clear)
        .popover(isPresented: $isPresented,
                 attachmentAnchor: .point(.init(x: 0.5, y: 1)),
                 arrowEdge: .bottom,
                 content: {
            OptionMenu(options: self.options, text: self.$text, isPresented: self.$isPresented)
            .frame(height: 100)
            .background(Color(white: 0.3).cornerRadius(5))
        })
            .onHover { (isHovering) in
                withAnimation(.spring()) {
                    self.isHovering = isHovering
                }
                
        }
    }
}


struct PickerFieldTest: View {
    @State var text: String = "Yolo"
    var body: some View {
        VStack {
            PickerField(options: GraphQLTypeDefs.allCases.map{$0.rawValue}, text: $text)
            Button("Hello boys") {}
        }
    }
}

struct PickerField_Previews: PreviewProvider {
    static var previews: some View {
        PickerFieldTest().frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

