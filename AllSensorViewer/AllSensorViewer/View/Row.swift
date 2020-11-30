//
//  Row.swift
//  AllSensorViewer
//
//  Created by Ricardo Venieris on 29/11/20.
//

import SwiftUI

struct Row: View {
    var label:String
    var value:String
    @State private var _divider:CGFloat = 100

    var body: some View {
        HStack {
            Text("\(label) :")
                .multilineTextAlignment(.trailing)
                .frame(width: _divider, alignment: .topTrailing)
            
            Text(value)
                .font(.system(.body, design: .monospaced))
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }.frame(maxWidth: .infinity)
    }
    
//    func divider(_ value:CGFloat)->Self {
//        self._divider = value
//        return self
//    }
}

struct Row_Previews: PreviewProvider {
    static var label:String = "Label"
    @State static var value:String = """
    Multiline value 123 123 123 123 123 123 123 123 123 123 
    Line 2
    Line 3
    """

    static var previews: some View {
        Row(label: Self.label, value: Self.value)
    }
}
