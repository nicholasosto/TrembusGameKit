//
//  TGKUtilityFunctions.swift
//  TrembusGameKit
//
//  Created by Nicholas Osto on 5/22/17.
//  Copyright © 2017 Nicholas Osto. All rights reserved.
//

import Foundation
import GameplayKit


// MARK: Points and vectors
extension CGPoint {
    init(_ point: float2) {
        x = CGFloat(point.x)
        y = CGFloat(point.y)
    }
}
extension float2 {
    init(_ point: CGPoint) {
        self.init(x: Float(point.x), y: Float(point.y))
    }
}
