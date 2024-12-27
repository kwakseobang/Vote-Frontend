//
//  HomeView.swift
//  Software_Project
//
//  Created by 곽서방 on 3/17/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var voteViewModel: VoteViewModel
    @State private var selectedIndex: Int = 0
    var body: some View {
        TabView(selection: $selectedIndex) {
            VoteListView()
                .onTapGesture {
                    self.selectedIndex = 0
                }
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }.tag(0)
            
            SettingView()
                 .onTapGesture {
                     self.selectedIndex = 1
                 }
                 .tabItem {
                     Image(systemName: "gearshape")
                     Text("설정")
                     
                 }.tag(1)
            
            EmptyView()
                 .onTapGesture {
                     self.selectedIndex = 2
                 }
                 .tabItem {
                     Image(systemName: "star")
                     Text("관심 목록")
                 }.tag(2)
            
            EmptyView()
                 .onTapGesture {
                     self.selectedIndex = 3
                 }
                 .tabItem {
                     Image(systemName: "message")
                     Text("쪽지함")
                 }.tag(3)
            
          
        }
        
        .environmentObject(VoteViewModel())
        .environmentObject(PathModel())
        .background(Color("vote-back"))
        .navigationBarBackButtonHidden(true)
    }
      
}

#Preview {
    HomeView()
        .environmentObject(LoginViewModel())
        .environmentObject(VoteViewModel())
        .environmentObject(PathModel())
}
