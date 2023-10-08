//
//  UpResults.swift
//  Tom
//
//  Created by 김종혁 on 2023/10/09.
//

import Foundation

struct UpResults: Identifiable, Codable {
    var id = UUID()
    var results: String?
    
    enum CodingKeys: CodingKey {
            case results
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            results = (try? values.decode(String.self, forKey: .results)) ?? nil
        }
}
