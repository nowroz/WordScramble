//
//  ScoreView.swift
//  WordScramble
//
//  Created by Nowroz Islam on 13/8/23.
//

import SwiftUI

struct ScoreView: View {
    var score: Int
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                Text("Score")
                    .font(.subheadline)
                    .foregroundStyle(.black)
                
                Text(score, format: .number)
                    .font(.headline)
                    .foregroundStyle(.black)
                    
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

#Preview {
    ScoreView(score: 0)
}
