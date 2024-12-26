//
//  HomeView.swift
//  VoteApp
//
//  Created by 곽서방 on 12/21/24.
//

import SwiftUI

struct VoteListView: View {
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

           

        }
        
        
    }
    
}

private struct ListView: View {
    @EnvironmentObject var voteViewModel: VoteViewModel
    fileprivate var body: some View {
        ZStack{
        ScrollView {
   
                LazyVStack {
                    ForEach(voteViewModel.votes.indices, id: \.self) { index in
                        NavigationLink {
                            
                            VoteView(voteId:voteViewModel.votes[index].voteID)
                                .environmentObject(voteViewModel)
                            
                            
                        }label: {
                            
                            VoteCellView(vote: voteViewModel.votes[index])
                                .environmentObject(voteViewModel)
                                .cornerRadius(15)
                                .padding(.horizontal,10)
                                .padding(.top,5)
                            
                        }
                    }
                }
                .padding(.top,20)
              
            }
            VStack {
                Spacer() // 버튼을 화면 하단으로 밀기
                HStack {
                    Spacer() // 버튼을 화면 오른쪽으로 밀기
                    WriteBtnView()
                        .padding(16) // 하단 및 우측 간격 추가
                }
            }
        }
        .background(Color("vote-back"))
        .padding(0)
    }
}

//MARK: - Todo 작성 버튼 뷰
private struct WriteBtnView: View {
    @EnvironmentObject private var pathViewModel: PathModel
    @EnvironmentObject private var voteViewModel: VoteViewModel
    fileprivate var body: some View {
        NavigationLink {
            VoteCreateView()
                .environmentObject(voteViewModel)
                .navigationBarBackButtonHidden()
        } label: {
            Image(systemName: "pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30) // 버튼 크기 설정
                .foregroundColor(.white)
                .background(Color("mainColor"))
                .cornerRadius(15) // 원형 버튼
        }
        .frame(width: 60, height: 60) // 버튼의 전체 뷰 크기 설정 (버튼 크기를 크게 설정하고 싶은 경우)
        .background(Color("mainColor"))
        .clipShape(Circle()) // 버튼이 원형으로 보이게 함
        .shadow(radius: 10) // 그림자 추가 (선택 사항)
    }
}



#Preview {
    VoteListView()
        .environmentObject(PathModel())
        .environmentObject(VoteViewModel(votes: [
            .init(voteID: 1, author: "짱구", title: "짜장 vs 짬뽕", createdTime: "2024.12.21"),
            .init(voteID: 2, author: "맹구", title: "최악의 연인은?", createdTime: "2024.12.22"),
            .init(voteID: 3, author: "수지", title: "여름 vs 겨울", createdTime: "2024.12.24"),
            .init(voteID: 3, author: "수지", title: "여름 vs 겨울", createdTime: "2024.12.24"),
            .init(voteID: 3, author: "수지", title: "여름 vs 겨울", createdTime: "2024.12.24"),
            .init(voteID: 3, author: "수지", title: "여름 vs 겨울", createdTime: "2024.12.24"),
            .init(voteID: 3, author: "수지", title: "여름 vs 겨울", createdTime: "2024.12.24")
        ])
        )
}
//
//  HomeView.swift
//  VoteApp
//
//  Created by 곽서방 on 12/21/24.
//

