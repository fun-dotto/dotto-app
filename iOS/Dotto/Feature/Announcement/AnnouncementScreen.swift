//
//  AnnouncementScreen.swift
//  Dotto
//
//  Created by Kanta Oikawa on 2026/04/12.
//

import ComposableArchitecture
import DottoModel
import SwiftUI

struct AnnouncementScreen: View {
    private let store: StoreOf<AnnouncementFeature>
    @State private var selectedAnnouncement: Announcement?

    init(
        store: StoreOf<AnnouncementFeature>
    ) {
        self.store = store
    }

    var body: some View {
        List(store.announcements) { announcement in
            Button {
                selectedAnnouncement = announcement
            } label: {
                AnnouncementRow(announcement: announcement)
            }
            .foregroundStyle(.primary)
        }
        .overlay {
            if store.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            } else if store.announcements.isEmpty {
                ContentUnavailableView(
                    "No Announcements",
                    systemImage: "bell.slash"
                )
                .listRowSeparator(.hidden)
            }
        }
        .navigationTitle("Announcements")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedAnnouncement) { announcement in
            SafariView(url: announcement.url)
                .ignoresSafeArea()
        }
        .refreshable {
            await store.send(.onRefresh).finish()
        }
        .task {
            await store.send(.onAppear).finish()
        }
    }
}

#Preview {
    NavigationStack {
        AnnouncementScreen(
            store: Store(initialState: .init()) {
                AnnouncementFeature()
            }
        )
    }
}
