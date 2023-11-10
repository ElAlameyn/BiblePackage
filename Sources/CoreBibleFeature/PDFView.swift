//
//  SwiftUIView.swift
//
//
//  Created by Артем Калинкин on 22.08.2023.
//

import PDFKit
import SwiftUI

struct PDFKitView: UIViewRepresentable {

  typealias UIViewType = PDFView
  let url: URL

  func makeUIView(context: Context) -> PDFView {
    let pdfView = PDFView()
    pdfView.document = PDFDocument(url: url)
    pdfView.autoScales = true
    pdfView.displayBox = .cropBox
//    pdfView.displayMode = .singlePage
    return pdfView
  }

  func updateUIView(_ uiView: PDFView, context: Context) {
    uiView.document = PDFDocument(url: url)
  }
}
