//
//  FinishViewController.swift
//  StackedForm
//
//  Created by Avismara HL on 18/07/21.
//

import UIKit

class FinishViewController: UIViewController {
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var marriedStatusLabel: UILabel!
    @IBOutlet var goodLookinLabel: UILabel!
    @IBOutlet var finishButton: UIButton!
    
    var age: Int!
    var married: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleFinishButton()
        self.setMessages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performAnimations()
        
    }
}

//MARK: Private Helpers
extension FinishViewController {
    private func setMessages() {
        self.ageLabel.text = String.finishAge(with: self.age)
        self.marriedStatusLabel.text = String.finishMarried(with: self.married)
    }
    
    private func performAnimations() {
        UIView.animate(withDuration: 0.3) {
            self.ageLabel.alpha = 1.0
        } completion: { completed in
            UIView.animate(withDuration: 0.3) {
                self.marriedStatusLabel.alpha = 1.0
            } completion: { completed in
                UIView.animate(withDuration: 1.0) {
                    self.goodLookinLabel.alpha = 1.0
                } completion: { completed in
                    self.finishButton.alpha = 1.0
                }

            }
        }
    }
    
    private func styleFinishButton() {
        self.finishButton.layer.cornerRadius = self.finishButton.frame.size.height / 2
        self.finishButton.layer.borderWidth = 1.0
        self.finishButton.layer.borderColor = UIColor.white.cgColor
        self.finishButton.clipsToBounds = true
    }
}

//MARK: IBActions
extension FinishViewController {
    @IBAction func didTapFinishButton(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
