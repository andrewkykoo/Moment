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
    // Add other properties as needed, like timestamp, image URL, etc.

}
