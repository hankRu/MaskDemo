//
//  Frost_BaseDialog.swift
//  TWLifeInfo
//
//  Created by Frost on 2015/10/22.
//  Copyright © 2015年 Frost Chen. All rights reserved.
//

import UIKit

public class FCBaseDialog: UIViewController, UIGestureRecognizerDelegate {

    public var isDismissSelfWhenTapBackgroundView: Bool = true
    var presentCompleteClosure: (() -> ())?
    var dismissCompleteClosure: (() -> ())?

    
    private var isKeyboardDidShow = false
    private var isScreenRaised = false
    private var selectedTextField: UITextField?
    var keyboardHeight: CGFloat = 0
    private var oriFrameOriginY: CGFloat = 0
    var keyboardDidShowScrollYDistance: CGFloat = 160
    
//MARK: Initalize
    public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
    
    public init() {
        let className = NSStringFromClass(type(of: self))
        let bundle:Bundle = Bundle(for: NSClassFromString(className)!)
        let xibName = className.components(separatedBy: ".").last!
        super.init(nibName: xibName, bundle: bundle)
    }

//MARK: Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.46)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureAction(recognizer:)))
        tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)

        
        self.initKeyboardNotifications()
        self.initTextFields()
        self.oriFrameOriginY = self.view.frame.origin.y
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.closeKeyboard()
        NotificationCenter.default.removeObserver(self)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK: Set Closures
    public func setPresentCompleteClosure(action: (() -> (Void))?) {
        self.presentCompleteClosure = action
    }
    
    public func setDismissCompleteClosure(action: (() -> (Void))?) {
        self.dismissCompleteClosure = action
    }
    
 //MARK: Animations
    func showPresentAnimation() {
     //   self.view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self.view.alpha = 0
        
        UIView.animate(withDuration: 0.25,
            animations: { [weak self] () -> Void in
                self?.view.alpha = 1
      //          self?.view.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            }, completion: { [weak self] (bool) -> Void in
                self?.presentCompleteClosure?()
            }
        )
    }
    
    func showDismissAnimation() {
    //    self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.view.alpha = 1
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
  //          self?.view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self?.view.alpha = 0.0
        }, completion: { [weak self] (isFinished : Bool)  in
            if (isFinished) {
                self?.dismissCompleteClosure?()
                self?.closeKeyboard()
                self?.view.removeFromSuperview()
                self?.removeFromParent()
            }
        })
    }
    
    //MARK: getTopViewController
    func getTopViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            return rootViewController
        }
        
        if let navigationController = controller as? UINavigationController {
            return getTopViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return getTopViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return getTopViewController(controller: presented)
        }
        
        return controller
    }
    
    //MARK: show, remove
    public func presentInView(parentViewController: UIViewController, isShowAnimation:Bool = true) {
        guard parentViewController.children.contains(self) == false else {
            return
        }
        
        DispatchQueue.main.async(execute: {
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            self.view.frame =  CGRect(x: 0, y: 0, width: parentViewController.view.frame.size.width, height:  parentViewController.view.frame.size.height)
            
            parentViewController.addChild(self)
            parentViewController.view.addSubview(self.view)
                
            if (isShowAnimation == true) {
                self.showPresentAnimation()
            } else {
                self.presentCompleteClosure?()
            }
        })
    }
    
    
    public func presentInTopView(parentViewController: UIViewController, isShowAnimation:Bool = true) {
        var topViewController = self.getTopViewController()
        
        if(topViewController == nil) {
            topViewController = parentViewController
        }
        
        self.presentInView(parentViewController: parentViewController, isShowAnimation: isShowAnimation)
    }
    
    public func presentInWindow(isShowAnimation:Bool = true) {
        DispatchQueue.main.async(execute: {
            let window = UIApplication.shared.keyWindow!
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.frame =  CGRect(x: 0, y: 0, width: window.frame.size.width, height: window.frame.size.height)
            
            window.rootViewController?.addChild(self)
            window.addSubview(self.view)
            
            if (isShowAnimation == true) {
                self.showPresentAnimation()
            } else {
                self.presentCompleteClosure?()
            }
        })
    }
    
    public func dismissSelf(isShowAnimation:Bool = true) {
        DispatchQueue.main.async(execute: { [weak self] in
            if (isShowAnimation == true) {
                self?.showDismissAnimation()
            } else {
                self?.view.removeFromSuperview()
                self?.removeFromParent()
                self?.closeKeyboard()
                self?.dismissCompleteClosure?()
            }
        })
    }
    
    private func closeKeyboard() {
        let textFields:[UITextField] = view.allSubviews.filter{$0 is UITextField} as! [UITextField]
        
        for textField in textFields {
            textField.resignFirstResponder()
        }
    }
    
    //MARK: Gesture_actions
    @objc func tapGestureAction(recognizer:UIPanGestureRecognizer) {
        if(isDismissSelfWhenTapBackgroundView == true) {
            self.dismissSelf(isShowAnimation: true)
        }
    }
    
    //MARK: UIGestureRecognizerDelegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view != self.view) {
            return false
        }
        return true
    }

    
    private func initTextFields() {
        let textFields:[UITextField] = view.allSubviews.filter{$0 is UITextField} as! [UITextField]
        
        for textField in textFields {
            textField.delegate = self
        }
    }
    
    private func initKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        self.isKeyboardDidShow = true
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardSize:CGSize = keyboardFrame.size
        self.keyboardHeight = keyboardSize.height
        //print("keyboardSize.height: \(keyboardSize.height)")
        
        
        self.raiseScreen()
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        
        if(self.isScreenRaised == true) {
            UIView.animate(withDuration: 0.4, animations: {
                UIView.animate(withDuration: 0.4) {
                    self.view.frame = CGRect(x: 0, y: self.oriFrameOriginY, width: self.view.frame.size.width, height: self.view.frame.size.height)
                }
            }) { (isCompleted) in
                self.isScreenRaised = false
            }
        }
        
        
        isKeyboardDidShow = false
    }
    
    private func raiseScreen() {
        if let selectedTextField = selectedTextField {
            let distance: CGFloat = keyboardDidShowScrollYDistance
            let locationY = (selectedTextField.superview == nil) ? selectedTextField.frame.origin.y: selectedTextField.superview!.convert(selectedTextField.frame, to: self.view).origin.y
            let threshold = self.view.frame.size.height - keyboardHeight
            
            if(locationY > (threshold - distance)) {
                let moveDistance: CGFloat = -(locationY - (threshold - distance))
                self.isScreenRaised = true
                UIView.animate(withDuration: 0.4) {
                    self.view.frame = CGRect(x: 0, y: moveDistance, width: self.view.frame.size.width, height: self.view.frame.size.height)
                }
            }
        }
    }
    
}

extension FCBaseDialog: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
        if(self.isKeyboardDidShow == true) {
            self.raiseScreen()
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        selectedTextField = nil
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true

    }
    
}
