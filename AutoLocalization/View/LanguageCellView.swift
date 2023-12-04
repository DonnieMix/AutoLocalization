//
//  LanguageCellView.swift
//  AutoLocalization
//
//  Created by Kyrylo Derkach on 01.12.2023.
//

import SwiftUI
import MLKitTranslate

struct LanguageCellView: View {
    let language: TranslateLanguage
    @State var downloadStatus: DownloadStatus = .none
    @ObservedObject var downloadProgress: DownloadProgressObservable
    
    var body: some View {
        HStack {
            Text(language.name)
                .padding()
                .frame(alignment: .leading)
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    if LanguageManager.shared.isLanguageDownloaded(language) &&
                        AutoLocalization.shared.currentTargetLanguage != language {
                        AutoLocalization.shared.localizeInterface(from: AutoLocalization.shared.currentTargetLanguage, to: language, options: .all)
                    }
                }
            Button(action: toggleDownload) {
                switch downloadStatus {
                case .downloaded:
                    Image(systemName: "trash")
                        .font(.title)
                case .inProgress:
                    ProgressView()
                        .progressViewStyle(.circular)
                case .none:
                    Image(systemName: "arrow.down.circle")
                        .font(.title)
                }
            }
            .frame(alignment: .trailing)
        }
        .onReceive(downloadProgress.$isCompleted) { completed in
            if completed {
                downloadStatus = .downloaded
            }
        }
    }
    
    private func toggleDownload() {
        switch downloadStatus {
        case .none:
            let progress: Progress = LanguageManager.shared.downloadLanguage(language)
            downloadProgress.progress = progress
            downloadStatus = .inProgress
        case .inProgress:
            downloadProgress.scheduleInstantDeletion()
            downloadStatus = .none
        case .downloaded:
            LanguageManager.shared.deleteLanguage(language)
            downloadStatus = .none
        }
    }
}

//#Preview {
//    LanguageCellView(language: .english, downloadStatus: LanguageCellView.debugStatus, downloadProgress: DownloadProgressObservable())
//}
