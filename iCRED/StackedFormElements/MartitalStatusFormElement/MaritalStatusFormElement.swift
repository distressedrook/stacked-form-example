//
//  MaritalStatusFormElement.swift
//  StackedForm
//
//  Created by Avismara HL on 18/07/21.
//

import UIKit
import StackedForm

@objc class MaritalStatusFormElement: NSObject, StackedFormElement {
    @IBOutlet var collapsedView: UIView!
    @IBOutlet var expandedView: UIView!
    
    @IBOutlet var yesCheckbox: Checkbox!
    @IBOutlet var noCheckbox: Checkbox!
    @IBOutlet var overlapSpacingConstraint: NSLayoutConstraint!
    @IBOutlet var collapsedMaritalStatusLabel: UILabel!
    
    var collapsedViewHeight: CGFloat = 90
    var ctaButtonText: String? = String.scanFace
    var valid: Bool = false {
        didSet {
            if valid {
                self.delegate?.dataDidBecomeValid(in: self)
            } else {
                self.delegate?.dataDidBecomeInvalid(in: self)
            }
        }
    }
    
    var delegate: StackedFormElementDelegate?
    
    private override init() {  }
    
    class func load() -> MaritalStatusFormElement {
        let element = MaritalStatusFormElement()
        Bundle.main.loadNibNamed("MaritalStatusCollapsedView", owner: element, options: nil)
        Bundle.main.loadNibNamed("MaritalStatusExpandedView", owner: element, options: nil)
        element.overlapSpacingConstraint.constant = element.overlapSpace
        return element
    }
}

extension MaritalStatusFormElement {
    @IBAction func checkboxValueDidChange(sender: Checkbox) {
        if self.valid == false {
            self.valid = true
        }
        if sender == self.yesCheckbox {
            self.noCheckbox.isChecked = !self.yesCheckbox.isChecked
        } else {
            self.yesCheckbox.isChecked = !self.noCheckbox.isChecked
        }
    }
}

extension MaritalStatusFormElement {
    func prepareToCollapse() {
        if self.yesCheckbox.isChecked {
            self.collapsedMaritalStatusLabel.text = String.married
        } else {
            self.collapsedMaritalStatusLabel.text = String.unmarried
        }
    }
    
    func prepareToExpand() { }
}
