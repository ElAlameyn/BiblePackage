//
//  File.swift
//
//
//  Created by Артем Калинкин on 10.11.2023.
//

import ComposableArchitecture
import Foundation
import PDFKit

public struct ParseClient {
  public var loadPage: (Int) throws -> Page
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
}
