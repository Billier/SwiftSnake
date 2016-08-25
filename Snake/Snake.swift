//
//  Snake.swift
//  Snake
//
//  Created by user on 16/8/22.
//  Copyright © 2016年 black. All rights reserved.
//

import Foundation
import UIKit

class Snake {
    
    enum Direction {
        case Up
        case Down
        case Left
        case Right
    }
    
    enum GameState: String {
        case Init="Tap to start"
        case Pause="Pause,tap to continu"
        case Playing=""
        case Over="Over,tap to restart"
    }
    
    var speed: Int { return moveSpeed }
    var scroll: Int { return totalScroll }
    
    private var moveSpeed = 1
    private var totalScroll = 0 {
        didSet{
            switch(totalScroll){
            case 0...100:
                moveSpeed = 1
            case 101...400:
                moveSpeed = 2
            case 401...800:
                moveSpeed = 3
            case 801...1550:
                moveSpeed = 4
            default:
                break
            }
            NSNotificationCenter.defaultCenter().postNotificationName("SnakeDescription", object: nil, userInfo: ["speed": speed, "scroll": scroll, "state": gameState.rawValue])
        }
    }
    
    private var moveDirection: Direction = .Right
    
    var direction: Direction{
        
        get{
            return moveDirection
        }
        set(newDirection){
            if gameState == .Pause {
                return
            }
            
            if (newDirection == .Left && viewList[0].column-1 == viewList[1].column)
                || (newDirection == .Right && viewList[0].column+1 == viewList[1].column)
                || (newDirection == .Up && viewList[0].row-1 == viewList[1].row)
                || (newDirection == .Down && viewList[0].row+1 == viewList[1].row) {
                return
            }
            moveDirection = newDirection
        }
        
    }
    
    private var gameState: GameState = .Init {
        didSet{
            NSNotificationCenter.defaultCenter().postNotificationName("SnakeDescription", object: self, userInfo: ["speed": speed, "scroll": scroll, "state": gameState.rawValue])
        }
    }
    
    private var boundX, boundY : Int!
    
    private var viewList: [SquareView] = [] {
        didSet{
            if viewList.count > oldValue.count {
                totalScroll += moveSpeed*10
            }
        }
    }
    
    var backScreen: UIView!
    
    var targetSquareView: SquareView!
    
    init(maxX: CGFloat, maxY: CGFloat){
        print("maxX: \(maxX), maxY: \(maxY)")
        boundX  = Int(maxX / SquareView.squareSize)
        boundY = Int(maxY / SquareView.squareSize)
        
        backScreen = UIView(frame: CGRectMake(0, 0, CGFloat(boundX) * SquareView.squareSize, CGFloat(boundY) * SquareView.squareSize))
        print("\(backScreen.frame)")
        backScreen.backgroundColor = UIColor.whiteColor()
        
        reset()
        
        moving()
    }
    
    init(view: UIView) {
        boundX  = Int(view.bounds.size.width / SquareView.squareSize)
        boundY = Int(view.bounds.size.height / SquareView.squareSize)
        
        backScreen = UIView(frame: CGRectMake(0, 0, CGFloat(boundX) * SquareView.squareSize, CGFloat(boundY) * SquareView.squareSize))
        backScreen.backgroundColor = UIColor.whiteColor()
        backScreen.center = view.center
        
        reset()
    }
    
    func reset() {
        
        gameState = .Init
        
        backScreen.subviews.map({ $0.removeFromSuperview() })
        viewList.removeAll()

        viewList.insert(SquareView(column: 0, row: 0), atIndex: 0)
        viewList.insert(SquareView(column: 1, row: 0), atIndex: 0)
        viewList.insert(SquareView(column: 2, row: 0), atIndex: 0)
        
        totalScroll = 0
        
        for squareView in viewList{
            backScreen.addSubview(squareView)
        }
        
        moveDirection = .Right
        
        targetSquareView = randomSquare()
        
        backScreen.addSubview(targetSquareView)
        
    }
    
    private func moving() {
        
        var nextColum = 0
        var nextRow = 0
        var needAdd = false
        
        UIView.animateWithDuration(0.2-Double(moveSpeed-1)*0.05, animations: {
            () -> Void in
            
            if self.gameState != .Playing {
                return
            }
            
            nextColum = self.viewList[0].column
            nextRow = self.viewList[0].row
            
            print("nextColum: \(nextColum), nextRow: \(nextRow)")
            
            switch(self.moveDirection) {
            case .Left:
                nextColum -= 1
            case .Right:
                nextColum += 1
            case .Up:
                nextRow -= 1
            case .Down:
                nextRow += 1
            }
            
            if nextColum < 0 || nextColum > self.boundX - 1
                || nextRow < 0 || nextRow > self.boundY - 1 {
                print("Over")
                self.gameState = .Over
                return
            }
            
            for squareView in self.viewList {
                
                if squareView.column == nextColum && squareView.row == nextRow {
                    print("Over")
                    self.gameState = .Over
                    return
                }
                
            }
            
            if nextColum == self.targetSquareView.column && nextRow == self.targetSquareView.row {
                needAdd = true
            }
            
            var next = 0
            
            for squareView in self.viewList {
                next = squareView.column
                squareView.column = nextColum
                nextColum = next
                
                next = squareView.row
                squareView.row = nextRow
                nextRow = next
            }
            
        }){
            finished in
            if finished {
                if needAdd {
                    
                    self.viewList.append(SquareView(column: nextColum, row: nextRow))
                    self.backScreen.addSubview(self.viewList[self.viewList.count-1])
                    
                    self.targetSquareView.removeFromSuperview()
                    
                    self.targetSquareView = self.randomSquare()
                    self.backScreen.addSubview(self.targetSquareView)
                    
                }
                
                if self.gameState == .Playing {
                    self.moving()
                }
            }
        }
    }
    
    private func randomSquare() -> SquareView {
    
        var isExit = true
        var column = Int(arc4random_uniform(UInt32(boundX)))
        var row = Int(arc4random_uniform(UInt32(boundY)))
        
        while isExit {
            
            isExit = false
            if viewList.count > 0 {
                for view in viewList {
                    if view.column == column && view.row == row {
                        
                        column = Int(arc4random_uniform(UInt32(boundX)))
                        row = Int(arc4random_uniform(UInt32(boundY)))
                        
                        isExit = true
                        break
                    }
                }
            }
            
        }
        print("target column: \(column), target row: \(row)")
        return SquareView(column: column, row: row)
        
    }
    
    func start() {
        
        switch(gameState) {
        case .Over:
            reset()
        default:
            gameState = .Playing
            moving()
        }
        
    }
    
    func pause() {
        
        switch(gameState) {
        case .Over:
            reset()
        default:
            gameState = .Pause
        }
    }
}
