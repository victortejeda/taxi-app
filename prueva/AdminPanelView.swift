//
//  AdminPanelView.swift
//  prueva
//
//  Created by Victor Tejeda on 8/12/24.
//

import SwiftUI
import SwiftUICharts // Para gráficos interactivos
import Combine // Para manejar datos dinámicos
import Lottie // Animaciones modernas

struct AdminPanelView: View {
    @State private var drivers: [Driver] = []
    @State private var searchText = ""
    @State private var selectedFilter = "All"
    @State private var animateStats = false
    @State private var cancellables = Set<AnyCancellable>() // Combine
    
    let filterOptions = ["All", "Active", "Inactive"]
    
    var filteredDrivers: [Driver] {
        drivers.filter { driver in
            (selectedFilter == "All" || driver.status == selectedFilter) &&
            (searchText.isEmpty || driver.name.localizedCaseInsensitiveContains(searchText) || driver.phone.localizedCaseInsensitiveContains(searchText))
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Stats Overview with Charts
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        BarChartView(data: ChartData(values: [
                            ("Online", drivers.filter { $0.isOnline }.count),
                            ("Active", drivers.filter { $0.status == "Active" }.count)
                        ]), title: "Drivers Status", legend: "Stats")
                            .frame(height: 200)
                        
                        StatCard(title: "Total Drivers", value: "\(drivers.count)", color: .blue, animationTrigger: $animateStats)
                    }
                    .padding()
                }
                
                // Search and Filter
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search drivers...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Picker("Filter", selection: $selectedFilter) {
                        ForEach(filterOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding(.horizontal)
                
                // Drivers List
                List {
                    ForEach(filteredDrivers) { driver in
                        DriverRow(driver: driver)
                    }
                }
            }
            .navigationTitle("Admin Panel")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: loadDrivers) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .onAppear {
                loadDrivers()
                setupAnimations()
            }
        }
    }
    
    // Backend Integration
    private func loadDrivers() {
        // Simular llamada a una API
        let sampleData = [
            Driver(number: 1, phone: "123-456-7890", name: "John Doe", status: "Active", type: "Full-time", isOnline: true),
            Driver(number: 2, phone: "234-567-8901", name: "Jane Smith", status: "Inactive", type: "Part-time", isOnline: false)
        ]
        Just(sampleData)
            .delay(for: .seconds(1), scheduler: RunLoop.main)
            .sink(receiveValue: { data in
                self.drivers = data
            })
            .store(in: &cancellables)
    }
    
    private func setupAnimations() {
        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            animateStats.toggle()
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    @Binding var animationTrigger: Bool
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
                .scaleEffect(animationTrigger ? 1.1 : 1.0)
        }
        .padding()
        .frame(width: 140, height: 100)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}
