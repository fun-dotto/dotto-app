//
//  UserView.swift
//  Dotto
//
//  Created by Kanta Oikawa on 2026/04/11.
//

import DottoModel
import SwiftUI

struct UserView: View {
    let user: DottoUser

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(user.name)
                    .bold()
                Text(user.email)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    UserView(
        user: DottoUser(
            id: "",
            name: "Dotto User",
            email: "dotto@fun.ac.jp",
            avatarURL: nil
        )
    )
}
