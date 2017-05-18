//
//  ButtonNode.swift
//  EntitiesPractice
//
//  Created by Nicholas Osto on 4/3/17.
//  Copyright © 2017 Nicholas Osto. All rights reserved.
//
// Testing GITHUP UPLOAD

import GameplayKit

public class TGKMenuItem: SKSpriteNode {
    
    let onButtonPress: ()->()
    let buttonNode: TGKButtonNode
    
    public init(imageName: String, iconImageName: String, onButtonPress: @escaping ()->(), buttonPosition: CGPoint?) {
        
        let texture = SKTexture(imageNamed: imageName)
        
        self.onButtonPress = onButtonPress
        self.buttonNode = TGKButtonNode(textureName: iconImageName, onButtonPress: onButtonPress)
        
        // Call Super
        super.init(texture: texture, color: .white, size: texture.size())
        
       
        if let position = buttonPosition {
            buttonNode.position = position
        }
        
        self.buttonNode.zPosition = 1
        addChild(buttonNode)
    
    }
    

    public required init?(coder aDecoder: NSCoder) {
        fatalError("Button node fatal error")
    }
    
}

public class TGKButtonNode: SKSpriteNode {
    
    let onButtonPress: ()->()

    
    var isEnabled: Bool = true
    
    
    public init(textureName:String, onButtonPress: @escaping ()->()) {
        
        // Set properties
        self.onButtonPress = onButtonPress

        let texture = SKTexture(imageNamed: textureName)
        
        // Call Super
        super.init(texture: texture, color: .white, size: texture.size())

        
        // Enable interaction
        self.isUserInteractionEnabled = true
        
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Button node fatal error")
    }
    

    public func touchUp(atPoint pos : CGPoint) {
        
        // do nothing if button is disabled or used moves of the button
        if(!self.isEnabled  || !self.contains(pos)) { return }

        onButtonPress()

    }

    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touch")
        if let containingNode = self.parent {
            for t in touches { self.touchUp(atPoint: t.location(in: containingNode)) }
        }
    }
}
