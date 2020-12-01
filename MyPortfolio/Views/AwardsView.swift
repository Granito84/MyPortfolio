//
//  AwardsView.swift
//  MyPortfolio
//
//  Created by Graham Reynolds on 14/11/20.
//

import SwiftUI

struct AwardsView: View {
    @EnvironmentObject private var dataController: DataController
    
    static let tag: String? = "Awards"
    
    @State private var selectedAward = Award.example
    @State private var showAwardDetails = false
    
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            selectedAward = award
                            showAwardDetails = true
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(
                                    dataController.hasEarned(award: award)
                                        ? Color(award.color)
                                        : Color.secondary.opacity(0.5))
                        }
                    }
                }
            }
            .navigationTitle("Awards")
            .alert(isPresented: $showAwardDetails) {
                if dataController.hasEarned(award: selectedAward) {
                    return Alert(title: Text("Unlocked: \(selectedAward.name)"), message: Text("\(selectedAward.description)"), dismissButton: .default(Text("OK")))
                } else {
                    return Alert(title: Text("Locked: \(selectedAward.name)"), message: Text("\(selectedAward.description)"), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}

// MARK: - previews

struct AwardsView_Previews: PreviewProvider {
    static let dataController = DataController.preview
    
    static var previews: some View {
        AwardsView()
            .environmentObject(dataController)
    }
}
