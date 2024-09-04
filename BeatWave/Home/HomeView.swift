//
//  HomeView.swift
//  BeatWave
//
//  Created by Vinicius Leal on 04/09/2024.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        VStack {
            HStack {
                PrimaryText(text: "BeatWave", font: .title, fontWeight: .bold)
                Spacer()
            }
            .padding()
            
            HStack {
                PrimaryText(text: "Top Music", font: .headline, fontWeight: .bold)
                Spacer()
            }
            .padding([.top, .horizontal])
            
            VStack(spacing: 15) {
                MusicRow(artist: "Artic Monkey", song: "Do I Wanna Know?", imageName: "articmonkey")
                MusicRow(artist: "The Cure", song: "Just Like Heaven", imageName: "thecure")
                MusicRow(artist: "Nirvana", song: "Sweet Child of Mine", imageName: "nirvana")
            }
            .padding(.horizontal)
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading) {
                    PrimaryText(text: "Fazerdaze", font: .caption, fontWeight: .semibold)
                    SecondaryText(text: "Lucky Girl", font: .caption2, fontWeight: .regular)
                }
                Spacer()
                HStack(spacing: 20) {
                    Image(systemName: "backward.fill").foregroundColor(.inactiveIcon)
                    Image(systemName: "play.fill").foregroundColor(.inactiveIcon)
                    Image(systemName: "forward.fill").foregroundColor(.inactiveIcon)
                }
                .font(.title2)
            }
            .padding()
            .background(Color.nowPlayingBarBackground.blur(radius: 40))
            .border(Color.nowPlayingBarBackground.gradient)
            .shadow(radius: 20)
            .cornerRadius(10)
            .padding()
            
        }
        .background(LinearGradient(gradient: Gradient(colors: [.topBackground, .bottomBackground]), startPoint: .top, endPoint: .bottom))
    }
}
