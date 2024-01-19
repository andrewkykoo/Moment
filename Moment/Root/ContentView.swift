//
//  ContentView.swift
//  Moment
//
//  Created by Andrew Koo on 1/14/24.
//

import SwiftUI

enum MomentType: Hashable {
    case text, voice, photo
}

struct ContentView: View {
    @StateObject var viewModel = MomentsViewModel()
    
    private var adaptiveButtonBackgroundColor: Color {
        Color(UIColor { traitCollection in
            // Adjust these UIColors based on your app's design and accent color
            let lightModeColor = UIColor.systemGray4
            let darkModeColor = UIColor.black
            return traitCollection.userInterfaceStyle == .dark ? lightModeColor : darkModeColor
        })
    }
    
    private var adaptiveButtonTextColor: Color {
        Color(UIColor { traitCollection in
            // Choose colors that provide good contrast with the background
            let lightModeColor = UIColor.white // For dark backgrounds in light mode
            let darkModeColor = UIColor.white // For light backgrounds in dark mode
            return traitCollection.userInterfaceStyle == .dark ? darkModeColor : lightModeColor
        })
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                HStack {
                    Text("Every Moment Matters")
                        .font(.headline)
                        .foregroundColor(Color("AccentColor"))
                    Spacer()
                }
                
                Spacer()
                
                HStack(spacing: 40) {
                    navigationIcon(label: "Text", imageName: "pencil", destination: TextMomentView(viewModel: viewModel))
                    navigationIcon(label: "Voice", imageName: "mic", destination: VoiceRecordingView(viewModel: viewModel))
                    navigationIcon(label: "Photo", imageName: "camera", destination: CameraView(viewModel: viewModel))
                }
                .padding()
                
                Spacer()
                
                NavigationLink(destination: AllMomentsView(viewModel: viewModel)) {
                    Text("Browse Moments")
                        .foregroundColor(adaptiveButtonTextColor)
                        .padding()
                        .background(adaptiveButtonBackgroundColor)
                        .cornerRadius(8)
                }
                .padding()
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground).edgesIgnoringSafeArea(.all))
            .navigationTitle("Moment")
            .navigationDestination(for: MomentType.self) { type in
                switch type {
                case .text:
                    TextMomentView(viewModel: viewModel)
                case .voice:
                    VoiceRecordingView(viewModel: viewModel)
                case .photo:
                    CameraView(viewModel: viewModel)
                }
            }
        }
    }
    
    private func navigationIcon<Destination: View>(label: String, imageName: String, destination: Destination) -> some View {
        VStack {
            Text(label)
                .font(.caption)
                .foregroundColor(Color("AccentColor"))
            
            NavigationLink(destination: destination) {
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.primary)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
        }
    }
}


#Preview {
    ContentView()
}
