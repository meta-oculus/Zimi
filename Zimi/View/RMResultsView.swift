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
    let differenceArray: [String]
    let result: String
    let colorIndicator: Color
    let risks: [String]
    let metric: Bool
    
    //MARK: Enum for Category
    enum Category {
        case underweight, normal, overweight, obese
    }
    
    //MARK: View
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Your BMI is...")
                        .font(.title)
                        .padding(.top, 40)
                    
                    //Shows Calculated BMI to .02 Decimal Place
                    Text(String(format: "%g", calculatedBMI))
                        .frame(width: 200, height: 150, alignment: .center)
                        .background(colorIndicator)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .font(.system(size: 60, weight: .black, design: .serif))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    VStack(alignment: .leading) {
                        Divider()
                            .padding(10)
                        
                        Text("RESULTS")
                            .font(.headline)
                            .padding(.leading, 20)
                    }
                    
                    //Range Differences Displayed
                    VStack(alignment: .leading) {
                        ForEach (differenceArray, id: \.self) { category in
                            Text(category)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.85, height: 80)
                    .padding()
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    VStack(alignment: .leading) {
                        Divider()
                            .padding(10)
                        
                        Text("RISKS")
                            .font(.headline)
                            .padding(.leading, 20)
                    }
                    
                    //Risks for Category Displayed
                    ForEach (risks, id: \.self) { risk in
                        VStack(alignment: .leading) {
                            Text(risk)
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width * 0.83, height: UIScreen.main.bounds.height * 0.015, alignment: .leading)
                                .padding(13)
                                .background(.pink)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                    }
                }
            }
        }
    }
}

//MARK: Previews
struct RMResultsView_Previews: PreviewProvider {
    static var previews: some View {
        RMResultsView(calculatedBMI: 18.43, differenceArray: ["You are normal.", "You are 74 pounds away from overweight.", "You are 102 pounds away from obese.", "You are 20 pounds away from underweight."], result: "Obese", colorIndicator: .blue, risks: ["Heart Disease", "Artheritis", "Risk of Cancer Increased", "Asthma"], metric: false)
    }
}
