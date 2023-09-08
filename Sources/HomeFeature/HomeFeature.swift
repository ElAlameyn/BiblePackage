//
//  File.swift
//
//
//  Created by Артем Калинкин on 17.08.2023.
//

import ComposableArchitecture
import PDFKit
import Foundation

public struct HomeFeature: Reducer {
  public init() {}

  public struct State: Equatable {
    var bibleBundleURL = Bundle.module.url(
      forResource: "Bible",
      withExtension: "pdf"
    )!

    public init() {}
  }

  public enum Action {
    case openBibleButtonTapped
    case openRules(RuleType)
  }

  public enum RuleType { case morning, evening }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        case .openBibleButtonTapped:
          var docContent = NSMutableAttributedString()
          let pdfDoc = PDFDocument(url: state.bibleBundleURL)!
          let pageCount = pdfDoc.pageCount

          for i in 0 ..< pageCount {
            guard let page = pdfDoc.page(at: i) else { continue }
            guard let pageContent = page.attributedString else { continue }
            docContent.append(pageContent)
          }

//          print(docContent.mutableString.substring(with: .init(location: 0, length: 500)))
          print(docContent.attributedSubstring(from: .init(location: 0, length: 500)))

        case .openRules: break
      }
      return .none
    }
  }
}
