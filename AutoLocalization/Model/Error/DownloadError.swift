//
//  DownloadError.swift
//  AutoLocalization
//
//  Created by Kyrylo Derkach on 30.11.2023.
//

import Foundation
import MLKitTranslate

struct DownloadError: Error {
    let localizedDescription: String
    var absentLanguages: [TranslateLanguage] = []
    
    init(_ localizedDescription: String) {
        self.localizedDescription = "Download Error: \(localizedDescription)"
    }
    
    mutating func put(absentLanguage: TranslateLanguage) {
        absentLanguages.append(absentLanguage)
    }
}
