//
//  HomeView.swift
//  MyPortfolio
//
//  Created by Graham Reynolds on 25/10/20.
//

import SwiftUI
import CoreData


struct HomeView: View {
    @EnvironmentObject var dataController: DataController
    static let tag: String? = "Home"
    
    @FetchRequest(entity: Project.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)], predicate: NSPredicate(format: "closed = false"))
    var projects: FetchedResults<Project>
    
    let items: FetchRequest<Item>
    
    private var projectRows: [GridItem] { [GridItem(.fixed(100))] }
    
    init() {
        let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()
        itemRequest.predicate = NSPredicate(format: "completed = false")
        itemRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.priority, ascending: false) ]
        itemRequest.fetchLimit = 10
        items = FetchRequest(fetchRequest: itemRequest)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(projects) { project in
                                VStack(alignment: .leading) {
                                    Text("\(project.projectItems.count) items")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(project.projectTitle)
                                        .font(.title2)
                                    ProgressView(value: project.completionAmount)
                                        .accentColor(project.projectColor)
                                }
                                .padding()
                                .background(
                                    Color.secondarySystemGroupedBackground.opacity(0.4)
                                        .cornerRadius(10)
                                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
                                )
                            }
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                        list("Up next", for: items.wrappedValue.prefix(3))
                        list("More to explore", for: items.wrappedValue.dropFirst(3))
                    })
                    .padding(.horizontal)
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
        }
    }
    
    @ViewBuilder private func list(_ title: LocalizedStringKey, for items: FetchedResults<Item>.SubSequence) -> some View {
        if items.isEmpty {
            EmptyView()
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)
            
            ForEach(items) { item in
                NavigationLink(destination: EditItemView(item: item)) {
                    HStack(spacing: 20) {
                        Circle()
                            .stroke(item.project?.projectColor ?? Color("Light Blue"))
                            .frame(width: 44, height: 44)
                        VStack(alignment: .leading) {
                            Text(item.itemTitle)
                                .font(.title2)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if item.itemDetail.isEmpty == false {
                                Text(item.itemDetail)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(
                        Color.secondarySystemGroupedBackground
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
                    )
                }
            }
        }
    }
}


// MARK: - Previews

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(DataController.preview)
    }
}
