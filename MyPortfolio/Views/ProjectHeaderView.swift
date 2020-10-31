//
//  ProjectHeaderView.swift
//  MyPortfolio
//
//  Created by Graham Reynolds on 30/10/20.
//

import SwiftUI


struct ProjectHeaderView: View {
    @ObservedObject var project: Project

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(project.projectTitle)
                    .font(.headline)
                Text("\(DateFormatter.localizedString(from: project.projectCreationDate, dateStyle: .medium, timeStyle: .short))")
                    .font(.caption2)
                ProgressView(value: project.completionAmount)
                    .accentColor(project.projectColor)
            }
            NavigationLink(destination: EditProjectView(project: project)) {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
            }
            Spacer()
            RoundedRectangle(cornerRadius: 6).fill(project.projectColor).frame(width: 18, height: 18)
                .padding(.trailing, 20)
        }
        .padding(.bottom, 10)
    }
}



struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectHeaderView(project: Project.example)
    }
}
