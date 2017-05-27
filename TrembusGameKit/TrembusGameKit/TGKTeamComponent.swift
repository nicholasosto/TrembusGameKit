//
//  TGKTeamComponent.swift
//  TrembusGameKit
//
//  Created by Nicholas Osto on 5/25/17.
//  Copyright © 2017 Nicholas Osto. All rights reserved.
//

import Foundation
import GameplayKit

public enum TGKTeam: Int {
    
    case robot = 1
    case goblin = 2
    
    public func getOppositeTeam() -> TGKTeam {
        switch self {
            
        case .goblin:
                return .robot
        case .robot:
                return .goblin
        }
    }
}

public class TGKTeamComponent:GKComponent {
    
    public let team:TGKTeam
    
    public init(team: TGKTeam) {
        self.team = team
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Team Component \(#function) not configured")
    }
    
}
