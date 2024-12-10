//
//  DriverRow.swift
//  prueva
//
//  Created by Victor Tejeda on 8/12/24.
//

import SwiftUI

struct DriverRow: View {
    let driver: Driver
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(driver.name)
                    .font(.headline)
                Text(driver.phone)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing) {
                StatusBadge(status: driver.status)
                OnlineBadge(isOnline: driver.isOnline)
            }
        }
        .padding(.vertical, 4)
    }
}

struct StatusBadge: View {
    let status: String
    
    var body: some View {
        Text(status)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status == "Active" ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
            .foregroundColor(status == "Active" ? .green : .red)
            .cornerRadius(8)
    }
}

struct OnlineBadge: View {
    let isOnline: Bool
    
    var body: some View {
        HStack {
            Circle()
                .fill(isOnline ? Color.green : Color.gray)
                .frame(width: 8, height: 8)
            Text(isOnline ? "Online" : "Offline")
                .font(.caption)
                .foregroundColor(isOnline ? .green : .gray)
        }
    }
}