//import SwiftUI
//
//struct VoteListView: View {
//    @EnvironmentObject private var voteViewModel: VoteViewModel
//    @State  var test: String = ""
//    var body: some View {
//        
//        
//        NavigationView {
//            ZStack{
//                VStack{
////                    if !voteViewModel.votes.isEmpty {
////                        CustomNavigationBar(
////                            isDisplayLeftBtn: false,
////                            rightBtnAction: {
////                                // TODO: -
////                            },
////                            rightBtnType: .setting
////                        )
////
////                    }
//                    SearchView(test:$test)
//                    
//                    ListView()
//                        .environmentObject(voteViewModel)
//                    
//                    
//                }
//            }
//        }
//        .onAppear {
//            voteViewModel.getVoteList() // 화면이 나타날 때 투표 목록을 가져옴
//        }
//       n
//        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Text("Voat")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundStyle(Color("fontColor"))
//            }
//            ToolbarItem(placement: .topBarTrailing) {
//                Button {
//                    // TODO: Settings action
//                } label: {
//                    Image(systemName: "gearshape")
//                        .foregroundStyle(Color("fontColor"))
//                }
//            }
//        }
//        
//        
//        
//        
//        
//    }
//}
//// MARK: - 주소 검색 및 해당 카테// MARK: - 주소 검색 및 해당 카테고리 검색
//private struct SearchView: View {
////    @EnvironmentObject var postListViewModel: PostListViewModel
//    @Binding var test: String
//    fileprivate var body: some View {
//        VStack(alignment: .center){
//            HStack {
//                TextField("투표 제목을 입력하세요.", text: $test )
//                    
//                Spacer()
//                Button{
//                    //TODO: - 검색어
//                }label: {
//                    Image(systemName: "magnifyingglass")
//                        .foregroundColor(.blue)
//                }
//            }
//            .font(.system(size: 16,weight: .bold))
//            .frame(width: 330,height: 20)
//            .padding()
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color("mainColor"), lineWidth: 2) // 외곽선 둥글게
//            )
//
//           
//
//        }
//        
//        
//    }
//    
//}
//
//private struct ListView: View {
//    @EnvironmentObject var voteViewModel: VoteViewModel
//    fileprivate var body: some View {
//        ZStack{
//        ScrollView {
//   
//                LazyVStack {
//                    ForEach(voteViewModel.votes.indices, id: \.self) { index in
//                        NavigationLink {
//                            
//                            VoteView(voteId:voteViewModel.votes[index].voteID)
//                                .environmentObject(voteViewModel)
//                            
//                            
//                        }label: {
//                            
//                            VoteCellView(vote: voteViewModel.votes[index])
//                                .environmentObject(voteViewModel)
//                                .cornerRadius(15)
//                                .padding(.horizontal,10)
//                                .padding(.top,5)
//                            
//                        }
//                    }
//                }
//                .padding(.top,20)
//              
//            }
//            VStack {
//                Spacer() // 버튼을 화면 하단으로 밀기
//                HStack {
//                    Spacer() // 버튼을 화면 오른쪽으로 밀기
//                    WriteBtnView()
//                        .padding(16) // 하단 및 우측 간격 추가
//                }
//            }
//        }
//        .background(Color("vote-back"))
//        .padding(0)
//    }
//}
//
////MARK: - Todo 작성 버튼 뷰
//private struct WriteBtnView: View {
//    @EnvironmentObject private var pathViewModel: PathModel
//    fileprivate var body: some View {
//        NavigationLink {
//            VoteCreateView()
//                .navigationBarBackButtonHidden()
//        } label: {
//            Image(systemName: "pencil")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 30, height: 30) // 버튼 크기 설정
//                .foregroundColor(.white)
//                .background(Color("mainColor"))
//                .cornerRadius(15) // 원형 버튼
//        }
//        .frame(width: 60, height: 60) // 버튼의 전체 뷰 크기 설정 (버튼 크기를 크게 설정하고 싶은 경우)
//        .background(Color("mainColor"))
//        .clipShape(Circle()) // 버튼이 원형으로 보이게 함
//        .shadow(radius: 10) // 그림자 추가 (선택 사항)
//    }
//}
//
//
//
//#Preview {
//    VoteListView()
//        .environmentObject(PathModel())
//        .environmentObject(VoteViewModel(votes: [
//            .init(voteID: 1, author: "짱구", title: "짜장 vs 짬뽕", createdTime: "2024.12.21"),
//            .init(voteID: 2, author: "맹구", title: "최악의 연인은?", createdTime: "2024.12.22"),
//            .init(voteID: 3, author: "수지", title: "여름 vs 겨울", createdTime: "2024.12.24"),
//            .init(voteID: 3, author: "수지", title: "여름 vs 겨울", createdTime: "2024.12.24"),
//            .init(voteID: 3, author: "수지", title: "여름 vs 겨울", createdTime: "2024.12.24"),
//            .init(voteID: 3, author: "수지", title: "여름 vs 겨울", createdTime: "2024.12.24"),
//            .init(voteID: 3, author: "수지", title: "여름 vs 겨울", createdTime: "2024.12.24")
//        ])
//        )
//}
