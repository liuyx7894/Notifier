//
//  ViewController.swift
//  Notifier
//
//  Created by Louis Liu on 28/04/2017.
//  Copyright © 2017 Louis Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for i in 0..<500 {
            Notifier.shared.showNotifier(title: "您有一条新消息", body: "@这是什么鬼\(i)", withObject:"\(i)", onTapNotifier: { (obj) in
                print("onTapNotifier----object:\(obj)")
            })
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

