//
//  VoteView.swift
//  VoteApp
//
//  Created by 곽서방 on 12/23/24.
//

import SwiftUI

struct VoteView: View {
    @EnvironmentObject private var voteViewModel: VoteViewModel
    @Environment(\.presentationMode)  var mode
    var body: some View {
     
        VStack {
            VoteResultView()
                .environmentObject(voteViewModel)
            Spacer()
                .frame(height: 200)
            VoteWriteView()
                .environmentObject(voteViewModel)
                .padding(.top,20)
                .background(Color("vote-back"))
            
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
                })
    }
}

private struct VoteResultView : View {
    @EnvironmentObject private var voteViewModel: VoteViewModel
    var body: some View {
        VStack(spacing: 10){
            HStack{
                Text("test")
            }
            HStack{
                Text("test")
            }
            HStack{
                Text("test")
            }
        }
    }
}
private struct VoteWriteView : View {
    @EnvironmentObject private var voteViewModel: VoteViewModel
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
                    Image(systemName: true ? "checkmark.circle" :"xmark.circle")
                        .rotation3DEffect(.degrees(true ? 360 : 0), axis: (x: 0, y: 0, z: 1))
                        .animation(.default, value: true)
                        .foregroundColor(false ? .clear : true ? .blue :.red)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 8)
                    
                    Button{
                        
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
        
    }
        
}

#Preview {
    VoteView()
        .environmentObject(VoteViewModel(
            voteItems: [
                .init(voteItemID: 1, itemName: "엄마", count: 0),
                .init(voteItemID: 2, itemName: "아빠", count: 0),
            ],
            vote: .init(voteID: 1, title: "엄마 vs 아빠", selectedItemID: 1, selectedVoteItem: "엄마", createdTime: "2024.12.12", voteItems: []) ))
}
