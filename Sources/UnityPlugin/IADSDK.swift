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
    public func getAttributionToken() -> String {
        do {
            let attributionToken = try AAAttribution.attributionToken()
            return attributionToken
        } catch {
            return ""
        }
    }
    
}
