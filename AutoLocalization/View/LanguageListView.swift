//
//  LanguageListView.swift
//  AutoLocalization
//
//  Created by Kyrylo Derkach on 01.12.2023.
//

import SwiftUI
import MLKitTranslate
import UIKit

public struct LanguageListView: View {
    
    let localizationOptions: LocalizationOptions
    @State private var chosenLanguage: TranslateLanguage = .english
    @State private var hasChosenLanguage: Bool = false
    private var onLanguageChosenAction: ((TranslateLanguage) -> Void)?
    
    public init(options: LocalizationOptions, onLanguageChosenAction: ((TranslateLanguage) -> Void)? = nil) {
        self.localizationOptions = options
        self.onLanguageChosenAction = onLanguageChosenAction
    }
    
    
    public var body: some View {
        List {
            ForEach(TranslateLanguage.allLanguages().sorted(by: { $0.name < $1.name }), id: \.self) { language in
                LanguageCellView(language: language, downloadProgress: DownloadProgressObservable(language: language), listChosenLanguage: $chosenLanguage, listHasChosenLanguage: $hasChosenLanguage, localizationOptions: localizationOptions)
            }
        }
        .onChange(of: hasChosenLanguage) { newValue in
            if newValue, let action = onLanguageChosenAction {
                action(chosenLanguage)
            }
        }
    }
}
