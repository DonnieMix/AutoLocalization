//
//  DetailedTranslator.swift
//  AutoLocalization
//
//  Created by Kyrylo Derkach on 30.11.2023.
//

import Foundation
import MLKitTranslate

class DetailedTranslator {
    let translator: Translator
    let sourceLanguage: TranslateLanguage
    let targetLanguage: TranslateLanguage
    
    init(sourceLanguage: TranslateLanguage, targetLanguage: TranslateLanguage) {
        self.sourceLanguage = sourceLanguage
        self.targetLanguage = targetLanguage
        
        let options = TranslatorOptions(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage)
        self.translator = Translator.translator(options: options)
    }
    
    func translate(_ text: String, completion: @escaping TranslatorCallback) {
        translator.translate(text, completion: completion)
    }
}
