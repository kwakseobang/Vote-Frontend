//
//  SplashView.swift
//  VoteApp
//
//  Created by 곽서방 on 12/21/24.
//

import SwiftUI
struct SplashView: View {
    var body: some View {
        
        VStack{
            Image(systemName: "hand.thumbsup.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .foregroundColor(Color("chat-notice"))
                .padding()
            
            Text("간편한 투표 App vote is goat")
                .font(.system(size: 20,weight: .semibold))
            //                    .foregroundColor(Color("mainColor"))
            HStack{
                Text("voat")
                    .font(.system(size: 40,weight: .bold))
                    .foregroundColor(Color("chat-notice"))
                Image(systemName: "hand.thumbsup.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .foregroundColor(Color("chat-notice"))
                
            }
            .padding(.leading)
        }
    }
}

#Preview {
    SplashView()
}
