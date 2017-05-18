//
//  ClippedScroller.swift
//  TroubleGamr
//
//  Created by Nicholas Osto on 5/13/17.
//  Copyright © 2017 Nicholas Osto. All rights reserved.
//

import Foundation
import SpriteKit

protocol SwipeDelegate {
    func touchesMoved()
   // func touchesEnded()
}


public class TGKVerticalScrollWindow: SwipeDelegate {
    
    public let node = SKNode()
    
    var frameSprite: SKSpriteNode?
    var scrollView: TGKScrollView
    var scrollBar: TGKScrollBar
    
    
    //Convinience Properties
    
    var scrollHeight: CGFloat = 0
    var scrollContainerHeight: CGFloat = 0
    
    private init(scrollView: TGKScrollView, menuItems:[SKSpriteNode], frameSprite: SKSpriteNode? = nil) {
        
        self.scrollView = scrollView
        self.frameSprite = frameSprite
        
        for menuItem in menuItems {
            scrollView.addMenuItem(menuItem: menuItem)
        }
        
        self.scrollBar = TGKScrollBar(backgroundTextureName: "scrollBar", positionIndicatorImageName: "scrollIndicator", width: 25, scrollBarHeight: scrollView.getFrameSize().height, listHeight: scrollView.getListHeight())
        
        self.node.addChild(scrollView)
        self.node.addChild(scrollBar)
        
        // Setup frame if it exists
        if let frameSprite = frameSprite {
            self.frameSprite = frameSprite
            
            node.addChild(frameSprite)
            
            frameSprite.zPosition = 3
        }
        
        // set zPositions
        self.node.zPosition = 1
        self.scrollView.zPosition = 1
        self.scrollBar.zPosition = 2
        
        // set Positions
        self.scrollBar.position.x += scrollView.size.width/2 - scrollBar.size.width/2 - 10
        
        // assign Delegate
        
        scrollView.delegate = self
        
        self.setScrollPosition()
    }
    
    public convenience init(backgroundTextureName: String, menuItems:[SKSpriteNode], frameTextureName: String?, itemGapHeight:CGFloat? = 0) {
        var frameSprite: SKSpriteNode?
        
        if let frameTextureName = frameTextureName {
            frameSprite = SKSpriteNode(imageNamed: frameTextureName)
        }
        let scrollView = TGKScrollView(textureName: backgroundTextureName, itemGapHeight: itemGapHeight)
        self.init(scrollView: scrollView, menuItems: menuItems, frameSprite: frameSprite)
        
    }
    
    private func setScrollPosition() {
        let cameraLocation = scrollView.getCameraPosition() - 0.6
        
        let scaleFactor = (scrollBar.size.height + scrollBar.positionIndicator.size.height)/2
        
        scrollBar.moveIndicatorToPosY(scaleFactor * cameraLocation * -1)
    }
    
    public func touchesMoved() {
        setScrollPosition()
        
    }
    
//    public func touchesEnded() {
//        
//        let cameraLocation = scrollView.getCameraPosition() - 0.6
//        
//        let scaleFactor = (scrollBar.size.height + scrollBar.positionIndicator.size.height)/2
//        
//        scrollBar.moveIndicatorToPosY(scaleFactor * cameraLocation * -1)
//    }
}

internal class TGKScrollView: SKSpriteNode {
    // Delegate
    var delegate: SwipeDelegate?
    
    // Utility properties
    var maskingNode: SKCropNode = SKCropNode()
    var menuCamera: SKCameraNode = SKCameraNode()
    var menuItemsNode: SKNode = SKNode()
    var clippingFrame:SKTexture

    // Prefferance Properties
    var menuItemXOffset: CGFloat = -20
    var menuItemHeight: CGFloat = 0
    var itemGapHeight: CGFloat
    
    // Computed Properties 
    var topPositionY: CGFloat { return (clippingFrame.size().height - menuItemHeight)/2 }
    var bottomPositionY: CGFloat {
        return (menuItemsNode.calculateAccumulatedFrame().size.height - topPositionY - menuItemHeight)
    }
    
    internal convenience init(textureName: String, itemGapHeight:CGFloat? = 0) {
        self.init(backgroundTexture: SKTexture(imageNamed: textureName), itemGapHeight: itemGapHeight)
    }
    
    internal init(backgroundTexture: SKTexture, itemGapHeight: CGFloat? = 0) {
        
        let texture = backgroundTexture
        
        self.clippingFrame = texture
        self.itemGapHeight = itemGapHeight ?? 0
        
        
        super.init(texture: texture, color: .white, size: texture.size())
        
        // Setup Clipping Mask
        self.maskingNode.maskNode = SKSpriteNode(texture: clippingFrame)

        // setup Z Positions
        self.zPosition = 0
        self.maskingNode.zPosition = 1
        self.menuCamera.zPosition = 1
        self.menuItemsNode.zPosition = 1
        
        // Add children
        self.addChild(maskingNode)
        self.maskingNode.addChild(self.menuCamera)
        self.menuCamera.addChild(self.menuItemsNode)
    
        // Enable userInteraction
        self.isUserInteractionEnabled = true
    }

