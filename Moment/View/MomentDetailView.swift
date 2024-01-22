//
//  MomentDetailView.swift
//  Moment
//
//  Created by Andrew Koo on 1/22/24.
//

import SwiftUI
import AVKit

struct MomentDetailView: View {
    var moment: Moment
    @State private var audioPlayer: AVAudioPlayer?
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if moment.momentType == .text {
                    Text(moment.content)
                } else if moment.momentType == .voice {
                    if let voiceText = moment.voiceRecordingText {
                        Text(voiceText)
                    }
                    
                    if let voiceURL = moment.voiceRecordingURL {
                        Button {
                            playVoiceRecording(from: voiceURL)
                        } label: {
                            Image(systemName: "play.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }

                    }
                } else if moment.momentType == .photo {
                    if let photoURL = moment.photoURL, let url = URL(string: photoURL) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .aspectRatio(contentMode: .fit)
                    }
                    Text(moment.content)
                }
                Text("Created: \(moment.dateCreated, formatter: dateFormatter)")
            }
            .padding()
        }
        .navigationTitle("Moment")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func playVoiceRecording(from urlString: String) {
        guard let audioURL = URL(string: urlString) else {
            print("Invalid URL for voice recording")
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)

            self.audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            self.audioPlayer?.prepareToPlay()
            self.audioPlayer?.play()
        } catch let error as NSError {
            print("Failed to play audio. Error: \(error), \(error.userInfo)")
        }
    }



}

//#Preview {
//    MomentDetailView()
//}
