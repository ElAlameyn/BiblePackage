//
//  File.swift
//  
//
//  Created by Артем Калинкин on 03.11.2023.
//

import Foundation

public struct Book: Encodable, Equatable {
  public let name: String
}

public struct Chapter: Encodable, Equatable, CustomStringConvertible {
  public let name: String
  public let number: Int
  
  public var description: String {
    "\(name) \(number)"
  }
}

public struct Paragraph: Encodable, Hashable, CustomStringConvertible, Identifiable {
  
  public let number: Int
  public var text: String
  
  public init(number: Int, text: String) {
    self.number = number
    self.text = text
  }
  
  public var description: String {
    "\(number) \(text)"
  }
  public var id: Int { number }
}

public enum Page {
  case start(PageInfo)
  case continious(ContinuousPageInfo)
}

public struct PageInfo {
  public var bibleBookName: Book
  public var chapter: Chapter
  public var paragraphs: [Paragraph]
}

public struct ContinuousPageInfo {
  public var extraParagraph: String?
  public var previousChapterParagraphs: [Paragraph]
  public var currentChapter: Chapter
  public var currentChapterParagraphs: [Paragraph]
}

