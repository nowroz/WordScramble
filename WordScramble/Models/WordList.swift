//
//  WordList.swift
//  WordScramble
//
//  Created by Nowroz Islam on 13/8/23.
//

import Foundation

final class WordList {
    var words: [String]
    
    var randomWord: String {
        words.randomElement()!
    }
    
    private init() {
        guard let url = Bundle.main.url(forResource: "start", withExtension: "txt") else {
            fatalError("Failed to locate start.txt in bundle.")
        }
        
        guard let content = try? String(contentsOf: url) else {
            fatalError("Failed to load start.txt from bundle.")
        }
        
        words = content.components(separatedBy: "\n")
    }
    
    static let shared: WordList = WordList()
}
