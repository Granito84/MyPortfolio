//
//  SelectSomethingView.swift
//  MyPortfolio
//
//  Created by Graham Reynolds on 12/11/20.
//

import SwiftUI

struct SelectSomethingView: View {
    var body: some View {
        Text("Please select something from the menu to begin")
            .italic()
            .foregroundColor(.secondary)
    }
}

// MARK: - previews

struct SelectSomethingView_Previews: PreviewProvider {
    static var previews: some View {
        SelectSomethingView()
    }
}
