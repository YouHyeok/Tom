//
//  ScheduledTasks.swift
//  Tom
//
//  Created by 김종혁 on 2/1/24.
//

import Foundation

struct ScheduledTasks: Identifiable, Decodable {
    var id = UUID()
    var user: String?
    var task: String?
    var scheduled_id: String?
    var scheduled_time: Int?
    
    enum CodingKeys: CodingKey {
        case user
        case task
        case scheduled_id
        case scheduled_time
    }
    
    init(user: String?, task: String?, scheduled_id: String?, scheduled_time: Int?) {
        self.user = user
        self.task = task
        self.scheduled_id = scheduled_id
        self.scheduled_time = scheduled_time
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = (try? values.decode(String.self, forKey: .user)) ?? nil
        task = (try? values.decode(String.self, forKey: .task)) ?? nil
        scheduled_id = (try? values.decode(String.self, forKey: .scheduled_id)) ?? nil
        scheduled_time = (try? values.decode(Int.self, forKey: .scheduled_time)) ?? nil
    }
}
