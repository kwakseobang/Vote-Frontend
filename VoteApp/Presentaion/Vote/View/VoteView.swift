//
//  VoteView.swift
//  VoteApp
//
//  Created by 곽서방 on 12/23/24.
//

import SwiftUI
import Charts
struct VoteView: View {
    @EnvironmentObject private var voteViewModel: VoteViewModel
    @Environment(\.presentationMode)  var mode
    var voteId: Int
    var body: some View {
        
        VStack {
         
            if voteViewModel.isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                
            } else {
                VoteResultView(vote: $voteViewModel.vote)
                    .environmentObject(voteViewModel)
                
                VoteWriteView(vote: $voteViewModel.vote)
                    .environmentObject(voteViewModel)
                    .padding(.top, 20)
                    .background(Color("vote-back"))
            }
        }
        .onAppear {
            // View가 나타날 때 vote 데이터를 비동기적으로 불러오기
            voteViewModel.isLoading = true
            voteViewModel.getVote(voteId: voteId){ voteDetails in
                if let voteDetails = voteDetails {
                    voteViewModel.vote = voteDetails
                    voteViewModel.isLoading = false
                    print(voteViewModel.vote)
                } else {
                    voteViewModel.isLoading = false
                    voteViewModel.error?.message = "투표 세부 정보를 불러오는 데 실패했습니다."
                }
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("투표")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading:
                                Button{
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
                        // TODO: Settings action
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundStyle(Color("fontColor"))
                    }
                }
            }
        )
    }
    
}


private struct VoteResultView: View {
    @EnvironmentObject private var voteViewModel: VoteViewModel
    @Binding var vote: Vote.VoteDetails
    var body: some View {
        VStack(spacing: 20) {
            // Donut Chart
            Chart(voteViewModel.voteItems) { item in
                SectorMark(
                    angle: .value("Votes", item.count),
                    innerRadius: .ratio(0.6)
                    
                )
                .annotation(position: .overlay) {
                    if (item.count != 0) {
                        Text("\(String(format: "%.1f%%", percentage(for: item)))")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color.black.opacity(0.6), in: RoundedRectangle(cornerRadius: 8))
                        
                    }
                }
                
                .foregroundStyle(by: .value("Item", item.itemName))
        
            }
            .chartLegend(position: .bottom) // Display legend at the bottom
            
            .frame(height: 200)
            // Display total vote count in the center of the donut
                        
            Text("총 투표 수: \(totalVotes)표")
                .foregroundColor(.black)
                .font(.system(size: 18,weight: .bold))
            // List of vote items with their percentages
            ForEach(voteViewModel.voteItems) { item in
                HStack {
                    Text(item.itemName)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(item.count) 표")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
            }
        }
        .padding()
    }

    private var totalVotes: Int {
        voteViewModel.voteItems.map(\.count).reduce(0, +)
    }

    private func percentage(for item: Vote.VoteItem) -> Double {
        let totalVotes = max(1, voteViewModel.voteItems.map(\.count).reduce(0, +))
        return (Double(item.count) / Double(totalVotes)) * 100
    }
}



private struct VoteWriteView : View {
    @EnvironmentObject private var voteViewModel: VoteViewModel
    @Binding var vote: Vote.VoteDetails
    var body: some View {
        
        ScrollView {
            ZStack{
                LazyVStack {
                    ForEach(voteViewModel.voteItems.indices, id: \.self) { index in
                        HStack{
                            VoteWriteCellView(voteItem: voteViewModel.voteItems[index])
                                .environmentObject(voteViewModel)
                                .cornerRadius(15)
                                .padding(.horizontal,3)
                                .padding(.vertical,10)
                        }
                    }
                }
                
                
            }
            
        }
    }
}
private struct VoteWriteCellView: View {
    @EnvironmentObject private var voteViewModel: VoteViewModel
    var voteItem: Vote.VoteItem
    @State private var isShowingAlert: Bool = false
    @State private var alertMessage: String = ""
    var body: some View {
        
        HStack(alignment:.top) {
            HStack{
                Image(systemName: "hand.thumbsup.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30 ,height: 30)
                    .clipShape(.rect(cornerRadius: 10))
                
                VStack(alignment: .leading,spacing: 10) {
                    Text(voteItem.itemName)
                        .font(.system(size: 14,weight: .semibold))
                        .foregroundStyle(Color("chat-notice"))
                }
                Spacer()
                HStack{
                    Image(systemName: voteViewModel.isSelectedVoteItem(voteItemId: voteItem.id) ? "checkmark.circle" :"xmark.circle")
                        .rotation3DEffect(.degrees(true ? 360 : 0), axis: (x: 0, y: 0, z: 1))
                        .animation(.default, value: true)
                        .foregroundColor(!voteViewModel.isSelectedVoteItem(voteItemId: voteItem.id) ? .clear :  .blue)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 8)
                    
                    Button{
                        if voteViewModel.isSameVote(voteItemId: voteItem.id) {
                            alertMessage = "현재 선택된 항목은 이미 투표되었습니다."
                            isShowingAlert = true
                        }else {
                            voteViewModel.submitVote(voteId: voteViewModel.getVoteId(), voteItemId: voteItem.id) { isReRoad in
                                voteViewModel.getVote(voteId: voteViewModel.getVoteId()) { updatedVoteDetails in
                                    if let updatedVoteDetails = updatedVoteDetails {
                                        voteViewModel.vote = updatedVoteDetails
                                    }
                                }
                            }
                        }
                    }label: {
                        
                        
                        Text("투표")
                            .frame(width: 50, height: 30)
                            .foregroundColor(.black)
                            .background(.greyCool)
                            .cornerRadius(10)
                        
                    }
                }
            }
            .padding(.vertical,10)
            
        }
        .padding(.horizontal)
        .padding(.vertical,15)
        
        .foregroundColor(.gray)
        .font(.system(size: 15))
        .background(.white)
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("다른 항목을 선택해 주세요"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
        }
    }
        
}

#Preview {
    VoteView( voteId: 1)
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
