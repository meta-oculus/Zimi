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
    @State private var showSheet = false
    @State private var differenceArray: [String] = [""]
    @State private var risks: [String] = [""]
    
    //MARK: Enum for Case
    @State private var category = Category.normal
    enum Category {
        case underweight, normal, overweight, obese
    }
    
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
        NavigationStack {
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
                        rangeOfBMI()
                        calculateDifference()
                        displayDifference()
                        showResults = true
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .buttonStyle(.borderedProminent)
                    .padding(5)
                    .disabled(disableForm)
                }
                
                Section {
                    if showResults {
                        Button("Results") {
                            showSheet = true
                            showResults = false
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
        .sheet(isPresented: $showSheet) {
            RMResultsView(calculatedBMI: calculatedBMI, differenceArray: differenceArray, result: result, colorIndicator: colorIndicator, risks: risks, metric: metric)
        }
    }
    
    //MARK: Calculates BMI
    func calculateBMI() {
        let convertedWeightKilograms = Double(weightKilograms.trimmingCharacters(in: .whitespacesAndNewlines))
        let convertedWeightPounds = Double(weightPounds.trimmingCharacters(in: .whitespacesAndNewlines))
        
        if metric {
            let heightCM = Double(heightCentimeters) + 60
            let meters = (heightCM / 100)
            let squaredHeightM = (meters * meters)
            let calcBMI = (convertedWeightKilograms ?? 60) / squaredHeightM
            calculatedBMI = round(calcBMI * 100) / 100.0
        } else {
            let heightIN = Double(heightInches) + 22
            let squaredHeightIN = (heightIN * heightIN)
            let calcBMI = (703 * (convertedWeightPounds ?? 150)) / squaredHeightIN
            calculatedBMI = round(calcBMI * 100) / 100.0
        }
    }
    
    //MARK: Calculate Results
    func rangeOfBMI() {
        if calculatedBMI <= 18 {
            result = "Underweight"
            category = .underweight
            colorIndicator = .lightBlue
        } else if calculatedBMI <= 25 {
            result = "Normal"
            category = .normal
            colorIndicator = .blue
        } else if calculatedBMI <= 30 {
            result = "Overweight"
            category = .overweight
            colorIndicator = .orange
        } else if calculatedBMI > 30 {
            result = "Obese"
            category = .obese
            colorIndicator = .red
        }
    }
    
    //MARK: Calculates Difference from
    func calculateDifference() {
        //Weights Converted
        let convertedWeightKilograms = Double(weightKilograms.trimmingCharacters(in: .whitespacesAndNewlines))
        let convertedWeightPounds = Double(weightPounds.trimmingCharacters(in: .whitespacesAndNewlines))
        
        if metric {
            differenceArray = []
            //Heights Converted to Metric
            let heightCM = Double(heightCentimeters) + 60
            let meters = heightCM / 100
            let metersSquared = meters * meters
            
            let calcUW = 18.5 * metersSquared - (convertedWeightKilograms ?? 60)
            let calcNM = 25 * metersSquared - (convertedWeightKilograms ?? 60)
            let calcOW = 30 * metersSquared - (convertedWeightKilograms ?? 60)
            let calcOB = 31 * metersSquared - (convertedWeightKilograms ?? 60)
            
            underweight = abs(round(calcUW * 100) / 100.0)
            normal = abs(round(calcNM * 100) / 100.0)
            overweight = abs(round(calcOW * 100) / 100.0)
            obese = abs(round(calcOB * 100) / 100.0)
        } else {
            differenceArray = []
            //Heights Converted to Imperial
            let heightIN = Double(heightInches) + 22
            let inchesSquared = heightIN * heightIN
            
            let calcUW = ((18.5 * inchesSquared)/730) - (convertedWeightPounds ?? 150)
            let calcNM = ((25 * inchesSquared)/730)  - (convertedWeightPounds ?? 150)
            let calcOW = ((30 * inchesSquared)/730)  - (convertedWeightPounds ?? 150)
            let calcOB = ((31 * inchesSquared)/730)  - (convertedWeightPounds ?? 150)
            
            underweight = abs(round(calcUW * 100) / 100.0)
            normal = abs(round(calcNM * 100) / 100.0)
            overweight = abs(round(calcOW * 100) / 100.0)
            obese = abs(round(calcOB * 100) / 100.0)
        }
    }
    
    //MARK: Displays Difference in Array
    func displayDifference() {
        if metric {
            switch category {
            case .underweight:
                differenceArray.insert("You are under the underweight category.", at: 0)
                differenceArray.insert("You are \(normal) kilograms away from normal.", at: 1)
                differenceArray.insert("You are \(overweight) kilograms away from overweight.", at: 2)
                differenceArray.insert("You are \(obese) kilograms away from obese.", at: 3)
                risks = [" Malnutrition and nutrient deficiencies", "Weak immune system", "Osteoporosis and bone fractures", "Anemia", "Infertility and hormonal imbalances"]
            case .normal:
                differenceArray.insert("You are under the normal category.", at: 0)
                differenceArray.insert("You are \(underweight) kilograms away from underweight.", at: 1)
                differenceArray.insert("You are \(overweight) kilograms away from overweight.", at: 2)
                differenceArray.insert("You are \(obese) kilograms away from obese.", at: 3)
                risks = ["Low risk of heart disease", "Low risk of diabetes", "Low risk of cancer", "Generally good overall health"]
            case .overweight:
                differenceArray.insert("You are under the overweight category.", at: 0)
                differenceArray.insert("You are \(underweight) kilograms away from underweight.", at: 1)
                differenceArray.insert("You are \(normal) kilograms away from normal.", at: 2)
                differenceArray.insert("You are \(obese) kilograms away from obese.", at: 3)
                risks = ["Increased risk of heart disease", "Increased risk of diabetes", "Increased risk of cancer", "High blood pressure and cholesterol", "Sleep apnea", "Joint pain and arthritis"]
            case .obese:
                differenceArray.insert("You are under the obese category.", at: 0)
                differenceArray.insert("You are \(underweight) kilograms away from underweight.", at: 1)
                differenceArray.insert("You are \(normal) kilograms away from normal.", at: 2)
                differenceArray.insert("You are \(overweight) kilograms away from overweight.", at: 3)
                risks = ["Increased risk of chronic heart disease", "Increased risk of diabetes", "Increased risk of cancer", "High blood pressure and cholesterol", "Sleep apnea", "Joint pain and arthritis", "Infertility and hormonal imbalances", "Gallbladder disease", "Stroke"]
            }
        } else {
            switch category {
            case .underweight:
                differenceArray.insert("You are under the underweight category.", at: 0)
                differenceArray.insert("You are \(normal) pounds away from normal.", at: 1)
                differenceArray.insert("You are \(overweight) pounds away from overweight.", at: 2)
                differenceArray.insert("You are \(obese) pounds away from obese.", at: 3)
                risks = [" Malnutrition and nutrient deficiencies", "Weak immune system", "Osteoporosis and bone fractures", "Anemia", "Infertility and hormonal imbalances"]
            case .normal:
                differenceArray.insert("You are under the normal category.", at: 0)
                differenceArray.insert("You are \(underweight) pounds away from underweight.", at: 1)
                differenceArray.insert("You are \(overweight) pounds away from overweight.", at: 2)
                differenceArray.insert("You are \(obese) pounds away from obese.", at: 3)
                risks = ["Low risk of heart disease", "Low risk of diabetes", "Low risk of cancer", "Generally good overall health"]
            case .overweight:
                differenceArray.insert("You are under the overweight category.", at: 0)
                differenceArray.insert("You are \(underweight) pounds away from underweight.", at: 1)
                differenceArray.insert("You are \(normal) pounds away from normal.", at: 2)
                differenceArray.insert("You are \(obese) pounds away from obese.", at: 3)
                risks = ["Increased risk of heart disease", "Increased risk of diabetes", "Increased risk of cancer", "High blood pressure and cholesterol", "Sleep apnea", "Joint pain and arthritis"]
            case .obese:
                differenceArray.insert("You are under the obese category.", at: 0)
                differenceArray.insert("You are \(underweight) pounds away from underweight.", at: 1)
                differenceArray.insert("You are \(normal) pounds away from normal.", at: 2)
                differenceArray.insert("You are \(overweight) pounds away from overweight.", at: 3)
                risks = ["Increased risk of chronic heart disease", "Increased risk of diabetes", "Increased risk of cancer", "High blood pressure and cholesterol", "Sleep apnea", "Joint pain and arthritis", "Infertility and hormonal imbalances", "Gallbladder disease", "Stroke"]
            }
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
