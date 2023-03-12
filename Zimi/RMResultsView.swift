//
//  RMResultsView.swift
//  Zimi
//
//  Created by Sarah Akhtar on 3/11/23.
//

import SwiftUI

struct RMResultsView: View {
    
    //MARK: User Information
    let calculatedBMI: Double
    let underweightDifference: Double
    let normalDifference: Double
    let overweightDifference: Double
    let obeseDifference: Double
    let result: String
    let colorIndicator: Color
    let metric: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Your BMI is...")
                        .font(.title)
                        .padding(.top, 40)
                    
                    Text("\(calculatedBMI, specifier: "%.0f")")
                        .frame(width: 200, height: 150, alignment: .center)
                        .background(colorIndicator)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .font(.system(size: 125, weight: .black, design: .serif))
                        .foregroundColor(.white)
                        .padding()
                    
                    if metric {
                        Text("You are...")
                            .font(.headline.bold())
                        VStack(alignment: .leading) {
                            Text("\(underweightDifference, specifier: "%.0f") kilograms away from underweight.")
                            Text("\(normalDifference, specifier: "%.0f") kilograms away from the normal weight.")
                            Text("\(overweightDifference, specifier: "%.0f") kilograms away from overweight.")
                            Text("\(obeseDifference, specifier: "%.0f") kilograms away from obese.")
                        }
                    } else {
                        Text("You are...")
                            .font(.headline.bold())
                        VStack(alignment: .leading) {
                            Text("\(underweightDifference, specifier: "%.0f") pounds away from underweight.")
                            Text("\(normalDifference, specifier: "%.0f") pounds away from the normal weight.")
                            Text("\(overweightDifference, specifier: "%.0f") pounds away from overweight.")
                            Text("\(obeseDifference, specifier: "%.0f") pounds away from obese.")
                        }
                    }
                }
            }
        }
    }
}

struct RMResultsView_Previews: PreviewProvider {
    static var previews: some View {
        RMResultsView(calculatedBMI: 18, underweightDifference: 10, normalDifference: 20, overweightDifference: 30, obeseDifference: 40, result: "Obese", colorIndicator: .red, metric: false)
    }
}
