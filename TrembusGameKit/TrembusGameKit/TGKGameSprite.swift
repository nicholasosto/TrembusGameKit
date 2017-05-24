//
//  TGKGameSprite.swift
//  TrembusGameKit
//
//  Created by Nicholas Osto on 5/22/17.
//  Copyright © 2017 Nicholas Osto. All rights reserved.
//

import Foundation
import SpriteKit

open class TGKGameSprite: SKSpriteNode {
    
    public let gameClass: GameClass
    
    private let timePerFrame = 0.03
    
    public var healthBar: TGKHealthBar? = nil
    
    public init(textureName: String, gameClass: GameClass) {
        
        let texture = SKTexture(imageNamed: textureName)
        
        self.gameClass = gameClass
        
        super.init(texture: texture, color: .white, size: texture.size())
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("TGKGameSprite: \(#function)")
    }
    
    public func addHealthBar(textureName: String, healthImageName: String, maxHealth: CGFloat) {
        let healthTexture = SKTexture(imageNamed: textureName)
        let healthBar = TGKHealthBar(texture: healthTexture, healthImageName: healthImageName, onHealthDepleted: onHealthExpire, maxHealth: maxHealth, size: CGSize(width: 1.2 * self.size.width, height: 50))
        
        healthBar.zPosition = 1
        healthBar.position.y -= (self.size.height/2 + healthBar.size.height)
        
        self.healthBar = healthBar
        addChild(healthBar)
    }
    
    public func walk() {
    
        run(SKAction.repeatForever(TGKAnimationManager.playAnimation(gameClass: gameClass, tag: .walking)), withKey: "\(gameClass.rawValue)_walk")
    }
    
    public func idle() {
        
        run(SKAction.repeatForever(TGKAnimationManager.playAnimation(gameClass: gameClass, tag: .idle)), withKey: "\(gameClass.rawValue)_idle")
    }
    
    public func attack() {
        
        run(TGKSoundManager.playSFX(gameClass: gameClass, tag: .attack))
        run(TGKAnimationManager.playAnimation(gameClass: gameClass, tag: .attack), withKey: "\(gameClass.rawValue)_attack")
        
    }
    
    public func hurt() {
        run(TGKSoundManager.playSFX(gameClass: gameClass, tag: .hurt))
        run(TGKAnimationManager.playAnimation(gameClass: gameClass, tag: .hurt), withKey: "\(gameClass.rawValue)_hurt")
    }
    
    private func onHealthExpire() {
        self.removeAllActions()
        run(TGKSoundManager.playSFX(gameClass: gameClass, tag: .death))
        run(TGKAnimationManager.playAnimation(gameClass: gameClass, tag: .death), withKey: "\(gameClass.rawValue)_death")
    }
}
