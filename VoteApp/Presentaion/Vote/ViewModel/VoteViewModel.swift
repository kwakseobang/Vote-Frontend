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
    @Published var isLoading: Bool = false  // 로딩 상태 추적
    
    
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
    
    public func getVoteId() -> Int{
        return vote.voteID
    }

    public func isSelectedVoteItem(voteItemId : Int) -> Bool {
        if let selectedItem =   vote.selectedItemID {
            return selectedItem == voteItemId
        } else {
            return false
        }
    }
    //첫투표냐?
    public func isFirstVote() -> Bool {
        return vote.selectedItemID == nil
    }
    // 같은 항목 제출이냐?
    public func isSameVote(voteItemId: Int) -> Bool {
        // 기존 투표와 현재 투표가 동일한지 확인
        return vote.selectedItemID == voteItemId// 비교 대상은 현재와 이전의 선택 항목 ID
    }

    public func getPostOrPutHttpMethod() -> HTTPMethod {
        return self.isFirstVote() ? .post : .put
    }
//    public func updateOrFirst() -> vo {
//        isFirstVote()
//    }
}

// MARK: - API 호출 전용
extension VoteViewModel {
    // MARK: - 투표 목록 조회
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
    // MARK: - 투표 조회
    func getVote(voteId: Int, completion: @escaping (Vote.VoteDetails?) -> Void) {
        let voteId : String = "\(voteId)"
        guard let url = URL(string:APIConstants.voteURL + "/" + voteId) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        AF.request(url, method: .get,encoding: JSONEncoding.default,headers: header,interceptor: AuthInterceptor())
            .validate(statusCode: 200..<300) // 유효성 검사
            .responseDecodable(of: Vote.VoteResponse.self){ response in
                switch response.result {
                    
                case .success(let result):
                    self.vote = result.data
                    self.voteItems = result.data.voteItems
                    completion(result.data)
                    print("투표  조회 성공")
                    
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
                        print("투표 조회 실패: \(error.localizedDescription)")
                        self.error?.statusCode = response.response!.statusCode
                        self.error?.message = "투표를 조회하는데 실패했습니다. 다시 시도해주세요."
                    }
                    completion(nil)
                }
                
                
            }
    }
    struct Empty: Decodable {}
    // MARK: - 투표 제출
    func submitVote(voteId: Int,voteItemId: Int, completion: @escaping (Bool) -> Void) {
        let voteId : String = "\(voteId)"
        guard let url = URL(string:APIConstants.voteURL + "/" + voteId) else {
            print("Invalid URL")
            completion(false)
            return
        }
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        let parameters: [String: Any] = [
            "voteItemId": voteItemId
        ]
        AF.request(url, method: getPostOrPutHttpMethod() ,parameters: parameters,encoding: JSONEncoding.default,headers: header,interceptor: AuthInterceptor())
            .validate(statusCode: 200..<300) // 유효성 검사
            .responseDecodable(of: Vote.Response.self){ response in
                switch response.result {
                    
                case .success(let result):
                    completion(true)
                    print(result.message)
                    
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
                        print("투표 제출 실패: \(error.localizedDescription)")
                        self.error?.statusCode = response.response!.statusCode
                        self.error?.message = "투표 제출을 실패했습니다. 다시 시도해주세요."
                    }
                    completion(false)
                }
                
                
            }
    }
    // MARK: - 투표 작성
    func createVote(title: String,voteItems: [String], completion: @escaping (Bool) -> Void) {
       
        guard let url = URL(string:APIConstants.voteURL) else {
            print("Invalid URL")
            completion(false)
            return
        }
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        let parameters: [String: Any] = [
            "title": title,
            "voteItems": voteItems
        ]
        AF.request(url, method: .post ,parameters: parameters,encoding: JSONEncoding.default,headers: header,interceptor: AuthInterceptor())
            .validate(statusCode: 200..<300) // 유효성 검사
            .responseDecodable(of: Vote.Response.self){ response in
                switch response.result {
                    
                case .success(let result):
                    completion(true)
                    print(result.message)
                    
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
                        print("투표 제출 실패: \(error.localizedDescription)")
                        self.error?.statusCode = response.response!.statusCode
                        self.error?.message = "투표 제출을 실패했습니다. 다시 시도해주세요."
                    }
                    completion(false)
                }
                
                
            }
    }
    


}
