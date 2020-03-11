//
//  FCLoadingDialog.swift
//  WebViewProject
//
//  Created by Frank Chen on 2018/11/5.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

import UIKit

class FCLoadingDialog: FCBaseDialog {
    static var shared = FCLoadingDialog()
    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.indicatorView.startAnimating()
    }

    private func initUI() {
        self.isDismissSelfWhenTapBackgroundView = false
        self.dialogView.dialogViewLayer(cornerRadius: 10)
        self.containerView.clipsToBounds = true
        self.containerView.layer.cornerRadius = self.dialogView.layer.cornerRadius
    }

    func presentInWindow() {
        let window:UIWindow = UIApplication.shared.delegate!.window!!
        
        DispatchQueue.main.async(execute: {
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            window.layer.removeAllAnimations()
            self.view.frame = CGRect(x: 0, y: 0, width: window.frame.size.width, height: window.frame.size.height)
            window.addSubview(self.view)
            
            self.showPresentAnimation()
        })
    }
    
    override func presentInView(parentViewController: UIViewController, isShowAnimation: Bool = true) {
        super.presentInView(parentViewController: parentViewController)
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
        self.indicatorView?.startAnimating()
    }
    
    override func dismissSelf(isShowAnimation: Bool = true) {
        DispatchQueue.main.async {
            super.dismissSelf(isShowAnimation: isShowAnimation)
            self.indicatorView?.stopAnimating()
        }
    }
}
