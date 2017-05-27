//
//  TGKAgent.swift
//  TrembusGameKit
//
//  Created by Nicholas Osto on 5/26/17.
//  Copyright © 2017 Nicholas Osto. All rights reserved.
//

import Foundation
import GameplayKit

public class TGKAgent: GKAgent2D, GKAgentDelegate {
    
    public var enemy:GKAgent2D?
    
    public init(mass: Float, acceleration: Float, maxSpeed: Float, radius: Float) {
        
        super.init()
        self.mass = mass
        self.maxAcceleration = acceleration
        self.maxSpeed = maxSpeed
        delegate = self
        
        print("Position: \(self.position)")
    }
    
    public func setEnemyFromEntity(_ entity:GKEntity) {
    
        if let enemyAgent = entity.component(ofType: TGKAgent.self) {
            self.enemy = enemyAgent
        }
        else {
            print("No Enemy found")
        }
    
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("TGKAgent \(#function)")
        
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let myEnemy = self.enemy else { return }
        
        behavior = TGKBehavior(targetSpeed: maxSpeed, seek: myEnemy)
    }
    
    public func agentWillUpdate(_ agent: GKAgent) {
        guard let spriteNode = entity?.component(ofType: TGKSpriteComponent.self)?.node else { return }
        
        self.position = float2(spriteNode.position)
        
        if self.position.y > 200 || spriteNode.position.y > 200{
            self.position.y = 200
            spriteNode.position.y = 200
        }

    }
    
    public func agentDidUpdate(_ agent: GKAgent) {
        guard let spriteNode = entity?.component(ofType: TGKSpriteComponent.self)?.node else { return }
        
        spriteNode.position = CGPoint(self.position)
        
        if spriteNode.position.x < 0 {
            spriteNode.xScale = 1
        } else {
            spriteNode.xScale = -1
        }
        
        guard let enemyAgent = self.enemy else {return}
        
        let distance = abs(self.position.x - enemyAgent.position.x)
        
        if distance <= 100 {
            spriteNode.attack()
            enemy?.entity?.component(ofType: TGKSpriteComponent.self)?.node.hurt(byAmount: -10)
            
        } else {
            spriteNode.walk()
        }
        
    }
    

}

public class TGKBehavior: GKBehavior {
    
    public init(targetSpeed: Float, seek: GKAgent) {
        
        super.init()
        
        if targetSpeed > 0 {
            
            setWeight(0.5, for: GKGoal(toReachTargetSpeed: targetSpeed))
            setWeight(0.5, for: GKGoal(toSeekAgent: seek))
            //setWeight(1.0, for: GKGoal(toAvoid: avoid, maxPredictionTime: 1.0))
        }
    }
}
