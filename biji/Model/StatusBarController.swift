//
//  StatusBarController.swift
//  biji
//
//  Created by Yubo Qin on 4/23/20.
//  Copyright © 2020 Yubo Qin. All rights reserved.
//

import AppKit

class StatusBarController {
    
    private let statusBar: NSStatusBar
    private let statusItem: NSStatusItem
    private let popover: NSPopover
    private let statusBarButton: NSStatusBarButton
    private var eventMonitor: EventMonitor?
    
    init(popover: NSPopover) {
        self.popover = popover
        statusBar = NSStatusBar()
        statusItem = statusBar.statusItem(withLength: 28.0)
        statusBarButton = statusItem.button!
        
        statusBarButton.image = NSImage(imageLiteralResourceName: "bing")
        statusBarButton.image?.size = NSSize(width: 18.0, height: 18.0)
        statusBarButton.image?.isTemplate = true
        
        statusBarButton.target = self
        statusBarButton.action = #selector(togglePopover(_:))

        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: mouseEventHandler)
    }
    
    @objc private func togglePopover(_ sender: AnyObject) {
        if popover.isShown {
            closePopover(sender)
        } else {
            openPopover(sender)
        }
    }
    
    private func closePopover(_ sender: AnyObject) {
        popover.performClose(sender)
        statusBarButton.highlight(false)
        eventMonitor?.stop()
    }
    
    private func openPopover(_ sender: AnyObject) {
        popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: .maxY)
        statusBarButton.highlight(true)
        popover.contentViewController?.view.window?.becomeKey()
        eventMonitor?.start()
    }
    
    private func mouseEventHandler(_ event: NSEvent?) {
        if popover.isShown {
            closePopover(event as AnyObject)
        }
    }
    
}

class EventMonitor {

    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent?) -> Void
    
    init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void) {
        self.mask = mask
        self.handler = handler
    }

    deinit {
        stop()
    }

    func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }

    func stop() {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
        }
        monitor = nil
    }
}
