//
//  AuthInterceptor.swift
//  VoteApp
//
//  Created by 곽서방 on 12/23/24.
//

import Alamofire
import Foundation

// 요청 인터셉터 클래스
final class  AuthInterceptor: RequestInterceptor {
    
    // 요청을 가로채서 헤더에 액세스 토큰을 추가합니다.
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
   
        // UserDefaults에서 액세스 토큰을 가져옵니다.
        if let accessToken = UserDefaultsManager.getData(type: String.self, forKey: .accessToken) {
            // Authorization 헤더에 Bearer 토큰 추가
            urlRequest.headers.add(.authorization(bearerToken: accessToken))
        }
        
        completion(.success(urlRequest))
    }
    
    // 네트워크 요청이 실패했을 때 재시도 정책을 설정할 수 있습니다.
    // 예를 들어, 액세스 토큰 만료 시 리프레시 토큰을 사용하여 새로운 액세스 토큰을 가져오는 로직을 추가할 수 있습니다.
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void)  {
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
                   completion(.doNotRetryWithError(error))
                   return
               }
        
        RefreshTokenAPI.refreshToken { result in
                   switch result {
                   case .success(let accessToken):
                       UserDefaultsManager.setData(value:accessToken, key: .accessToken) // 토큰 저장
                       completion(.retry)
                   case .failure(let error):
                       completion(.doNotRetryWithError(error))
                   }
               }
    }
}

