//
//  Home.swift
//  HOTH
//
//  Created by Marius Genton on 3/3/24.
//

import SwiftUI

struct Home: View {
    
    @State private var emissionsByDay: [(String, Double)]? = nil
    @State private var emissionsByActivityType: [(ActivityType, Int)]? = nil
    @State private var currentUserActivities = [Activity]()
    @State private var followingActivities = [Activity]()
    @State private var achievements = [Achievement]()
    @Binding var user: User?
    
    func totalEmission() -> Double {
        var s = 0.0
        for day in emissionsByDay! { s += day.1 }
        return s
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ZStack {
                    Rectangle()
                        .foregroundStyle(.white)
                        .cornerRadius(15)
                    
                    VStack(alignment: .leading) {
                        
                        if emissionsByDay != nil && emissionsByActivityType != nil && totalEmission() == 0 {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Welcome, \(user!.name)")
                                        .fontWeight(.bold)
                                    Text("Log an activity to start seeing your impact 👀")
                                        .font(.footnote)
                                        .opacity(0.7)
                                }
                                Spacer()
                            }
                        } else {
                            
                            if emissionsByDay == nil || emissionsByActivityType == nil {
                                Text("Welcome, \(user!.name)")
                                    .fontWeight(.bold)
                                ProgressView().progressViewStyle(.circular)
                            } else {
                                Text("Way to go, \(user!.name)!")
                                    .fontWeight(.bold)
                                Text("You've saved **\(totalEmission(), specifier: "%.2f")kgs** of CO2 emissions so far this week.")
                                HStack {
                                    EmissionsByDay(data: emissionsByDay!)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .padding()
                
                Text("Achievements")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding([.leading, .trailing])
                
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(achievements, id: \.name) { a in
                            AchievementCard(achievement: a)
                        }
                        .padding(.trailing)
                    }
                    .padding(.leading)
                }
                .scrollIndicators(.hidden)
                
                Spacer().frame(height: 20)
                
                Text("Your Activities")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding([.leading, .trailing])
                
                if currentUserActivities.count != 0 {
                    ActivityList(isSelf: true, activities: currentUserActivities)
                        .padding([.leading, .trailing])
                } else {
                    Text("You have not posted any activities yet. Click the Plus button to log your first activity when you are ready!")
                        .font(.footnote)
                        .opacity(0.5)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                Spacer().frame(height: 20)
                
                Text("Following")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding([.leading, .trailing])
                
                
                if followingActivities.count != 0 {
                    ActivityList(isSelf: false, activities: followingActivities)
                        .padding([.leading, .trailing])
                } else {
                    Text("You are not following anyone who has posted yet! Start following friends using the \"Add Friends\" button in the top right corner.")
                        .font(.footnote)
                        .opacity(0.5)
                        .multilineTextAlignment(.center)
                        .padding()
                        .padding(.leading)
                }
                
                Spacer(minLength: 250)
            }
            .onAppear {
                Task {
                    currentUserActivities = await DataManager.getUserActivities(userID: user!.id)
                    achievements = AchievementManager.loadAchievements(user: user!, activities: currentUserActivities)
                    let (byDay, bySport) = await DataManager.getWeeklyStats(user!.id, activities: currentUserActivities)
                    DispatchQueue.main.async { withAnimation {
                        self.emissionsByDay = byDay
                        self.emissionsByActivityType = bySport
                    }}
                }
                Task { followingActivities = await DataManager.getFriendActivities(user!) }
            }
        }
        .refreshable {
            currentUserActivities = await DataManager.getUserActivities(userID: user!.id)
            achievements = AchievementManager.loadAchievements(user: user!, activities: currentUserActivities)
            let (byDay, bySport) = await DataManager.getWeeklyStats(user!.id, activities: currentUserActivities)
            DispatchQueue.main.async { withAnimation {
                self.emissionsByDay = byDay
                self.emissionsByActivityType = bySport
            }}
            followingActivities = await DataManager.getFriendActivities(user!)
        }
    }
}
