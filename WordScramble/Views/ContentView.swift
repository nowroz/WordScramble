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
            .alert(alertTitle, isPresented: $showingAlert) { } message: {
                Text(alertMessage)
            }
            .toolbar {
                Button("Restart") {
                    withAnimation {
                        data.restart()
                    }
                }
            }
        }
    }
    
    func addWord() {
        do {
            if try data.isValid() {
                withAnimation {
                    data.update()
                }
            }
        } catch ValidationError.emptyString {
            // do nothing
        } catch ValidationError.notAllowed {
            displayAlert(title: "Not Allowed", message: "You cannot use the root word.")
        } catch ValidationError.tooShort {
            displayAlert(title: "Too Short", message: "The word must contain at least 3 letters.")
        } catch ValidationError.notPossible {
            displayAlert(title: "Not Possible", message: "'\(data.trimmedNewWord)' cannot be created from '\(data.rootWord)'.")
        } catch ValidationError.notOriginal {
            displayAlert(title: "Not Original", message: "'\(data.trimmedNewWord)' is already used.")
        } catch ValidationError.notReal {
            displayAlert(title: "Not Real", message: "'\(data.trimmedNewWord)' is not a real word.")
        } catch {
            
        }
        
    }
    
    func displayAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}

#Preview {
    ContentView()
}
