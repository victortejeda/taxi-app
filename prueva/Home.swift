//
//  Home.swift
//  prueva
//
//  Created by Victor Tejeda on 8/12/24.
//

import SwiftUI

struct HomeView: View {
    @State private var isAdmin = true // This should be based on user role
    
    var body: some View {
        TabView {
            if isAdmin {
                AdminPanelView()
                    .tabItem {
                        Label("Admin", systemImage: "shield")
                    }
            }
            
            ReservationListView()
                .tabItem {
                    Label("Reservations", systemImage: "list.bullet")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}
