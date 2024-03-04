//
//  GLobals.swift
//  HOTH
//
//  Created by Marius Genton on 3/3/24.
//

import Foundation
import UIKit

enum Tab { case Home, Add, Profile }

enum ActivityType { case Walk, Ride }

enum AuthStatus { case Uninitialized, Manual, AutoSignedIn }

let USERNAME_KEY = "saved_username"
let PASSWORD_KEY = "saved_password"


final class HapticManager {
    static func mediumFeedback() { Task {
        await UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }}
}

func co2saving(distance: Int) -> Double {
    return (0.18785 * 1.6 * Double(distance)) / 1000
}
