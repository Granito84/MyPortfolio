//
//  ProjectsView.swift
//  MyPortfolio
//
//  Created by Graham Reynolds on 25/10/20.
//

import SwiftUI

struct ProjectsView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var showingSortOrder = false
    @State private var sortOrder = Item.SortOrder.optimized
    
    let showClosedProjects: Bool
    let projects: FetchRequest<Project>
    
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"
    
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        
        projects = FetchRequest<Project>(entity: Project.entity(),
                                         sortDescriptors: [ NSSortDescriptor(keyPath: \Project.creationDate, ascending: true) ],
                                         predicate: NSPredicate(format: "closed = %d", showClosedProjects))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(projects.wrappedValue) { project in
                    Section(header: ProjectHeaderView(project: project)) {
                        ForEach(project.projectItems(using: sortOrder)) { item in
                            ItemRowView(item: item)
                        }
                        .onDelete { offsets in
                            let allItems = project.projectItems(using: sortOrder)
                            for offset in offsets {
                                let item = allItems[offset]
                                dataController.delete(item)
                            }
                            dataController.save()
                        }
                        if !showClosedProjects {
                            // New Item button
                            Button {
                                withAnimation {
                                    let item = Item(context: managedObjectContext)
                                    item.project = project
                                    item.creationDate = Date()
                                    dataController.save()
                                }
                            } label: {
                                Label("Add New Item", systemImage: "plus")
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !showClosedProjects {
                        // New Project button
                        Button {
                            withAnimation {
                                let project = Project(context: managedObjectContext)
                                project.closed = false
                                project.creationDate = Date()
                                dataController.save()
                            }
                        } label: {
                            Label("Add Project", systemImage: "plus")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button(action: { sortOrder = .optimized}, label: {
                            Label("Optimized", systemImage: "list.bullet.indent")
                        })
                        Button(action: { sortOrder = .creationDate}, label: {
                            Label("Creation Date", systemImage: "calendar")
                        })
                        Button(action: { sortOrder = .title}, label: {
                            Label("Title", systemImage: "textformat")
                        })
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
        }
    }
}


// MARK: - Previews

struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ProjectsView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .preferredColorScheme(.dark)
    }
}
