//
//  Message.swift
//  StreetFighner7
//
//  Created by shunsuke tamura on 2024/09/08.
//

import Foundation

enum MessageType: Int, Codable {
    case ready = 0
    case start = 1
    case attackCenter = 2
    case attackLeft = 3
    case attackRight = 4
    case result = 5
}

class Message: Codable, Identifiable, Hashable {
    let type: MessageType
    let message: String
    
    init(type: MessageType, message: String) {
        self.type = type
        self.message = message
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(message)
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.message == rhs.message
    }
    
    func toJson() -> String? {
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print("Failed to encode Message to JSON: \(error)")
            return nil
        }
    }
    
    static func fromJson(jsonString: String) -> Message? {
        let decoder = JSONDecoder()
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Failed to convert JSON string to Data.")
            return nil
        }
        
        do {
            let message = try decoder.decode(Message.self, from: jsonData)
            return message
        } catch {
            print("Failed to decode JSON: \(error)")
            return nil
        }
    }
}
