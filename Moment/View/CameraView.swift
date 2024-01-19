//
//  CameraView.swift
//  Moment
//
//  Created by Andrew Koo on 1/14/24.
//

import SwiftUI
import UIKit

enum CameraNavigationTrigger {
    case momentDetail
}


struct CameraView: View {
    @ObservedObject var viewModel: MomentsViewModel
    @State private var capturedImage: UIImage?
    @State private var showCamera = true
    @Environment(\.presentationMode) var presentationMode
    @State private var isPresentingMomentDetail = false
    @State private var isCameraReadyToShow = false
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            if isCameraReadyToShow && showCamera {
                CameraViewControllerWrapper(
                    capturedImage: $capturedImage,
                    onImageCapture: { image in
                        self.capturedImage = image
                        self.showCamera = false
                        self.isPresentingMomentDetail = true
                    },
                    onCancel: {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                )
                .edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                isCameraReadyToShow = true
            }
            showCamera = true
            isPresentingMomentDetail = false
            capturedImage = nil
        }
        .onDisappear {
            isCameraReadyToShow = false
        }
        .toolbar(.hidden)
        .navigationDestination(isPresented: $isPresentingMomentDetail) {
            if let capturedImage = capturedImage {
                MomentDetailView(viewModel: viewModel, momentType: .photo, capturedImage: capturedImage)
            }
        }
    }
}


struct CameraViewControllerWrapper: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?
    var onImageCapture: (UIImage) -> Void
    var onCancel: () -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, onCancel: onCancel)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraViewControllerWrapper
        var onCancel: () -> Void
        
        init(_ parent: CameraViewControllerWrapper, onCancel: @escaping () -> Void) {
            self.parent = parent
            self.onCancel = onCancel
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImageCapture(image)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.onCancel()
        }
    }
}


#Preview {
    CameraView(viewModel: MomentsViewModel())
}
