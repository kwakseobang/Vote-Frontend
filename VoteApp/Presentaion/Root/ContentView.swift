//
//  ContentView.swift
//  VoteApp
//
//  Created by 곽서방 on 12/20/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    
    @StateObject private var loginViewModel = LoginViewModel()
//    @StateObject private var pathViewModel = PathModel()
    @State var isLaunching: Bool = true
    var body: some View {
        ZStack {
            if isLaunching {
                SplashView()
                    .opacity(isLaunching ? 1 : 0)
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation(.easeIn(duration: 1)) {
                                isLaunching = false
                            }
                        }
                    }
            } else {
                LoginView()
                    .environmentObject(loginViewModel)
            }
        }
    }

}

#Preview {
    ContentView()
        
}
