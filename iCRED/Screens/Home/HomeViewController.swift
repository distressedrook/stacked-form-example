//
//  ViewController.swift
//  StackedForm
//
//  Created by Avismara HL on 17/07/21.
//

import UIKit
import StackedForm

class HomeViewController: UIViewController {
    
    @IBOutlet var stackedFormView: StackedFormView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stackedFormView.setup()
    }
}

extension HomeViewController: StackedFormViewDelegate {
    func stackedFormView(_ stackedFormView: StackedFormView, styleButtonForValidStateWith button: UIButton) {
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.gilroySemibold(with: 18)
        button.backgroundColor = UIColor.enabledCta
    }
    
    func stackedFormView(_ stackedFormView: StackedFormView, styleButtonForInvalidStateWith button: UIButton) {
        button.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
        button.titleLabel?.font = UIFont.gilroySemibold(with: 18)
        button.backgroundColor = UIColor.disbledCta
    }
    
    func stackedFormView(_ stackedFormView: StackedFormView, didCompleteFormWith formElements: [StackedFormElement]) {
        var age: Int!
        var married: Bool!
        
        for element in formElements {
            if let ageInputFormElement = element as? AgeInputFormElement {
                age = Int(ageInputFormElement.expandedAgeLabel.text!)
            } else if let maritalStatusFormlement = element as? MaritalStatusFormElement {
                married = maritalStatusFormlement.yesCheckbox.isChecked
            }
        }
        let finishViewController = UIViewController.finish(with: age, married: married)
        self.present(finishViewController, animated: true) {
            self.stackedFormView.setup()
        }
    }
}

extension HomeViewController: StackedFormViewDataSource {
    func numberOfItems(in stackedFormView: StackedFormView) -> Int {
        return 3
    }
    
    func stackedFormView(_ stackedFormView: StackedFormView, stackedFormElementAt index: Int) -> StackedFormElement {
        return StackedFormElementFactory.stackedFormElement(for: index)
    }
    
    
    func stackedFormView(_ stackedFormView: StackedFormView, collapsedHeightForElementAt index: Int) -> CGFloat {
        return StackedForm.StackFormViewAutomaticElementHeight
    }
    
    func heightForCtaButton(in stackedFormView: StackedFormView) -> CGFloat {
        return StackedForm.StackFormViewAutomaticCtaButtonHeight
    }
}
