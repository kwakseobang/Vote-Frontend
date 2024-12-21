//
//  SignUpView.swift
//  VoteApp
//
//  Created by 곽서방 on 12/21/24.
//

import SwiftUI

//
//  InfoRegisterView.swift
//  Software_Project
//
//  Created by 곽서방 on 3/20/24.
//

/// 정리하자면 닉네임 중복확인과 이메일 인증을 거친 후 비번까지 확인. 그 후. 회원 가입 누르면 회원가입 요청 (닉네임, 이메일, 비밀번호 입
///
struct SignUpView: View {
//    @StateObject private var signUpViewModel = SignUpViewModel()
//    @Environment(\.presentationMode) var mode // 화면 전환
    var body: some View {
        VStack{
            ScrollView {
                HeaderView()
                ShowView(signUpViewModel: signUpViewModel)
                SignUpBtnView(signUpViewModel: signUpViewModel)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("회원가입")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button{
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.bkText)
                    })
            
        }
        .transition(.scale)
    }
}
// MARK: - 헤더 뷰
private struct HeaderView: View {
    fileprivate var body: some View {
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
// MARK: - 바디 뷰
private struct ShowView: View {
    @ObservedObject private var signUpViewModel: SignUpViewModel
    
    
    fileprivate init(signUpViewModel: SignUpViewModel) {
        self.signUpViewModel = signUpViewModel
    }
    
    fileprivate var body: some View {
        VStack(alignment: .leading,spacing: 20) {
            HStack {
                InputView(
//                    ischeck: $viewModel.IscheckName,
                    text: $signUpViewModel.user.userInfo.name,
                    title: "닉네임",
                    placeholder: "닉네임을 입력해주세요",
                    stateCheck: signUpViewModel.IscheckName
                )
                Button {
                    //TODO: - 중복 확인 API
                    signUpViewModel.checkName()
                } label: {
                    Text("중복확인")
                }
                .buttonStyle(CheckBtnStyle())
        
            }
            
            HStack {
                InputView(
//                    ischeck: viewModel.IscheckName,
                    text: $signUpViewModel.user.userInfo.email,
                    title: "학교 E-mail",
                    placeholder: "학교 이메일을 입력해주세요",
                    stateCheck: signUpViewModel.IsEmailName
                )
                .textInputAutocapitalization(.never)
                .autocapitalization(.none)
                
                Button {
                    //TODO: - 인증 확인 API
                    signUpViewModel.checkEmail()
                } label: {
                    Text(signUpViewModel.IsEmailName ? "인증완료" :"인증확인")
                        
                }
                .buttonStyle(CheckBtnStyle())
            }
            
            InputView(
                text: $signUpViewModel.user.userInfo.password,
                title: "비밀번호",
                placeholder: "비밀번호를 8자리 이상 입력해주세요",
                isSecureField: true
            )
            .textContentType(.oneTimeCode)
            
            InputView(
                text: $signUpViewModel.confirmPassword,
                title: "비밀번호 확인",
                placeholder: "다시 한번 입력해주세요",
                isSecureField: true,
                checkPassword: signUpViewModel.comparePassword()
            )
            .textContentType(.oneTimeCode)
        }

        .padding(.bottom)
    }
}
// MARK: - 입력 뷰
private struct InputView: View {
    @Binding var text: String
    @State var isPasswordCountError: Bool = false
    var title: String
    var placeholder: String
    var isSecureField = false
    var stateCheck = false
    var checkPassword = true

    fileprivate var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .font(.headline)
                .foregroundColor(checkPassword ? .bkText : .red )
            
            if isSecureField {
                SecureField(placeholder,text: $text)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 28)
                    .font(.system(size: 15))
                    .padding(.vertical,13)
                    .background(.thinMaterial)
                    .cornerRadius(10)
                
            } else {
                HStack {
                    TextField(placeholder,text: $text)
                        .frame(width: UIScreen.main.bounds.width - 120, height: 28)
                        .font(.system(size: 15))
                        .padding(.vertical,13)
                        .background(.thinMaterial)
                        .cornerRadius(10)
                        .overlay(
                            HStack{
                                Image(systemName: stateCheck ? "checkmark.circle" :"xmark.circle")
                                    .rotation3DEffect(.degrees(stateCheck ? 360 : 0), axis: (x: 0, y: 0, z: 1))
                                    .animation(.default, value: stateCheck)
                                    .foregroundColor(text.isEmpty ? .clear : stateCheck ? .blue :.red)
                                
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, 8)
                            }
                        )
                }
            }
        }
        
    }
}

//MARK: - 회원 가입 버튼 뷰
private struct SignUpBtnView: View {
    @ObservedObject var signUpViewModel: SignUpViewModel
    @Environment(\.presentationMode) var mode
    fileprivate init(signUpViewModel: SignUpViewModel) {
        self.signUpViewModel = signUpViewModel
    }
    
    fileprivate var body: some View {
        Button {
            if signUpViewModel.comparePassword() {
                //TODO: - User 데이터 서버로 전송
                signUpViewModel.sendUserDate()
                
                mode.wrappedValue.dismiss()
                    
                  
            }else {
                //TODO: -
            }
        } label: {
            HStack {
                Text("회원 가입")
                    .fontWeight(.semibold)
                Image(systemName: "arrow.right")
            }
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
        }
        .background(Color(.systemBlue))
        .cornerRadius(10)
        .padding(.top,25)
        .disabled(!signUpViewModel.checkSignUpCondition())
        .opacity(signUpViewModel.checkSignUpCondition() ? 1.0 : 0.5)
    
    }
}

#Preview {
    SignUpView()
}




#Preview {
    SignUpView()
}
