//
//  Vote.swift
//  VoteApp
//
//  Created by 곽서방 on 12/23/24.
//

import Foundation

struct Vote {
    struct Response: Codable {
        let status: Int
        let message, code: String
        let data: JSONNull?
    }
    
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
        let selectedItemID: Int?  // 옵셔널 처리
        var selectedVoteItem: String?  // 옵셔널 처리
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
    struct VoteItem: Codable, Identifiable {
        // Identifiable 요구사항 충족
        var id: Int {
            voteItemID
        }

        let voteItemID: Int
        var itemName: String
        var count: Int

        enum CodingKeys: String, CodingKey {
            case voteItemID = "voteItemId"
            case itemName, count
        }
    }

    // MARK: - 투표 작성자
    struct VoteAuthor: Codable {
        let status: Int
        let message, code: String
        var data: AuthorInfo
    }

    // MARK: - AuthorInfo
    struct AuthorInfo: Codable {
        let userID, voteID: Int
        let title, createTime: String

        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case voteID = "voteId"
            case title, createTime
        }
    }

}
