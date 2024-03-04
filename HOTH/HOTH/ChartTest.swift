//
//  ChartTest.swift
//  HOTH
//
//  Created by Marius Genton on 3/3/24.
//

import SwiftUI
import Charts

struct EmissionsByDay: View {
    
    let data: [(String, Double)]
    
    var body: some View {
        Chart {
            ForEach(data, id: \.0) { (day, emissions) in
                BarMark(
                    x: .value("D", day),
                    y: .value("C", emissions)
                )
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom) { _ in
                AxisValueLabel()
            }
        }
        .frame(height: 120)
        .chartLegend(.hidden)
        .chartYAxis(.hidden)
        .foregroundStyle(Color("C5"))
        
    }
}


struct EmissionsByActivityType: View {
    
    let data: [(ActivityType, Int)]
    
    var body: some View {
        Chart {
            ForEach(data, id: \.0) { (sport, emissions) in
                BarMark(
                    x: .value("C", emissions),
                    y: .value("Sport", emojiBySport(sport))
                )
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisValueLabel()
            }
        }
        .frame(height: 120)
        .chartLegend(.hidden)
        .chartXAxis(.hidden)
        .foregroundStyle(Color("C5"))
        
    }
}

func emojiBySport(_ sport: ActivityType) -> String {
    switch sport {
    case .Ride:
        return "🚴‍♂️"
    case .Walk:
        return "🚶‍♂️"
    }
}

#Preview {
    /*EmissionsByDay(data: [
        ("M", 5), ("T", 3), ("W", 2), ("R", 5), ("F", 6), ("Sa", 3), ("Su", 1)
    ])*/
    EmissionsByActivityType(data: [(ActivityType.Ride, 50), (ActivityType.Walk, 30)])
}
