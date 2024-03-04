//
//  ManualSignIn.swift
//  HOTH
//
//  Created by Marius Genton on 3/3/24.
//

import SwiftUI

struct ManualSignIn: View {
    
    @Binding var authStatus: AuthStatus
    @Binding var user: User?
    @State private var username = ""
    @State private var pwd = ""
    @State private var name = ""
    @State private var previousAttemptFailed = false
    @State private var loginPhase = LoginPhase.Choose
    @State private var loading = false
    
    enum LoginPhase { case Choose, Login, New }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Text("stride")
                .fontWeight(.black)
                .foregroundStyle(Color("C5"))
                .font(.title)
            Spacer().frame(height: 20)
                
            switch loginPhase {
            case .Choose:
                VStack(spacing: 0) {
                    Button {
                        HapticManager.mediumFeedback()
                        withAnimation { loginPhase = .Login }
                    } label: {
                        ZStack {
                            Rectangle()
                                .cornerRadius(10)
                                .foregroundStyle(Color("C5"))
                            Text("Login")
                                .foregroundStyle(.white)
                                .padding()
                                .fontWeight(.semibold)
                        }
                    }
                    .padding([.leading, .trailing], 20)
                    .padding([.leading, .trailing, .top])
                    .fixedSize(horizontal: false, vertical: true)
                    
                    Button {
                        HapticManager.mediumFeedback()
                        withAnimation { loginPhase = .New }
                    } label: {
                        ZStack {
                            Rectangle()
                                .cornerRadius(10)
                                .foregroundStyle(Color("C5"))
                            Text("Create an account")
                                .foregroundStyle(.white)
                                .padding()
                                .fontWeight(.semibold)
                        }
                    }
                    .padding([.leading, .trailing], 20)
                    .padding()
                    .fixedSize(horizontal: false, vertical: true)
                }
            case .Login:
                VStack {
                    TextField(text: $username) {
                        Text("Username")
                    }
                    .textFieldStyle(.roundedBorder)
                    .padding([.leading, .trailing])
                    .textInputAutocapitalization(.never)
                    SecureField(text: $pwd) {
                        Text("Password")
                    }
                    .textContentType(.password)
                    .textFieldStyle(.roundedBorder)
                    .padding([.leading, .trailing])
                    .padding(.bottom)
                    Button {
                        HapticManager.mediumFeedback()
                        Task {
                            loading = true
                            let result = await DataManager.auth(username: username, pwd: pwd)
                            withAnimation {
                                if result == nil { previousAttemptFailed = true }
                                else { user = result }
                            }
                            loading = false
                        }
                    } label: {
                        ZStack {
                            Rectangle()
                                .cornerRadius(10)
                                .foregroundStyle(username != "" && pwd != "" ? Color("C5") : Color("C3"))
                            if !loading {
                                Text("Log in")
                                    .padding()
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                            } else {
                                ProgressView().progressViewStyle(.circular)
                                    .padding()
                            }
                        }
                    }
                    .disabled(username == "" || pwd == "")
                    .fixedSize()
                    
                    Button {
                        HapticManager.mediumFeedback()
                        withAnimation { loginPhase = .New }
                    } label: {
                        Text("Create an account instead")
                            .underline()
                            .foregroundStyle(Color("C5"))
                            .padding(.top, 10)
                            .font(.footnote)
                    }

                    
                    if previousAttemptFailed {
                        Text("The username and password you entered do not correspond :(")
                            .foregroundStyle(.red)
                            .fontWeight(.bold)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                }
            case .New:
                VStack {
                    TextField(text: $name) {
                        Text("Your name")
                    }
                    .textFieldStyle(.roundedBorder)
                    .padding([.leading, .trailing])
                    TextField(text: $username) {
                        Text("Choose a username")
                    }
                    .textFieldStyle(.roundedBorder)
                    .padding([.leading, .trailing])
                    .textInputAutocapitalization(.never)
                    SecureField(text: $pwd) {
                        Text("Set a password")
                    }
                    .textContentType(.password)
                    .textFieldStyle(.roundedBorder)
                    .padding([.leading, .trailing])
                    .padding(.bottom)
                    Button {
                        HapticManager.mediumFeedback()
                        Task {
                            loading = true
                            let result = await DataManager.createAccount(username: username, pwd: pwd, name: name)
                            withAnimation {
                                user = result
                            }
                            loading = false
                        }
                    } label: {
                        ZStack {
                            Rectangle()
                                .cornerRadius(10)
                                .foregroundStyle(username != "" && pwd != "" ? Color("C5") : Color("C3"))
                            if !loading {
                                Text("Create account")
                                    .padding()
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                            } else {
                                ProgressView().progressViewStyle(.circular)
                                    .padding()
                            }
                        }
                    }
                    .disabled(username == "" || pwd == "" || name == "")
                    .fixedSize()
                    
                    Button {
                        HapticManager.mediumFeedback()
                        withAnimation { loginPhase = .Login }
                    } label: {
                        Text("Log in instead")
                            .underline()
                            .foregroundStyle(Color("C5"))
                            .padding(.top, 10)
                            .font(.footnote)
                    }
                    
                }
            }
            Spacer()
        }
        .background(Color("C1"))
    }
}
