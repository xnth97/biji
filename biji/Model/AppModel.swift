//
//  AppViewModel.swift
//  biji
//
//  Created by Yubo Qin on 4/23/20.
//  Copyright © 2020 Yubo Qin. All rights reserved.
//

import Cocoa
import Combine
import Kingfisher
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var title: String
    @Published var description: String
    @Published var imageUrl: String
    @Published var previousEnabled: Bool
    @Published var nextEnabled: Bool
    @Published var currentIndex: Int
    @Published var total: Int
    
    init(title: String,
         description: String,
         imageUrl: String,
         previousEnabled: Bool,
         nextEnabled: Bool,
         currentIndex: Int,
         total: Int) {
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.previousEnabled = previousEnabled
        self.nextEnabled = nextEnabled
        self.currentIndex = currentIndex
        self.total = total
    }
}

class AppModel {
    
    static let shared = AppModel()
    
    private static let totalCount = 10
    
    private(set) var viewModel = AppViewModel(title: "",
                                              description: "",
                                              imageUrl: "",
                                              previousEnabled: true,
                                              nextEnabled: true,
                                              currentIndex: 0,
                                              total: 0)
    
    private var imageItems: [ImageItem] = []
    
    private let updateChecker = NSBackgroundActivityScheduler(identifier: "io.yuboqin.biji.updateChecker")
    
    private lazy var preferenceWindow: NSWindow = {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 360),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered,
            defer: false)
        window.contentView = NSHostingView(rootView: PreferenceView())
        window.center()
        window.setFrameAutosaveName("Preferences")
        window.title = "Preferences"
        window.isReleasedWhenClosed = false
        return window
    }()
    
    init() {
        commonInit()
        refresh()
    }
    
    private func commonInit() {
        ImageCache.default.memoryStorage.config.totalCostLimit = 1
        ImageCache.default.diskStorage.config.sizeLimit = 1000 * 1024 * 1024
        ImageCache.default.diskStorage.config.expiration = .days(30)
        
        updateChecker.repeats = true
        updateChecker.interval = PreferenceManager.shared.autoUpdateThreshold * 60 * 60
        updateChecker.schedule { [weak self] completion in
            guard let strongSelf = self, strongSelf.imageItems.count > 0, let latestDate = Int(strongSelf.imageItems[0].startDate) else {
                return
            }
            let now = Date()
            let calendar = Calendar.current
            let currentDate = calendar.component(.year, from: now) * 10000 + calendar.component(.month, from: now) * 100 + calendar.component(.day, from: now)
            if latestDate == currentDate {
                return
            }
            strongSelf.refresh {
                completion(.finished)
            }
        }
    }
    
    private func loadViewModel(withImageItemAtIndex index: Int) {
        guard index >= 0 && index < imageItems.count else {
            return
        }
        let imageItem = imageItems[index]
        viewModel.title = imageItem.title
        viewModel.description = imageItem.copyright
        viewModel.imageUrl = NetworkManager.getImageUrl(imageUrl: imageItem.url)
        viewModel.nextEnabled = index > 0
        viewModel.previousEnabled = index < imageItems.count - 1
        viewModel.currentIndex = index + 1
        viewModel.total = imageItems.count
        
        if PreferenceManager.shared.setWallpaperAutomatically {
            setAsWallpaper()
        }
    }
    
    func setAsWallpaper() {
        NetworkManager.requestImage(url: viewModel.imageUrl, completion: { localUrl in
            guard let localUrl = localUrl, let screen = NSScreen.main else {
                return
            }
            do {
                try NSWorkspace.shared.setDesktopImageURL(localUrl, for: screen, options: [:])
            } catch {
                
            }
        })
    }
    
    func refresh(completion: (() -> Void)? = nil) {
        NetworkManager.requestBingWallpaper(locale: PreferenceManager.shared.locale) { [weak self] imageItems in
            self?.imageItems = imageItems
            self?.loadViewModel(withImageItemAtIndex: 0)
            completion?()
        }
    }
    
    func previousTapped() {
        loadViewModel(withImageItemAtIndex: viewModel.currentIndex)
    }
    
    func nextTapped() {
        loadViewModel(withImageItemAtIndex: viewModel.currentIndex - 2)
    }
    
    func terminate() {
        NSApp.terminate(self)
    }
    
    func openCopyright() {
        let index = viewModel.currentIndex - 1
        let copyrightUrl = imageItems[index].copyrightLink
        NSWorkspace.shared.open(URL(string: copyrightUrl)!)
    }
    
    func openCacheDirectory() {
        let path = (ImageCache.default.cachePath(forKey: "") as NSString).deletingLastPathComponent
        NSWorkspace.shared.openFile(path)
    }
    
    func showPreferenceWindow() {
        preferenceWindow.makeKeyAndOrderFront(nil)
    }
    
    var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
}
