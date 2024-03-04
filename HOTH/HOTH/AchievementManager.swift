//
//  AchievementManager.swift
//  HOTH
//
//  Created by Marius Genton on 3/3/24.
//

import Foundation
import SwiftUI

class AchievementManager {
    
    static func loadAchievements(user: User, activities: [Activity]) -> [Achievement] {
        var a = [Achievement(name: "The Beginnings", description: "Make a stride account", image: Image("Baby"))]
        
        if activities.count > 0 {
            a.append(Achievement(name: "First Steps", description: "Log an activity.", image: Image("Shoes")))
        }
        
        var hasUploadedRide = false
        var hasUploadedWalk = false
        for activity in activities {
            if activity.activityType == .Ride { hasUploadedRide = true }
            else { hasUploadedWalk = true }
        }
        
        if hasUploadedRide {
            a.append(Achievement(name: "Broom Broom", description: "Log a ride.", image: Image("Cycling")))
        }
        
        if hasUploadedWalk {
            a.append(Achievement(name: "Walky Walky", description: "Log a walk", image: Image("Walking")))
        }
        
        if user.following.count > 0 {
            a.append(Achievement(name: "Networking AF", description: "Follow someone.", image: Image("Networking")))
        }
        
        if user.following.count >= 5 {
            a.append(Achievement(name: "Extrovert", description: "Follow 5 people.", image: Image("Talking")))
        }
        
        if activities.count >= 10 {
            a.append(Achievement(name: "Power User", description: "Log 10 activities.", image: Image("Superhero")))
        }
        
        return a.reversed()
    }
}
