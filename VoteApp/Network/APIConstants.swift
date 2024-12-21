//
//  APIConstants.swift
//  VoteApp
//
//  Created by 곽서방 on 12/21/24.
//

import Foundation


struct APIConstants {
    // MARK: - Base URL
    static let baseURL = "http:/localhost:8080"
    
    // MARK: - SignUp URL
    static let signUpURL = baseURL + "/auth/signup"
    
    // MARK: - loginURL URL
    
    static let loginURL = baseURL + "/auth/login"
    
    // MARK: - ID 중복체크
    static let usernameURL = baseURL + "/auth/username"
    // MARK: - 닉네임 중복체크
    static let nicknameURL = baseURL + "/auth/nickname"
}
