//
//  RMCalculatorBMI.swift
//  Zimi
//
//  Created by Sarah Akhtar on 3/11/23.
//

import SwiftUI

struct RMCalculatorBMI: View {
    
    //MARK: BMI Imperial System
    @State private var heightInches = 0
    @State private var weightPounds: String = ""
    
    //MARK: BMI Metric System
    @State private var heightCentimeters = 0
    @State private var weightKilograms: String = ""
    
    //MARK: Away From Bracket
    @State private var underweight: Double = 0
    @State private var normal: Double = 0
    @State private var overweight: Double = 0
    @State private var obese: Double = 0
    @State private var colorIndicator: Color = .red
    
    //MARK: Choose System and Results
    @State private var metric = false
    @State private var calculatedBMI: Double = 0
    @State private var result = "Normal"
    @State private var showResults = false
    
    //MARK: Hide Keyboard and Settings
    @FocusState var keyboardShow: Bool
    @State private var showSettings = false
    var disableForm: Bool {
        if metric {
            if weightKilograms.isEmpty || weightKilograms.count <= 1 {
                return true
            }
        } else {
            if weightPounds.isEmpty || weightPounds.count <= 1 {
                return true
            }
        }
        return false
    }
    
    //MARK: Color for NavigationTitle
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    //MARK: View
    var body: some View {
        NavigationView {
            Form {
                Section(header: SectionHeader(text: "Enter Your Information")) {
                    if metric == false {
                        Picker("Height in inches", selection: $heightInches) {
                            ForEach(22..<120) {
                                Text("\($0) in")
                            }
                        }
                        
                        TextField("Weight in pounds", text: $weightPounds)
                            .keyboardType(.numberPad)
                            .focused($keyboardShow)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Button("Done") {
                                        keyboardShow = false
                                    }
                                }
                            }
                        
                    } else {
                        Picker("Height in centimeters", selection: $heightCentimeters) {
                            ForEach(60..<300) {
                                Text("\($0) cm")
                            }
                        }
                        
                        TextField("Weight in kilograms", text: $weightKilograms)
                            .keyboardType(.decimalPad)
                            .focused($keyboardShow)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Button("Done") {
                                        keyboardShow = false
                                    }
                                }
                            }
                    }
                }
                
                Section {
                    Button("Calculate BMI Score") {
                        calculateBMI()
                        calculateDifference()
                        rangeOfBMI()
                        showResults = true
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .buttonStyle(.borderedProminent)
                    .padding(5)
                    .disabled(disableForm)
                }
                
                Section {
                    if showResults {
                        NavigationLink {
                            RMResultsView(calculatedBMI: calculatedBMI, underweightDifference: underweight, normalDifference: normal, overweightDifference: overweight, obeseDifference: obese, result: result, colorIndicator: colorIndicator, metric: metric)
                        } label: {
                            Button("Results") {
                                showResults = false
                            }
                        }
                    }
                }
                
                Section {
                    if showSettings {
                        Toggle("Metric Units", isOn: $metric)
                    }
                }
            }
            .navigationTitle("BMI Calculator")
            .scrollContentBackground(.hidden)
            .background(Color.blueGradient)
            .toolbar {
                Button {
                    showSettings.toggle()
                } label: {
                    Label("", systemImage: "gearshape.fill")
                        .foregroundColor(.white)
                }
            }
        }
        .onAppear()
    }
    
    //MARK: Calculates BMI
    func calculateBMI() {
        let convertedWeightKilograms = Double(weightKilograms.trimmingCharacters(in: .whitespacesAndNewlines))
        let convertedWeightPounds = Double(weightPounds.trimmingCharacters(in: .whitespacesAndNewlines))
        
        if metric {
            let heightCM = Double(heightCentimeters) + 60
            let meters = heightCM / 100
            let squaredHeightM = (meters * meters)
            calculatedBMI = (convertedWeightKilograms ?? 60) / squaredHeightM
        } else {
            let heightIN = Double(heightInches) + 22
            let squaredHeightIN = (heightIN * heightIN)
            calculatedBMI = (703 * (convertedWeightPounds ?? 150)) / squaredHeightIN
        }
    }
    
    //MARK: Calculates Difference from
    func calculateDifference() {
        
        let convertedWeightKilograms = Double(weightKilograms.trimmingCharacters(in: .whitespacesAndNewlines))
        let convertedWeightPounds = Double(weightKilograms.trimmingCharacters(in: .whitespacesAndNewlines))
        
        if metric {
            let heightCM = Double(heightCentimeters) + 60
            let meters = heightCM / 100
            let metersSquared = meters * meters
            
            underweight = abs(18.5 * metersSquared - (convertedWeightKilograms ?? 60))
            normal = abs(25 * metersSquared - (convertedWeightKilograms ?? 60))
            overweight = abs(30 * metersSquared - (convertedWeightKilograms ?? 60))
            obese = abs(31 * metersSquared - (convertedWeightKilograms ?? 60))
        } else {
            let heightIN = Double(heightInches) + 22
            let inchesSquared = heightIN * heightIN
            
            let underweightScore = (18.5 * inchesSquared)/730
            let normalScore = (25 * inchesSquared)/730
            let overWeightScore = (30 * inchesSquared)/730
            let obeseScore = (31 * inchesSquared)/730
                
            underweight = abs(underweightScore - (convertedWeightPounds ?? 150))
            normal = abs(normalScore - (convertedWeightPounds ?? 150))
            overweight = abs(overWeightScore - (convertedWeightPounds ?? 150))
            obese = abs(obeseScore - (convertedWeightPounds ?? 150))
        }
    }
    
    //MARK: Calculate Results
    func rangeOfBMI() {
        if calculatedBMI <= 18 {
            result = "Underweight"
            colorIndicator = .lightBlue
        } else if calculatedBMI <= 25 {
            result = "Normal"
            colorIndicator = .blue
        } else if calculatedBMI <= 30 {
            result = "Overweight"
            colorIndicator = .orange
        } else if calculatedBMI > 30 {
            result = "Obese"
            colorIndicator = .red
        }
    }
}

//MARK: SectionHeader Customized
struct SectionHeader: View {
    let text: String
    var body: some View {
        Text(text)
            .padding()
            .frame(width: UIScreen.main.bounds.width, height: 20, alignment: .center)
            .background(Color.clear)
            .foregroundColor(Color.white)
            .font(.caption)
    }
}

//MARK: Previews
struct RMCalculatorBMI_Previews: PreviewProvider {
    static var previews: some View {
        RMCalculatorBMI()
    }
}
