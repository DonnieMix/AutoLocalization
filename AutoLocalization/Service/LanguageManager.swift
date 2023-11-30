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
    
    public func downloadLanguage(_ language: TranslateLanguage) {
        let languageModel = TranslateRemoteModel.translateRemoteModel(language: language)
        
        modelManager.download(
            languageModel,
            conditions: ModelDownloadConditions(
                allowsCellularAccess: false,
                allowsBackgroundDownloading: true
            )
        )
    }
    
}
