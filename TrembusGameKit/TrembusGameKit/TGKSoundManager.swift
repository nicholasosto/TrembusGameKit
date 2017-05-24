//
//  TGKSoundManager.swift
//  TrembusGameKit
//
//  Created by Nicholas Osto on 5/23/17.
//  Copyright © 2017 Nicholas Osto. All rights reserved.
//

import SpriteKit


open class TGKSoundManager {
    

    public enum SoundTag:String {
        // Character Sounds
        case attack = "attack"
        case hurt = "hurt"
        case death = "death"
        
        // User Interface
        case click = "click"
        case open = "open"
        
        // Backgrounds
        case beach = "beach"
    }
 
    public static func playSFX(gameClass: GameClass, tag: SoundTag) -> SKAction {
        
        let soundFile = "\(gameClass.rawValue)_\(tag.rawValue)"
        
        return(SKAction.playSoundFileNamed(soundFile, waitForCompletion: false))
    }
    
}
