//
//  MomentsViewModel.swift
//  Moment
//
//  Created by Andrew Koo on 1/14/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

@MainActor
class MomentsViewModel: ObservableObject {
    @Published var moments: [Moment] = []
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    @Published var voiceRecordingData: Data?
    @Published var voiceRecordingText: String = ""
    @Published var currentSloganIndex = 0
    
    init() {
        fetchMoments()
    }
    
    deinit {
        listenerRegistration?.remove()
    }
    
    func addMoment(moment: Moment) {
        do {
            _ = try db.collection("moments").document(moment.id).setData(from: moment)
            print("Moment successfully added: \(moment)")
        } catch {
            print("Error adding moment: \(error.localizedDescription)")
        }
    }
    
    func fetchMoments() {
        listenerRegistration = db.collection("moments").addSnapshotListener { [weak self] querySnapshot, error in
            if let querySnapshot = querySnapshot {
                self?.moments = querySnapshot.documents.compactMap { document in
                    try? document.data(as: Moment.self)
                }
            } else if let error = error {
                print("Error fetching moments: \(error.localizedDescription)")
            }
        }
    }

    
    func uploadImage(_ image: UIImage) async -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("images/\(UUID().uuidString).jpg")
        
        do {
            let _ = try await imageRef.putDataAsync(imageData)
            let downloadURL = try await imageRef.downloadURL()
            return downloadURL.absoluteString
        } catch {
            print("Error uploading image to firebase storage: \(error)")
            return nil
        }
    }
    
    func uploadVoiceRecording(_ voiceData: Data) async -> String? {
        let storageRef = Storage.storage().reference()
        let voiceRef = storageRef.child("voiceRecordings/\(UUID().uuidString).m4a")
        
        do {
            let _ = try await voiceRef.putDataAsync(voiceData)
            let downloadURL = try await voiceRef.downloadURL()
            return downloadURL.absoluteString
        } catch {
            print("Error uploading voice recording to Firebase Storage: \(error)")
            return nil
        }
    }
    
    func saveMoment(content: String, image: UIImage? = nil, voiceData: Data? = nil, momentType: MomentDataType) async {
        var photoURL: String? = nil
        var voiceRecordingURL: String? = nil
        
        if let image = image, momentType == .photo {
            photoURL = await uploadImage(image)
        }

        if let voiceData = voiceData, momentType == .voice {
            voiceRecordingURL = await uploadVoiceRecording(voiceData)
        }
        
        let newMoment = Moment(
            content: content,
            voiceRecordingURL: voiceRecordingURL,
            voiceRecordingText: voiceRecordingText,
            photoURL: photoURL,
            dateCreated: Date(),
            labels: []
        )
        
        addMoment(moment: newMoment)
        voiceRecordingData = nil
        voiceRecordingText = ""
    }
}
