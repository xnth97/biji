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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            HStack(alignment: .center, spacing: 24.0) {
                Button(action: {
                    AppModel.shared.previousTapped()
                }) {
                    Text("Previous").frame(width: 80)
                }
                .disabled(!viewModel.previousEnabled)
                Text("\(viewModel.currentIndex) / \(viewModel.total)")
                Button(action: {
                    AppModel.shared.nextTapped()
                }) {
                    Text("Next").frame(width: 80)
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
                Spacer()
                MenuButton(label: Image("settings").frame(width: 48)) {
                    Button(action: {}) {
                        Text("Biji \(AppModel.shared.appVersion)")
                    }
                    .disabled(true)
                    VStack {
                        Divider()
                    }
                    .disabled(true)
                    Button(action: {
                        AppModel.shared.openCopyright()
                    }) {
                        Text("View on Bing")
                    }
                    Button(action: {
                        AppModel.shared.refresh()
                    }) {
                        Text("Refresh")
                    }
                    VStack {
                        Divider()
                    }
                    .disabled(true)
                    Button(action: {
                        AppModel.shared.terminate()
                    }) {
                        Text("Quit")
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
