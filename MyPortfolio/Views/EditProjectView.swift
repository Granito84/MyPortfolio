//
//  EditProjectView.swift
//  MyPortfolio
//
//  Created by Graham Reynolds on 30/10/20.
//

import SwiftUI

struct EditProjectView: View {
    let project: Project
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm = false
    @State private var hasChanges = false
    
    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]
    
    init(project: Project) {
        self.project = project
        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.color ?? "Light Blue")
    }
    
    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Project name", text: $title.onChange { hasChanges = true })
                TextField("Description of project", text: $detail.onChange { hasChanges = true })
            }
            
            Section(header: Text("Custom project color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self) { item in
                        ZStack {
                            Color(item)
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(6)
                            if item == color {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                            }
                        }
                        .onTapGesture {
                            color = item
                            hasChanges = true
                        }
                    }
                }
                .padding(.vertical)
            }
            
            Section(footer: Text("Closing a project moves it from Open to Closed tab; deleting it removes the project entirely")) {
                Button(project.closed ? "Reopen this project" : "Close this project") {
                    project.closed.toggle()
                    update()
                }
                Button("Delete this project") {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }

            Section(footer: Text("Press save to keep the changes; otherwise go back to discard the changes")) {
                Button("Save") {
                    update()
                }
                .padding(.vertical, 10)
                .wideButtonStyle(color: hasChanges ? Color(.systemOrange) : .gray)
                .disabled(!hasChanges)
            }
        }
        .navigationTitle("Edit Project")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(title: Text("Delete project?"),
                  message: Text("Are you sure you want to delete this project?"),
                  primaryButton: .default(Text("Delete"), action: delete),
                  secondaryButton: .cancel())
        }
    }
    
    func update() {
        project.title = title
        project.detail = detail
        project.color = color
    }
    
    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }
}


// MARK: - previews
struct EditProjectView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        EditProjectView(project: Project.example)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .preferredColorScheme(.dark)
    }
}
