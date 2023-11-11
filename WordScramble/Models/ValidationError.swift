//
//  ValidationError.swift
//  WordScramble
//
//  Created by Nowroz Islam on 11/11/23.
//

import Foundation

enum ValidationError: Error {
    case emptyString
    case notAllowed
    case tooShort
    case notPossible
    case notOriginal
    case notReal
}
