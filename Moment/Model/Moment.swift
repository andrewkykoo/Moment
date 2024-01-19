//
//  Moment.swift
//  Moment
//
//  Created by Andrew Koo on 1/14/24.
//

import Foundation

struct Moment: Identifiable, Codable {
    var id: String = UUID().uuidString
    var content: String
    var voiceData: Data?
    var photoURL: String?
    var dateCreated: Date = Date()
    var labels: [String]?
    
    var momentType: MomentType {
        if photoURL != nil {
            return .photo
        } else if voiceData != nil {
            return .voice
        } else {
            return .text
        }
    }

}
