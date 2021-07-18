//
//  StackedFormViewController.swift
//  iCRED
//
//  Created by Avismara HL on 17/07/21.
//

import UIKit

class StackedFormView: UIView {
    
    private let MIN_ELEMENTS_COUNT = 2
    private let MAX_ELEMENTS_COUNT = 4
    private let ANIMATION_TIME = 0.3
    
    weak var delegate: StackedFormViewDelegate?
    weak var dataSource: StackedFormViewDataSource!
    
    let StackFormViewAutomaticElementHeight: CGFloat = 75
    let StackFormViewAutomaticCtaButtonHeight: CGFloat = 75
    
    private var numberOfItems = 2
    private var elementInfos = [ElementInfo]()
    private var currentExpandedIndex = 0
    private let ctaButton = UIButton()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: Public Methods
extension StackedFormView {
    open func stackedFormElement(at index: Int) -> StackedFormElement? {
        if index < 2 || index >= 4 {
            return nil
        }
        return self.elementInfos[index].stackedFormElement
    }
    
    open func setup() {
        self.addCtaButton()
        self.queryNumberOfItems()
        self.queryElements()
        self.expand(at: 0, animated: false)
        self.clipsToBounds = true
    }
}

//MARK: Private Setup Methods
extension StackedFormView {
    private func addCtaButton() {
        self.addSubview(self.ctaButton)
        self.ctaButton.addTarget(self, action: #selector(StackedFormView.didTapNextButton(sender:)), for: .touchUpInside)
        let buttonHeight = self.dataSource.heightForCtaButton(in: self)
        let heightConstraint = ctaButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        NSLayoutConstraint.activate([
            ctaButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            ctaButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            ctaButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            heightConstraint
        ])
        self.ctaButton.translatesAutoresizingMaskIntoConstraints = false
        self.ctaButton.backgroundColor = UIColor.green
        self.layoutIfNeeded()
    }
    
    private func queryNumberOfItems() {
        let numberOfItems = dataSource.numberOfItems(in: self)
        if numberOfItems < MIN_ELEMENTS_COUNT  {
            fatalError("The number of steps in the form cannot be lesser than \(MIN_ELEMENTS_COUNT)")
        } else if numberOfItems > MAX_ELEMENTS_COUNT {
            fatalError("The number of steps in the form cannot be greater than \(MAX_ELEMENTS_COUNT)")
        }
    }
    
    private func queryElements() {
        self.numberOfItems = self.dataSource.numberOfItems(in: self)
        for i in 0 ..< numberOfItems {
            self.addElement(at: i)
        }
    }
}

//MARK: Internal Selectors
extension StackedFormView {
    @objc func handleTap(sender: UIGestureRecognizer) {
        guard let view = sender.view else {
            fatalError("This can never be nil")
        }
        let previousExpandedIndex = self.currentExpandedIndex
        self.expand(at: view.tag, animated: true) { [weak self] in
            self?.collapse(at: previousExpandedIndex, animated: false)
        }
    }
    
    @objc func didTapNextButton(sender: UIButton) {
        if self.currentExpandedIndex == self.numberOfItems - 1 {
            self.delegate?.stackedFormView(self, didCompleteFormWith: self.elementInfos.map{$0.stackedFormElement})
            return
        }
        let previousExpandedIndex = self.currentExpandedIndex
        self.expand(at: previousExpandedIndex + 1, animated: false) { [weak self] in
            self?.collapse(at: previousExpandedIndex, animated: true)
        }
    }
}

//MARK: Private Helpers
extension StackedFormView {
    private func addElement(at index: Int) {
        let stackedFormElement = dataSource.stackedFormView(self, stackedFormElementAt: index)
        if stackedFormElement.delegate == nil {
            stackedFormElement.delegate = self
        }
        
        self.styleCtaButton(valid: stackedFormElement.valid)
        
        let height = self.dataSource.stackedFormView(self, collapsedHeightForElementAt: index)
        let view = self.viewFor(index)
        
        let heightConstraint = view.heightAnchor.constraint(equalToConstant: height)
        
        let topAnchor: NSLayoutYAxisAnchor
        if index == 0 {
            topAnchor = self.topAnchor
        } else {
            topAnchor = self.elementInfos[index - 1].viewArea.bottomAnchor
        }
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            heightConstraint
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(StackedFormView.handleTap(sender:)))
        view.addGestureRecognizer(gestureRecogniser)
        
        let elementInfo = ElementInfo(stackedFormElement: stackedFormElement, viewArea: view, heightConstraint: heightConstraint, gestureRecogniser: gestureRecogniser)
        self.elementInfos.append(elementInfo)
        self.bringSubviewToFront(ctaButton)
    }
    
    private func viewFor(_ index: Int) -> UIView {
        let view = UIView()
        view.tag = index
        self.addSubview(view)
        return view
    }
    
    private func styleCtaButton(valid: Bool) {
        if valid {
            self.delegate?.stackedFormView(self, styleButtonForValidStateWith: self.ctaButton)
        } else {
            self.delegate?.stackedFormView(self, styleButtonForInvalidStateWith: self.ctaButton)
        }
    }
    
    private func expand(at index: Int, animated: Bool, completed: (() -> ())? = nil) {
        self.delegate?.stackedFormView?(self, prepareElementToExpandAt: index)
        let elementInfo = self.elementInfos[index]
        self.prepareElementToExpand(elementInfo, at: index)
        if animated {
            self.animateExpand(for: elementInfo, at: index, completed: completed)
        } else {
            self.suddenlyExpand(for: elementInfo, at: index, completed: completed)
        }
    }
    
