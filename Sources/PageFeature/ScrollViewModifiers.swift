//
//  File.swift
//  
//
//  Created by Артем Калинкин on 17.11.2023.
//

import SwiftUI

struct ScrollStatusModifier: ViewModifier {
  @Binding var isScrolling: Bool
  
  func body(content: Content) -> some View {
    content
//      .environment(\.isScrolling, true)
//      .introspectScrollView   {
//
//      }
  }
}
