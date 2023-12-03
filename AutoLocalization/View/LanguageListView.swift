//
//  LanguageListView.swift
//  AutoLocalization
//
//  Created by Kyrylo Derkach on 01.12.2023.
//

import SwiftUI
import MLKitTranslate

public struct LanguageListView: View {
    public init() {
        
    }
    
    public var body: some View {
        List {
            ForEach(TranslateLanguage.allLanguages().sorted(by: { $0.name < $1.name }), id: \.self) { language in
                LanguageCellView(language: language, downloadProgress: DownloadProgressObservable(language: language))
            }
        }
    }
}

#Preview {
    LanguageListView()
}
