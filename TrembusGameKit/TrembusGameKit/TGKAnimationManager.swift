//
//  TGKAnimationManager.swift
//  TrembusGameKitTesting
//
//  Created by Nicholas Osto on 5/23/17.
//  Copyright © 2017 Nicholas Osto. All rights reserved.
//

import SpriteKit

open class TGKAnimationManager {
    
    
    public enum AnimationTag:String {

        case attack = "attack"
        case hurt = "hurt"
        case death = "death"
        case idle = "idle"
        case walking = "walking"
    }
    
    
    public static func playAnimation(gameClass: GameClass, tag: AnimationTag)-> SKAction {
        
        let animationFile = "\(gameClass.rawValue)_\(tag.rawValue)"
        
        return getAnimationForFileNamed(fileName: animationFile)
    }
    
    
    private static func getAnimationForFileNamed(fileName:String) -> SKAction {
        
        var pngFiles:[String] = [String]()
        var animationFrames:[SKTexture] = [SKTexture]()
        
        let resourcePath = NSURL(string: Bundle.main.resourcePath!)?.absoluteURL
        
       // print(resourcePath?.absoluteString)
        let resourcesContent = try! FileManager().contentsOfDirectory(at: resourcePath!, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
        
        for url in resourcesContent {
            if url.lastPathComponent.contains(fileName) && url.lastPathComponent.contains(".png") {
                pngFiles.append(url.lastPathComponent)
            }
        }
        
        for png in pngFiles {
            
            animationFrames.append(SKTexture(imageNamed: png))
        }
        
        //print(pngFiles)
        let timePerFrame = 0.4/Double(pngFiles.count)
        return(SKAction.animate(with: animationFrames, timePerFrame: timePerFrame, resize: true, restore: false))
    }
    
}

