//
//  ItemRowView.swift
//  MyPortfolio
//
//  Created by Graham Reynolds on 27/10/20.
//

import SwiftUI

struct ItemRowView: View {
    @ObservedObject var item: Item
    
    var body: some View {
        NavigationLink(destination: EditItemView(item: item)) {
            ItemView(title: item.itemTitle, priority: item.priority, completed: item.completed)
        }
    }
}


struct ItemView: View {
    let title: String
    let priority: Int16
    let completed: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                Text("priority: \(priority)").font(.caption2).foregroundColor(.secondary)
            }
            Spacer()
            Group {
                if completed {
                    Image(systemName: "checkmark.circle")
                } else {
                    Image(systemName: "circle")
                }
            }
            .font(.subheadline)
            .foregroundColor(Color("Light Blue"))
        }
    }
}


struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(item: Item.example)
    }
}
