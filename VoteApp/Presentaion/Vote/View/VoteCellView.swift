//
//  VoteCellView.swift
//  VoteApp
//
//  Created by 곽서방 on 12/23/24.
//

import SwiftUI

struct VoteCellView: View {
    @EnvironmentObject private var voteViewModel: VoteViewModel
    var vote: Vote.Votes
    var body: some View {
        VStack(alignment: .leading){
            
            HStack(alignment:.top) {
                HStack{
                    Image(systemName: "hand.thumbsup.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50 ,height: 50)
                        .clipShape(.rect(cornerRadius: 10))
                    
                    VStack(alignment: .leading,spacing: 10) {
                        Text(vote.title)
                            .font(.system(size: 17,weight: .bold))
                            .foregroundStyle(.bkText)
                        Text(vote.createdTime)
                        
                    }
                }
                Spacer()
                Text(vote.author)
                    .font(.system(size: 17,weight: .semibold))
                    .foregroundStyle(.bkText)
                    .padding()
            }
            .padding(.horizontal)
            .padding(.vertical,15)
            
            .foregroundColor(.gray)
            .font(.system(size: 15))
                
            }
        .background(.white)
    }
}

#Preview {
    VoteCellView(vote: .init(voteID: 1, author: "곽태풍", title: "붕어빵은 어디부터인가", createdTime: "2024.12.21"))
}
