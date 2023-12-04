//
//  UILanguageListView.swift
//  AutoLocalization
//
//  Created by Kyrylo Derkach on 04.12.2023.
//

import Foundation
import UIKit
import SwiftUI
import MLKitTranslate

public class UILanguageListView: UIView {
    
    private var viewController: UIViewController? = nil
    
    func setupView(_ options: LocalizationOptions, _ action: ((TranslateLanguage) -> Void)? = nil) {
        let vc = UIHostingController(rootView: LanguageListView(options: options, onLanguageChosenAction: action))

        vc.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(vc.view)
        
        NSLayoutConstraint.activate([
            vc.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            vc.view.topAnchor.constraint(equalTo: topAnchor),
            vc.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            vc.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        guard let viewController = viewController else { return }
        vc.didMove(toParent: viewController)
    }
    
    public init(_ viewController: UIViewController, options: LocalizationOptions, onLanguageChosenAction: ((TranslateLanguage) -> Void)? = nil) {
        self.viewController = viewController
        super.init(frame: viewController.view.bounds)
        setupView(options, onLanguageChosenAction)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView(.all)
    }
}
