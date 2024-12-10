//
//  Profile.swift
//  prueva
//
//  Created by Victor Tejeda on 8/12/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var fullName = "John Doe"
    @State private var email = "john.doe@example.com"
    @State private var phone = "+1 (555) 123-4567"
    @State private var receiveMarketingEmails = false
    @State private var pushNotifications = true
    @State private var darkMode = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    HStack {
                        Spacer()
                        VStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .foregroundColor(.blue)
                            
                            Text(fullName)
                                .font(.headline)
                            
                            Text(email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding()
                    
                    TextField("Full Name", text: $fullName)
                    TextField("Email", text: $email)
                    TextField("Phone", text: $phone)
                }
                
                Section(header: Text("Settings")) {
                    Toggle("Receive Marketing Emails", isOn: $receiveMarketingEmails)
                    Toggle("Push Notifications", isOn: $pushNotifications)
                    Toggle("Dark Mode", isOn: $darkMode)
                }
                
                Section {
                    Button(action: updateProfile) {
                        Text("Update Profile")
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
    
    func updateProfile() {
        // Implement profile update logic here
        print("Profile updated")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
