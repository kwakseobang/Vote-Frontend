//
//  VoteView.swift
//  VoteApp
//
//  Created by 곽서방 on 12/23/24.
//

import SwiftUI
import Charts
struct VoteCreateView: View {
    @EnvironmentObject private var voteViewModel: VoteViewModel
    @EnvironmentObject private var pathModel: PathModel
    @Environment(\.presentationMode) var mode
    @State var title: String = ""
    @State var voteItemList = [""]
    @State private var isShowingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading) {
                    TitleView(title: $title)
                    Spacer()
                        .frame(height: 50)
                    ScrollView {
                        VoteItemListView(voteItemList: $voteItemList)
                        WriteBtnView(voteItemList: $voteItemList)
                            .padding(.top, 10)  // 버튼과 항목 사이의 간격
                    }
                }
                .padding(.horizontal)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("투표 작성")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading:
                                    Button {
                mode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.black)
            }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Voat")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Color("fontColor"))
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            if isFormValid() {
                                voteViewModel.createVote(title:title,voteItems: voteItemList) { result in
                                    if result {
                                        mode.wrappedValue.dismiss()
                                    } else {
                                        alertMessage = "투표 생성에 실패했습니다. 다시 시도해주세요."
                                        isShowingAlert = true
                                    }
                                }
                                
                            } else {
                                isShowingAlert = true
                            }
                        } label: {
                            Text("작성")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(Color("fontColor"))
                        }
                    }
                }
            )
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("입력 오류"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("확인")))
            }
        }
        
    }

    private func isFormValid() -> Bool {
        if title.isEmpty {
            alertMessage = "투표 제목을 입력하세요."
            return false
        }
        if voteItemList.contains(where: { $0.trimmingCharacters(in: .whitespaces).isEmpty }) {
            alertMessage = "모든 투표 항목을 입력하세요."
            return false
        }
        return true
    }
}


// MARK: - 투표 타이틀 작성
private struct TitleView: View {
    @Binding var title: String
    fileprivate var body: some View {
        
        VStack(alignment: .leading) {
            Text("제목")
                .font(.system(size: 18,weight: .bold))
            TextField("투표 제목", text: $title)
                .frame(width: UIScreen.main.bounds.width - 50, height: 20)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
                .keyboardType(.default)
                .textCase(.lowercase)
                .autocapitalization(.none) // 대문자 설정 지우기
                .disableAutocorrection(false) // 자동 수정 설정 해제
                .textInputAutocapitalization(.never)
        }
    }
}

private struct VoteItemListView: View {
    @Binding  var voteItemList: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("투표 항목")
                .font(.system(size: 18,weight: .bold))
            ForEach(0..<voteItemList.count, id: \.self) { index in
                            VoteItemView(voteItem: $voteItemList[index])
                        }
        }
    
    }
}

// MARK: - 투표 항목
private struct VoteItemView: View {
    @EnvironmentObject private var voteViewModel: VoteViewModel
    
    @State private var isShowingAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @Binding var voteItem: String
    
    var body: some View {
        
        
        HStack(alignment:.top) {
            HStack{
                Image(systemName: "hand.thumbsup.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30 ,height: 30)
                    .clipShape(.rect(cornerRadius: 10))
                
                
                TextField("투표 항목", text: $voteItem)
                    .frame(width: UIScreen.main.bounds.width - 200, height: 20)
                    .padding()
                    .cornerRadius(10)
                    .keyboardType(.default)
                    .textCase(.lowercase)
                    .autocapitalization(.none) // 대문자 설정 지우기
                    .disableAutocorrection(false) // 자동 수정 설정 해제
                    .textInputAutocapitalization(.never)
                    .font(.system(size: 14,weight: .semibold))
                
                
                Spacer()
                Text("투표")
                    .frame(width: 50, height: 30)
                    .foregroundColor(.black)
                    .background(.greyCool)
                    .cornerRadius(10)
                
            }
            
            
            
            
        }
        
        
    }
}

private struct WriteBtnView: View {
    @Binding var voteItemList: [String]
    
    var body: some View {
        HStack {
            Spacer() // 위쪽 여백을 확보
            Button {
                voteItemList.append("")
            } label: {
                Image(systemName: "plus")
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
                    .padding(5)
                    .background(.greyCool)
            }
            .cornerRadius(20)
            Button {
                if voteItemList.count > 1 {
                    voteItemList.removeLast()
                }
            } label: {
                Image(systemName: "minus")
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
                    .padding(5)
                    .background(.greyCool)
            }
            .cornerRadius(20)
            Spacer() // 아래쪽 여백을 확보
        }
        
    }
}

#Preview {
    VoteCreateView(title: "엄마 vs 아빠")
        .environmentObject(
            VoteViewModel(
                votes: [],
                voteItems: [
                    .init(voteItemID: 1, itemName: "엄마", count: 100),
                    .init(voteItemID: 2, itemName: "아빠", count: 43)
                ],
                vote: .init(voteID: 1, title: "엄마 vs 아빠", selectedItemID: 1, selectedVoteItem: "아빠", createdTime: "2024.12.12", voteItems: [
                    .init(voteItemID: 1, itemName: "엄마", count: 2),
                    .init(voteItemID: 2, itemName: "아빠", count: 4),
                ]
                )))
}

