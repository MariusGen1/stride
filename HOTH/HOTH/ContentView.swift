//
//  ContentView.swift
//  HOTH
//
//  Created by Marius Genton on 3/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var user: User?
    @State private var selectedTab: Tab = .Home
    @State private var presentingFriendsSheet = false
    
    init(user: Binding<User?>) {
        self._user = user
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor(Color("C5"))
        
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().prefersLargeTitles = true
        
        UISearchBar.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = .black
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white], for: .normal)
        
        UITabBar.appearance().barTintColor = .white // Background color of the tab bar
        UITabBar.appearance().layer.borderWidth = 0.0 // Remove the border line
        
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch selectedTab {
                case .Home:
                    Home(user: $user)
                case .Add:
                    Add(user: $user)
                case .Profile:
                    Profile(user: $user)
                }
                
                
                VStack(spacing: 0) {
                    Spacer()
                    HStack {
                        Spacer()
                        TabBar(selectedTab: $selectedTab)
                        Spacer()
                    }
                    Spacer().frame(height: 15)
                }
                .sheet(isPresented: $presentingFriendsSheet, content: {
                    AddFriendsSheet(user: $user)
                })
                .navigationTitle(selectedTab == .Home ? "Home" : (selectedTab == .Add ? "Add" : "Profile"))
                .navigationBarItems(trailing:
                                        HStack {
                    Button(action: {
                        presentingFriendsSheet = true
                        HapticManager.mediumFeedback()
                    }, label: { Image(systemName: "person.fill.badge.plus") })
                        .foregroundStyle(.white)
                })
            }
            .background(Color("C1"))
        }
    }
}

