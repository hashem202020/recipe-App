//
//  APIService.swift
//  iosTask
//
//  Created by hashem on 06/08/2021.
//

import Foundation
import Alamofire

class APIService{
public static let sharedInstance = APIService()

    
//MARK:- Generic Function to Request Data
    
    func getData<T: Codable >(url: String, method: HTTPMethod, param: [String : String]!, completion: @escaping(T?, Error?) -> Void ){
        AF.request(url, method: method, parameters: param, encoding: JSONEncoding.default)
            .responseJSON { (response) in
            guard let data = response.data else {return}

            switch response.result{
            case .success(let value):
                print(value)

                do{
                    let json = try JSONDecoder().decode(T.self, from: data)                    
                    completion(json, nil)
                } catch let jsonError {
                    print(jsonError)
                    completion(nil, jsonError)
                }
            case .failure(let error):
            print(error)
            completion(nil, error)
            }
        }
    }
}
