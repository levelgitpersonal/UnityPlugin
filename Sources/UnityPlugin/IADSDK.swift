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
    public func getJsonString() -> String {
        do {
            let attributionToken = try AAAttribution.attributionToken()
            let data = attributionToken.data(using: .utf8)
            
            guard let data = data else {
                return ""
            }
            
            let byteArray = [UInt8](data)
            let jsonString = String(data: try JSONSerialization.data(withJSONObject: byteArray), encoding: .utf8)
            
            guard let jsonString = jsonString else {
                return ""
            }
            
            return jsonString
        } catch {
            return ""
        }
    }
    
}
