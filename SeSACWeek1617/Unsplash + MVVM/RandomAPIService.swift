//
//  RandomAPIService.swift
//  SeSACWeek1617
//
//  Created by 이병현 on 2022/10/24.
//

import Foundation
import Alamofire

class RandomAPIService {
    static func randomPhoto(query: String, completion: @escaping (RandomPhoto?, Int?, Error?) -> Void) {
        let url = "\(APIKey.randomURL)\(query)"
        let header: HTTPHeaders = ["Authorization": APIKey.authorization]
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: RandomPhoto.self) { response in
            
            let statusCode = response.response?.statusCode // 상태코드 조건문
            
            switch response.result {
            case .success(let value): completion(value, statusCode, nil)
            case .failure(let error): completion(nil, statusCode, error)
            }
        }
    }
    
    private init() { }
}
