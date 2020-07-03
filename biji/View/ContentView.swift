//
//  ContentView.swift
//  biji
//
//  Created by Yubo Qin on 4/23/20.
//  Copyright © 2020 Yubo Qin. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: AppViewModel
    @ObservedObject var preference = PreferenceManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            HStack(alignment: .center, spacing: 24.0) {
                Button(action: {
                    AppModel.shared.previousTapped()
                }) {
                    Text(NSLocalizedString("Previous", comment: "")).frame(width: 80)
                }
                .disabled(!viewModel.previousEnabled)
                Text("\(viewModel.currentIndex) / \(viewModel.total)")
                Button(action: {
                    AppModel.shared.nextTapped()
                }) {
                    Text(NSLocalizedString("Next", comment: "")).frame(width: 80)
                }
                .disabled(!viewModel.nextEnabled)
            }
            KFImage(URL(string: viewModel.imageUrl))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(alignment: .center)
            if !viewModel.title.isEmpty {
                Text(viewModel.title)
                    .font(.headline)
            }
            Text(viewModel.description)
                .font(.body)
            Spacer()
            HStack {
                if !preference.setWallpaperAutomatically {
                    Button(action: {
                        AppModel.shared.setAsWallpaper()
                    }, label: {
                        Text(NSLocalizedString("Set As Wallpaper", comment: ""))
                    })
                }
                Spacer()
                MenuButton(label: Image("settings").frame(width: 48)) {
                    Button(action: {}) {
                        Text("\(NSLocalizedString("Biji", comment: "")) \(AppModel.shared.appVersion)")
                    }
                    .disabled(true)
                    VStack {
                        Divider()
                    }
                    .disabled(true)
                    Button(action: {
                        AppModel.shared.openCopyright()
                    }) {
                        Text(NSLocalizedString("View on Bing", comment: ""))
                    }
                    Button(action: {
                        AppModel.shared.refresh()
                    }) {
                        Text(NSLocalizedString("Refresh", comment: ""))
                    }
                    Button(action: {}) {
                        Text("\(NSLocalizedString("Last updated: ", comment: ""))\(Date(timeIntervalSince1970: PreferenceManager.shared.lastUpdated).localizedDescription(dateStyle: .medium, timeStyle: .short))")
                    }
                    .disabled(true)
                    VStack {
                        Divider()
                    }
                    .disabled(true)
                    Button(action: {
                        AppModel.shared.showPreferenceWindow()
                    }, label: {
                        Text(NSLocalizedString("Preferences", comment: ""))
                    })
                    VStack {
                        Divider()
                    }
                    .disabled(true)
                    Button(action: {
                        AppModel.shared.terminate()
                    }) {
                        Text(NSLocalizedString("Quit", comment: ""))
                    }
                }
                .menuButtonStyle(BorderlessButtonMenuButtonStyle())
                .frame(width: 48.0, alignment: .trailing)
            }
        }
        .padding(EdgeInsets(top: 16.0, leading: 16.0, bottom: 16.0, trailing: 16.0))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: AppModel.shared.viewModel)
    }
}
