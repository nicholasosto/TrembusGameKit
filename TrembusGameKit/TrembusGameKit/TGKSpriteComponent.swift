//
//  TGKSpriteComponent.swift
//  TrembusGameKit
//
//  Created by Nicholas Osto on 5/23/17.
//  Copyright © 2017 Nicholas Osto. All rights reserved.
//

import GameplayKit

public class TGKSpriteComponent: GKComponent{
    
    public let node: TGKGameSprite
    
    public init(node: TGKGameSprite) {
        self.node = node
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("TGKSpriteComponent: \(#function) not configured")
    }
    
}
