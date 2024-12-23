//
//  VoteViewModel.swift
//  VoteApp
//
//  Created by 곽서방 on 12/23/24.
//

import Foundation
import Alamofire

class VoteViewModel: ObservableObject {
    @Published var votes: [Vote.Votes]
    @Published var error: CustomError? = nil // 오류 메시지를 표시하기 위한 프로퍼티
    @Published var vote: Vote.VoteDetails
    @Published var voteItems: [Vote.VoteItem]
    
    
    init(
        votes: [Vote.Votes] = [],
        voteItems: [Vote.VoteItem] = [],
        vote: Vote.VoteDetails = .init(voteID: 1, title: "", selectedItemID: 1, selectedVoteItem: "", createdTime: "", voteItems: [])
    ) {
        self.votes = votes
        self.voteItems = voteItems
        self.vote = vote
    }
    
    
    
    
}
extension VoteViewModel {
    
}

// MARK: - API 호출 전용
extension VoteViewModel {
    
    func getVoteList(){
        guard let url = URL(string:APIConstants.voteURL) else {
            print("Invalid URL")
            return
        }
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        
        AF.request(url, method: .get,encoding: JSONEncoding.default,headers: header,interceptor: AuthInterceptor())
            .validate(statusCode: 200..<300) // 유효성 검사
            .responseDecodable(of: Vote.VotesResponse.self){ response in
                switch response.result {
                    
                case .success(let result):
                    self.votes =  result.data // 목록 저장
                    print("투표 목록 조회 성공")
                    
                    
                case .failure(let error):
                    // 실패 시 오류 처리
                    if let httpResponse = response.response, httpResponse.statusCode == 401 {
                        // 401 Unauthorized일 경우 리프레시 토큰을 갱신하고 재시도
                        print("인증 오류 - 리프레시 토큰으로 액세스 토큰을 갱신해야 합니다.")
                        self.error?.statusCode = httpResponse.statusCode
                        // 로그인 화면으로 리다이렉트하거나 리프레시 토큰 로직을 추가합니다.
                        self.error?.message = "로그인 세션이 만료되었습니다. 다시 로그인 해주세요."
                    } else {
                        // 다른 오류 처리
                        print("투표 목록 조회 실패: \(error.localizedDescription)")
                        self.error?.statusCode = response.response!.statusCode
                        self.error?.message = "투표 목록을 조회하는데 실패했습니다. 다시 시도해주세요."
                    }
                }
                

            }
        
    }

}
