//
//  CategoryBtnStyle.swift
//  VoteApp
//
//  Created by 곽서방 on 12/23/24.
//


import SwiftUI

struct CategoryBtnStyle: ButtonStyle {
    let width: CGFloat
    let height: CGFloat
    
//    init(
//        width: CGFloat,
//        height: CGFloat
//    ) {
//        self.width = width
//        self.height = height
//    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: self.width, height: self.height)
            .foregroundColor(.blue)
            .background(.greyCool)
            .cornerRadius(10)
    }
}
