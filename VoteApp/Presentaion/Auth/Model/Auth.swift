//
//  Auth.swift
//  VoteApp
//
//  Created by 곽서방 on 12/20/24.
//

import Foundation


struct Auth {
    // MARK: - Welcome
    struct SignUpResponse: Codable {
        let status: Int
        let message, code: String
        let data: JSONNull?
    }
}
// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    // Hashable 구현
       func hash(into hasher: inout Hasher) {
           // 해시 값을 위해 고유한 값을 설정. 여기서는 `nil`을 사용하는 방식으로 간단하게 처리.
           hasher.combine("null") // "null"을 해시하여 동일한 null 값을 동일한 해시로 처리
       }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}
