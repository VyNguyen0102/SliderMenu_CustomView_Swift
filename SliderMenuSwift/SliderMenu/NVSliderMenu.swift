//
//  File.swift
//  SliderMenuSwift
//
//  Created by MAC on 12/17/15.
//  Copyright © 2015 VVLab. All rights reserved.
//

import UIKit
import Foundation

protocol NVSliderMenuDelegate{
    func callback()
}
class NVSliderMenu: UIView , UIGestureRecognizerDelegate {
    
    var kSLIDE_TIMING = 0.2
    var kMARGIN_LEFT:CGFloat = 100.0
    var kTOUCH_AREA:CGFloat = 30
    var kSHADOW_OFFSET:CGFloat = 2
    
    var delegate:NVSliderMenuDelegate! = nil
    
    var availableTouchPoint = false
    var isShow = false
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init( viewController: UIViewController) {
        let sliderRect = CGRect(x: kMARGIN_LEFT - viewController.view.frame.size.width, y: 0, width: viewController.view.frame.size.width - kMARGIN_LEFT, height: viewController.view.frame.size.height)
        super.init(frame:sliderRect)
        self.delegate = viewController as! NVSliderMenuDelegate
        self.load()
    }
    func load() {
        let view = Bundle.main.loadNibNamed("NVSliderMenu", owner: nil, options: nil)?[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
    }
    @IBAction func btnClick(_ sender: AnyObject) {
        delegate.callback()
    }
    //
    // overide
    //
    override func didMoveToWindow() {
        self.setupGestures();
    }
    //
    // Design.
    //
    func setViewShadow(_ isShow: Bool) {
        if (isShow) {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.8
            self.layer.shadowOffset = CGSize(width: kSHADOW_OFFSET,height: kSHADOW_OFFSET)
        } else {
            self.layer.shadowOffset = CGSize(width: 0,height: 0)
        }
    }
    //
    // Show, Hide slider.
    //
    func showSliderMenu(){
        
        UIView.animate(withDuration: kSLIDE_TIMING, animations: {
            self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            }, completion:{(finished: Bool) -> Void in
                self.isShow = true;
                self.setViewShadow(true)
        })
    }
    func hideSliderMenu() {
        
        UIView.animate(withDuration: kSLIDE_TIMING, animations: {
            self.frame = CGRect( x: -self.frame.size.width, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                self.isShow = false;
                self.setViewShadow(false)
        })
    }
    //
    // Handle touch event
    //
    func setupGestures() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action:#selector(NVSliderMenu.movePanel(_:)))
        panRecognizer.minimumNumberOfTouches = 1
        panRecognizer.maximumNumberOfTouches = 1
        panRecognizer.delegate = self
        self.superview!.addGestureRecognizer(panRecognizer);
    }
    func movePanel(_ sender:UIPanGestureRecognizer) {
        sender.view?.layer.removeAllAnimations()
        if(sender.state == UIGestureRecognizerState.began){
            availableTouchPoint = fabs(sender.location(in: self).x - self.frame.size.width) < kTOUCH_AREA
        }
        if(sender.state == UIGestureRecognizerState.changed){
            if(availableTouchPoint){
                let touchPoint = sender.location(in: self.superview)
                var xCenter = touchPoint.x - self.frame.size.width/2
                xCenter = xCenter > self.frame.size.width/2 ? self.frame.size.width/2: xCenter;
                self.center = CGPoint(x: xCenter, y: self.center.y)
            }
        }
        if (sender.state == UIGestureRecognizerState.ended){
            let velocity = sender.velocity(in: self.superview)
            if (self.center.x + velocity.x > 0) {
                self.showSliderMenu();
            } else {
                self.hideSliderMenu();
            }
            
        }
    }
    
}
