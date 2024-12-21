//
//  LoginView.swift
//  Software_Project
//
//  Created by 곽서방 on 3/15/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var pathModel = PathModel()
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @StateObject private var postViewModel = PostListViewModel()
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        NavigationStack(path: $pathModel.tabPaths) {
            VStack {
                TitleView()
                    .padding(.top,40)
                Spacer()
                    .frame(height: 30)
                LoginInputView(email: $email, password: $password)
                
                LoginTabView(email: $email, password: $password)
                    .padding(.vertical,5)
                
                FindAccountView()
                Spacer()
                    .frame(height: 50)
                CreateInfoBtnView()
            }
            
}

//MARK: - 헤더 뷰
        private struct TitleView: View {
            fileprivate var body: some View {
                ZStack {
                    VStack{
                        Image(systemName: "house")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                            .padding()
                        
                        Text("안서동 자취방 정보는")
                            .font(.system(size: 20,weight: .semibold))
                        HStack{
                            Text("안방")
                                .font(.system(size: 40,weight: .bold))
                            Image(systemName: "house")
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
}
//MARK: - 아이디 비밀번호 입력 뷰
private struct LoginInputView: View {
    @Binding var email: String
    @Binding var password: String
    
    fileprivate var body: some View {
        // ID 텍스트 필드
        VStack(spacing:15){
            TextField("학교 이메일", text: $email)
                .frame(width: UIScreen.main.bounds.width - 50, height: 20)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
                .keyboardType(.emailAddress) //email 형식으로 입력 받도록
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
//    @EnvironmentObject private var pathModel: PathModel
//    @EnvironmentObject private var loginViewModel: LoginViewModel
    @Binding var email: String
    @Binding var password: String
    
    @State private var tag: Int? = nil
    
    fileprivate var body: some View {
        Button {
          
            if true /*loginViewModel.sendLogin(email: email, password: password)*/ {
                print("로그인 성공")
                pathModel.tabPaths.append(.homeView)
               
            } else {
                print("Login Failed...")
            }
           
        }label: {
            HStack{
                Text("Login")
                Image(systemName: "house")
            }
        }
//            .disabled((email.isEmpty || password.isEmpty) ? true : false) // 둘 다 입력 시
            .font(.system(size: 20,weight: .bold))
            .frame(width: 330,height: 20)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(Color.clear, lineWidth: 2) // 외곽선 둥글게
            )
            .background(Color((email.isEmpty || password.isEmpty) ? "sky_bg": "mainColor"))
            .foregroundColor(.white)
        
    }
}
    
    // MARK: -  Etc.. 뷰
private struct FindAccountView: View {
    @State private var isAutoLogin = false
    fileprivate var body: some View {
        
        HStack{
            Toggle(isOn: $isAutoLogin) {
                Text("아이디 저장")
            }
            .toggleStyle(iOSCheckboxToggleStyle())
            Spacer()
            
            HStack(spacing: 5){
                
                HStack{
                    Button{
                        
                    }label: {
                        Text("비밀번호 찾기")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.trailing)
            .font(.system(size: 15))
        }
        .padding(.leading,20)
    }
}

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
        .environmentObject(LoginViewModel())
        
}
