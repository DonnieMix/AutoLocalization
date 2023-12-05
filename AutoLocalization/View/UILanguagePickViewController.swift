//
//  UILanguagePickViewController.swift
//  AutoLocalization
//
//  Created by Kyrylo Derkach on 05.12.2023.
//

import Foundation
import UIKit

public class UILanguagePickViewController: UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let languageListView = UILanguageListView(self, options: .all, onLanguageChosenAction: { _ in
            self.dismiss(animated: true)
        })
        view.addSubview(languageListView)
        
    }
    
}
