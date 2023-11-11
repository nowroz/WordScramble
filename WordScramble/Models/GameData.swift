//
//  GameData.swift
//  WordScramble
//
//  Created by Nowroz Islam on 11/11/23.
//

import Foundation

@Observable
final class GameData {
    static let wordList: WordList = .init()
    
    var rootWord: String
    var newWord: String
    var usedWords: [String]
    var score: Int
    
    init() {
        rootWord = GameData.wordList.getWord()
        newWord = ""
        usedWords = []
        score = 0
    }
}
