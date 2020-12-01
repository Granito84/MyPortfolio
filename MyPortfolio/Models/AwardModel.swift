//
//  AwardModel.swift
//  MyPortfolio
//
//  Created by Graham Reynolds on 14/11/20.
//

import Foundation


struct Award: Decodable, Identifiable {
    let name: String
    let description: String
    let color: String
    let criterion: String
    let value: Int
    let image: String
    
    var id: String { name }
    
    static let allAwards = Bundle.main.decode([Award].self, from: "Awards.json")
    static let example = allAwards[0]
}
