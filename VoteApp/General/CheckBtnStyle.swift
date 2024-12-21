//
//  CheckBtnStyle.swift
//  VoteApp
//
//  Created by 곽서방 on 12/21/24.
//


import SwiftUI


struct CheckBtnStyle: ButtonStyle {
    
//    var isCheck: Bool = false
 
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16,weight: .semibold))
            .foregroundColor(.white)
            .frame(width: 80,height: 50)
            .background(
                RoundedRectangle(
                    cornerRadius: 10,
                    style: .continuous
                )
                .fill(.blue)
            )
            .padding(.top,32)
    }
}