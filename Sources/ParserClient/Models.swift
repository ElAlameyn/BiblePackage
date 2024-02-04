//
//  File.swift
//  
//
//  Created by Артем Калинкин on 03.11.2023.
//

import Foundation

public struct Book: Encodable, Hashable {
  public let name: String
}

public struct Chapter: Encodable, Hashable, CustomStringConvertible {
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

public enum Page: Hashable {
  case start(PageInfo)
  case continious(ContinuousPageInfo)
}

public struct PageInfo: Hashable {
  public var bibleBookName: Book
  public var chapter: Chapter
  public var paragraphs: [Paragraph]
}

public struct ContinuousPageInfo: Hashable {
  public var extraParagraph: String?
  public var previousChapterParagraphs: [Paragraph]
  public var currentChapter: Chapter
  public var currentChapterParagraphs: [Paragraph]
}

