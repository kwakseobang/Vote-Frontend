//
//  LoginView.swift
//  VoteApp
//
//  Created by 곽서방 on 12/21/24.
//

import SwiftUI

struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    var body: some View {
        NavigationStack{
            VStack {
                TitleView()
                    .padding(.top,40)
                Spacer()
                    .frame(height: 30)
                LoginInputView(username: $username, password: $password)
                
                LoginTabView(username: $username, password: $password)
                    .padding(.vertical,5)
                
                //            FindAccountView()
                Spacer()
                    .frame(height: 50)
                CreateInfoBtnView()
            }
        }
    }
}
//MARK: - 헤더 뷰
private struct TitleView: View {
    fileprivate var body: some View {
        ZStack {
            VStack{
                Image(systemName: "hand.thumbsup.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .padding()
                
                Text("간편한 투표 App vote is goat")
                    .font(.system(size: 20,weight: .semibold))
                HStack{
                    Text("voat")
                        .font(.system(size: 40,weight: .bold))
                    Image(systemName: "hand.thumbsup.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .foregroundColor(.black)

                }
                .padding(.leading)
            }
        }
    }
}
//MARK: - 아이디 비밀번호 입력 뷰
private struct LoginInputView: View {
    @Binding var username: String
    @Binding var password: String
    
    fileprivate var body: some View {
        // ID 텍스트 필드
        VStack(spacing:15){
            TextField("아이디", text: $username)
                .frame(width: UIScreen.main.bounds.width - 50, height: 20)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
                .keyboardType(.default) //email 형식으로 입력 받도록
                .textCase(.lowercase)
                .autocapitalization(.none) // 대문자 설정 지우기
                .disableAutocorrection(false) // 자동 수정 설정 해제
                .textInputAutocapitalization(.never)
             
            SecureField("비밀번호", text: $password)
                .frame(width: UIScreen.main.bounds.width - 50, height: 20)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
                .autocapitalization(.none)
            
        }
    }
    
}

private struct LoginTabView: View {
 
    @Binding var username: String
    @Binding var password: String
    
    @State private var tag: Int? = nil
    
    fileprivate var body: some View {
        Button {
           
        } label: {
            HStack{
                Text("Login")
                Image(systemName: "house")
            }
        }
        
        .disabled((username.isEmpty || password.isEmpty) ? true : false) // 둘 다 입력 시
        .font(.system(size: 20,weight: .bold))
        .frame(width: 330,height: 20)
        .padding()
        .overlay(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(Color.clear, lineWidth: 2) // 외곽선 둥글게
        )
        .background(Color((username.isEmpty || password.isEmpty) ? "sky_bg": "mainColor"))
        .foregroundColor(.white)
        
    }
}
//    

private struct CreateInfoBtnView: View {
    fileprivate var body: some View {
        
        HStack{
            Text("아직 회원이 아니신가요?")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            NavigationLink {
                SignUpView()
            }label: {
                Text("회원가입 >")
                    .foregroundColor(Color("mainColor"))
            }
        }
        
        Spacer()
        
    }
}
#Preview {
    LoginView()
}
