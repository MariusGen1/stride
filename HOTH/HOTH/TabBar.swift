//
//  TabBar.swift
//  HOTH
//
//  Created by Marius Genton on 3/3/24.
//

import SwiftUI

struct TabBar: View {
    
    @Binding var selectedTab: Tab
    
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                HapticManager.mediumFeedback()
                withAnimation { selectedTab = .Home }
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundStyle(selectedTab == .Home ? Color("C5") : .white)
                    Image(systemName: "house.fill")
                        .padding([.leading, .trailing], 18)
                        .padding([.top, .bottom], 10)
                        .foregroundStyle(selectedTab != .Home ? Color("C5") : .white)
                }
            }
            
            Button {
                HapticManager.mediumFeedback()
                withAnimation { selectedTab = .Add }
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundStyle(selectedTab == .Add ? Color("C5") : .white)
                    Image(systemName: "plus")
                        .padding([.leading, .trailing], 18)
                        .padding([.top, .bottom], 10)
                        .foregroundStyle(selectedTab != .Add ? Color("C5") : .white)
                }
            }
            
            Button {
                HapticManager.mediumFeedback()
                withAnimation { selectedTab = .Profile }
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundStyle(selectedTab == .Profile ? Color("C5") : .white)
                    Image(systemName: "person.fill")
                        .padding([.leading, .trailing], 18)
                        .padding([.top, .bottom], 10)
                        .foregroundStyle(selectedTab != .Profile ? Color("C5") : .white)
                }
            }
        }
        .font(.title3)
        .fontWeight(.bold)
        .fixedSize()
        .clipShape(.rect(cornerRadii: RectangleCornerRadii(topLeading: 30, bottomLeading: 30, bottomTrailing: 30, topTrailing: 30)))
        .shadow(color: Color(white: 0.75), radius: 10)
    }
}
