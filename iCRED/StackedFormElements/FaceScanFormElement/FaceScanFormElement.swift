//
//  FaceScanFormElement.swift
//  StackedForm
//
//  Created by Avismara HL on 18/07/21.
//

import UIKit
import StackedForm
import FLAnimatedImage

class FaceScanFormElement: NSObject, StackedFormElement {
    
    var collapsedView = UIView()
    @IBOutlet var expandedView: UIView!
    @IBOutlet var animatedImageView: FLAnimatedImageView!
    
    var collapsedViewHeight: CGFloat = 90
    var ctaButtonText: String? = nil
    var valid = true
    
    var delegate: StackedFormElementDelegate?
    
    private override init() { }
    
    class func load() -> FaceScanFormElement {
        let element = FaceScanFormElement()
        Bundle.main.loadNibNamed("FaceScanExpandedView", owner: element, options: nil)
        element.animatedImageView.layer.cornerRadius = 20
        element.animatedImageView.clipsToBounds = true
        return element
    }
}

extension FaceScanFormElement {
    func prepareToCollapse() {}
    func prepareToExpand() {
        if let url =  Bundle.main.url(forResource: "scan_face", withExtension: "gif"), let data = try? Data(contentsOf: url) {
            let gif = FLAnimatedImage(animatedGIFData: data)
            self.animatedImageView.animatedImage = gif
            self.animatedImageView.loopCompletionBlock = { [weak self] duration in
                guard let self = self else {
                    return
                }
                self.animatedImageView.stopAnimating()
                self.delegate?.didFinishInput(in: self)
            }
        }
    }
}
