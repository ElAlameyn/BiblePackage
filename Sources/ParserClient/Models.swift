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

public struct Paragraph: Encodable, Hashable, CustomStringConvertible {
  public let number: Int
  public var text: String
  
  public var description: String {
    "\(number) \(text)"
  }
}

public enum Page {
  case start(PageInfo)
  case continious(ContinuousPageInfo)
}


public typealias PageInfo = (Book, Chapter, [Paragraph])
public typealias ContinuousPageInfo = (String?, [Paragraph], Chapter, [Paragraph])
