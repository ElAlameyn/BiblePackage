//
//  File.swift
//  
//
//  Created by Артем Калинкин on 10.11.2023.
//

import SwiftUI

public struct Centralized<CenterView: View>: View {
  @ViewBuilder public var view: () -> CenterView
  
  public init(view: @escaping () -> CenterView) {
    self.view = view
  }

  public var body: some View {
    VStack {
        view()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
