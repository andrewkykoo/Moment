//
//  MomentDetailView.swift
//  Moment
//
//  Created by Andrew Koo on 1/14/24.
//

import SwiftUI

struct SaveMomentView: View {
    @ObservedObject var viewModel: MomentsViewModel
    @State private var momentNote = ""
    
    var momentType: MomentDataType
    var capturedImage: UIImage?
    
    var body: some View {
        VStack(spacing: 20) {
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
            }
            
            if momentType == .voice, !viewModel.voiceRecordingText.isEmpty {
                Text(viewModel.voiceRecordingText)
                    .padding()
                    .background(Color(UIColor.tertiarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $momentNote)
                    .frame(minHeight: 100, maxHeight: .infinity)
                    .padding(4)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .fixedSize(horizontal: false, vertical: true)
                
                if momentNote.isEmpty {
                    Text("Write a brief note")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                }
            }
            
            Button(action: {
                Task {
                    switch momentType {
                    case .voice:
                        // For voice moments, pass the voiceRecordingData along with the content
                        await viewModel.saveMoment(content: momentNote, voiceData: viewModel.voiceRecordingData, momentType: momentType)
                    case .photo:
                        // For photo moments
                        await viewModel.saveMoment(content: momentNote, image: capturedImage, momentType: momentType)
                    case .text:
                        // For text moments, only content is needed
                        await viewModel.saveMoment(content: momentNote, momentType: momentType)
                    }
                    momentNote = ""
                }
            }) {
                Text("Save")
                    .foregroundColor(Color(UIColor.systemBackground))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.primary)
                    .cornerRadius(8)
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(momentTypeTitle())
    }
    
    private func momentTypeTitle() -> String {
        switch momentType {
        case .text:
            return "Text Moment"
        case .voice:
            return "Voice Moment"
        case .photo:
            return "Photo Moment"
        }
    }
}

#Preview {
    SaveMomentView(viewModel: MomentsViewModel(), momentType: .text, capturedImage: UIImage(systemName: "person"))
}
