//
//  TGKGrid.swift
//  TrembusGameKit
//
//  Created by Nicholas Osto on 5/20/17.
//  Copyright © 2017 Nicholas Osto. All rights reserved.
//

import Foundation

public class TGKGrid {
    
    public var hudPoint:[[CGPoint]] = [[CGPoint]]()
    
    public init(numColumns: CGFloat, numRows: CGFloat, size: CGSize) {
        
        let cellHeight = size.height/numRows
        let cellWidth = size.width/numColumns
        
        for i in 0..<Int(numColumns) {
            
            var subArray = [CGPoint]()
            
            for j in 0..<Int(numRows) {
                
                let normalX = CGFloat(i+1) * cellWidth
                let anchorX = normalX - size.width/2 - cellWidth/2
                
                let normalY = CGFloat(j+1) * cellHeight
                let anchorY = normalY - size.height/2 - cellHeight/2
                
                subArray.append(CGPoint(x: anchorX, y: -1 * anchorY))
            }
            
            hudPoint.append(subArray)
        }
    }
}
