//
//  Moment.swift
//  Moment
//
//  Created by Andrew Koo on 1/14/24.
//

import Foundation


enum MomentDataType: String, Codable {
    case text = "Text"
    case voice = "Voice"
    case photo = "Photo"
}

struct Moment: Identifiable, Codable {
    var id: String = UUID().uuidString
    var content: String
    var voiceData: Data?
    var photoURL: String?
    var dateCreated: Date = Date()
    var labels: [String]?
    
    var momentType: MomentDataType {
        if photoURL != nil {
            return .photo
        } else if voiceData != nil {
            return .voice
        } else {
            return .text
        }
    }

}
