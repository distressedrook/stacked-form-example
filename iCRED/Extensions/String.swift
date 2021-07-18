//
//  String.swift
//  StackedForm
//
//  Created by Avismara HL on 18/07/21.
//

import Foundation

extension String {
    static var maritalStatus: String {
        return "2. are you married?"
    }
    
    static func finishAge(with age: Int) -> String {
        return "you are \(age),"
    }
    
    static func finishMarried(with married: Bool) -> String {
        var marriedString = "married"
        if !married {
            marriedString = "unmarried"
        }
        return "\(marriedString), and..."
    }
    
    static var scanFace: String {
        return "3. scan your face"
    }
    
    static var married: String {
        return "married"
    }
    
    static var unmarried: String {
        return "unmarried"
    }
}
