//
//  DataItem.swift
//  biji
//
//  Created by Yubo Qin on 4/24/20.
//  Copyright © 2020 Yubo Qin. All rights reserved.
//

import Foundation

struct ResponseItem: Codable {
    let images: [ImageItem]
}

struct ImageItem: Codable {

    let startDate: String
    let fullStartDate: String
    let endDate: String
    let url: String
    let urlBase: String
    let copyright: String
    let copyrightLink: String
    let title: String
    let quiz: String
    let hash: String
    
    enum CodingKeys: String, CodingKey {
        case startDate = "startdate"
        case fullStartDate = "fullstartdate"
        case endDate = "enddate"
        case url
        case urlBase = "urlbase"
        case copyright
        case copyrightLink = "copyrightlink"
        case title
        case quiz
        case hash = "hsh"
    }

}
