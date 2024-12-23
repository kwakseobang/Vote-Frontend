//
//  Vote.swift
//  VoteApp
//
//  Created by 곽서방 on 12/23/24.
//

import Foundation
import Foundation

struct Vote {
    
    // MARK: - 투표 목록 조회
    struct VotesResponse: Codable {
        let status: Int
        let message, code: String
        var data: [Votes]
    }

    // MARK: - Datum
    struct Votes: Codable {
        let voteID: Int
        var author, title, createdTime: String

        enum CodingKeys: String, CodingKey {
            case voteID = "voteId"
            case author, title, createdTime
        }
    }
    // MARK: - 투표 조회
    struct VoteResponse: Codable {
        let status: Int
        let message, code: String
        var data: VoteDetails
    }

    // MARK: - VoteDetails
    struct VoteDetails: Codable {
        let voteID: Int
        var title: String
        let selectedItemID: Int
        var selectedVoteItem: String
        let createdTime: String
        var voteItems: [VoteItem]

        enum CodingKeys: String, CodingKey {
            case voteID = "voteId"
            case title
            case selectedItemID = "selectedItemId"
            case selectedVoteItem, createdTime, voteItems
        }
    }
    
    // MARK: - VoteItem
    struct VoteItem: Codable {
        let voteItemID: Int
        var itemName: String
        var count: Int

        enum CodingKeys: String, CodingKey {
            case voteItemID = "voteItemId"
            case itemName, count
        }
    }

    
}
