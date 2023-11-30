//
//  LocalizationOptions.swift
//  AutoLocalization
//
//  Created by Kyrylo Derkach on 30.11.2023.
//

import Foundation

public struct LocalizationOptions: OptionSet {
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public let rawValue: Int
    
    public static let labels = LocalizationOptions(rawValue: 1 << 0)
    public static let buttons = LocalizationOptions(rawValue: 1 << 1)
    public static let textfields = LocalizationOptions(rawValue: 1 << 2)
    public static let toolbars = LocalizationOptions(rawValue: 1 << 3)
    public static let segmentedControls = LocalizationOptions(rawValue: 1 << 4)
    public static let searchBars = LocalizationOptions(rawValue: 1 << 5)

    public static let all: LocalizationOptions = [.labels, .buttons, .textfields, .toolbars, .segmentedControls, .searchBars]
    
    public func excluding(_ options: LocalizationOptions) -> LocalizationOptions {
        return LocalizationOptions(rawValue: self.rawValue & ~options.rawValue)
    }
}
