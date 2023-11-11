//
//  WordList.swift
//  WordScramble
//
//  Created by Nowroz Islam on 13/8/23.
//

import Foundation

struct WordList {
    var words: [String]
    
    func getWord() -> String {
        words.randomElement()!
    }
    
    init() {
        guard let url = Bundle.main.url(forResource: "start", withExtension: "txt") else {
            fatalError("Failed to locate start.txt in bundle")
        }
        
        guard let content = try? String(contentsOf: url) else {
            fatalError("Failed to load start.txt from bundle")
        }
        
        words = content.components(separatedBy: "\n")
    }
}
