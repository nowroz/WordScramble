//
//  GameData.swift
//  WordScramble
//
//  Created by Nowroz Islam on 11/11/23.
//

import Foundation
import UIKit

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

extension GameData {
    func update() {
        usedWords.insert(trimmedNewWord, at: 0)
        score += trimmedNewWord.count
        newWord = ""
    }
    
    func restart() {
        rootWord = GameData.wordList.getWord()
        score = 0
        newWord = ""
        usedWords = []
    }
}

extension GameData {
    var trimmedNewWord: String {
        newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func isValid() throws -> Bool {
        guard trimmedNewWord.isEmpty == false else {
            throw ValidationError.emptyString
        }
        
        guard trimmedNewWord != rootWord else {
            throw ValidationError.notAllowed
        }
        
        guard trimmedNewWord.count >= 3 else {
            throw ValidationError.tooShort
        }
        
        guard isPossible() else {
            throw ValidationError.notPossible
        }
        
        guard isOriginal() else {
            throw ValidationError.notOriginal
        }
        
        guard isReal() else {
            throw ValidationError.notReal
        }
        
        return true
    }
    
    func isPossible() -> Bool {
        var tempWord = rootWord
        
        for letter in newWord {
            if let index = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: index)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal() -> Bool {
        usedWords.contains(trimmedNewWord) == false
    }
    
    func isReal() -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: trimmedNewWord.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: trimmedNewWord, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
}
