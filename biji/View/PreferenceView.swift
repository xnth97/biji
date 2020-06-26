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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            Toggle(isOn: $manager.setWallpaperAutomatically) {
                Text("Change wallpaper automatically")
            }
            Picker(selection: $manager.locale, label: Text("Locale")) {
                Text("English (United States)").tag("en-us")
                Text("Chinese (China)").tag("zh-cn")
            }
            HStack {
                Slider(value: $manager.autoUpdateThreshold, in: 1.0 ... 12.0, step: 1.0) {
                    Text("Auto update time threshold")
                }
                Text("\(Int(manager.autoUpdateThreshold)) hours")
                    .frame(width: 60.0, alignment: .trailing)
            }
            HStack {
                Text("Image cache")
                Button(action: {
                    AppModel.shared.openCacheDirectory()
                }, label: {
                    Text("Open cache directory")
                })
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
