//
//  Profile.swift
//  HOTH
//
//  Created by Marius Genton on 3/3/24.
//

import SwiftUI

struct Profile: View {
    
    @Binding var user: User?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Text("Name")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(user?.name ?? "")
                }
                HStack {
                    Text("Username")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(user?.username ?? "")
                }
                HStack {
                    Text("Account creation date")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(user?.accountCreationDate ?? "")
                }
                
                Button {
                    HapticManager.mediumFeedback()
                    withAnimation { DataManager.removeAutoLogin(); user = nil }
                } label: {
                    ZStack {
                        Rectangle()
                            .cornerRadius(10)
                            .foregroundStyle(Color("C5"))
                        Text("Sign out")
                            .foregroundStyle(.white)
                            .padding()
                            .fontWeight(.semibold)
                    }
                }
                .padding()
                .fixedSize()
            }
            .padding()
        }
    }
}
