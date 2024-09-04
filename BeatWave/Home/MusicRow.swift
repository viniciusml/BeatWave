//
//  MusicRow.swift
//  BeatWave
//
//  Created by Vinicius Leal on 04/09/2024.
//

import SwiftUI

struct MusicRow: View {
    
    private let artist: String
    private let song: String
    private let imageName: String
    
    init(artist: String, song: String, imageName: String) {
        self.artist = artist
        self.song = song
        self.imageName = imageName
    }
    
    var body: some View {
        HStack {
            Image(imageName) // Replace with actual images
                .resizable()
                .frame(width: 50, height: 50)
                .background(Color.gray)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                PrimaryText(text: artist, font: .subheadline, fontWeight: .bold)
                SecondaryText(text: song, font: .caption, fontWeight: .regular)
            }
            Spacer()
            Image(systemName: "play.circle.fill")
                .foregroundColor(.inactiveIcon)
                .font(.title)
        }
    }
}
