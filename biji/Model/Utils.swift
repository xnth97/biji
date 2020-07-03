//
//  Utils.swift
//  biji
//
//  Created by Yubo Qin on 6/26/20.
//  Copyright © 2020 Yubo Qin. All rights reserved.
//

import Foundation

extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)!
}

extension Formatter {
    static let date = DateFormatter()
}

extension Date {
    func localizedDescription(dateStyle: DateFormatter.Style = .medium,
                              timeStyle: DateFormatter.Style = .medium,
                              in timeZone: TimeZone = .current,
                              locale: Locale = .current) -> String {
        Formatter.date.locale = locale
        Formatter.date.timeZone = timeZone
        Formatter.date.dateStyle = dateStyle
        Formatter.date.timeStyle = timeStyle
        return Formatter.date.string(from: self)
    }
    var localizedDescription: String { localizedDescription() }
}

struct Utils {
    
    static func getInitialDefaultLocale() -> String {
        if NSLocale.current.languageCode == "zh" {
            return "zh-cn"
        }
        return "en-us"
    }
    
}
