//
//  NavigationView.swift
//  BeatWave
//
//  Created by Vinicius Leal on 04/09/2024.
//

import SwiftUI

struct NavigationView: View {
    
    @ObservedObject var registry: ViewRegistry
    
    var body: some View {
        registry.view
            .transition(
                AnyTransition
                    .opacity
                    .combined(with: .move(edge: .trailing))
            )
            .id(UUID())
    }
}
