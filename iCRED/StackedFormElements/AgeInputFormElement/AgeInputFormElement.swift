//
//  AgeInputFormElement.swift
//  StackedForm
//
//  Created by Avismara HL on 17/07/21.
//

import UIKit
import StackedForm

@objc class AgeInputFormElement: NSObject, StackedFormElement {
   private let MIN_AGE: Float = 18
    private let MAX_AGE: Float = 100
    
    @IBOutlet var collapsedView: UIView!
    @IBOutlet var expandedView: UIView!
    
    @IBOutlet var collapsedAgeLabel: UILabel!
    @IBOutlet var expandedAgeLabel: UILabel!
    @IBOutlet var ageSlider: UISlider!
    @IBOutlet var overlapSpaceConstraint: NSLayoutConstraint!
    
    var collapsedViewHeight: CGFloat = 90
    var ctaButtonText: String? = String.maritalStatus
    var valid = true
    
    var delegate: StackedFormElementDelegate?
    
    private override init() {}
    
    class func load() -> AgeInputFormElement {
        let element = AgeInputFormElement()
        Bundle.main.loadNibNamed("AgeInputExpandedView", owner: element, options: nil)
        Bundle.main.loadNibNamed("AgeInputCollapsedView", owner: element, options: nil)
        let ageString = element.ageString(for: element.ageSlider.value)
        element.expandedAgeLabel.text = ageString
        element.overlapSpaceConstraint.constant = element.overlapSpace
        return element
    }
    
    private func ageString(for value: Float) -> String {
        let curAge = Int(MIN_AGE + (MAX_AGE - MIN_AGE) * value)
        return String(curAge)
    }
    
    @IBAction func sliderDidSlide(sender: UISlider) {
        let ageString = self.ageString(for: sender.value)
        self.expandedAgeLabel.text = ageString
    }
}

extension AgeInputFormElement {
    func prepareToCollapse() {
        let ageString = self.ageString(for: self.ageSlider.value)
        self.collapsedAgeLabel.text = ageString
    }
    
    func prepareToExpand() { }
}
