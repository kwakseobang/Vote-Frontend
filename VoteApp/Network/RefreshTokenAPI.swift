//
//  RefreshAPI.swift
//  VoteApp
//
//  Created by 곽서방 on 12/23/24.
//
// 현재 백엔드 수정해야됨 지금 해야될 일

import Foundation
import Alamofire
class RefreshTokenAPI {
    
    // /reissue 엔드포인트로 액세스 토큰을 갱신하는 함수
    static func refreshToken(completion: @escaping (Result<String, Error>) -> Void) {
        // /reissue API 엔드포인트 URL
        guard let url = URL(string: APIConstants.reissueURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        var accessToken = ""
        if let Token = UserDefaultsManager.getData(type: String.self, forKey: .accessToken) {
            print("Access Token: \(accessToken)")
            accessToken = Token
        } else {
            print("No access token found")
            completion(.failure(NSError(domain: "No access token found", code: 404, userInfo: nil)))
        }
        // 헤더 설정 (Content-Type은 application/json)
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        // Alamofire로 요청을 보내어 리프레쉬 토큰을 사용해 새 액세스 토큰을 받아옴
        AF.request(url, method: .post, headers: headers)
            .validate(statusCode: 200..<300) // 유효한 상태 코드만 처리
            .responseDecodable(of: Auth.TokenResponse.self) { response in
                switch response.result {
                case .success(let tokenResponse):
                    // tokenResponse.data가 nil일 수 있기 때문에 안전한 옵셔널 바인딩 사용
                    if let accessToken = tokenResponse.data?.accessToken {
                        completion(.success(accessToken))
                    } else {
                        // accessToken이 nil인 경우 실패 처리
                        let error = NSError(domain: "Missing Access Token", code: 404, userInfo: nil)
                        completion(.failure(error))
                    }
                case .failure(let error):
                    // 오류 발생 시 처리
                    completion(.failure(error))
                }
            }
    }
}



