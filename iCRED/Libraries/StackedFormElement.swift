//
//  StackedFormElementViewController.swift
//  iCRED
//
//  Created by Avismara HL on 17/07/21.
//

import UIKit


@objc protocol StackedFormElement {
    var collapsedView: UIView! { get set }
    var expandedView: UIView! { get set }
    
    var collapsedViewHeight: CGFloat { get set }
    
    var valid: Bool { get set }
    var delegate: StackedFormElementDelegate? { get set }
    
    func prepareToCollapse()
    func prepareToExpand()
    
}

@objc protocol StackedFormElementDelegate {
    func dataDidBecomeInvalidInStackedFormElement(_ stackedFormElement: StackedFormElement)
    func dataDidBecomeValidInStackedFormElement(_ stackedFormElement: StackedFormElement)
}
