//
//  Metadata.swift
//  BookTestTCA
//
//  Created by Mykola Hrybeniuk on 05.02.2025.
//

import Foundation

struct Metadata: Codable, Equatable {
    struct Chapter: Codable, Equatable {
        let title: String
        let fileUrl: String
        let text: String
    }
    
    let bookName: String
    let imageUrl: String
    let keyPoints: [Chapter]
}


// MARK: - Mock data

extension Metadata {
    static let mock = Self(bookName: "NAME", imageUrl: "URL", keyPoints: [.init(title: "Title1", fileUrl: "ChapterUrl1", text: "TextLong1"), .init(title: "Title2", fileUrl: "ChapterUrl2", text: "TextLong2")])
}
