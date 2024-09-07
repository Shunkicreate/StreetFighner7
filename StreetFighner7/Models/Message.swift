//
//  Message.swift
//  StreetFighner7
//
//  Created by shunsuke tamura on 2024/09/08.
//

import Foundation

class Message: Decodable, Encodable, Identifiable, Hashable {
    let message: String
    
    init(message: String) {
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
