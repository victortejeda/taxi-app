//
//  Login.swift
//  prueva
//
//  Created by Victor Tejeda on 8/12/24.
//

import SwiftUI

struct LoginView: View {
    @State private var loginInput = "" // Can be email or phone
    @State private var password = ""
    @State private var loginError = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 30)
            
            VStack(spacing: 15) {
                TextField("Email or Phone", text: $loginInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal, 30)
            
            if !loginError.isEmpty {
                Text(loginError)
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }
            
            Button(action: login) {
                Text("Sign In")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 30)
            .padding(.horizontal, 30)
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
                    .foregroundColor(.blue)
            }
            .padding(.top, 15)
        }
        .padding()
    }
    
    func login() {
        guard let url = URL(string: "https://taxi.markadai.com/validate_login.php") else {
            loginError = "Invalid URL"
            return
        }
        
        let body: [String: String] = ["loginInput": loginInput, "password": password]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    loginError = "Connection error: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    loginError = "Empty server response"
                }
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                DispatchQueue.main.async {
                    if decodedResponse.success {
                        print("Welcome, \(decodedResponse.user?.name ?? "User") \(decodedResponse.user?.apellido ?? "")")
                        loginError = ""
                        // Navigate to the next screen here
                    } else {
                        loginError = decodedResponse.message ?? "Unknown error"
                    }
                }
            } else {
                DispatchQueue.main.async {
                    loginError = "Failed to process server response"
                }
            }
        }.resume()
    }
}

struct LoginResponse: Codable {
    let success: Bool
    let message: String?
    let user: User?
}

struct User: Codable {
    let id: Int
    let name: String
    let apellido: String
    let typeu: String
    let status: String
}
