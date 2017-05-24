//
//  TGKHud.swift
//  TrembusGameKit
//
//  Created by Nicholas Osto on 5/20/17.
//  Copyright © 2017 Nicholas Osto. All rights reserved.
//

import Foundation
import SpriteKit


//TODO: Lots!
class TGKHud: SKNode {

    var hudName:String
    
    public init(hudName: String) {
        self.hudName = hudName
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("HUD Error")
    }
    
    public func addHudElement(element: Any) {
        
    }
    
    public func update(dt: TimeInterval) {
        print("Updating HUD")
    }
}
