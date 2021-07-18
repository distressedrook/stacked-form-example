//
//  StackedFormElementFactory.swift
//  StackedForm
//
//  Created by Avismara HL on 17/07/21.
//

import UIKit
import StackedForm

class StackedFormElementFactory {
    class func stackedFormElement(for type: Int) -> StackedFormElement {
        switch type {
        case 0:
            return AgeInputFormElement.load()
        case 1:
            return MaritalStatusFormElement.load()
        default:
            return FaceScanFormElement.load()
        }
    }
}
