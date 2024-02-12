//
//  File.swift
//  
//
//  Created by Steve on 12.02.2024.
//

import Foundation
import AdServices


public struct IADSDK {
    
    @available(iOS 14.3, *)
    public static func getCampaignId(with appleID: String, completion: @escaping (Result<Int, Error>) -> Void) {
        do {
            let attributionToken = try AAAttribution.attributionToken()
            
            let data = attributionToken.data(using: .utf8)
            
            guard let baseUrl = URL(string: appleID) else {
                return
            }
            
            let request = NSMutableURLRequest(url: baseUrl)
            request.httpMethod = "POST"
            request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
               
                guard let httpResponse = response as? HTTPURLResponse else {
                    getCampaignId(with: appleID, completion: completion)
                    return
                }
                
                switch httpResponse.statusCode {
                case 200:
                    guard let data = data else {
                        getCampaignId(with: appleID, completion: completion)
                        return
                    }
                    
                    do {
                        guard let json = try JSONSerialization.jsonObject(
                            with: data,
                            options: .fragmentsAllowed
                        ) as? [String: Any] else {
                            completion(.failure(IAdError.noCampaignId))
                            return
                        }
                        
                        if let campaignId = json["campaignId"] as? Int {
                            completion(.success(campaignId))
                        } else {
                            completion(.failure(IAdError.noCampaignId))
                        }
                        
                    } catch {
                        completion(.failure(IAdError.failedToSerializeJson))
                    }
                    break
                case 404:
                    getCampaignId(with: appleID, completion: completion)
                    break
                default:
                    completion(.failure(IAdError.iAdServerError))
                    break
                }
            }
            task.resume()
        } catch {
            completion(.failure(IAdError.failedToGetAttributionToken))
        }
    }
    
}

enum IAdError: Error {
    case iAdServerError
    case failedToGetAttributionToken
    case noCampaignId
    case failedToSerializeJson
}
