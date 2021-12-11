//
//  UserChemiView.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import AutoVliveApi
import SwiftUI

struct UserChemiView: View {
    let chemi: ChemiStatus

    var body: some View {
        VStack {
            Text("Level: \(chemi.level)")
            Text("Detail level: \(chemi.detailedLevel)")
            Text("Rank: \(chemi.ranking)")
        }
        .padding()
    }
}

struct UserChemiView_Previews: PreviewProvider {
    static var previews: some View {
        UserChemiView(chemi: ChemiStatus(level: 0, detailedLevel: 0, ranking: 0))
    }
}
