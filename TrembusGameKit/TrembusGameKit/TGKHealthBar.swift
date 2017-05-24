//
//  TGKHealthBar.swift
//  TrembusGameKit
//
//  Created by Nicholas Osto on 5/22/17.
//  Copyright © 2017 Nicholas Osto. All rights reserved.
//

import Foundation
import SpriteKit

public struct TGKProgressBarNodeNames {
    static let health = "HealthNode"
    static let healthBar = "HealthBar"
    static let healthFrame = "HealthFrame"
}


public class TGKHealthBar: SKSpriteNode {
    
    private var cropNode: SKCropNode = SKCropNode()
    private var healthSprite: SKSpriteNode
    private var onHealthDepleted: (()->())? = nil
    
    private var maxHealth: CGFloat
    private var currentHealth: CGFloat {
        didSet{
            if currentHealth <= 0 {
                if let onHealthDepleted = onHealthDepleted { onHealthDepleted() }
            }
        }
    }
    
    public init(texture: SKTexture, healthImageName: String, onHealthDepleted: (()->())? = nil, maxHealth: CGFloat, size: CGSize? = nil) {
        
        var scaleFactorX:CGFloat = 1
        var scaleFactorY:CGFloat = 1
        
        self.onHealthDepleted = onHealthDepleted
        self.maxHealth = maxHealth
        self.currentHealth = maxHealth
        
        
        self.healthSprite = SKSpriteNode(imageNamed: healthImageName)
        self.healthSprite.name = TGKProgressBarNodeNames.health
        
        
        if let size = size {
            self.cropNode.maskNode = SKSpriteNode(texture: texture, size: size)
            super.init(texture: texture, color: .white, size: size)
            scaleFactorX = size.width / texture.size().width
            scaleFactorY = size.height / texture.size().height
            
        } else {
            self.cropNode.maskNode = SKSpriteNode(texture: texture)
            super.init(texture: texture, color: .white, size: texture.size())
        }
        
        self.name = TGKProgressBarNodeNames.healthBar
        
        self.healthSprite.xScale = scaleFactorX
        self.healthSprite.yScale = scaleFactorY
        
        self.addChild(cropNode)
        self.cropNode.addChild(healthSprite)
        
        self.cropNode.zPosition = 1
    }
    
    
    public convenience init(textureName: String, healthImageName: String, frameImageName:String? = nil,  maxHealth: CGFloat, size: CGSize? = nil) {
        
        let texture = SKTexture(imageNamed: textureName)
        
        self.init(texture: texture, healthImageName: healthImageName, maxHealth: maxHealth, size: size)
        
        if let frameImageName = frameImageName {
            let frameSprite = SKSpriteNode(imageNamed: frameImageName)
            frameSprite.name = TGKProgressBarNodeNames.healthFrame
            frameSprite.zPosition = self.cropNode.zPosition + 1
            self.addChild(frameSprite)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("TGK Healthbar \(#function)")
    }
    
    public func setCallback(function: @escaping ()->()) {
        self.onHealthDepleted = function
    }
    
    public func modifyHealth(byAmount amount:CGFloat) {
        
        guard currentHealth > 0 || amount > 0 else { return }
        
        self.currentHealth += amount
        
        if currentHealth > maxHealth { currentHealth = maxHealth }
        
        let percentHealth = currentHealth/maxHealth
        
        let xPosition = (self.size.width * percentHealth) - self.size.width
        
        self.healthSprite.position.x = xPosition
        
    }
}

