//
//  File.swift
//  
//
//  Created by Артем Калинкин on 28.08.2023.
//

import SwiftUI
import UIKit

struct TextView: UIViewRepresentable {

  @Binding var text: String
  var textStyle: UIFont.TextStyle = UIFont.TextStyle.body

  func makeUIView(context: Context) -> UITextView {
    let textView = UITextView()

    textView.font = UIFont.preferredFont(forTextStyle: textStyle)
    textView.autocapitalizationType = .sentences
    textView.isSelectable = true
    textView.isUserInteractionEnabled = true
    textView.isScrollEnabled = false

    return textView
  }

  func updateUIView(_ uiView: UITextView, context: Context) {
    uiView.text = text
    uiView.font = UIFont.preferredFont(forTextStyle: textStyle)
  }
}