    internal required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    internal func addMenuItem(menuItem: SKSpriteNode) {

        var nextPosition: CGFloat = 0
        
        menuItemHeight = menuItem.size.height
        
        if (menuItemsNode.children.count > 0) {
            
            nextPosition =  -1 * (menuItemsNode.calculateAccumulatedFrame().height + itemGapHeight)
        }
        
        menuItem.position = CGPoint(x: self.menuItemXOffset, y: nextPosition)
        
        menuItemsNode.addChild(menuItem)
        
        menuCamera.position.y = topPositionY
    }
    
    internal func getCameraPosition() -> CGFloat {
        return menuCamera.position.y / (menuItemsNode.calculateAccumulatedFrame().size.height - clippingFrame.size().height)
    }
    
    internal func getFrameSize() -> CGSize {
        return clippingFrame.size()
    }
    internal func getListHeight() -> CGFloat {
        return(menuItemsNode.calculateAccumulatedFrame().size.height)
    }

    // Touch Handlers
    override internal func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        
        let previousLocation = touch.previousLocation(in: self)
        
        menuCamera.position.y += location.y - previousLocation.y
        
        delegate?.touchesMoved()
    }
    
    override internal func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        if menuCamera.position.y >= bottomPositionY { menuCamera.run(bottomBounceAction(bottomPosition: bottomPositionY)) }

        if menuCamera.position.y <= topPositionY { menuCamera.run(topBounceAction(topPosition: topPositionY)) }
        

    }
    
    // Bounce Effect Actions
    private func topBounceAction(topPosition: CGFloat) -> SKAction{
        
        let myAction1 = SKAction.move(to: CGPoint(x:0, y: topPosition + 50), duration: 0.5)
        let myAction2 = SKAction.move(to: CGPoint(x:0, y: topPosition - 5), duration: 0.5)
        
        myAction1.timingMode = SKActionTimingMode.easeOut
        myAction2.timingMode = SKActionTimingMode.easeIn
        
        let groupAction = SKAction.sequence([myAction1, myAction2])
        
        return groupAction
    }
    
    private func bottomBounceAction(bottomPosition: CGFloat) -> SKAction{
        
        let myAction1 = SKAction.move(to: CGPoint(x:0, y: bottomPosition - 50), duration: 0.5)
        let myAction2 = SKAction.move(to: CGPoint(x:0, y: bottomPosition + 5), duration: 0.5)
        
        myAction1.timingMode = SKActionTimingMode.easeOut
        myAction2.timingMode = SKActionTimingMode.easeIn
        
        let groupAction = SKAction.sequence([myAction1, myAction2])
        
        return groupAction
    }
    
}

internal class TGKScrollBar:SKSpriteNode {
    
    var maskingNode: SKCropNode = SKCropNode()
    var maskingSpriteNode: SKSpriteNode = SKSpriteNode()
    var positionIndicator: SKSpriteNode = SKSpriteNode()
    
    // Calculated Properties
    var topPositionY: CGFloat { return (maskingSpriteNode.size.height/2 - positionIndicator.size.height/2) }
    var bottomPositionY: CGFloat { return -1 * (maskingSpriteNode.size.height/2 - positionIndicator.size.height/2) }
    
    
    internal init(backgroundTextureName: String, positionIndicatorImageName: String, width: CGFloat, scrollBarHeight: CGFloat, listHeight: CGFloat) {
        
        let texture = SKTexture(imageNamed: backgroundTextureName)
        
        // Setup Masking Node
        self.maskingSpriteNode = SKSpriteNode(imageNamed: backgroundTextureName)
        self.maskingSpriteNode.size = CGSize(width: width, height: scrollBarHeight)
        self.maskingNode.maskNode = maskingSpriteNode

        // Setup Positional Indicator
        self.positionIndicator = SKSpriteNode(imageNamed: positionIndicatorImageName)
        self.positionIndicator.size.width = width
        self.positionIndicator.size.height *= scrollBarHeight/listHeight
        
        super.init(texture: texture, color: .white, size: texture.size())
        
        
        self.size = self.maskingSpriteNode.size
        
        // Add Children
        self.addChild(maskingNode)
        maskingNode.addChild(positionIndicator)
        
        // set Z Position
        maskingNode.zPosition = 1
    
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    internal func moveIndicatorToPosY(_ posY: CGFloat) {
        
        if posY >= topPositionY {
            positionIndicator.position.y = topPositionY
        }
        else if posY <= bottomPositionY {
            positionIndicator.position.y = bottomPositionY
        }
        else {
            positionIndicator.position.y = posY
        }
    }

}










