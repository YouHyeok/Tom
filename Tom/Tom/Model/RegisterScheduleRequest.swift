//
//  RegisterSchedule.swift
//  Tom
//
//  Created by 김종혁 on 2/1/24.
//

import Foundation

struct RegisterScheduleRequest: Identifiable, Codable {
    var id = UUID()
    var user: String?
    var task: String?
    var scheduled_time: Int?
}

extension Encodable {
    var toDictionary : [String: Any]? {
        guard let object = try? JSONEncoder().encode(self) else { return nil }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String:Any] else { return nil }
        return dictionary
    }
}
