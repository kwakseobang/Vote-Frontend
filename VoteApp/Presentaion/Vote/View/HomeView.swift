//
//  HomeView.swift
//  VoteApp
//
//  Created by 곽서방 on 12/21/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var voteViewModel: VoteViewModel
    @State  var test: String = ""
    var body: some View {
     
        NavigationView {
            
            ZStack{
                VStack{
                    SearchView(test:$test)
                    
                    ListView()
                        .environmentObject(voteViewModel)
                }
            }
            .onAppear {
                voteViewModel.getVoteList() // 화면이 나타날 때 투표 목록을 가져옴
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Voat")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color("fontColor"))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // TODO: Settings action
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundStyle(Color("fontColor"))
                    }
                }
            }
            
            
            
        }
       
    }
}
// MARK: - 주소 검색 및 해당 카테// MARK: - 주소 검색 및 해당 카테고리 검색
private struct SearchView: View {
//    @EnvironmentObject var postListViewModel: PostListViewModel
    @Binding var test: String
    fileprivate var body: some View {
        VStack(alignment: .center){
            HStack {
                TextField("투표 제목을 입력하세요.", text: $test )
                    
                Spacer()
                Button{
                    //TODO: - 검색어
                }label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.blue)
                }
            }
            .font(.system(size: 16,weight: .bold))
            .frame(width: 330,height: 20)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("mainColor"), lineWidth: 2) // 외곽선 둥글게
            )

           
//            ScrollView(.horizontal){
//                HStack(spacing: 20){
//                    
//                    VStack {
//                        Button {
//                            
//                        } label: {
//                            Image(systemName: "house")
//                                .resizable()
//                                .frame(width: 30,height: 30)
//                        }
//                        Text("최신순")
//                            .font(.system(size: 14,weight: .medium))
//                            .foregroundColor(.bkText)
//                    }
//                    VStack {
//                        Button {
//                            
//                        } label: {
//                            Image(systemName: "building.2")
//                                .resizable()
//                                .frame(width: 30,height: 30)
//                            
//                        }
//                        Text("기숙사")
//                            .font(.system(size: 14,weight: .medium))
//                            .foregroundColor(.bkText)
//                    }
//                    VStack {
//                        Button {
//                            
//                        } label: {
//                            Image(systemName: "heart.circle.fill")
//                                .resizable()
//                                .frame(width: 30,height: 30)
//                            
//                        }
//                        Text("추천순")
//                            .font(.system(size: 14,weight: .medium))
//                            .foregroundColor(.bkText)
//                    }
//                    VStack {
//                        Button {
//                            
//                        } label: {
//                            Image(systemName: "dollarsign.circle.fill")
//                                .resizable()
//                                .frame(width: 30,height: 30)
//                        }
//                        Text("낮은 가격대")
//                            .font(.system(size: 14,weight: .medium))
//                            .foregroundColor(.bkText)
//                    }
//                    VStack {
//                        Button {
//                            
//                        } label: {
//                            Image(systemName: "dollarsign.circle.fill")
//                                .resizable()
//                                .frame(width: 30,height: 30)
//                                .foregroundColor(Color("mainColor"))
//                        }
//                        Text("높은 가격대")
//                            .font(.system(size: 14,weight: .medium))
//                            .foregroundColor(.bkText)
//                    }
//                    
//                    
//                }
//                .buttonStyle(CategoryBtnStyle(width: 53, height: 53))
//            }
//            .padding(.leading)
//            
        }
        
        
    }
    
}
             
private struct ListView: View {
    @EnvironmentObject var voteViewModel: VoteViewModel
    fileprivate var body: some View {
        
        ScrollView {
            LazyVStack {
                ForEach(voteViewModel.votes.indices, id: \.self) { index in
                    NavigationLink {
                        VoteView()
                    }label: {
                        
                        VoteCellView(vote: voteViewModel.votes[index])
                            .cornerRadius(15)
                            .padding(.horizontal,10)
                            .padding(.top,5)
                        
                    }
                }
            }
            .padding(.top,20)
            
        }
        .background(Color("vote-back"))
        .padding(0)
    }
}

#Preview {
    HomeView()
        .environmentObject(VoteViewModel(votes: [
            .init(voteID: 1, author: "짱구", title: "짜장 vs 짬뽕", createdTime: "2024.12.21"),
            .init(voteID: 2, author: "맹구", title: "최악의 연인은?", createdTime: "2024.12.22"),
            .init(voteID: 3, author: "수지", title: "여름 vs 겨울", createdTime: "2024.12.24")
        ])
        )
}
