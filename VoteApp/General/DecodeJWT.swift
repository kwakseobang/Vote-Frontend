//
//  DecodeJWT.swift
//  VoteApp
//
//  Created by 곽서방 on 12/27/24.
//

import Foundation


func decodeJWT(_ token: String) -> [String: Any]? {
    let parts = token.split(separator: ".")
    guard parts.count == 3 else { return nil } // JWT는 3부분으로 구성됨
    let payload = parts[1] // Payload는 두 번째 부분

    // Base64 URL-safe 디코딩
    var base64 = String(payload)
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")
    while base64.count % 4 != 0 {
        base64.append("=")
    }
    
    guard let data = Data(base64Encoded: base64) else { return nil }
    let json = try? JSONSerialization.jsonObject(with: data, options: [])
    return json as? [String: Any]
}


