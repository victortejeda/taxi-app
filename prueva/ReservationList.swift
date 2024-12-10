//
//  ReservationList.swift
//  prueva
//
//  Created by Victor Tejeda on 8/12/24.
//

import SwiftUI
import AVKit

struct Reservation: Identifiable {
    let id = UUID()
    var number: Int
    var name: String
    var phone: String
    var status: String
    var stars: Int
    var comment: String
    var bannerImage: String?
}

struct ReservationListView: View {
    @State private var reservations: [Reservation] = [
        Reservation(number: 1, name: "John Doe", phone: "123-456-7890", status: "Active", stars: 4, comment: "Great customer"),
        Reservation(number: 2, name: "Jane Smith", phone: "098-765-4321", status: "Pending", stars: 3, comment: ""),
        Reservation(number: 3, name: "Alice Johnson", phone: "555-555-5555", status: "Completed", stars: 5, comment: "Excellent experience")
    ]
    @State private var showingAddReservation = false
    @State private var showingVideoBanner = false

    var body: some View {
        NavigationView {
            List {
                ForEach(reservations) { reservation in
                    ReservationRow(reservation: binding(for: reservation))
                }
                .onDelete(perform: deleteReservation)
            }
            .navigationTitle("Reservations")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddReservation = true }) {
                        Label("Add Reservation", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingVideoBanner = true }) {
                        Label("Video Banner", systemImage: "video")
                    }
                }
            }
            .sheet(isPresented: $showingAddReservation) {
                AddReservationView(reservations: $reservations)
            }
            .sheet(isPresented: $showingVideoBanner) {
                VideoBannerView()
            }
        }
    }

    private func binding(for reservation: Reservation) -> Binding<Reservation> {
        guard let index = reservations.firstIndex(where: { $0.id == reservation.id }) else {
            fatalError("Reservation not found")
        }
        return $reservations[index]
    }

    private func deleteReservation(at offsets: IndexSet) {
        reservations.remove(atOffsets: offsets)
    }
}

struct ReservationRow: View {
    @Binding var reservation: Reservation
    @State private var showingEditView = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Reservation #\(reservation.number)")
                    .font(.headline)
                Spacer()
                Text(reservation.status)
                    .foregroundColor(statusColor(for: reservation.status))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor(for: reservation.status).opacity(0.2))
                    .cornerRadius(8)
            }

            Text(reservation.name)
                .font(.subheadline)
            Text(reservation.phone)
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= reservation.stars ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .onTapGesture {
                            reservation.stars = index
                        }
                }
            }

            if !reservation.comment.isEmpty {
                Text("Comment: \(reservation.comment)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if let bannerImage = reservation.bannerImage {
                Image(bannerImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .cornerRadius(8)
            }

            Button("Edit") {
                showingEditView = true
            }
            .padding(.top, 4)
        }
        .padding(.vertical, 8)
        .sheet(isPresented: $showingEditView) {
            EditReservationView(reservation: $reservation)
        }
    }

    private func statusColor(for status: String) -> Color {
        switch status {
        case "Active":
            return .green
        case "Pending":
            return .orange
        case "Completed":
            return .blue
        default:
            return .gray
        }
    }
}

struct AddReservationView: View {
    @Binding var reservations: [Reservation]
    @State private var name = ""
    @State private var phone = ""
    @State private var status = "Pending"
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Phone", text: $phone)
                Picker("Status", selection: $status) {
                    Text("Active").tag("Active")
                    Text("Pending").tag("Pending")
                    Text("Completed").tag("Completed")
                }
            }
            .navigationTitle("Add Reservation")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newReservation = Reservation(number: reservations.count + 1, name: name, phone: phone, status: status, stars: 0, comment: "")
                        reservations.append(newReservation)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct EditReservationView: View {
    @Binding var reservation: Reservation
    @State private var comment: String
    @State private var bannerImage: String?
    @Environment(\.presentationMode) var presentationMode

    init(reservation: Binding<Reservation>) {
        self._reservation = reservation
        self._comment = State(initialValue: reservation.wrappedValue.comment)
        self._bannerImage = State(initialValue: reservation.wrappedValue.bannerImage)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $reservation.name)
                TextField("Phone", text: $reservation.phone)
                Picker("Status", selection: $reservation.status) {
                    Text("Active").tag("Active")
                    Text("Pending").tag("Pending")
                    Text("Completed").tag("Completed")
                }
                TextField("Comment", text: $comment)
                Picker("Banner Image", selection: $bannerImage) {
                    Text("None").tag(nil as String?)
                    Text("Banner 1").tag("banner1" as String?)
                    Text("Banner 2").tag("banner2" as String?)
                    Text("Banner 3").tag("banner3" as String?)
                }
            }
            .navigationTitle("Edit Reservation")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        reservation.comment = comment
                        reservation.bannerImage = bannerImage
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct VideoBannerView: View {
    @State private var selectedVideo: String?
    let videos = ["video1", "video2", "video3"]

    var body: some View {
        NavigationView {
            VStack {
                if let video = selectedVideo {
                    VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource: video, withExtension: "mp4")!))
                        .frame(height: 300)
                } else {
                    Text("Select a video")
                        .frame(height: 300)
                }

                List(videos, id: \.self) { video in
                    Button(video) {
                        selectedVideo = video
                    }
                }
            }
            .navigationTitle("Video Banners")
        }
    }
}

struct ReservationListView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationListView()
    }
}
