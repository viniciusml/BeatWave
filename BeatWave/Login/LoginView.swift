//
//  LoginView.swift
//  BeatWave
//
//  Created by Vinicius Leal on 02/09/2024.
//

import SwiftUI

struct LoginView: View {
    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [
                Color.topBackground,
                Color.midBackground,
                Color.bottomBackground
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                VStack(spacing: 10) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                    Text("BeatWave")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                // Add text views here.
                
                Button(action: {
                    // Login Action
                }) {
                    Text("Log in")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                
                Text("© 2024 BeatWave")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                Spacer().frame(height: 20)
            }
        }
    }
}

#Preview {
    LoginView()
}
