//
//  File.swift
//  
//
//  Created by Артем Калинкин on 02.11.2023.
//

import XCTest
@testable import ParserClient

final class ParserClientTests: XCTestCase {

  func testParagraph() throws {
    let input = """
    3 И сказал Бог: да будет свет. И стал свет.
    7 И создал Бог твердь, и отделил воду, которая под твердью, от воды, которая над твердью. И
    стало так.
    """

    XCTAssert(
      try ManyParagraphsParser().parse(input) ==
      [
        Paragraph(number: 3, text: "И сказал Бог: да будет свет. И стал свет."),
        Paragraph(number: 7, text: "И создал Бог твердь, и отделил воду, которая под твердью, от воды, которая над твердью. И стало так."),
      ]
    )
  }

  func testBookPage()  {
    let input = """
      Бытие
        Глава 1
    3 И сказал Бог: да будет свет. И стал свет.
    7 И создал Бог твердь, и отделил воду, которая под твердью, от воды, которая над твердью. И
    стало так.
    """

    XCTAssert(
      try BookPageParser().parse(input) ==
      PageInfo(
        bibleBookName:  Book(name: "Бытие"),
        chapter: Chapter(name: "Глава", number: 1),
        paragraphs: [
          Paragraph(number: 3, text: "И сказал Бог: да будет свет. И стал свет."),
          Paragraph(number: 7, text: "И создал Бог твердь, и отделил воду, которая под твердью, от воды, которая над твердью. И стало так."),
        ])
    )
  }
}


