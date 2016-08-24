//
//  ViewController.swift
//  Snake
//
//  Created by user on 16/8/22.
//  Copyright © 2016年 black. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var backScreen: UIView!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var scrollLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    
    var tapGestureRecognizer : UITapGestureRecognizer!
    var panGestureRecognizer: UIPanGestureRecognizer!
    
    var snake: Snake!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        initView()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func initView() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateSnakeInfo(_:)), name: "SnakeDescription", object: nil)

        snake = Snake(view: backScreen)
        
        backScreen.addSubview(snake.backScreen)
        
        backScreen.bringSubviewToFront(hintLabel)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        snake.backScreen.addGestureRecognizer(tapGestureRecognizer)
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        snake.backScreen.addGestureRecognizer(panGestureRecognizer)

    }
    
    var i = 0
    
    func tap(sender: UITapGestureRecognizer) {
        
        if i%2 == 0 {
            snake.start()
        }else {
            snake.pause()
        }
        
        i += 1
        if i == 1000 {
            i = 0
        }
        
    }
    
    func pan(sender: UIPanGestureRecognizer) {
        
        let translatedPoint = sender.translationInView(snake.backScreen)
        
        let tPoint = (translatedPoint.x, translatedPoint.y)
        
        switch tPoint {
        case let (x, y) where x<0 && abs(x)>abs(y):
            snake.direction = .Left
        case let (x, y) where x>0 && x>abs(y):
            snake.direction = .Right
        case let (x, y) where y<0 && abs(x)<abs(y):
            snake.direction = .Up
        case let (x, y) where y>0 && abs(x)<y:
            snake.direction = .Down
        default:
            break
        }
        
        sender.setTranslation(CGPointZero, inView: snake.backScreen)
        
    }
    
    func updateSnakeInfo(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            speedLabel.text = String(userInfo["speed"] as! Int)
            scrollLabel.text = String(userInfo["scroll"] as! Int)
            hintLabel.text = userInfo["state"] as! String
            
        }
        
    }
}

