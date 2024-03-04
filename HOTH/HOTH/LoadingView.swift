//
//  LoadingView.swift
//  HOTH
//
//  Created by Marius Genton on 3/3/24.
//

import SwiftUI

struct LoadingView: View {
    
    @Binding var authStatus: AuthStatus
    @Binding var userID: User?
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(.circular)
                    .onAppear {
                        Task {
                            userID = await DataManager.attemptAutoAuth()
                            if userID == nil { authStatus = .Manual}
                        }
                    }
                Spacer()
            }
            Spacer()
        }
        .background(Color("C1"))
    }
}
