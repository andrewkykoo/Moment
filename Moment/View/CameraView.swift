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
    @State private var navigateToDetail = false
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)

            if showCamera {
                CameraViewControllerWrapper(
                    capturedImage: $capturedImage,
                    onImageCapture: { image in
                        self.capturedImage = image
                        self.showCamera = false
                    },
                    onCancel: {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                )
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let capturedImage = capturedImage {
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
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraViewControllerWrapper
        
        init(_ parent: CameraViewControllerWrapper) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImageCapture(image)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onCancel()
            picker.dismiss(animated: true, completion: nil)
        }
    }
}


#Preview {
    CameraView(viewModel: MomentsViewModel())
}
