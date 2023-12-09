//
//  BlueNavigationLink.swift
//  TabsAndTrails
//
//  Created by Vaibhav Rajani on 12/9/23.
//

import Foundation
import SwiftUI

struct BlueNavigationLink<Label, Destination>: View where Label: View, Destination: View {
    var destination: Destination
    var label: () -> Label

    init(destination: Destination, @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.label = label
    }

    var body: some View {
        ZStack {
            NavigationLink(destination: destination) {
                EmptyView()
            }
            .opacity(0)

            label()
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(8)
        }
    }
}

