//
//  ContentView.swift
//  WordScramble
//
//  Created by Nowroz Islam on 12/8/23.
//

import SwiftUI

struct ContentView: View {
    @State private var rootWord: String = WordList.shared.randomWord
    
    @State private var inputWord: String = ""
    @State private var words: [String] = []
    
    @State private var score: Int = 0
    
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showingAlert: Bool = false
    
    var rootWordView: some View {
        LabeledContent {
            Text(rootWord)
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
                        TextField("Enter Word", text: $inputWord)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                    
                    Section("Entered Words") {
                        ForEach(words, id: \.self) { word in
                            LabeledContent(word) {
                                Text("+\(word.count) points")
                            }
                        }
                    }
                }
                
                ScoreView(score: score)
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
        let word = inputWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isValid(word) {
            withAnimation {
                words.insert(word, at: 0)
                inputWord = ""
                score += word.count
            }
        }
        
    }
    
    func restart() {
        withAnimation {
            rootWord = WordList.shared.randomWord
            score = 0
            inputWord = ""
            words = []
        }
    }
    
    func isValid(_ word: String) -> Bool {
        guard word.isEmpty == false else {
            return false
        }
        
        guard word != rootWord else {
            displayAlert(title: "Not Allowed", message: "Cannot use the root word.")
            return false
        }
        
        guard word.count >= 3 else {
            displayAlert(title: "Too Short", message: "The word must contain at least 3 letters.")
            return false
        }
        
        guard isPossible(word) else {
            displayAlert(title: "Not Possible", message: "'\(word)' cannot be formed from '\(rootWord)'.")
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
        var temp = rootWord
        
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
        words.contains(word) == false
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
