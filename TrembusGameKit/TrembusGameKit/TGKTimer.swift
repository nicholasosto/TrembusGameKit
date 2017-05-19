//
//  TGKFile.swift
//  TrembusGameKitTesting
//
//  Created by Nicholas Osto on 5/19/17.
//  Copyright © 2017 Nicholas Osto. All rights reserved.
//

import Foundation
import SpriteKit

public class TGKTimer {
    
    
    
    private var timeLimit: Int
    private var timeLeft: Int = 0
    public var timeLabel = SKLabelNode(fontNamed: "Chalkduster")
    public var timeFunction: ()->()
    private var timeText = "Time"
    private var enabled:Bool
    private var timeFormat:String = "%02d"
    
    public init(timeLimitDays: Int = 0, timeLimitHours:Int = 0, timeLimitMinutes: Int = 0, timeLimitSeconds:Int = 0, timeFunction: @escaping ()->()) {
        
        self.timeLimit = (timeLimitDays * 86400) + (timeLimitHours * 3600) + (timeLimitMinutes * 60) + timeLimitSeconds
        self.enabled = false
        self.timeLeft = timeLimit
        self.timeFunction = timeFunction
        
        
        timeLabel.fontSize = 12
        timeLabel.verticalAlignmentMode = .center
        timeLabel.horizontalAlignmentMode = .center
        timeLabel.position = CGPoint.zero
        timeLabel.zPosition = 1
        timeLabel.text = timeText
        
        
        print(self.timeLimit)
    }
    
    
    public func startTimer() {

        self.enabled = true
        updateTimeLabel()
   
    }
    public func stopTimer() {
        self.enabled = false
    }
    
    public func updateTimeLabel() {
        
        
        let days = timeLeft / 24 / 60 / 60
        let hours = (timeLeft  / 60 / 60) % 24
        let mins = (timeLeft / 60) % 60
        let seconds = timeLeft % 60
        
        print("Hours\(hours) Min\(mins) Sec\(seconds)")
        print("timeLeft - days * 8600 \(timeLeft - days * 86400)")
        
        switch timeLeft {
        case (0...59):
            self.timeText = String(format: "%02d Sec", seconds)
        case (60...3599):
            self.timeText = String(format: "%02d M %02dSec", mins, seconds)
        case (3600...86399):
            self.timeText = String(format: "%02d H %02d M %02d Sec", hours, mins, seconds)
        case (86400...Int.max):
            self.timeText = String(format: "%02d D %02d H %02d M %02d Sec", days, hours, mins, seconds)
        default:
            self.timeText = String(format: "%02ds NEWWWWB", timeLeft)
        }

        
        self.timeLabel.text = timeText
    }
    
    public func getDaysLeft()->Int {
        print("timeLimit: \(timeLimit)")
        
        let daysLeft = timeLimit / 86400

        return(daysLeft)
    }
    
    public func updateTimer(time: Int) {
        
        guard self.enabled else { return }
        
        self.timeLeft -= time
        updateTimeLabel()
        
        if(timeLeft <= 0) {
            timeFunction()
            self.enabled = false
        }
    
        
    }
    
    
}
