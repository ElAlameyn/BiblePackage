//
//  File.swift
//  
//
//  Created by Артем Калинкин on 01.11.2023.
//

import Foundation
import Combine

extension UTF8.CodeUnit {
  @usableFromInline
  var isDigit: Bool {
    (.init(ascii: "0") ... .init(ascii: "9")).contains(self)
  }
  @usableFromInline
  var isWhitespace: Bool {
    self == .init(ascii: " ")
  }
}
