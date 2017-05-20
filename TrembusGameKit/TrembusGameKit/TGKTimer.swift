//
//  TGKTimer.swift
//  TrembusGameKit
//
//  Created by Nicholas Osto on 5/19/17.
//  Copyright © 2017 Nicholas Osto. All rights reserved.
//

import Foundation
import SpriteKit

public enum TGKFontTimeDisplay:String {
    case days = "%02d Days %02d Hrs %02d Min %02d Sec"
    case hours = "%02d Hrs %02d Min %02d Sec"
    case minutes = "%02d Min %02d Sec"
    case seconds = "%02d Sec"
}

public class TGKTimerLabel: SKLabelNode {
 
    
    var labelText: String = "Time Label"
    var formatString: TGKFontTimeDisplay = .seconds
    var timer: TGKTimer
    
    public init(font: String = "Optima", timer:TGKTimer) {
        print("Version: 02")
        self.timer = timer

        super.init()
        
        
        self.verticalAlignmentMode = .center
        self.horizontalAlignmentMode = .center
        self.fontSize = 54
        
        self.fontColor = UIColor.white
        self.fontName = font
        self.position = CGPoint(x: 0, y: 0)
        self.upadteLabelText()

    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Outch")
    }
    
    private func upadteLabelText() {
        print("time Left: \(timer.getTimeLeft())")
        switch timer.getTimeLeft(){
        case (0...59):
            formatString = .seconds
            self.text = String(format: formatString.rawValue, timer.getSeconds())
        case (60...3599):
            formatString = .minutes
            self.text = String(format: formatString.rawValue, timer.getMinutes(), timer.getSeconds())
        case (3600...86399):
            formatString = .hours
            self.text = String(format: formatString.rawValue, timer.getHours(), timer.getMinutes(), timer.getSeconds())
        case (86400...Int.max):
            formatString = .days
            self.text = String(format: formatString.rawValue, timer.getDays(), timer.getHours(), timer.getMinutes(), timer.getSeconds())
        default:
            self.text = String(format: formatString.rawValue, timer.getTimeLeft())
        }
    }
    
    public func update(dt: TimeInterval) {

        timer.updateTimer(dt: dt)
        upadteLabelText()
    }

}

public class TGKTimer {
    
    public var timeFunction: ()->()?
    
    private var timeSinceUpdate: TimeInterval = 0
    private var timeLimit: Int
    private var timeLeft: Int = 0
    private var enabled:Bool = false

    
    public init(timeLimitDays: Int = 0, timeLimitHours:Int = 0, timeLimitMinutes: Int = 0, timeLimitSeconds:Int = 0, timeFunction: @escaping ()->()?) {
        
        self.timeLimit = (timeLimitDays * 86400) + (timeLimitHours * 3600) + (timeLimitMinutes * 60) + timeLimitSeconds
        self.timeLeft = timeLimit
        self.timeFunction = timeFunction

    }
    
    public func getDays() -> Int {
        return(timeLeft/24/60/60)
    }
    public func getHours() -> Int {
        return((timeLeft  / 60 / 60) % 24)
    }
    public func getMinutes() ->Int {
        return((timeLeft / 60) % 60)
    }
    public func getSeconds() ->Int {
        return(timeLeft%60)
    }
    
    public func getTimeLeft() ->Int {
        return(timeLeft)
    }
    
    public func resetTimer() {
        self.timeLeft = self.timeLimit
        self.timeSinceUpdate = 0
    }
    
    public func startTimer() {
        self.enabled = true
    }
    
    public func stopTimer() {
        self.enabled = false
    }

    public func updateTimer(dt: TimeInterval) {
        
        guard self.enabled == true else { return }
        
        timeSinceUpdate += dt
        
        if(timeSinceUpdate >= 1) {
            
            self.timeLeft -= 1
            
            timeSinceUpdate = 0
        }
        
        if(timeLeft <= 0) {
            
            timeFunction()
        }
    }
}


