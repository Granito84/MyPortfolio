//
//  ItemRowView.swift
//  MyPortfolio
//
//  Created by Graham Reynolds on 27/10/20.
//

import SwiftUI

struct ItemRowView: View {
    @ObservedObject var project: Project
    @ObservedObject var item: Item
    
    @ViewBuilder var icon: some View {
        if item.completed {
            Image(systemName: "checkmark.circle")
                .foregroundColor(project.projectColor)
        } else if item.priority == 3 {
            Image(systemName: "exclamationmark.triangle")
                .foregroundColor(project.projectColor)
        } else {
            Image(systemName: "checkmark.circle")
                .foregroundColor(.clear)
        }
    }
    
    var body: some View {
        NavigationLink(destination: EditItemView(item: item)) {
            Label {
                Text(item.itemTitle)
            } icon: {
                icon
            }
        }
    }
}


// MARK: - Previews

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ItemRowView(project: Project.example, item: Item.example)
            }
        }
        .preferredColorScheme(.dark)
    }
}
