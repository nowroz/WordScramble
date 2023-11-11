//
//  ContentView.swift
//  WordScramble
//
//  Created by Nowroz Islam on 12/8/23.
//

import SwiftUI

struct ContentView: View {
    @Bindable var data: GameData = .init()
    
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showingAlert: Bool = false
    
    var rootWordView: some View {
        LabeledContent {
            Text(data.rootWord)
                .font(.headline)
                .foregroundStyle(.black)
        } label: {
            Text("Root Word")
                .foregroundStyle(.gray)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    Section {
                        rootWordView
                            .listRowBackground(Color.yellow)
                    }
                    
                    Section {
                        TextField("Enter Word", text: $data.newWord)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                    
                    Section("Entered Words") {
                        ForEach(data.usedWords, id: \.self) { word in
                            LabeledContent(word) {
                                Text("+\(word.count) points")
                            }
                        }
                    }
                }
                
                ScoreView(score: data.score)
                    .ignoresSafeArea(.keyboard)
            }
            .navigationTitle("WordScramble")
            .onSubmit(addWord)
            .alert(alertTitle, isPresented: $showingAlert) {
                
            } message: {
                Text(alertMessage)
            }
            .toolbar {
                Button("Restart") {
                    restart()
                }
            }
        }
    }
    
    func addWord() {
        let word = data.newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isValid(word) {
            withAnimation {
                data.usedWords.insert(word, at: 0)
                data.newWord = ""
                data.score += word.count
            }
        }
        
    }
    
    func restart() {
        withAnimation {
            data.rootWord = GameData.wordList.getWord()
            data.score = 0
            data.newWord = ""
            data.usedWords = []
        }
    }
    
    func isValid(_ word: String) -> Bool {
        guard word.isEmpty == false else {
            return false
        }
        
        guard word != data.rootWord else {
            displayAlert(title: "Not Allowed", message: "Cannot use the root word.")
            return false
        }
        
        guard word.count >= 3 else {
            displayAlert(title: "Too Short", message: "The word must contain at least 3 letters.")
            return false
        }
        
        guard isPossible(word) else {
            displayAlert(title: "Not Possible", message: "'\(word)' cannot be formed from '\(data.rootWord)'.")
            return false
        }
        
        guard isOriginal(word) else {
            displayAlert(title: "Already Used", message: "'\(word)' is already used.")
            return false
        }
        
        guard isReal(word) else {
            displayAlert(title: "Not Real", message: "'\(word)' is not a real word.")
            return false
        }
        
        return true
    }
    
    func displayAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
    
    func isPossible(_ word: String) -> Bool {
        var temp = data.rootWord
        
        for letter in word {
            if let index = temp.firstIndex(of: letter) {
                temp.remove(at: index)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(_ word: String) -> Bool {
        data.usedWords.contains(word) == false
    }
    
    func isReal(_ word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let mispelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return mispelledRange.location == NSNotFound
    }
}

#Preview {
    ContentView()
}
