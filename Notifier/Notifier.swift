    //
//  Notifier.swift
//  Notifier
//
//  Created by Louis Liu on 28/04/2017.
//  Copyright © 2017 Louis Liu. All rights reserved.
//

import UIKit

class Notifier: NSObject {
    
    struct NotifyModel {
        var title:String = ""
        var body:String = ""
        var userObject:Any?
        
        init(title:String, body:String, userObject:Any?) {
            self.title = title
            self.body = body
            self.userObject = userObject
        }
    }

    typealias OnTapNotifierCallback = ((Any?)->Void)
   
    private static let exhibitionSec:Double = 3.0
    private let notifierHeight:CGFloat = 54 + 20
    private let titleHeight:CGFloat = 15
    private let margin:CGFloat = 15
    private let notifierMargin:CGFloat = 0
    private var processQueue = [NotifyModel]()
    private var notifiView:UIView!
    private var label_title:UILabel!
    private var label_body:UILabel!
    
    private static var NotifierAssociatedKey = "NotifierAssociatedKey"
    
    static let shared = Notifier()
    var onTapped:OnTapNotifierCallback?
    
    private var isShowing:Bool = false {

        didSet {
            self.showCurrentNotifier()
        }
    }
    
    lazy var keyWindow:UIWindow! = {
        
        var tmp = UIApplication.shared.keyWindow
        if(tmp == nil ){
            tmp = UIApplication.shared.windows.first
        }
        return tmp
    }()
    
   
    override init() {
        super.init()
        initNotifier()
    }
    
    func showNotifier(title:String, body:String, onTapNotifier:OnTapNotifierCallback?){
        showNotifier(title:title, body:body, withObject: nil, onTapNotifier:onTapNotifier)
    }
    
    func showNotifier(title:String, body:String, withObject obj:Any?, onTapNotifier:OnTapNotifierCallback?){
        
        onTapped = onTapNotifier
        
        processQueue.append(NotifyModel(title: title, body: body, userObject:obj))
        if(isShowing == false){
            isShowing = true
        }
            }

    func dismissNotifier(withSec sec:Double){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(sec * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.dismissNotifier()
        })
    }
    
    func dismissNotifier(){
        
        if let _ = processQueue.first {
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.33, animations: { 
                    self.notifiView.frame.origin.y = -self.notifierHeight
                }, completion: { (complete) in
                    if complete {
                        self.notifiView.removeFromSuperview()
                        self.processQueue.remove(at: 0)
                        self.isShowing = false
                    }
                })
            }
        }
    }
    
    private func showCurrentNotifier(){
        
        if let model = processQueue.first {
            
            DispatchQueue.main.async {
                self.notifiView.frame.origin.y = -self.notifierHeight
                self.keyWindow.addSubview(self.notifiView)
                self.label_title.text = model.title
                self.label_body.text = model.body
                
                UIView.animate(withDuration: 0.33, animations: {
                    self.notifiView.frame.origin.y = 0
                })
                
                self.dismissNotifier(withSec: Notifier.exhibitionSec)
            }
        }
    }
    
    private func initNotifier(){
        
        let screenWidth = keyWindow!.bounds.width
        notifiView = UIView(frame: CGRect.init(x: CGFloat(notifierMargin),
                                                   y: CGFloat(notifierMargin),
                                                   width: screenWidth - notifierMargin*2,
                                                   height: notifierHeight))
        
        let effectiveView = UIVisualEffectView(frame: notifiView.frame)
        let effect = UIBlurEffect.init(style: .prominent)
        effectiveView.effect = effect
        notifiView.insertSubview(effectiveView, at: 0)

        label_title = UILabel(frame: CGRect.init(x: margin, y: 25, width: screenWidth-margin, height: titleHeight))
        label_title.text = "您有一条新消息"
        label_title.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightHeavy)
        label_title.textColor = UIColor.black
        
        label_body = UILabel(frame: CGRect.init(x: margin, y: label_title.frame.maxY, width: screenWidth-margin, height: 24))
        label_body.text = "学习学习经历卡绝世独立卡就收到了空啊实打实的离开家啊收到了空间阿斯利康多久啊啥的间"
        label_body.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightThin)
        label_body.numberOfLines = 0
        label_body.textColor = UIColor.black
        
        notifiView.addSubview(label_title)
        notifiView.addSubview(label_body)
        
        notifiView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.onTappedNotifier)))
    }
    
    @objc private func onTappedNotifier(){
        if let model = processQueue.first {
            let obj = model.userObject
            if(onTapped != nil){
                onTapped!(obj)
            }
        }
    }
}
