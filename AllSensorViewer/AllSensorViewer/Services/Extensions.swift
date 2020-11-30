//
//  Extensions.swift
//  AllSensorViewer
//
//  Created by Ricardo Venieris on 29/11/20.
//

import Foundation

extension Optional where Wrapped == String {
    var orEmpty:String {
        return self ?? ""
    }
}

var defaultDoubleFormatDigits:Int = 10
extension Double {
    var formatted:String {
        return self.format(f: "01.0\(defaultDoubleFormatDigits)")
    }
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
    
}


extension Int {
    mutating func stepUp(limit:Int) {
        self += 1
        self = self > limit ? limit : self

    }
    mutating func stepDown(limit:Int) {
        self -= 1
        self = self < limit ? limit : self

    }
}
