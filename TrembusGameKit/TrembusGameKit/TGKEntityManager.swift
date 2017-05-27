//
//  TGKEntityManager.swift
//  TrembusGameKit
//
//  Created by Nicholas Osto on 5/25/17.
//  Copyright © 2017 Nicholas Osto. All rights reserved.
//
//
import Foundation
import GameplayKit


public class TGKEntityManager {
    
    var entities:[TGKEntity] = [TGKEntity]()
    var agentSystem: GKComponentSystem = GKComponentSystem(componentClass: TGKAgent.self)
    var toRemove:Set<GKEntity> = Set<GKEntity>()
    let scene: SKScene
    
    public init(scene: SKScene) {
        
        self.scene = scene
        
    }
    
    public func addEntity(_ entity: TGKEntity) {
        
        self.entities.append(entity)
        
        if let spriteComponent = entity.component(ofType: TGKSpriteComponent.self) {
            scene.addChild(spriteComponent.node)
            spriteComponent.node.entity = entity
        }
        
        if let agent = entity.component(ofType: TGKAgent.self) {
            agentSystem.addComponent(agent)
        }
    }
    
    public func removeEntity(_ entity: GKEntity) {
        self.toRemove.insert(entity)
    }
    
    
    public func getEntitiesForTeam(_ team:TGKTeam) ->[TGKEntity]{
        
        var entitiesForTeam: [TGKEntity] = [TGKEntity]()
        
        for entity in entities {
            if entity.component(ofType: TGKTeamComponent.self)?.team == team {
                entitiesForTeam.append(entity)
            }
        }

        
        return entitiesForTeam
    }
    
    public func spawnRobot(atPoint position: CGPoint) {
        
        let spriteNode = TGKGameSprite(textureName: "robot_idle_001", gameClass: .robot)
        spriteNode.addHealthBar(textureName: "loading_2", healthImageName: "loading_3", maxHealth: 200)
        spriteNode.position = position
        let spriteComponent = TGKSpriteComponent(node: spriteNode)
        
        let teamComponent = TGKTeamComponent(team: .robot)
        
        let agent = TGKAgent(mass: 0.01, acceleration: 150, maxSpeed: 400, radius: 50)
        
        let entity = TGKEntity()
        
        entity.addComponent(agent)
        entity.addComponent(teamComponent)
        entity.addComponent(spriteComponent)
        
        self.addEntity(entity)
    }
    
    public func spawnGoblin(atPoint position: CGPoint) {
        
        let spriteNode = TGKGameSprite(textureName: "goblin_idle_001", gameClass: .goblin)
        spriteNode.addHealthBar(textureName: "loading_2", healthImageName: "loading_3", maxHealth: 200)
        spriteNode.position = position
        let spriteComponent = TGKSpriteComponent(node: spriteNode)
        
        let teamComponent = TGKTeamComponent(team: .goblin)
        
        let agent = TGKAgent(mass: 0.01, acceleration: 150, maxSpeed: 400, radius: 50)
        
        let entity = TGKEntity()
        
        entity.addComponent(agent)
        entity.addComponent(teamComponent)
        entity.addComponent(spriteComponent)
        
        self.addEntity(entity)
        
    }
    
    public func update(_ deltaTime:CFTimeInterval) {

        agentSystem.update(deltaTime: deltaTime)
    }
}
