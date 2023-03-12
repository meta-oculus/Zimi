//
//  Colors.swift
//  Zimi
//
//  Created by Sarah Akhtar on 3/11/23.
//

import Foundation
import SwiftUI

extension Color {
    static let lightBlue = Color("lightBlue")
    
    static let blueGradient = LinearGradient(gradient: Gradient(colors: [Color("customBlue"), Color("customLightBlue")]), startPoint: .topLeading, endPoint: .bottomTrailing)
}
