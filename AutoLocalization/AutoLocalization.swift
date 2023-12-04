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
    // MARK: - Singleton
    public static var shared: AutoLocalization = AutoLocalization()
    private init() {}
    
    // MARK: - Private
    private var translators: [DetailedTranslator] = []
    
    private func existingTranslator(sourceLanguage: TranslateLanguage, targetLanguage: TranslateLanguage) -> Bool {
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
    
    private func translatorForLanguages(sourceLanguage: TranslateLanguage, targetLanguage: TranslateLanguage) -> DetailedTranslator {
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
    
    private func checkLanguageModels(sourceLanguage: TranslateLanguage, targetLanguage: TranslateLanguage, completion: @escaping (Result<Void, Error>) -> Void) {
        var error: DownloadError?
        if !LanguageManager.shared.isLanguageDownloaded(sourceLanguage) {
            error = DownloadError("Languages not downloaded")
            error?.put(absentLanguage: sourceLanguage)
        }
        if !LanguageManager.shared.isLanguageDownloaded(targetLanguage) {
            if var error {
                error.put(absentLanguage: targetLanguage)
            }
            else {
                error = DownloadError("Languages not downloaded")
                error?.put(absentLanguage: targetLanguage)
            }
        }
        
        if let error {
            completion(.failure(error))
            return
        }
        completion(.success(()))
    }
    
    // MARK: - Public
    public func translate(
        from sourceLanguage: TranslateLanguage,
        to targetLanguage: TranslateLanguage,
        _ stringToTranslate: String,
        completion: @escaping (String?, Error?) -> Void
    ) {
        let translator = translatorForLanguages(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage)
        
        translator.translate(stringToTranslate) { translatedText, error in
            guard error == nil, let translatedText else {
                completion(nil, error)
                return
            }
            completion(translatedText, nil)
        }
    }
    
    public func localizeInterface(_ viewController: UIViewController, from sourceLanguage: TranslateLanguage, to targetLanguage: TranslateLanguage, options: LocalizationOptions) {
        checkLanguageModels(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage) { result in
            switch result {
            case .success:
                if options.contains(.labels) {
                    for label in viewController.view.subviews.filter({ $0 is UILabel }) {
                        guard let label = label as? UILabel,
                              let text = label.text else { continue }
                        AutoLocalization.shared.translate(from: sourceLanguage, to: targetLanguage, text) { translatedText, _ in
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
                        AutoLocalization.shared.translate(from: sourceLanguage, to: targetLanguage, text) { translatedText, _ in
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
                        AutoLocalization.shared.translate(from: sourceLanguage, to: targetLanguage, text) { translatedText, _ in
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
                                AutoLocalization.shared.translate(from: sourceLanguage, to: targetLanguage, title) { translatedText, _ in
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
                            AutoLocalization.shared.translate(from: sourceLanguage, to: targetLanguage, title) { translatedText, _ in
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
                        AutoLocalization.shared.translate(from: sourceLanguage, to: targetLanguage, text) { translatedText, _ in
                            guard let translatedText = translatedText else { return }
                            searchBar.placeholder = translatedText
                        }
                    }
                }
            case .failure(let error):
                let alert = UIAlertController(
                    title: "Download needed",
                    message: "The missing language models need to be downloaded",
                    preferredStyle: .alert
                )
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                let downloadAction = UIAlertAction(title: "Download", style: .default, handler: { _ in
                    guard let downloadError = error as? DownloadError else { return }
                    self.downloadLanguages(languages: downloadError.absentLanguages) {
                        self.localizeInterface(viewController, from: sourceLanguage, to: targetLanguage, options: options)
                    }
                })
                alert.addAction(cancelAction)
                alert.addAction(downloadAction)
                
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let delegate = scene.delegate as? UIWindowSceneDelegate,
                   let window = delegate.window,
                   let window {
                    let viewController = window.rootViewController
                    viewController?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    let dispatchGroup: DispatchGroup = DispatchGroup()
    
    private func downloadLanguages(languages: [TranslateLanguage], completion: @escaping () -> Void) {
        dispatchGroup.enter()
        for language in languages {
            dispatchGroup.enter()
            LanguageManager.shared.downloadLanguage(language)
        }

        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    @Sendable public func handleDownloadLanguageSuccess(_ notification: Notification) {
        dispatchGroup.leave()
    }
    @Sendable public func handleDownloadLanguageFailed(_ notification: Notification) {
        print("Couldn't download language")
        dispatchGroup.leave()
    }
    
}
