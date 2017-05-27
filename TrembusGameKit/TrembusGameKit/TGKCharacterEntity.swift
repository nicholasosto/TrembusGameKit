//
//  TGKCharacterEntity.swift
//  TrembusGameKit
//
//  Created by Nicholas Osto on 5/26/17.
//  Copyright © 2017 Nicholas Osto. All rights reserved.
//

import Foundation
import GameplayKit

public class TGKEntity: GKEntity {
    
    public func getSprite() -> TGKGameSprite? {
        
        if let sprite = self.component(ofType: TGKSpriteComponent.self)?.node {
            return(sprite)
        }
        return nil
    }
    
    public func getTeam() -> TGKTeam? {
        
        if let team = self.component(ofType: TGKTeamComponent.self)?.team {
            return team
        }
        return nil
    }
    
    public func  getAgent() -> TGKAgent? {
        if let agent = self.component(ofType: TGKAgent.self) {
            return agent
        }
        return nil
    }
}
