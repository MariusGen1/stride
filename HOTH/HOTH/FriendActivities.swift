//
//  FriendActivities.swift
//  HOTH
//
//  Created by Marius Genton on 3/3/24.
//

import SwiftUI

struct ActivityList: View {
    
    let isSelf: Bool
    let activities: [Activity]
    
    func formatDate(_ date: Date) -> String {
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "MMMM d, h:mm"
        return formatter1.string(from: date)
    }

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.white)
                .cornerRadius(15)
            
            VStack {
                ForEach(activities.indices, id: \.self) { i in
                    HStack {
                        Image(systemName: activities[i].activityType == .Walk ? "figure.walk.circle" : "bicycle.circle")
                            .foregroundStyle(Color("C5"))
                            .fontWeight(.bold)
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("\(isSelf ? "You" : activities[i].userName) \(activities[i].activityType == .Ride ? "rode" : "walked") \((Double(activities[i].distance) / 1000), specifier: "%.1f") miles")
                                .fontWeight(.semibold)
                            Text(formatDate(activities[i].date))
                                .font(.footnote)
                                .opacity(0.5)
                        }
                        
                        Spacer()
                    }
                    
                    if i < activities.count - 1 {
                        Divider()
                    }
                }
            }
            .padding()
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

//#Preview {
//    ActivityList(isSelf: false, activities: [
//        Activity(name: "A", description: "B", activityType: .Ride, distance: 2450, profilePhoto: Image(""), userName: "Gianna", likeCount: 2, id: "abc"),
//        Activity(name: "A2", description: "B", activityType: .Ride, distance: 1250, profilePhoto: Image(""), userName: "Gianna", likeCount: 2, id: "ab"),
//        Activity(name: "A3", description: "Some long ahhhhh description just to annoy the dev. Will prob fuck the app up", activityType: .Ride, distance: 1253, profilePhoto: Image(""), userName: "Gianna", likeCount: 2, id: "a"),
//    ])
//}
