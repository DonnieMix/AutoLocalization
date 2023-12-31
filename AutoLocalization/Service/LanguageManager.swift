//
//  LanguageManager.swift
//  AutoLocalization
//
//  Created by Kyrylo Derkach on 30.11.2023.
//

import Foundation
import MLKitTranslate

class LanguageManager {
    
    // MARK: - Singleton
    static let shared: LanguageManager = LanguageManager()
    private init() {}
    
    // MARK: - Private
    private let autoLocalization = AutoLocalization.shared
    
    private let modelManager = ModelManager.modelManager()
    
    private var localModels: Set<TranslateRemoteModel> {
        get { ModelManager.modelManager().downloadedTranslateModels }
    }
    
    // MARK: - Public
    public func isLanguageDownloaded(_ language: TranslateLanguage) -> Bool {
        for localModel in localModels {
            if localModel.language == language {
                return true
            }
        }
        return false
    }
    
    @discardableResult
    public func downloadLanguage(_ language: TranslateLanguage) -> Progress {
        let languageModel = TranslateRemoteModel.translateRemoteModel(language: language)
        print("Downloading \(language.name)")
        NotificationCenter.default.addObserver(forName: .mlkitModelDownloadDidSucceed, object: autoLocalization, queue: nil, using: autoLocalization.handleDownloadLanguageSuccess(_:))
        NotificationCenter.default.addObserver(forName: .mlkitModelDownloadDidFail, object: autoLocalization, queue: nil, using: autoLocalization.handleDownloadLanguageFailed(_:))
        let progress = modelManager.download(
            languageModel,
            conditions: ModelDownloadConditions(
                allowsCellularAccess: false,
                allowsBackgroundDownloading: true
            )
        )
        
        return progress
    }
    
    public func deleteLanguage(_ language: TranslateLanguage) {
        let languageModel = TranslateRemoteModel.translateRemoteModel(language: language)
        modelManager.deleteDownloadedModel(languageModel) { error in
            guard error == nil else { return }
        }
    }
    
}
