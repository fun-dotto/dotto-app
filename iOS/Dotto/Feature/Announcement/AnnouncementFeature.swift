//
//  AnnouncementFeature.swift
//  Dotto
//
//  Created by Kanta Oikawa on 2026/04/12.
//

import ComposableArchitecture
import DottoModel

@Reducer
struct AnnouncementFeature {
    @ObservableState
    struct State: Equatable {
        var announcements: [Announcement] = []
        var isLoading: Bool = false
    }

    enum Action {
        case onAppear
        case onRefresh
        case getAnnouncementsResult(Result<[Announcement], Error>)
    }

    @Dependency(\.announcementClient) var announcementClient

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    await send(
                        .getAnnouncementsResult(
                            Result {
                                try await announcementClient.getAnnouncements()
                            }
                        )
                    )
                }

            case .onRefresh:
                return .run { send in
                    await send(
                        .getAnnouncementsResult(
                            Result {
                                try await announcementClient.getAnnouncements()
                            }
                        )
                    )
                }

            case .getAnnouncementsResult(.success(let announcements)):
                state.announcements = announcements
                state.isLoading = false
                return .none

            case .getAnnouncementsResult(.failure):
                state.isLoading = false
                return .none
            }
        }
    }
}
