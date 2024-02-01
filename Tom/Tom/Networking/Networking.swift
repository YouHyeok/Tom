//
//  Networking.swift
//  Tom
//
//  Created by 김종혁 on 2023/10/08.
//

import Foundation
import Alamofire
import SwiftUI

class Networking: ObservableObject {
    @Published var lcategories = [String]()
    @Published var ltimes = ["Descheduling", "5 min", "10 min", "15 min", "30 min", "1 hour", "2 hour"]
    @Published var lcatetime: [String: Int] = ["0": 0, "1": 1, "2": 2]
    @Published var selectedLtimesid: Int = 1
    
    func getCategories(url: String, query: [String: String], completion: @escaping (([String]?) -> Void)) {
            guard let sessionUrl = URL(string: url) else {
                print("Invalid URL")
                return
            }
        
            AF.request(sessionUrl,
                       method: .get,
                       parameters: query,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json"])
                .validate(statusCode: 200..<300)
                .responseDecodable (of: LCategories.self) { response in
                                switch response.result {
                                case .success(let value):
                                    self.lcategories = value.results!
                                    
                                    completion(value.results!)
                                    
                                    print(self.lcategories)
                                case .failure(let error):
                                    print(error)
                            }
                    }
        }
    
    func triggerGIT(url: String, bodyl: [String: String], completion: @escaping ((String?) -> Void)) {
            guard let sessionUrl = URL(string: url) else {
                print("Invalid URL")
                return
            }
        
            AF.request(sessionUrl,
                       method: .post,
                       parameters: bodyl,
                       encoding: JSONEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json"])
                .validate(statusCode: 200..<300)
                .responseDecodable (of: UpResults.self) { response in
                                switch response.result {
                                case .success(let value):
                                    completion(value.results!)
                                case .failure(let error):
                                    print(error)
                            }
                    }
        }
    
    
}
