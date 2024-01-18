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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                HStack {
                    Text("Every Moment Matters")
                        .font(.headline)
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
                        .foregroundColor(Color(uiColor: .systemBackground))
                        .padding()
                        .background(Color.primary)
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
                .foregroundColor(.primary)
            
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
