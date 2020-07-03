//
//  PreferenceView.swift
//  biji
//
//  Created by Yubo Qin on 6/24/20.
//  Copyright © 2020 Yubo Qin. All rights reserved.
//

import SwiftUI

struct PreferenceView: View {
    @ObservedObject var manager = PreferenceManager.shared
    @State var clearCacheAlertIsShown = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            Toggle(isOn: $manager.setWallpaperAutomatically) {
                Text(NSLocalizedString("Change wallpaper automatically", comment: ""))
            }
            Picker(selection: $manager.locale, label: Text(NSLocalizedString("Locale", comment: ""))) {
                Text("Chinese (China)").tag("zh-cn")
                Text("English (Australia)").tag("en-au")
                Text("English (Canada)").tag("en-ca")
                Text("English (New Zealand)").tag("en-nz")
                Text("English (United Kingdom)").tag("en-uk")
                Text("English (United States)").tag("en-us")
                Text("German (Germany)").tag("de-de")
                Text("Japanese (Japan)").tag("ja-jp")
            }
            HStack {
                Slider(value: $manager.autoUpdateThreshold, in: 1.0 ... 12.0, step: 1.0) {
                    Text(NSLocalizedString("Auto update time interval", comment: ""))
                }
                Text("\(Int(manager.autoUpdateThreshold)) \(NSLocalizedString("hours", comment: ""))")
                    .frame(width: 60.0, alignment: .trailing)
            }
            HStack {
                Text(NSLocalizedString("Image cache", comment: ""))
                Button(action: {
                    AppModel.shared.openCacheDirectory()
                }, label: {
                    Text(NSLocalizedString("Open cache directory", comment: ""))
                })
                Button(action: {
                    self.clearCacheAlertIsShown = true
                }) {
                    Text(NSLocalizedString("Clear cache", comment: ""))
                }
                .alert(isPresented: $clearCacheAlertIsShown) {
                    Alert(
                        title: Text(NSLocalizedString("Clear cache", comment: "")),
                        message: Text(NSLocalizedString("This action cannot be undone.", comment: "")),
                        primaryButton: .destructive(Text(NSLocalizedString("Clear", comment: ""))) {
                            AppModel.shared.clearDiskCache()
                        },
                        secondaryButton: .cancel())
                }
            }
        }
        .padding(.all)
    }
}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView()
    }
}
