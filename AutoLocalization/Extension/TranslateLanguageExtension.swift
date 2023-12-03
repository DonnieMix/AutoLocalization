//
//  TranslateLanguageExtension.swift
//  AutoLocalization
//
//  Created by Kyrylo Derkach on 01.12.2023.
//

import Foundation
import MLKitTranslate

extension TranslateLanguage {
    
    var name: String {
        switch self {
        case .afrikaans: return "Afrikaans"
        case .albanian: return "Albanian"
        case .arabic: return "Arabic"
        case .belarusian: return "Belarusian"
        case .bengali: return "Bengali"
        case .bulgarian: return "Bulgarian"
        case .catalan: return "Catalan"
        case .chinese: return "Chinese"
        case .croatian: return "Croatian"
        case .czech: return "Czech"
        case .danish: return "Danish"
        case .dutch: return "Dutch"
        case .english: return "English"
        case .eperanto: return "Esperanto"
        case .estonian: return "Estonian"
        case .finnish: return "Finnish"
        case .french: return "French"
        case .galician: return "Galician"
        case .georgian: return "Georgian"
        case .german: return "German"
        case .greek: return "Greek"
        case .gujarati: return "Gujarati"
        case .haitianCreole: return "Haitian Creole"
        case .hebrew: return "Hebrew"
        case .hindi: return "Hindi"
        case .hungarian: return "Hungarian"
        case .icelandic: return "Icelandic"
        case .indonesian: return "Indonesian"
        case .irish: return "Irish"
        case .italian: return "Italian"
        case .japanese: return "Japanese"
        case .kannada: return "Kannada"
        case .korean: return "Korean"
        case .latvian: return "Latvian"
        case .lithuanian: return "Lithuanian"
        case .macedonian: return "Macedonian"
        case .malay: return "Malay"
        case .maltese: return "Maltese"
        case .marathi: return "Marathi"
        case .norwegian: return "Norwegian"
        case .persian: return "Persian"
        case .polish: return "Polish"
        case .portuguese: return "Portuguese"
        case .romanian: return "Romanian"
        case .russian: return "Russian"
        case .slovak: return "Slovak"
        case .slovenian: return "Slovenian"
        case .spanish: return "Spanish"
        case .swahili: return "Swahili"
        case .swedish: return "Swedish"
        case .tagalog: return "Tagalog"
        case .tamil: return "Tamil"
        case .telugu: return "Telugu"
        case .thai: return "Thai"
        case .turkish: return "Turkish"
        case .ukrainian: return "Ukrainian"
        case .urdu: return "Urdu"
        case .vietnamese: return "Vietnamese"
        case .welsh: return "Welsh"
        default:
            return "Undefined"
        }
    }
}
