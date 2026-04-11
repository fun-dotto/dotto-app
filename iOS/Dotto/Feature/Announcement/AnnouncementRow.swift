//
//  AnnouncementRow.swift
//  Dotto
//
//  Created by Kanta Oikawa on 2026/04/12.
//

import DottoModel
import SwiftUI

struct AnnouncementRow: View {
    let announcement: Announcement

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(announcement.title)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                Text(announcement.date, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    List {
        AnnouncementRow(
            announcement: Announcement(
                id: "1",
                title: "2026年度前期の履修登録について",
                date: Date(),
                url: URL(string: "https://example.com")!
            )
        )
    }
}
