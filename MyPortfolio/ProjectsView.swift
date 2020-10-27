//
//  ProjectsView.swift
//  MyPortfolio
//
//  Created by Graham Reynolds on 25/10/20.
//

import SwiftUI

struct ProjectsView: View {
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
                    Section(header: ProjectHeaderView(title: project.projectTitle, date: project.projectCreationDate, color: project.projectColor)) {
                        ForEach(project.projectItems) { item in
                            ItemView(title: item.itemTitle, priority: item.priority, completed: item.completed)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
        }
    }
}


struct ProjectHeaderView: View {
    let title: String
    let date: Date
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                Text("\(DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short))")
                    .font(.caption2)
            }
            Spacer()
            RoundedRectangle(cornerRadius: 6).fill(color).frame(width: 18, height: 18)
                .padding(.trailing, 20)
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


struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ProjectsView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