    private func collapse(at index: Int, animated: Bool, completed: (() -> ())? = nil) {
        self.delegate?.stackedFormView?(self, prepareElementToCollapseAt: index)
        let elementInfo = self.elementInfos[index]
        self.prepareElementToCollapse(elementInfo, at: index)
        if animated {
            self.animateCollapse(for: elementInfo, at: index, completed: completed)
        } else {
            self.suddenlyCollapse(for: elementInfo, at: index, completed: completed)
        }
    }
    
    private func stickSidesOfView(view: UIView, to anotherView: UIView) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: anotherView.topAnchor, constant: 0),
            view.leftAnchor.constraint(equalTo: anotherView.leftAnchor, constant: 0),
            view.rightAnchor.constraint(equalTo: anotherView.rightAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: anotherView.bottomAnchor, constant: 0)
        ])
    }
    
    private func prepareElementToCollapse(_ elementInfo: ElementInfo, at index: Int) {
        elementInfo.stackedFormElement.prepareToCollapse()
        elementInfo.viewArea.addGestureRecognizer(elementInfo.gestureRecogniser)
        elementInfo.viewArea.addSubview(elementInfo.stackedFormElement.collapsedView)
        self.stickSidesOfView(view: elementInfo.viewArea, to: elementInfo.stackedFormElement.collapsedView)
        elementInfo.stackedFormElement.collapsedView.alpha = 0
        elementInfo.heightConstraint.constant = self.dataSource.stackedFormView(self, collapsedHeightForElementAt: index)
    }
    
    private func prepareElementToExpand(_ elementInfo: ElementInfo, at index: Int) {
        elementInfo.stackedFormElement.prepareToExpand()
        elementInfo.viewArea.removeGestureRecognizer(elementInfo.gestureRecogniser)
        elementInfo.viewArea.addSubview(elementInfo.stackedFormElement.expandedView)
        self.stickSidesOfView(view: elementInfo.viewArea, to: elementInfo.stackedFormElement.expandedView)
        elementInfo.stackedFormElement.expandedView.alpha = 0
        elementInfo.heightConstraint.constant = self.frame.size.height - self.ctaButton.frame.size.height
    }
    
    private func animateCollapse(for elementInfo: ElementInfo, at index: Int, completed: (() -> ())?) {
        UIView.animate(withDuration: self.ANIMATION_TIME/2) {
            elementInfo.stackedFormElement.expandedView.alpha = 0
        } completion: { status in
            UIView.animate(withDuration: self.ANIMATION_TIME/2) {
                elementInfo.stackedFormElement.collapsedView.alpha = 1
                self.delegate?.stackedFormView?(self, didElementCollapseAt: index)
                completed?()
            }
            elementInfo.stackedFormElement.expandedView.removeFromSuperview()
        }
        UIView.animate(withDuration: self.ANIMATION_TIME) {
            self.layoutIfNeeded()
        }
    }
    
    private func animateExpand(for elementInfo: ElementInfo, at index: Int, completed: (() -> ())?) {
        UIView.animate(withDuration: self.ANIMATION_TIME/2) {
            elementInfo.stackedFormElement.collapsedView.alpha = 0
        } completion: { status in
            UIView.animate(withDuration: self.ANIMATION_TIME/2) {
                elementInfo.stackedFormElement.expandedView.alpha = 1
                self.currentExpandedIndex = index
                completed?()
                self.delegate?.stackedFormView?(self, didElementExpandAt: index)
            }
            elementInfo.stackedFormElement.collapsedView.removeFromSuperview()
        }
        UIView.animate(withDuration: self.ANIMATION_TIME) {
            self.layoutIfNeeded()
        }
    }
    
    private func suddenlyCollapse(for elementInfo: ElementInfo, at index: Int, completed: (() -> ())?) {
        elementInfo.stackedFormElement.expandedView.removeFromSuperview()
        elementInfo.stackedFormElement.collapsedView.alpha = 1.0
        self.delegate?.stackedFormView?(self, didElementCollapseAt: index)
        completed?()
    }
    
    private func suddenlyExpand(for elementInfo: ElementInfo, at index: Int, completed: (() -> ())?) {
        elementInfo.stackedFormElement.collapsedView.removeFromSuperview()
        elementInfo.stackedFormElement.expandedView.alpha = 1.0
        self.currentExpandedIndex = index
        self.delegate?.stackedFormView?(self, didElementExpandAt: index)
        self.layoutIfNeeded()
        completed?()
    }
    
}

//MARK: ElementInfo Class Declaration
extension StackedFormView {
    private class ElementInfo {
        let stackedFormElement: StackedFormElement
        let heightConstraint: NSLayoutConstraint
        let viewArea: UIView
        let gestureRecogniser: UIGestureRecognizer
        
        init(stackedFormElement: StackedFormElement, viewArea: UIView, heightConstraint: NSLayoutConstraint, gestureRecogniser: UIGestureRecognizer) {
            self.stackedFormElement = stackedFormElement
            self.heightConstraint = heightConstraint
            self.viewArea = viewArea
            self.gestureRecogniser = gestureRecogniser
        }
    }
}

extension StackedFormView: StackedFormElementDelegate {
    func dataDidBecomeInvalidInStackedFormElement(_ stackedFormElement: StackedFormElement) {
        self.delegate?.stackedFormView(self, styleButtonForInvalidStateWith: self.ctaButton)
    }
    
    func dataDidBecomeValidInStackedFormElement(_ stackedFormElement: StackedFormElement) {
        self.delegate?.stackedFormView(self, styleButtonForValidStateWith: self.ctaButton)
    }
}
