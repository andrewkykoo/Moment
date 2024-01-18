//
//  MomentDetailView.swift
//  Moment
//
//  Created by Andrew Koo on 1/14/24.
//

import SwiftUI

struct MomentDetailView: View {
    @ObservedObject var viewModel: MomentsViewModel
    @State private var momentNote = ""
    
    var momentType: MomentType
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
            
            if momentType == .voice, !viewModel.recordedText.isEmpty {
                Text(viewModel.recordedText)
                    .padding()
                    .background(Color(UIColor.tertiarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            TextField("Write a brief note", text: $momentNote)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            Button(action: {
                let newMoment = Moment(content: momentNote)
                viewModel.addMoment(moment: newMoment)
                momentNote = ""
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
    MomentDetailView(viewModel: MomentsViewModel(), momentType: .text, capturedImage: UIImage(systemName: "person"))
}
