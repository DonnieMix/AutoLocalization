//
//  DownloadProgressObservable.swift
//  AutoLocalization
//
//  Created by Kyrylo Derkach on 03.12.2023.
//

import Foundation
import SwiftUI
import MLKitTranslate

class DownloadProgressObservable: NSObject, ObservableObject {
    
    init(language: TranslateLanguage) {
        self.language = language
        self.isCompleted = LanguageManager.shared.isLanguageDownloaded(language)
    }
    
    @objc var progress: Progress = Progress() {
        didSet {
            completionObservation = observe(\.progress.isFinished, options: [.new]) { [weak self] _, change in
                guard let newValue = change.newValue else { return }
                self?.objectWillChange.send()
                if self?.toDelete == true, let language = self?.language {
                    self?.isCompleted = false
                    LanguageManager.shared.deleteLanguage(language)
                    self?.toDelete = false
                    return
                }
                self?.isCompleted = newValue
            }
        }
    }
    
    private var completionObservation: NSKeyValueObservation?
    @Published var isCompleted: Bool
    private var toDelete: Bool = false
    private let language: TranslateLanguage
    
    func scheduleInstantDeletion() {
        toDelete = true
    }
}
