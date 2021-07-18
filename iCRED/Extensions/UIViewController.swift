//
//  UIViewController.swift
//  StackedForm
//
//  Created by Avismara HL on 18/07/21.
//

import UIKit

extension UIViewController {
    static func finish(with age: Int, married: Bool) -> FinishViewController {
        let finishViewController = UIStoryboard.finish.instantiateInitialViewController() as! FinishViewController
        finishViewController.age = age
        finishViewController.married = married
        return finishViewController
    }
}
