//
//  AddFriendsSheet.swift
//  HOTH
//
//  Created by Marius Genton on 3/3/24.
//

import SwiftUI

struct AddFriendsSheet: View {
    
    @Binding var user: User?
    @State private var allUsers = [(String, String, String)]()
    
    var body: some View {
        ScrollView {
            
            HStack {
                Text("Follow your friends")
                Spacer()
            }
            .font(.title)
            .fontWeight(.bold)
            .padding([.leading, .trailing, .top])
            .padding(.top)
            
            if allUsers.count == 0 {
                VStack {
                    Spacer(minLength: 300)
                    HStack {
                        Spacer()
                        ProgressView().progressViewStyle(.circular)
                        Spacer()
                    }
                    Spacer(minLength: 500)
                }
            } else {
                VStack {
                    
                    ForEach(allUsers.indices, id: \.self) { i in
                        if allUsers[i].2 != user?.id {
                            HStack {
                                Text("\(allUsers[i].0) (\(allUsers[i].1))")
                                    .fontWeight(.bold)
                                Spacer()
                                
                                if !(user?.following.contains(allUsers[i].2) ?? false) {
                                    
                                    Button {
                                        Task { 
                                            await DataManager.follow(currentUser: user!, accountToFollow: allUsers[i].2)
                                            let newU = await DataManager.getUserByID(user!.id)
                                            withAnimation {
                                                user = newU
                                            }
                                        }
                                    } label: {
                                        ZStack {
                                            Rectangle()
                                                .foregroundStyle(Color("C5"))
                                                .cornerRadius(10)
                                            
                                            HStack {
                                                Image(systemName: "plus")
                                                Text("Follow")
                                            }
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white)
                                            .padding(10)
                                        }
                                    }
                                    .fixedSize()
                                } else {
                                    Text("Following")
                                        .italic()
                                        .opacity(0.6)
                                        .padding([.top, .bottom], 10)
                                }
                            }
                            .padding([.leading, .trailing])
                        }
                    }
                }
                Spacer(minLength: 500)
            }
        }
        .background(Color("C1"))
        .onAppear { Task {
            let n = await DataManager.getAllUsers()
            withAnimation {
                allUsers = n
            }
        }}
    }
}

