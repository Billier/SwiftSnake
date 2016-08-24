//
//  SquareView.swift
//  Snake
//
//  Created by user on 16/8/22.
//  Copyright © 2016年 black. All rights reserved.
//

import UIKit

class SquareView: UIView {

    static let squareSize: CGFloat = 8.0
    
    private var col: Int = 0
    private var r: Int = 0
    
    var column: Int {
        get{
            return col
        }
        set(newColumn){
            col = newColumn
            super.frame = CGRectMake(CGFloat(col)*SquareView.squareSize, CGFloat(r)*SquareView.squareSize, SquareView.squareSize, SquareView.squareSize)
        }
    }
    
    var row: Int {
        get{
            return r
        }
        set(newRow){
            r = newRow
            super.frame = CGRectMake(CGFloat(col)*SquareView.squareSize, CGFloat(r)*SquareView.squareSize, SquareView.squareSize, SquareView.squareSize)
        }
    }
    
    init(column: Int, row: Int) {
        super.init(frame: CGRectMake(0, 0, 0, 0))
        super.backgroundColor = UIColor.blackColor()
        
        self.column = column
        self.row = row
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
