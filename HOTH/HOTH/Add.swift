//
//  Add.swift
//  HOTH
//
//  Created by Marius Genton on 3/3/24.
//

import SwiftUI

struct Add: View {
    
    enum ActivityLogPhase { case SportType, Distance, Details, Done }
    @State private var phase = ActivityLogPhase.SportType
    @Binding var user: User?
    
    @State private var sportType: ActivityType?
    @State private var distance: Double = 0
    @State private var date = Date()
    @State private var title: String = ""
    @State private var caption: String = ""
    @State private var loading = false
    
    private func randomTitle(_ activityType: ActivityType) -> String {
        let walkCaptions = [
            "Walk 🤙",
            "Sustainable Footsteps",
            "Green Strides 🍃",
            "Green Commute"
        ]
        let rideCaptions = [
            "Eco Ride",
            "Sustainable Spin",
            "Pedaling Green",
            "Green Commute"
        ]
        
        if activityType == .Ride { return rideCaptions.randomElement()! }
        return walkCaptions.randomElement()!
    }
    
    var body: some View {
        ScrollView {
            switch phase {
            case .SportType:
                VStack(alignment: .leading) {
                    Spacer()
                    Text("Kudos for choosing to commute sustainably \(user!.name).")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Log it to track your impact & share with friends!")
                        .opacity(0.7)
                        .font(.footnote)
                    
                    Spacer()
                        .frame(height: 30)
                    Text("What type of activity are you logging?")
                    
                    Button {
                        HapticManager.mediumFeedback()
                        sportType = .Walk
                        title = randomTitle(.Walk)
                        withAnimation { phase = .Distance }
                    } label: {
                        ZStack {
                            Rectangle()
                                .cornerRadius(10)
                                .foregroundStyle(Color("C5"))
                            Text("Walk/Run")
                                .foregroundStyle(.white)
                                .padding()
                                .fontWeight(.semibold)
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    
                    Button {
                        HapticManager.mediumFeedback()
                        sportType = .Ride
                        title = randomTitle(.Ride)
                        withAnimation { phase = .Distance }
                    } label: {
                        ZStack {
                            Rectangle()
                                .cornerRadius(10)
                                .foregroundStyle(Color("C5"))
                            Text("Ride")
                                .foregroundStyle(.white)
                                .padding()
                                .fontWeight(.semibold)
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }.padding()
            case .Distance:
                VStack {
                    HStack {
                        Text("Perfect. Now, how long was your \(sportType == .Walk ? "walk" : "ride")?")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer(minLength: 0)
                    }
                    
                    VStack {
                        Text("\(co2saving(distance: Int(1000*distance)), specifier: "%.2f")")
                            .font(.system(size: 80))
                            .foregroundStyle(Color("C5"))
                            .fontWeight(.bold)
                        Text("kgs of CO2 emissions saved 🥳")
                            .foregroundStyle(Color("C5"))
                            .fontWeight(.semibold)
                    }
                    .frame(height: 180)
                    
                    Text("\(distance, specifier: "%.1f")mi")
                        .font(.title3)
                        .fontWeight(.black)
                    
                    if sportType == .Walk {
                        Slider(value: $distance, in: 0.0...10.0)
                            .tint(Color("C5"))
                    } else {
                        Slider(value: $distance, in: 0.0...30.0)
                            .tint(Color("C5"))
                    }
                    
                    Button {
                        HapticManager.mediumFeedback()
                        withAnimation { phase = .Details }
                    } label: {
                        ZStack {
                            Rectangle()
                                .cornerRadius(10)
                                .foregroundStyle(Color("C5"))
                            HStack {
                                Text("Let's wrap this up")
                                Image(systemName: "chevron.right")
                            }
                            .foregroundStyle(.white)
                            .padding()
                            .fontWeight(.semibold)
                        }
                    }
                    .disabled(distance == 0)
                    .opacity(distance == 0 ? 0.7 : 1)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    Button {
                        HapticManager.mediumFeedback()
                        withAnimation { phase = .SportType }
                    } label: {
                        Text("Back")
                            .underline()
                            .foregroundStyle(Color("C5"))
                            .padding(.top, 10)
                            .font(.footnote)
                    }
                }
                .padding()
            case .Details:
                VStack() {
                    HStack {
                        Text("Last tid bit.")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer(minLength: 0)
                    }
                    
                    Spacer()
                        .frame(height: 30)
                    
                    HStack {
                        Text("Give your commute a name for others to see!")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        Spacer(minLength: 0)
                    }
                    TextField("Activity title", text: $title)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    HStack {
                        Text("Any interesting stories to tell? Share it here for your followers to read.")
                            .fontWeight(.semibold)
                        Spacer(minLength: 0)
                    }
                    .font(.footnote)
                    TextField("Write a public description (optional)", text: $caption)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    DatePicker("Date & Time", selection: $date)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Button {
                        HapticManager.mediumFeedback()
                        loading = true
                        Task { await DataManager.uploadActivity(Activity(name: title, description: caption, activityType: sportType!, distance: Int(distance * 1000), profilePhoto: Image(""), userName: user!.name, likeCount: 0, id: "", date: date), user: user!)}
                        withAnimation {
                            phase = .Done
                        }
                        loading = false
                    } label: {
                        ZStack {
                            Rectangle()
                                .cornerRadius(10)
                                .foregroundStyle(Color("C5"))
                            if !loading {
                                Text("Post")
                                    .foregroundStyle(.white)
                                    .padding()
                                    .fontWeight(.semibold)
                            } else {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .padding()
                            }
                        }
                    }
                    .padding(.top)
                    .fixedSize(horizontal: false, vertical: true)
                    .disabled(title == "")
                    .opacity(title == "" ? 0.7 : 1)
                    
                    Button {
                        HapticManager.mediumFeedback()
                        withAnimation { phase = .Distance }
                    } label: {
                        Text("Back")
                            .underline()
                            .foregroundStyle(Color("C5"))
                            .padding(.top, 10)
                            .font(.footnote)
                    }
                }
                
                .padding()
            case .Done:
                VStack(alignment: .leading) {
                    Text("Activity logged! 🥳")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Good job. You're doing your part to make the world a better place, stride by stride. To see your activity, go back to the home page.")
                        .multilineTextAlignment(.leading)
                }
                .padding()
            }
        }
    }
}
