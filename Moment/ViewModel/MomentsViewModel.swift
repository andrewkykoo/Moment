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


class MomentsViewModel: ObservableObject {
    @Published var moments: [Moment] = []
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    @Published var recordedText: String = ""
    @Published var currentSloganIndex = 0
    
    init() {
        listenerRegistration = db.collection("moments").addSnapshotListener({ querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.moments = documents.compactMap({ document in
                try? document.data(as: Moment.self)
            })
        })
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
        db.collection("moments").getDocuments { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                self.moments = querySnapshot.documents.compactMap({ document in
                    try? document.data(as: Moment.self)
                })
            } else if let error = error {
                print("Error fetching moments: \(error.localizedDescription)")
            }
        }
    }
}
