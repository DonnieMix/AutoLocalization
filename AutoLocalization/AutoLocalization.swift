//
//  AutoLocalization.swift
//  AutoLocalization
//
//  Created by Kyrylo Derkach on 29.11.2023.
//

import Foundation
import MLKitTranslate
import UIKit

public class AutoLocalization {
    
    // MARK: - Private
    private static var translators: [DetailedTranslator] = []
    
    private static func existingTranslator(sourceLanguage: TranslateLanguage, targetLanguage: TranslateLanguage) -> Bool {
        guard LanguageManager.shared.isLanguageDownloaded(sourceLanguage) &&
                LanguageManager.shared.isLanguageDownloaded(targetLanguage) else {
            return false
        }
        
        for translator in translators {
            if translator.sourceLanguage == sourceLanguage &&
                translator.targetLanguage == targetLanguage {
                return true
            }
        }
        return false
    }
    
    private static func translatorForLanguages(sourceLanguage: TranslateLanguage, targetLanguage: TranslateLanguage) -> DetailedTranslator {
        for translator in translators {
            if translator.sourceLanguage == sourceLanguage &&
                translator.targetLanguage == targetLanguage {
                return translator
            }
        }
        
        let translator = DetailedTranslator(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage)
        translators.append(translator)
        
        return translator
    }
    
    private static func checkAndDownloadLanguageModels(sourceLanguage: TranslateLanguage, targetLanguage: TranslateLanguage, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        
        if !LanguageManager.shared.isLanguageDownloaded(sourceLanguage) {
            dispatchGroup.enter()
            // TODO: Send alert asking to download language model
            
            // If user accepted
            if true {
                DispatchQueue.main.async {
                    LanguageManager.shared.downloadLanguage(sourceLanguage)
                    dispatchGroup.leave()
                }
            } else {
                completion(.failure(DownloadError("User refused to download source language model")))
                return
            }
        }
        
        if !LanguageManager.shared.isLanguageDownloaded(targetLanguage) {
            dispatchGroup.enter()
            // TODO: Send alert asking to download language model
            
            // If user accepted
            if true {
                DispatchQueue.main.async {
                    LanguageManager.shared.downloadLanguage(targetLanguage)
                    dispatchGroup.leave()
                }
            } else {
                completion(.failure(DownloadError("User refused to download target language model")))
                return
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(()))
        }
        
        dispatchGroup.wait()
    }
    
    // MARK: - Public
    public static func translate(
        from sourceLanguage: TranslateLanguage,
        to targetLanguage: TranslateLanguage,
        _ stringToTranslate: String,
        completion: @escaping (String?, Error?) -> Void
    ) {
        checkAndDownloadLanguageModels(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage) { result in
            switch result {
            case .success:
                let translator = translatorForLanguages(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage)
                
                translator.translate(stringToTranslate) { translatedText, error in
                    guard error == nil, let translatedText else {
                        completion(nil, error)
                        return
                    }
                    completion(translatedText, nil)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    public static func localizeInterface(_ viewController: UIViewController, from sourceLanguage: TranslateLanguage, to targetLanguage: TranslateLanguage, options: LocalizationOptions) {
        if options.contains(.labels) {
            for label in viewController.view.subviews.filter({ $0 is UILabel }) {
                guard let label = label as? UILabel,
                      let text = label.text else { continue }
                AutoLocalization.translate(from: sourceLanguage, to: targetLanguage, text) { translatedText, _ in
                    guard let translatedText else { return }
                    label.text = translatedText
                    label.sizeToFit()
                }
            }
        }
        if options.contains(.buttons) {
            for button in viewController.view.subviews.filter({ $0 is UIButton }) {
                guard let button = button as? UIButton,
                      let text = button.titleLabel?.text else { continue }
                AutoLocalization.translate(from: sourceLanguage, to: targetLanguage, text) { translatedText, _ in
                    guard let translatedText else { return }
                    button.titleLabel?.text = translatedText
                    button.sizeToFit()
                }
            }
        }
        if options.contains(.textfields) {
            for textField in viewController.view.subviews.filter({ $0 is UITextField }) {
                guard let textField = textField as? UITextField,
                      let text = textField.text else { continue }
                AutoLocalization.translate(from: sourceLanguage, to: targetLanguage, text) { translatedText, _ in
                    guard let translatedText else { return }
                    textField.text = translatedText
                    textField.sizeToFit()
                }
            }
        }
        if options.contains(.toolbars) {
            for toolbar in viewController.view.subviews.filter({ $0 is UIToolbar }) {
                if let toolbar = toolbar as? UIToolbar,
                   let toolbarItems = toolbar.items {
                    for item in toolbarItems {
                        guard let title = item.title else { continue }
                        AutoLocalization.translate(from: sourceLanguage, to: targetLanguage, title) { translatedText, _ in
                            guard let translatedText = translatedText else { return }
                            item.title = translatedText
                        }
                    }
                }
            }
        }
        if options.contains(.segmentedControls) {
            for segmentedControl in viewController.view.subviews.filter({ $0 is UISegmentedControl }) {
                guard let segmentedControl = segmentedControl as? UISegmentedControl else { continue }
                for i in 0..<segmentedControl.numberOfSegments {
                    guard let title = segmentedControl.titleForSegment(at: i) else { continue }
                    AutoLocalization.translate(from: sourceLanguage, to: targetLanguage, title) { translatedText, _ in
                        guard let translatedText else { return }
                        segmentedControl.setTitle(translatedText, forSegmentAt: i)
                        segmentedControl.sizeToFit()
                    }
                }
            }
        }
        if options.contains(.searchBars) {
            for searchBar in viewController.view.subviews.compactMap({ $0 as? UISearchBar }) {
                guard let text = searchBar.placeholder else { continue }
                AutoLocalization.translate(from: sourceLanguage, to: targetLanguage, text) { translatedText, _ in
                    guard let translatedText = translatedText else { return }
                    searchBar.placeholder = translatedText
                }
            }
        }
        
    }
    
}
