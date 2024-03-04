//
//  AchievementCard.swift
//  HOTH
//
//  Created by Marius Genton on 3/3/24.
//

import SwiftUI

struct AchievementCard: View {
    
    let achievement: Achievement
    
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(15)
                .foregroundStyle(.white)
            
            VStack {
                achievement.image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                Text(achievement.name)
                    .fontWeight(.bold)
                Text(achievement.description)
                    .multilineTextAlignment(.leading)
                    .opacity(0.7)
                    .font(.footnote)
            }
            .padding()
        }
        .fixedSize()
    }
}

#Preview {
    AchievementCard(achievement: Achievement(name: "King of the Castle", description: "Logged 5 acitvities", image: Image("tidin")))
}
