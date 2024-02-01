//
//  LScheduledTasks.swift
//  Tom
//
//  Created by 김종혁 on 2/1/24.
//

import Foundation

struct LScheduledTasks: Identifiable, Decodable {
    var id = UUID()
    var data: [ScheduledTasks]?
    
    enum CodingKeys: CodingKey {
            case data
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            data = (try? values.decode([ScheduledTasks].self, forKey: .data)) ?? nil
        }
}
