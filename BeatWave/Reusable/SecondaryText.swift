//
//  SecondaryText.swift
//  BeatWave
//
//  Created by Vinicius Leal on 04/09/2024.
//

import SwiftUI

struct SecondaryText: View {
    
    private let text: String
    private let font: Font
    private let fontWeight: Font.Weight
    
    init(text: String, font: Font, fontWeight: Font.Weight) {
        self.text = text
        self.font = font
        self.fontWeight = fontWeight
    }
    
    var body: some View {
        Text(text)
            .font(font)
            .fontWeight(fontWeight)
            .foregroundColor(.secondaryText)
    }
}
