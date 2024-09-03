//
//  LoginView.swift
//  BeatWave
//
//  Created by Vinicius Leal on 02/09/2024.
//

import SwiftUI

struct LoginView: View {
    
    private let viewModel: LoginViewModel
    
    @State var username: String = ""
    @State var password: String = ""
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [
                Color.topBackground,
                Color.midBackground,
                Color.bottomBackground
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                VStack(spacing: 10) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                    Text("BeatWave")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                TextField("Username", text: $username)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
                
                SecureField("Password", text: $password)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
                
                Spacer().frame(height: 40)
                
                Button(action: {
                    viewModel.performAction(.didPressLogIn(username: username, password: password))
                }) {
                    Text("Log in")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .disabled(isButtonDisabled)
                .padding(.horizontal, 40)
                
                Text("© 2024 BeatWave")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                Spacer().frame(height: 20)
            }
        }
    }
    
    private var isButtonDisabled: Bool {
        !username.isEmpty && !password.isEmpty
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
}
