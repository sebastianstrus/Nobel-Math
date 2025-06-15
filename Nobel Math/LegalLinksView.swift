//
//  LegalLinksView.swift
//  Nobel Math
//
//  Created by Sebastian Strus on 6/15/25.
//

import SwiftUI

struct LegalLinksView: View {
    let termsURL = URL(string: "https://sebastianstrus.com/documents/nobel-math/privacy-policy.html")!
    let privacyURL = URL(string: "https://sebastianstrus.com/documents/nobel-math/terms-of-use.html")!

    var body: some View {
        HStack(spacing: 24) {
            Link("Terms of Use", destination: termsURL)
            Link("Privacy Policy", destination: privacyURL)
        }
        .font(.footnote)
        .foregroundColor(.white.opacity(0.8))
        .padding(.top, 8)
        .padding(.bottom, 20)
    }
}
