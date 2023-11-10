//
//  File.swift
//  
//
//  Created by Артем Калинкин on 03.11.2023.
//

import Foundation

struct Book: Encodable, Equatable {
  let name: String
}

struct Chapter: Encodable, Equatable {
  let name: String
  let number: Int
}

struct Paragraph: Encodable, Equatable {
  let number: Int
  var text: String
}
