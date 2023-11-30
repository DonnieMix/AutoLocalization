//
//  DownloadError.swift
//  AutoLocalization
//
//  Created by Kyrylo Derkach on 30.11.2023.
//

import Foundation

struct DownloadError: Error {
    let localizedDescription: String
    
    init(_ localizedDescription: String) {
        self.localizedDescription = "Download Error: \(localizedDescription)"
    }
}
