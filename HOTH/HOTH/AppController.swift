//
//  AppController.swift
//  HOTH
//
//  Created by Marius Genton on 3/3/24.
//

import SwiftUI

struct AppController: View {
    
    @State private var user: User? = nil
    @State private var authStatus: AuthStatus = .Uninitialized
    
    var body: some View {
        if user != nil {
            ContentView(user: $user)
        } else {
            if authStatus == .Uninitialized { LoadingView(authStatus: $authStatus, userID: $user)}
            else if authStatus == .Manual {
                ManualSignIn(authStatus: $authStatus, user: $user)
            }
        }
    }
}

#Preview {
    AppController()
}
