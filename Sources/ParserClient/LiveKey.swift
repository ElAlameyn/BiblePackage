//
//  File.swift
//
//
//  Created by Артем Калинкин on 10.11.2023.
//

import ComposableArchitecture
import Extensions_GenericViews
import Foundation
import PDFKit

public struct ParseClient {
  public var parsePage: (Int) throws -> Page
}

enum ParseError: Error {
  case notFound
}

public extension DependencyValues {
  var parseClient: ParseClient {
    get { self[ParseClient.self] }
    set { self[ParseClient.self] = newValue }
  }
}

private enum BundlePath {
  static let bibleBundle = Bundle.module.url(forResource: "Bible", withExtension: "pdf")!
}

extension ParseClient: DependencyKey {
  public static var liveValue = ParseClient { pageNumber in
    guard let pdf = PDFDocument(url: BundlePath.bibleBundle),
          let pdfContent = pdf.page(at: pageNumber + 34)?.string
    else {
      throw ParseError.notFound
    }
    return try PageParser().parse(pdfContent[...])
  }

  public static var testValue = ParseClient { _ in
    let test = (0 ... 12).map {
      Paragraph(number: $0, text: String.loremIpsum5)
    }
    return .start(.init(
      bibleBookName: Book(name: "Бытие"),
      chapter: Chapter(name: "Глава", number: 1),
      paragraphs: test))
  }

  public static var singleValue = ParseClient { _ in
    let test = (0 ... 3).map {
      Paragraph(number: $0, text: String.loremIpsum5)
    }
    return .start(.init(
      bibleBookName: Book(name: "Бытие"),
      chapter: Chapter(name: "Глава", number: 1),
      paragraphs: test))
  }
}
